var sexp = require('sexpression');
var fs = require('fs');
var bDebug = true;

const UNWANTED_CHARS = "\\*`.#" // . ` * を _ にする
const INPUTS = [
"escape.txt",
	"let-expanded.scm"
	];
var buf = [], indentLevel = 0, whitespaces = '    ', bol = true;
function newline() { B.push('\n'); bol = true; }

var B = { // Buffer
	push: function (/* args */) {
		for (var i = 0; i < arguments.length; i++) {
			this.indent();
			buf.push(arguments[i]);
		}
	},
	params: function (names) {
		if (names.length > 0) B.push(ident(names[0]));
		for (var i = 1; i < names.length; i++)
			this.format(', ', ident(names[i]));
	},
	separating: function (arr, separator, s, t) {
		if (t <= s) return;
		psr.s2j(arr[s]);
		for (var i = s + 1; i < t; i++) { this.push(separator); psr.s2j(arr[i]); }
	},
	terminating: function (arr) {
		arr.forEach(function (a) { B.format(a, ';', newline); });
	},
	format: function (/* args */) {
		this.indent();
		for (var i = 0; i < arguments.length; i++) {
			var a = arguments[i];
			if (a == null) ;
			// else if (Array.isArray(a)) {
				// var sep = arguments[i+1]; i++;
				// if (sep === ',') this.separating(a, sep);
				// else if (sep === ';') this.terminating(a, sep);
			// } else if (typeof a === 'object' && a.type) T(a);
			else if (typeof a === 'string') this.push(a);
			else if (typeof a === 'number') indentLevel += a;
			else if (typeof a === 'function') a();
			else console.error('I do not know what to do with: ', a);
		}
	},
	indent: function () {
		if (!bol) return;
		while (whitespaces.length < indentLevel)
			whitespaces += whitespaces;
		buf.push(whitespaces.substr(0, indentLevel));
		bol = false;
	},
	flush: function (fd) {
		if (fd) {
			newline();
			console.log("|buf| = " + buf.length);
			console.log("buf = " + buf);
			buf.forEach(function (line) { fs.writeSync(fd, line); });
			this.reset();
		} else {
			var result = buf.join('');
			this.reset();
			return result;
		}
	},
	reset: function () { buf = []; indentLevel = 0; }
};

function ord(c){
	return c.charCodeAt(0);
}

function delete_chars(buf){
	var bSQ = false, bDQ = false;
	for(var i = 0; i < buf.length; i++){
		if(bSQ){
			if(buf[i] == ord("'")) bSQ = false;
		}
		else if(bDQ){
			if(buf[i] == ord('"')) bDQ = false;
		}
		else{
			if(buf[i] == ord("'")) bSQ = true;
			else if(buf[i] == ord('"')) bDQ = true;
			else {
				for(var j = 0; j < UNWANTED_CHARS.length; j++)
					if(buf[i] == UNWANTED_CHARS[j].charCodeAt(0))
						buf[i] = '_'.charCodeAt(0);
			}
		}
		// console.log(buf[i]);
	}
}

var psr = {
	isSymbol : function(e){
		return typeof(e) == "object" && typeof(e.name) != "undefined";
	},
	isNull : function(e){
		return typeof(e) == "object" && e.name == "__nul";
	},
	isAt : function(e){
		return typeof(e) == "object" && e.name == "__@";
	},

	do_begin : function(e, pos){
		for(var i = pos; i < e.length; i++){
			// console.log("do_begin");
			// console.log(e[i]);
			if(psr.isNull(e[i]) || psr.isAt(e[i])) continue;
			psr.s2j(e[i]);
			B.format(';', newline);
		}
	},
	do_binary : function(e, pos){
		if(bDebug) console.log("do_binary: e = " + JSON.stringify(e) + ", pos = " + pos);
		B.push("(");
		psr.s2j(e[pos+1]);
		B.push(e[pos]);
		psr.s2j(e[pos+2]);
		B.push(")");
	},
	do_block : function(e, pos){
		if(bDebug) console.log("do_block: e = " + JSON.stringify(e) + ", pos = " + pos);
		B.format("{", newline, 2);
		psr.do_begin(e, pos);
		B.format(newline, -2, "}");
	},
	do_define : function(name, val){
		if(bDebug) console.log("do_def invoked.");
		// console.log(e);
		// var name = e[0];
		// var val = e[1];
		if(Array.isArray(val) && val[0] == "lambda"){
			B.push("function ");
			psr.do_symbol(name);
			B.push(" ");
			// do-fargs(e[1][0]);
			B.push(" ");
			// do-block(e[1][1]);
		}
		else{
			B.push("var ");
			psr.do_symbol(name);
			if(!psr.isNull(val)){
				B.push(" = ");
				psr.s2j(val);
			}
		}
	},


	do_fargs : function(e, pos){
		if(bDebug) console.log("do_fargs: e = " + e + ", pos = " + pos);
		B.push("(");
		B.separating(e, ', ', pos, e.length);
		B.push(")");
	},

	do_funcCall : function(e, pos){
		if(bDebug) console.log("do_funcCall: e = " + e + ", pos = " + pos);
		B.push("(");
		psr.s2j(e[pos]);
		B.push(" ");
		psr.do_fargs(e, pos+1);
		// for(var i = pos+1; i < e.length; i++){
		// psr.do_fargs(e[i]);
		// }
		B.push(")");

	},
	do_function : function(e, pos){
		if(bDebug) console.log("do_function: e = " + JSON.stringify(e) + ", pos = " + pos);
		var name = e[pos];
		var args = e[pos+1][1];
		var body = e[pos+1][pos+1];
		B.push("(function");
		if(psr.isNull(name)) ;
		B.push(" ");
		psr.do_fargs(args, 0);
		B.push(" ");
		psr.do_block(e[pos+1], 2);
		B.push(")");
	},

	do_JS : function(e, pos){
		var type = e[pos];
		if(bDebug) console.log("do_JS: type = " + type + ", pos = " + pos + ", e = " + e);
		if(type == "binary") psr.do_binary(e, pos+1);
		else if(type == "const") B.push(e[pos + 1]);
		else if(type == "funcCall") psr.do_funcCall(e, pos+1);
		else if(type == "function") psr.do_function(e, pos+1);
		else if(type == "return") psr.do_return(e, pos+1);
		else throw new Error("do_JS: unknown type => " + type + ", pos = " + pos + ", e => " + e );
	},

	do_list : function(es){
		if(es.length == 0){
			//とりあえずエラーにしておく？
			throw new Error("do_list: lengthZero error.");
		}
		var e = es[0];
		if(typeof(e) == "string"){
			if(e == "JS"){
				psr.do_JS(es, 1);
			}
			else{
				throw new Error("do_list: invalid element. => " + e);
			}
		}
		else if(psr.isSymbol(e)){
			if(e.name == "begin") psr.do_begin(es, 1);
			else if(e.name == "define") psr.do_define(es[1], es[2]);
			else if(e.name == "letrec") psr.do_retlec(es[1]);
			else throw new Error("do_list: Invalid symbol. => " + e.name);
		}
		else{
		}

	},

	do_return : function(e, pos){
		var v = e[pos];
		B.push("return ");
		if(!psr.isNull(v)) psr.s2j(v);
	},


	s2j : function(e){
		if(Array.isArray(e)) psr.do_list(e);
		else if(psr.isSymbol(e)) psr.do_symbol(e);
		else if(typeof(e) == "string"){
			if(psr.isNull(e)) throw new Error("s2j: misplaced null character.");
			else if(psr.isAt(e)) ;
			else throw new Error("s2j: this string cannot happen. => " + e);
		}
		else throw new Error("s2j: Invalid elements in the Scheme program => " + typeof(e));
	},
	do_symbol : function(e){
		if(bDebug) console.log("do_symbol: e = " + e);
		if(!psr.isNull(e) && !psr.isAt(e)) B.push(e.name);
		// B.push(e.name);

	}
};
exports.convert = function (t, output) {
	var fd = false;
	if (typeof output === 'number') fd = output;
	if (typeof output === 'string') {
		fd = fs.openSync(output, 'w');
	}
	// B.format(B.reset, t);
	B.reset();
	console.log("parse start!!!");
	psr.s2j(t);
	// B.format(t);
	var result = B.flush(fd);
	if (fd) fs.closeSync(fd);
	return result;
};

function doIt(){

	var input = INPUTS[1];
	// var buf = [];
	// var fd = fs.openSync(input, 'r');
	var rd = fs.readFileSync(input, 'utf8');
	var buff = new Buffer(rd);
	delete_chars(buff);
	console.log(buff.toString());
	var tt = sexp.parse(buff.toString());
	console.log(JSON.stringify(tt, null, 2));

	// psr.s2j(tt);

	exports.convert(tt, 1);

}

doIt();
