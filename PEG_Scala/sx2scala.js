var sexp = require('sexpression');
var fs = require('fs');
// var bDebug = true;
var bDebug = false;

var ast = {};
fs.readFileSync(__dirname + '/ast.spec', 'utf8').split('\n').forEach(function (line) {
    var spec = line.split(': ');
    if (spec.length === 1) return;
    var type = spec[0], keys = spec[1].split(', ');
    keys.splice(0, 0, 'type');
    // ast[type] = keys;
    ast[type] = keys.length - 1;
  });

const UNWANTED_CHARS = "\\*`.#" // . ` * を _ にする
const INPUTS = [
"escape.txt",
__dirname + "/scala/A.scm",
	"let-expanded.scm"
	];
var buf = [], indentLevel = 0, whitespaces = '    ', bol = true;
function newline() {
	if(bDebug){
		console.log("newline invoked.");
	}
	B.push('\n');
	bol = true;
}

var B = { // Buffer
	push: function (/* args */) {
		for (var i = 0; i < arguments.length; i++) {
			if(bDebug) console.log("push(" + i + "): " + arguments[i]);
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
		if(typeof separator === 'undefined') separator = ' ';
		if(typeof s === 'undefined') s = 0;
		if(typeof t === 'undefined') t = arr.length;
		if(bDebug) console.log("separating: s = %d, t = %d, JSON = %j", s ,t, arr);
		if (t <= s) return;
		psr.s2j(arr[s]);
		for (var i = s + 1; i < t; i++) { this.push(separator); psr.s2j(arr[i]); }
	},
	terminating: function (arr) {
		arr.forEach(function (a) { B.format(a, ';', newline); });
	},
	format: function (/* args */) {
		// this.indent();
		for (var i = 0; i < arguments.length; i++) {
			var a = arguments[i];
			if (a == null) ;
			// else if (Array.isArray(a)) {
				// var sep = arguments[i+1]; i++;
				// if (sep === ',') this.separating(a, sep);
				// else if (sep === ';') this.terminating(a, sep);
			// } else if (typeof a === 'object' && a.type) T(a);
			else if (typeof a === 'string') this.push(a);
			else if (typeof a === 'number'){
				indentLevel += a;
				if(bDebug) console.log("indent change. => " + indentLevel);
			}
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
			if(bDebug){
				console.log("|buf| = " + buf.length);
				console.log("buf = " + buf);
			}
			buf.forEach(function (line) {
				fs.writeSync(fd, line);
				// fs.writeSync(fd, ' '); //トークンで分割
			});
			this.reset();
		} else {
			// var result = buf.join(' ');
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

	CompilationUnit : function(e, pos){
		if(bDebug) console.log("do_CompilationUnit: e = " + JSON.stringify(e) + ", pos = " + pos);
		//todo : ひとまずpackagesは後で考える
		psr.s2j(e[pos+1]);
	},
	ImportStatement : function(e, pos){
		B.push("import ");
		B.separating(e[pos], ', ');
	},
	StableId : function(e, pos){
		B.separating(e[pos], '.');
	},
	TopStatSeq : function(e, pos){
		var tps = e[pos];
		tps.forEach(function(a){
			psr.s2j(a);
			B.format(";", newline);
		});
	},


	do_scala : function(e, pos){
		var type = e[pos];
		var f = psr[type];
		if(bDebug) console.log("\ndo_scala: type = " + type + ", pos = " + pos + ", e = " + e);

		if(type == "ArgumentExpression"){
			B.push('(');
			psr.s2j(e[pos+1]);
			B.push(')');
		}
		else if(type == "Block"){
			e[pos + 1].forEach(function(stat){
				psr.s2j(stat);
				B.format(';', newline);
			});
			if(!psr.isNull(e[pos+2])){
				psr.s2j(e[pos+2]);
				B.format(';', newline);
			}
		}
		else if(type == "Exprs"){
			if(bDebug) console.log("Exprs: " + JSON.stringify(e));
			B.separating(e[pos+1], ", ");
		}
		else if(type == "ObjectTemplateDefinition"){
			if(!psr.isNull(e[pos+1])) B.push("case");
			B.push("object ");
			psr.s2j(e[pos + 2]);
		}
		else if(type == "Procedure"){
			psr.s2j(e[pos + 1]); //signature
			B.format('{', newline, 2);
			psr.s2j(e[pos + 2]); //block
			B.format(-2, '}');
		}
		else if(type == "stringLiteral"){
			B.push('"' + e[pos + 1] + '"');
		}
		else if(type == "TemplateBody"){
			B.push('{');
			if(!psr.isNull(e[pos+1])){ //selftype
				psr.s2j(e[pos + 1]);
			}
			B.format(newline, 2);
			e[pos + 2].forEach(function (stat) {
				psr.s2j(stat);
				B.format(';', newline);
			});
			B.format(-2, '}');
		}
		else if(typeof(f) != "undefined") f(e, pos+1);
		else if(typeof(ast[type]) == "number"){
			if(bDebug) console.log("do_scala :: " + type + ", num = " + ast[type]);
			var p = pos + 1;
			// B.separating(e, ' ', p, p+ast[type]);
			for(var i = p; i < p + ast[type]; i++){
				psr.s2j(e[i]);
			}
		}
		else throw new Error("do_scala: unknown type => " + type + ", pos = " + pos + ", e => " + e );
	},

	do_list : function(es){
		if(bDebug) console.log("do_list : " + es);
		if(es.length == 0){
			//とりあえずエラーにしておく？
			throw new Error("do_list: lengthZero error.");
		}
		var e = es[0];
		if(typeof(e) == "string"){
			if(e == "Scala"){
				psr.do_scala(es, 1);
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
		else if(Array.isArray(e)){
			// psr.do_list(e);
			es.map(psr.s2j);
		}
		else{
			throw new Error("do_list : unknown object." + JSON.stringify(e));
		}

	},

	do_return : function(e, pos){
		var v = e[pos];
		B.push("return");
		if(!psr.isNull(v)) psr.s2j(v);
	},


	s2j : function(e){
		if(Array.isArray(e)) psr.do_list(e);
		else if(e == null) ;
		else if(psr.isSymbol(e)) psr.do_symbol(e);
		else if(typeof(e) == "string"){
			if(psr.isNull(e)) throw new Error("s2j: misplaced null character.");
			else if(psr.isAt(e)) ;
			else B.push(e);
			// else throw new Error("s2j: this string cannot happen. => " + e);
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
