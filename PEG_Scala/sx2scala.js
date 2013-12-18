var sexp = require('sexpression');
var fs = require('fs');
// var bDebug = true;
var bDebug = false;

function DP(fname, pos, e, level){
	console.error("\n[%s] : pos = %d", fname, pos);
	if(level == 1) console.error(e);
	else if(level == 2) console.error("%s", e);
	else if(level == 3) console.error("%j", e);
	else if(level == 4) console.error(JSON.stringify(e, null, 1));
	console.error("");
}
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
			// if(bDebug) console.log("push(" + i + "): " + arguments[i]);
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
		// if(bDebug) console.log("separating: s = %d, t = %d, JSON = %j", s ,t, arr);
		if (t <= s) return;
		trans.s2j(arr[s], 0);
		for (var i = s + 1; i < t; i++) { this.push(separator); trans.s2j(arr[i], 0); }
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

var trans = {

	isSymbol : function(e){
		return typeof(e) == "object" && typeof(e.name) != "undefined";
	},
	isNull : function(e){
		return typeof(e) == "object" && e.name == "__nul";
	},
	isAt : function(e){
		return typeof(e) == "object" && e.name == "__@";
	},
	isVariable : function(e){
		if(typeof(e) == "object" && e.name.length >= 3){
			if(e.name[0] == 'V' && e.name[1] == '-') return true;
		}
		return false;
	},

	CompilationUnit : function(e, pos){
		//todo : ひとまずpackagesは後で考える
		this.s2j(e[pos+1], 0);
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
			this.s2j(a, 0);
			B.format(";", newline);
		});
	},
	do_begin : function(e, pos){
		if(bDebug) DP("begin", pos, e, 1);
		for(var i = pos; i < e.length; i++){
			this.s2j(e[i], 0);
			B.format(';', newline);
		}
	},

	do_scala : function(e, pos){
		var type = e[pos];
		var f = trans[type];
		if(bDebug){
			DP("do_scala", pos, e, 1);
			console.log("\ndo_scala: type = %s\n",type);
		}

		if(type == "AnonymousFunction"){
			B.push("( ");
			this.s2j(e[pos+1], 0);
			B.push(" => ");
			this.s2j(e[pos+2], 0);
			B.push(" )");
		}
		else if(type == "AssignmentExpression"){
			this.s2j(e[pos+1], 0);
			this.s2j(e[pos+2], 0);
			B.push(" = ");
			this.s2j(e[pos+3], 0);
		}
		else if(type == "ArgumentExpression"){
			B.push('(');
			this.s2j(e[pos+1], 0);
			B.push(')');
		}
		else if(type == "Binding"){
			this.s2j(e[pos+1], 0);
			if(!this.isNull(e[pos+2])){
				B.push(':');
				this.s2j(e[pos+2], 0);
			}
		}
		else if(type == "Bindings"){
			B.push('(');
			B.separating(e[pos+1], ", ");
			B.push(')');
		}
		else if(type == "Block"){
			e[pos + 1].forEach(function(stat){
				this.s2j(stat, 0);
				B.format(';', newline);
			});
			if(!this.isNull(e[pos+2])){
				this.s2j(e[pos+2], 0);
				B.format(';', newline);
			}
		}
		else if(type == "Exprs"){
			if(bDebug) console.log("Exprs: " + JSON.stringify(e));
			B.separating(e[pos+1], ", ");
		}
		else if(type == "ObjectTemplateDefinition"){
			if(!this.isNull(e[pos+1])) B.push("case");
			B.push("object ");
			this.s2j(e[pos + 2], 0);
		}
		else if(type == "Procedure"){
			this.s2j(e[pos + 1], 0); //signature
			B.format('{', newline, 2);
			this.s2j(e[pos + 2], 0); //block
			B.format(-2, '}');
		}
		else if(type == "stringLiteral"){
			B.push('"' + e[pos + 1] + '"');
		}
		else if(type == "TemplateBody"){
			B.push('{');
			if(!this.isNull(e[pos+1])){ //selftype
				this.s2j(e[pos + 1], 0);
			}
			B.format(newline, 2);
			e[pos + 2].forEach(function (stat) {
				this.s2j(stat, 0);
				B.format(';', newline);
			});
			B.format(-2, '}');
		}
		else if(typeof(f) != "undefined") f(e, pos+1);
		else if(typeof(ast[type]) == "number"){
			if(bDebug) console.log("do_scala2 :: %s, num = %d\n",type, ast[type]);
			var p = pos + 1;
			// B.separating(e, ' ', p, p+ast[type]);
			for(var i = p; i < p + ast[type]; i++){
				this.s2j(e[i], 0);
			}
		}
		else throw new Error("do_scala: unknown type => " + type + ", pos = " + pos + ", e => " + e );
	},

	do_list : function(es, pos){
		if(bDebug) DP("do_list", pos, es, 1);
		if(es.length == 0){
			//とりあえずエラーにしておく？
			throw new Error("do_list: lengthZero error.");
		}
		else if(es.length == pos) return;
		var e = es[pos];
		if(typeof(e) == "string"){
			if(e == "Scala"){
				this.do_scala(es, pos + 1);
			}
			else{
				throw new Error("do_list: invalid element. => " + e);
			}
		}
		else if(this.isSymbol(e)){
			if(e.name == "begin") this.do_begin(es, pos + 1);
			else if(e.name == "define") this.do_define(es[1], es[2]);
			else if(e.name == "letrec") this.do_retlec(es[1]);
			// else if(this.isNull(e)){
				// console.error(es);
				// console.error("aaaaa");
			else{
				this.do_symbol(e);
				this.do_list(es, pos+1);
			}
			// else throw new Error("do_list: Invalid symbol. => " + e.name);
		}
		else if(Array.isArray(e)){
			// this.do_list(e);
			// これおかしい！！！！
			// es.map(this.s2j);
			this.do_list(e, 0);
			this.do_list(es, pos + 1);
		}
		else{
			throw new Error("do_list : unknown object." + JSON.stringify(e));
		}

	},

	do_return : function(e, pos){
		var v = e[pos];
		B.push("return");
		if(!this.isNull(v)) this.s2j(v, 0);
	},


	s2j : function(e, pos){
		// console.log("this = " + this);
		// なぜかs2jではtransをthisにするとthisがグローバルオブジェクトを参照することがある・・・。
		if(Array.isArray(e)) trans.do_list(e, pos);
		else if(e == null) ;
		else if(trans.isSymbol(e)) trans.do_symbol(e);
		else if(typeof(e) == "string" || typeof(e) == 'number'){
			B.push(e);
			// else throw new Error("s2j: trans string cannot happen. => " + e);
		}
		else throw new Error("s2j: Invalid elements in the Scheme program => " + typeof(e));
	},
	do_symbol : function(e){
		if(!trans.isNull(e) && !trans.isAt(e)){
			console.error("do_symbol: %j, %s, %s", e, typeof(e), trans.isVariable(e));
			if(trans.isVariable(e)) B.push(e.name.slice(2));
			else B.push(e.name);
		}
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
	console.error("parse start!!!");
	var buff = new Buffer(t);
	delete_chars(buff);
	// console.log(buff.toString());
	var tt = sexp.parse(buff.toString());
	console.error("%j", tt);
	trans.s2j(tt, 0);
	// B.format(t);
	var result = B.flush(fd);
	console.error("parse end!!!");
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

	// this.s2j(tt);

	exports.convert(tt, 1);

}

// doIt();
