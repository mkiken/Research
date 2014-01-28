
var sexp = require('sexpression');
var fs = require('fs');
// var bDebug = true;
var bDebug = false;

//debug print
function DP(fname, pos, e, level){
	console.error("\n[%s] : pos = %d", fname, pos);
	if(level == 1) console.error(e);
	else if(level == 2) console.error("%s", e);
	else if(level == 3) console.error("%j", e);
	else if(level == 4) console.error(JSON.stringify(e, null, 1));
}

var ast = {};
fs.readFileSync(__dirname + '/ast.spec', 'utf8').split('\n').forEach(function (line) {
    var spec = line.split(': ');
    if (spec.length === 1) return;
    var type = spec[0], keys = spec[1].split(', ');
    keys.splice(0, 0, 'type');
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
	B.push('\n');
	bol = true;
}

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
		if(typeof separator === 'undefined') separator = ' ';
		if(typeof s === 'undefined') s = 0;
		if(typeof t === 'undefined') t = arr.length;
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
			}
			else if (typeof a === 'function') a();
			else throw new Error('I do not know what to do with: ' + a);
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
			buf.forEach(function (line) {
				fs.writeSync(fd, line);
			});
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
		return typeof(e) == "object" && typeof e.name !== 'undefined' && e.name == "__nul";
	},
	isAt : function(e){
		return typeof(e) == "object" && e.name == "__@";
	},
	isVariable : function(e){
		if(typeof(e) == "string" && e.length >= 3){
			if(e[0] == 'V' && e[1] == '-') return true;
		}
		return false;
	},
	isReserved : function(e){
		if(typeof(e) == "string" && e.length >= 3){
			if(e[0] == 'R' && e[1] == '-') return true;
		}
		return false;
	},
	isTypeVariable : function(e){
		if(typeof(e) == "object" && typeof e.name == 'string' && e.name.length >= 3){
			if(e.name[0] == 'T' && e.name[1] == '-') return true;
		}
		return false;
	},
	isWildCard : function(e){
		if(typeof(e) == "object" && typeof e.name == 'string' && e.name.length >= 12){
			//wildcardはV--WILDCARD-\x60;38*のような形
			if(e.name.substr(0, 12) == "V--WILDCARD-") return true;
		}
		return false;
	},


	do_begin : function(e, pos){
		for(var i = pos; i < e.length; i++){
			if(!trans.isNull(e[i])){trans.s2j(e[i], 0);
				B.format(newline);
			}
		}
	},

	do_lambda : function(e, pos){
		var params = e[pos], types = e[pos+1];
		B.push("( ");
		B.push("( ");
		if(params !== null){
			for(var i = 0; i < params.length; i++){
				this.do_symbol(params[i], 1); //パラメータはシンボル
				if(!this.isNull(types[i])) {
					B.push(" : ");
					this.do_scala(types[i], 1);
				}
				if(i != params.length-1) B.push(", ");
			}
		}
		B.push(" ) => ");
		this.s2j(e[pos + 2], 0); //body
		B.push(" )");
	},

	//letrec*の変数宣言を解析する
	do_letrec_star : function(e, pos){
		//変数宣言の解析
		var vars = e[pos];
		if(vars == null) return;
		for(var i = 0; i < vars.length; i++){
			var def = vars[i];
			var prefix = def[1][0];
			if(prefix[0].name === "val"){
				if(prefix[1].name === "variable"){
					var option = def[1][3];
					this.s2j(option[0], 0);
					this.s2j(option[1], 0);
				}
				B.push("val ");
			}
			else if(prefix[0].name === "var"){
				if(prefix[1].name === "variable"){
					var option = def[1][3];
					this.s2j(option[0], 0);
					this.s2j(option[1], 0);
				}
				B.push("var ");
			}
			else if(prefix[0].name === "type"){
				if(prefix[1].name === "TypeDeclaration"
						|| prefix[1].name === "TypeDefinition"){
					var option = def[1][3];
					this.s2j(option[0], 0);
					this.s2j(option[1], 0);
				}
				B.push("type ");
			}
			else if(prefix[0].name === "lambda"){
				//関数定義
				if(prefix[2][0].name === "function"){
					var option = prefix[3];
					this.s2j(option[0], 0);
					this.s2j(option[1], 0);
					B.push("def ");
					// 整形して出力
					this.s2j(prefix[4], 0); //signature
					if(!this.isNull(prefix[5])){
						B.push(':');
						this.s2j(prefix[5], 0);
					}
					if(prefix[2][1].name === "FunctionDefinition"){
						B.push(' = ');
						this.s2j(prefix[6], 0);
					}
					else if(prefix[2][1].name === "Procedure"){
						B.format('{', newline, 2);
						this.s2j(prefix[6], 0); //block
						B.format(-2, '}');
					}
					B.format(';', newline);
					continue;
				}
				else{
					throw new Error("sx2scala.do_letrec*: undefined prefix_lambda. => " + prefix[2]);
				}
			}
			else{
				throw new Error("sx2scala.do_letrec*: undefined prefix0. => " + prefix[0]);
			}

			this.do_symbol(def[0]); //変数名
			B.push(" "); //変数名
			if(prefix[1].name === "variable"){
				//付加情報を処理する
				var infos = def[1][1];
				for(var j = 0; j < infos.length; j++){
					if(!this.isNull(infos[j])){
						if(infos[j][0] === "Scala" && infos[j][1] === "Type"){
							B.push(':');
							this.s2j(infos[j], 0);
						}
						else{
							throw new Error("sx2scala.do_letrec*: undefined info. => " + infos[j].type);
						}
					}
				}
				//右辺
				if(!this.isNull(def[1][2])){
					B.push(" = ");
					this.s2j(def[1][2], 0);
				}
				B.format(';', newline);
			}
			else if(prefix[1].name == "TypeDeclaration"){
				//付加情報を処理する
				B.format(';', newline);

			}
			else if(prefix[1].name == "TypeDefinition"){
				//付加情報を処理する
				var infos = def[1][1];
				for(var j = 0; j < infos.length; j++){
					if(!this.isNull(infos[j])){
						if(infos[j][0] === "Scala" && infos[j][1] === "Type"){
							B.push(':');
							this.s2j(infos[j], 0);
						}
						else{
							throw new Error("sx2scala.do_letrec*: undefined info. => " + infos[j].type);
						}
					}
				}
				//右辺
				B.push(" = ");
				this.s2j(def[1][2], 0);
				B.format(';', newline);

			}
			else{
				throw new Error("sx2scala.do_letrec*: undefined prefix1. => " + prefix[1]);
			}
		}
	},

	do_scala : function(e, pos){
		var type = e[pos];
		var f = trans[type];
		if(type == "AnonymousFunction"){
			this.s2j(e[pos+1], 0);
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
			if(!this.isNull(e[pos+1])) this.do_letrec_star(e[pos+1], 1);
			var body = e[pos+1];
			//BlockStateの解析
			if(!this.isNull(body[2]))
				body[2].forEach(function(stat){
					if(!trans.isNull(stat)
						&& !(stat[1] == "BlockStat" && trans.isNull(stat[4]))
						){
						trans.s2j(stat, 0);
						B.format(';', newline);
					}
				});
			if(!this.isNull(body[3])){
				this.s2j(body[3], 0);
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
			B.separating(e[pos+1], ", ");
		}
		else if(type == "ForStatement"){
			B.push("for");
			this.s2j(e[pos + 1], 0); //op
			this.s2j(e[pos + 3], 0); //enumrator
			this.s2j(e[pos + 2], 0); //cl
			this.s2j(e[pos + 4], 0); //yield
			this.s2j(e[pos + 5], 0); //statement
		}
		else if(type == "FunctionArgTypes"){
			B.push('(');
			B.separating(e[pos+1], ", ");
			B.push(')');
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
		else if(type == "FunctionType"){
			this.s2j(e[pos + 1], 0);
			B.push(" => ");
			this.s2j(e[pos + 2], 0);
		}
		else if(type == "Generator"){
			this.s2j(e[pos + 1], 0); //pt1
			B.push(" <- ");
			this.s2j(e[pos + 2], 0); //expr
			this.s2j(e[pos + 3], 0); //guard
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
			var seq = e[pos + 1];
			for(var i = 0; i < seq.length; i++){
			if(this.isSymbol(seq[i]) && this.isVariable(seq[i].name)){
				B.push(' ');
				this.s2j(seq[i], 0);
				B.push(' ');
			}
			else this.s2j(seq[i], 0);
			}
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
		else if(type == "PostfixExpression"){
			this.s2j(e[pos + 1], 0);
			if(!this.isNull(e[pos+2])){
				B.push(' ');
				this.s2j(e[pos + 2], 0);
				B.push(' ');
			}
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
		else if(type == "symbolLiteral"){
			B.push("'" + e[pos + 1]);
		}
		else if(type == "TemplateBody"){
			B.format('{', newline, 2);
			//selftypeの解析
			var body = e[pos + 1];
			if(!this.isNull(body[2])){
				this.s2j(body[2], 0);
				B.format(newline);
			}
			if(!this.isNull(e[pos+1])) this.do_letrec_star(e[pos+1], 1);

			//statsの解析
			if(!this.isNull(body[3]))
				body[3].forEach(function(stat){
					if(!trans.isNull(stat)
						&& !(stat[1] == "TemplateStatement" && trans.isNull(stat[4]))
						){
						trans.s2j(stat, 0);
						B.format(';', newline);
					}
				});
			B.format(-2, '}');
		}
		else if(type == "TupleExpression"){
			B.push('(');
			this.s2j(e[pos + 1], 0); //exprs
			B.push(')');
			if(!this.isNull(e[pos+2])){
				B.push(' ');
				this.s2j(e[pos+2], 0);
			}
		}
		else if(type == "TypeArgs"){
			B.push('[');
			this.s2j(e[pos+1], 0);
			B.push(']');
		}
		else if(type == "Types"){
			B.separating(e[pos+1], ", ");
		}
		else if(type == "VirtualExpression"){
			this.s2j(e[pos + 1], 0); //exprs
			if(!this.isNull(e[pos+2])){
				B.push(' ');
				this.s2j(e[pos+2], 0);
			}
		}
		else if(typeof(f) != "undefined") f(e, pos+1);
		else if(typeof(ast[type]) == "number"){
			var p = pos + 1;
			for(var i = p; i < p + ast[type]; i++){
				this.s2j(e[i], 0);
			}
		}
		else throw new Error("do_scala: unknown type => " + type + ", pos = " + pos + ", e => " + e );
	},

	do_list : function(es, pos){
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
			else if(e.name == "letrec") this.do_retlec(es[1], pos+1);
			else if(e.name == "letrec*") this.do_letrec_star(es, pos+1);
			else{
				this.do_symbol(e);
			}
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
		// なぜかs2jではtransをthisにするとthisがグローバルオブジェクトを参照することがある・・・。
		if(typeof pos === 'undefined') throw new Error("s2j: assert => pos is undefined.");
		if(Array.isArray(e)) this.do_list(e, pos);
		else if(e == null) ;
		else if(this.isSymbol(e)) this.do_symbol(e);
		else if(typeof(e) == "string" || typeof(e) == 'number'){
			B.push(e);
		}
		else throw new Error("s2j: Invalid elements in the Scheme program => " + typeof(e));
	},

	do_symbol : function(e){
		if(!this.isNull(e) && !this.isAt(e)){
			var nm = e.name;
			if(this.isVariable(nm)){
				if(this.isWildCard(e)) B.push("_");
				else B.push(delete_chars(convertAsterisk(nm.slice(2))));
			}
			else if(this.isReserved(nm)){
				var idx = nm.indexOf('-', 3);
				if(idx == -1) throw new Error("sx2scala . incorrect reserved words => " + nm);
				B.push(delete_chars(convertAsterisk(nm.slice(2, idx))));
			}
			else B.push(nm);
		}
	}
};

exports.convert = function (t, output) {
	var fd = false;
	if (typeof output === 'number') fd = output;
	if (typeof output === 'string') {
		fd = fs.openSync(output, 'w');
	}
	B.reset();
	var buff = new Buffer(t);
	delete_chars(buff);
	var tt = sexp.parse(buff.toString());
	// console.error("%j\n\n\n", tt);
	trans.s2j(tt, 0);
	var result = B.flush(fd);
	// if (fd) fs.closeSync(fd);
	return result;
};

