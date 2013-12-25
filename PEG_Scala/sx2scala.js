
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

// const UNWANTED_CHARS = "\\*`.#;" // . ` * を _ にする
const UNWANTED_CHARS = "\\`.#;" // . ` * を _ にする
const INPUTS = [
"escape.txt",
__dirname + "/scala/A.scm",
	"let-expanded.scm"
	];
var buf = [], indentLevel = 0, whitespaces = '    ', bol = true;
function newline() {
	if(bDebug){
		console.error("newline invoked.");
	}
	B.push('\n');
	bol = true;
}

var B = { // Buffer
	push: function (/* args */) {
		for (var i = 0; i < arguments.length; i++) {
			// if(bDebug) console.error("push(" + i + "): " + arguments[i]);
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
		// if(bDebug) console.error("separating: s = %d, t = %d, JSON = %j", s ,t, arr);
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
				if(bDebug) console.error("indent change. => " + indentLevel);
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
				console.error("|buf| = " + buf.length);
				console.error("buf = " + buf);
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
		// console.error(buf[i]);
	}
	return buf;
}

//最後の_以前の*を_に変換する。a*b_+*をa_b_+*に変換する
function convertAsterisk(str){
	const opchars = "+-*/><=!&|%:~^|";
	var last = str.lastIndexOf('_');
	var buf = new Buffer(str.length);
	var bOp = true;

	for(var i = 0; i <= last; i++){
		if(str[i] == '*') buf[i] = '_'.charCodeAt(0);
		else buf[i] = str[i].charCodeAt(0);
	}
	//_以降が全て演算子であるか？
	for(var i = last + 1; i < str.length; i++){
		if(opchars.indexOf(str[i]) < 0){
			bOp = false;
			break;
		}
	}
	if(!bOp){
		for(var i = last + 1; i < str.length; i++){
			if(str[i] == '*') buf[i] = '_'.charCodeAt(0);
			else buf[i] = str[i].charCodeAt(0);
		}
	}
	else{
		for(var i = last + 1; i < str.length; i++) buf[i] = str[i].charCodeAt(0);
	}
	return buf.toString();
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

	// CompilationUnit : function(e, pos){
		// //todo : ひとまずpackagesは後で考える
		// trans.s2j(e[pos+1], 0);
	// },
	// ImportStatement : function(e, pos){
		// B.push("import ");
		// B.separating(e[pos], ', ');
	// },
	// StableId : function(e, pos){
		// B.separating(e[pos], '.');
	// },
	// TopStatSeq : function(e, pos){
		// var tps = e[pos];
		// tps.forEach(function(a){
			// if(!trans.isNull(a)){
				// trans.s2j(a, 0);
				// B.format(";", newline);
			// }
		// });
	// },
	do_begin : function(e, pos){
		if(bDebug) DP("begin", pos, e, 1);
		for(var i = pos; i < e.length; i++){
			if(!trans.isNull(e[i])){trans.s2j(e[i], 0);
				// B.format(';', newline);
				B.format(newline);
			}
		}
	},

	do_lambda : function(e, pos){
		// if(bDebug) DP("lambda", pos, e, 1);
		// DP("lambda", pos, e, 3);
		var params = e[pos], types = e[pos+1];
		console.error("do_lambda: params = " + JSON.stringify(params));
		console.error("do_lambda: types = " + JSON.stringify(types));
		B.push("( ");
		B.push("( ");
		for(var i = 0; i < params.length; i++){
			this.do_symbol(params[i], 1); //パラメータはシンボル
			if(!this.isNull(types[i])) {
				B.push(" : ");
		// console.error("do_lambda: types[i] = " + JSON.stringify(types[i]));
				this.do_scala(types[i], 1);
			}
			if(i != params.length-1) B.push(", ");
		}
		// B.separating(e[pos], ", ") //args
		B.push(" ) => ");
		this.s2j(e[pos + 2], 0); //body
		B.push(" )");
	},

	do_scala : function(e, pos){
		var type = e[pos];
		var f = trans[type];
		// if(true){
		if(bDebug){
			DP("do_scala", pos, e, 1);
			console.error("\ndo_scala: type = %s\n",type);
		}

		if(type == "AnonymousFunction"){
			DP("do_scala_anonyomus", pos, e, 1);
			this.s2j(e[pos+1], 0);
			// B.push("( ");
			// this.s2j(e[pos+1], 0);
			// B.push(" => ");
			// this.s2j(e[pos+2], 0);
			// B.push(" )");
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
				B.push(': ');
				this.s2j(e[pos+2], 0);
			}
		}
		else if(type == "Bindings"){
			B.push('(');
			B.separating(e[pos+1], ", ");
			B.push(')');
		}
		else if(type == "Block"){
			if(!this.isNull(e[pos+1]))
				e[pos + 1].forEach(function(stat){
					if(!trans.isNull(stat)){trans.s2j(stat, 0);
						B.format(';', newline);
					}
				});
			if(!this.isNull(e[pos+2])){
				this.s2j(e[pos+2], 0);
				B.format(';', newline);
			}
		}
		else if(type == "BlockExpression"){
			B.format('{', newline, 2);
			this.s2j(e[pos + 1], 0); //block
			B.format(-2, '}');
		}
		else if(type == "Definition"){
			B.push("def ");
			this.s2j(e[pos + 1], 0); //Fundef
		}
		else if(type == "DesignatorPostfix"){
			if(!this.isNull(e[pos+1])) B.push("_ "); //under
			B.push('.');
			this.s2j(e[pos + 2], 0); //id
			this.s2j(e[pos + 3], 0); //postfix
		}
		else if(type == "Exprs"){
			if(bDebug) console.error("Exprs: " + JSON.stringify(e));
			B.separating(e[pos+1], ", ");
		}
		else if(type == "FunctionDefinition"){
			this.s2j(e[pos + 1], 0); //signature
			if(!this.isNull(e[pos+2])){
				B.push(": ");
				this.s2j(e[pos + 2], 0); //type
			}
			B.push(" = ");
			this.s2j(e[pos + 3], 0); //expr
		}
		else if(type == "InfixOperatorPattern"){
			var ids = e[pos + 2], simplePatterns = e[pos + 3];
			this.s2j(e[pos + 1], 0); //head
			if(!this.isNull(ids)){
				for(var i = 0; i < ids.length; i++){
					B.push(" ");
					this.s2j(ids[i], 0);
					B.push(" ");
					this.s2j(simplePatterns[i], 0);
				}
			}
		}
		else if(type == "IfStatement"){
			B.push("if( ");
			this.s2j(e[pos + 1], 0); //condition
			B.push(" ) ");
			this.s2j(e[pos + 2], 0); //if
			if(!this.isNull(e[pos+3])){
				B.format(";", newline, "else ");
				this.s2j(e[pos + 3], 0); //else
			}
		}
		else if(type == "InfixExpression"){
			var ops = e[pos + 2], rights = e[pos + 3];
			// console.error("InfixExpr: " + ops);
			// B.push("( ");
			this.s2j(e[pos + 1], 0); //left
			if(!this.isNull(ops)){
				for(var i = 0; i < ops.length; i++){
					B.push(" ");
					this.s2j(ops[i], 0);
					B.push(" ");
					this.s2j(rights[i], 0);
				}
			}
			// B.push(" )");
		}

		else if(type == "ObjectTemplateDefinition"){
			if(!this.isNull(e[pos+1])) B.push("case");
			B.push("object ");
			this.s2j(e[pos + 2], 0);
		}
		else if(type == "Param"){
			this.s2j(e[pos+1], 0); //annotations
			this.s2j(e[pos+2], 0); //id
			if(!this.isNull(e[pos+3])){ //pt
				B.push(': ');
				this.s2j(e[pos+3], 0);
			}
			if(!this.isNull(e[pos+4])){ //expr
				B.push(' = ');
				this.s2j(e[pos+4], 0);
			}
		}
		else if(type == "ParamClause"){
			B.push('(');
			this.s2j(e[pos + 1], 0); //params
			B.push(')');
		}
		else if(type == "PatDef"){
			B.separating(e[pos+1], ", "); //patterns
			if(!this.isNull(e[pos+2])){ //tp
				B.push(': ');
				this.s2j(e[pos+2], 0);
			}
			B.push(" = ");
			this.s2j(e[pos+3], 0);
		}
		else if(type == "PatternBinder"){
			this.s2j(e[pos+1], 0); //id
			if(!this.isNull(e[pos+2])){ //pt
				B.push('@ ');
				this.s2j(e[pos+2], 0);
			}
		}
		else if(type == "PatValDef"){
			B.push("val ");
			this.s2j(e[pos + 1], 0);
		}
		else if(type == "PatVarDef"){
			B.push("var ");
			this.s2j(e[pos + 1], 0);
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
				if(!trans.isNull(stat)){
					trans.s2j(stat, 0);
					B.format(';', newline);
				}
			});
			B.format(-2, '}');
		}
		else if(type == "TypeArgs"){
			B.push('[');
			this.s2j(e[pos+1], 0);
			B.push(']');
		}
		else if(type == "Types"){
			B.separating(e[pos+1], ", ");
		}


		else if(typeof(f) != "undefined") f(e, pos+1);
		else if(typeof(ast[type]) == "number"){
			if(bDebug) console.error("do_scala2 :: %s, num = %d\n",type, ast[type]);
			var p = pos + 1;
			// B.separating(e, ' ', p, p+ast[type]);
			for(var i = p; i < p + ast[type]; i++){
				this.s2j(e[i], 0);
			}
		}
		else throw new Error("do_scala: unknown type => " + type + ", pos = " + pos + ", e => " + e );
	},

	do_list : function(es, pos){
		// if(bDebug) DP("do_list", pos, es, 1);
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
		else if(this.isNull(e)) this.do_list(es, pos + 1);
		else if(this.isSymbol(e)){
			if(e.name == "begin") this.do_begin(es, pos + 1);
			else if(e.name == "define") this.do_define(es[1], es[2]);
			else if(e.name == "lambda") this.do_lambda(es, pos + 1);
			else if(e.name == "letrec") this.do_retlec(es[1]);
			else{
				this.do_symbol(e);
				// this.do_list(es, pos+1);
			}
			// else throw new Error("do_list: Invalid symbol. => " + e.name);
		}
		else if(Array.isArray(e)){
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
		// console.error("this = " + this);
		// なぜかs2jではtransをthisにするとthisがグローバルオブジェクトを参照することがある・・・。
		if(typeof pos === 'undefined') console.error("s2j: assert => pos is undefined.");
		if(Array.isArray(e)) this.do_list(e, pos);
		else if(e == null) ;
		else if(this.isSymbol(e)) this.do_symbol(e);
		else if(typeof(e) == "string" || typeof(e) == 'number'){
			B.push(e);
			// else throw new Error("s2j: this string cannot happen. => " + e);
		}
		else throw new Error("s2j: Invalid elements in the Scheme program => " + typeof(e));
	},
	do_symbol : function(e){
		if(!this.isNull(e) && !this.isAt(e)){
			// console.error("do_symbol: %j, %s, %s", e, typeof(e), this.isVariable(e));
			if(this.isVariable(e)) B.push(delete_chars(convertAsterisk(e.name.slice(2))));
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
	// console.error(buff.toString());
	var tt = sexp.parse(buff.toString());
	console.error("%j", tt);
	trans.s2j(tt, 0);
	// B.format(t);
	var result = B.flush(fd);
	console.error("parse end!!!");
	if (fd) fs.closeSync(fd);
	return result;
};

// function doIt(){

	// var input = INPUTS[1];
	// // var buf = [];
	// // var fd = fs.openSync(input, 'r');
	// var rd = fs.readFileSync(input, 'utf8');
	// var buff = new Buffer(rd);
	// delete_chars(buff);
	// console.error(buff.toString());
	// var tt = sexp.parse(buff.toString());
	// console.error(JSON.stringify(tt, null, 2));

	// // this.s2j(tt);

	// exports.convert(tt, 1);

// }

// doIt();
