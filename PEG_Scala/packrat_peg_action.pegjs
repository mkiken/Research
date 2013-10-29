/************** Initializer **************/
{

	//namespace
	var ns = {};

	//定数
	var consts = {
		FAIL_FUNC : -1,
		END_INPUT : -2
	};

	//関数テンプレート
	var template = {
		//Prioritized Choiceテンプレート
		pri : function(f1, f2, dname, pos, input, memory, nt, layer){
			var ret = f1(pos, input, memory, nt, layer+1);
			if(ret.pos == consts["FAIL_FUNC"]) ret = f2(pos, input, memory, nt, layer);
			if(ret.pos == consts["FAIL_FUNC"] && layer == 0) func.err(dname, pos, "matching at least one prioritized choice", "matching not", "");

			//console.log("pri:[" + dname + "] end. ret = " + ret.pos);
			return ret;
		},

		//Sequenceテンプレート
		seq : function(fary, dname, pos, input, memory, nt, layer){
			//console.log("seq invoked. |fary| = " + fary.length);
			var ret = {pos: pos, val: null}, vals = [], tmp;
			for(var i = 0; i < fary.length; i++){
				tmp = fary[i](ret.pos, input, memory, nt, layer);
				ret.pos = tmp.pos;
				if(ret.pos == consts["FAIL_FUNC"]) break;
				if(tmp.val != null) vals.push(tmp.val);
				//console.log("seq: tmp.val = " + vals[i]);
			}
			if(ret.pos != consts["FAIL_FUNC"]) ret.val = func.remUniAry(vals);
			//console.log("seq: ret = " + ret.val);
			//console.log("seq:[" + dname + "] end. ret = " + ret.pos);
			return ret;
		},

		//Starテンプレート（Plusテンプレート）
		star : function(f, bPlus, dname, pos, input, memory, nt, layer){
			var ret = {pos: bPlus? consts["FAIL_FUNC"] : pos, val: null}, tmp = f(pos, input, memory, nt, bPlus? layer : layer + 1), vals = [];
			if(!bPlus) tmp = {pos: pos, val: null};
			while(tmp.pos != consts["FAIL_FUNC"]){
				ret.pos = tmp.pos;
				if(tmp.val != null) vals.push(tmp.val);
				tmp = f(ret.pos, input, memory, nt, layer+1);
			}
			//if(ret.pos != consts["FAIL_FUNC"]) console.log(JSON.stringify(vals));;
			//if(ret.pos != consts["FAIL_FUNC"] && 1 <= vals.length) ret.val = func.sjoin(func.remUniAry(vals));
			if(ret.pos != consts["FAIL_FUNC"] && 1 <= vals.length) ret.val = func.remUniAry(vals);
			console.log("star[" + bPlus + "]: pos = " + ret.pos + ", val = " + ret.val);
			return ret;
		},

		//Questionテンプレート (syntax sugar)
		question : function(f, dname, pos, input, memory, nt, layer){
			var ret = f(pos, input, memory, nt, layer+1);
			//if(ret.pos == consts["FAIL_FUNC"]) ret.pos = pos;
			if(ret.pos == consts["FAIL_FUNC"]) ret = {pos:pos, val:ret.val};
			//console.log("que:[" + dname + "] end. ret = " + ret.pos);
			return ret;
		},

		//Notテンプレート（Andテンプレート (syntax sugar)）
		not : function(f, bAnd, dname, pos, input, memory, nt, layer){
			var ret = f(pos, input, memory, nt, layer+1);
			if(bAnd){
				//if(ret.pos != consts["FAIL_FUNC"]) ret.pos = pos;
				if(ret.pos != consts["FAIL_FUNC"]) ret = {pos:pos, val:null};
			}
			//else ret.pos = (ret.pos == consts["FAIL_FUNC"]? pos : consts["FAIL_FUNC"]);
			else ret = (ret.pos == consts["FAIL_FUNC"]? {pos:pos, val:null} : {pos:consts["FAIL_FUNC"], val:null});
			if(ret.pos == consts["FAIL_FUNC"] && layer == 0) func.err(dname, pos, "predicate matching", "matching not", "");
			//ret.val = null;
			//console.log("not:[" + dname + "] end. ret = " + ret.pos);
			return ret;
		},

		//Identifierテンプレート
		identifier : function(dname, pos, input, memory, nt, layer){
			//console.log(dname + " invoked. pos = [" + pos + "]");
			//console.log(dname + " invoked. nt = [" + JSON.stringify(nt) + "]");
			/* var i = 0; */
			/* for( key in nt ){ i++; } [> keyと言う文字は任意の変数名 <] */
			//alert(i);
			var cacheKey = dname + "@" + pos, ret, memo = memory[cacheKey];
			if(memo){
				//ret = {pos: memo.pos, val: memo.val};
				//ret = memory[cacheKey];
				ret = func.clone(memo);
			}
			else{
				ret = nt[dname](pos, input, memory, nt, layer);
				console.log(dname + " invoked. pos = " + pos);
				if(ret.val != null){
					console.log("---ret = " + func.form(ret.pos, input));
					console.log("---val = " + JSON.stringify(ret.val));
				}
				//memory[cacheKey] = ret;
				//valのメモ化は本当にこれで大丈夫？とりあえず
				//memory[cacheKey] = {pos: ret.pos, val: ret.val};
				memory[cacheKey] = func.clone(ret);
			}
			//console.log("ret = " + ret);
			//console.log(dname + "[" + pos + "] end. ret = " + JSON.stringify(ret));
			//console.log(dname + "[" + pos + "] end. ret = " + ret.pos);
			return ret;
		},

		//Literalテンプレート
		literal : function(lit, dname, pos, input, memory, nt, layer){
			var tmp = pos + lit.length - 1, ret = {pos: consts["FAIL_FUNC"], val: null};
			//console.log("literal: " + lit);
			if(tmp < input.length && pos != consts["END_INPUT"]){
				tmp++;
				//console.log("lit : subs = " + input.substring(pos, ret.pos));
				if(input.substring(pos, tmp) == lit){
					ret.pos = (tmp == input.length? consts["END_INPUT"] : tmp);
					ret.val = lit;
					//console.log("lit : ret = " + ret);
				}
			}
			if(ret.pos == consts["FAIL_FUNC"] && layer == 0) func.err(dname, pos, lit, input.substring(pos, tmp), "");
			//console.log("lit:[" + dname + "] end. ret = " + ret.pos);
			return ret;
		},

		//Classテンプレート
		cls : function(fary, bHat, dname, pos, input, memory, nt, layer){
			//var ret = {pos: consts["FAIL_FUNC"], val: null};
			var ret = {pos: pos, val: null};
			for(var i = 0; i < fary.length; i++){
				//console.log("class -> " + typeof(fary[0][1]));
				//pegjsの仕様上、fary[i][1]に関数が入っている
				ret = fary[i][1](pos, input, memory, nt, layer+1);
				if(ret.pos != consts["FAIL_FUNC"]) break;
			}
			//if(bHat) ret.pos = (ret.pos == consts["FAIL_FUNC"]? pos+1 : consts["FAIL_FUNC"]);
			if(bHat) ret = (ret.pos == consts["FAIL_FUNC"]? {pos:pos+1, val:ret.val} : ret);
			if(ret.pos == input.length) ret = {pos:consts["END_INPUT"], val:ret.val};
			if(ret.pos == consts["FAIL_FUNC"] && layer == 0) func.err(dname, pos, "class", "not match", "");
			//console.log("cls:[" + dname + "] end. ret = " + ret.pos);
			return ret;
		},

		//Charテンプレート
		chr : function(c, dname, pos, input, memory, nt, layer){
			//console.log("chr invoked. [" + c + "]");
			var ret = {pos: consts["FAIL_FUNC"], val: null};
			if(pos < input.length && pos != consts["END_INPUT"]){
				if(input[pos] == c){
					ret.pos = (pos+1 == input.length? consts["END_INPUT"] : pos+1);
					ret.val = c;
				}
			}
			//if(ret == consts["FAIL_FUNC"]) func.err(dname, pos, c, input[pos], "");
			//console.log("chr:[" + dname + "] end. ret = " + ret.pos);
			return ret;
		},

		//Rangeテンプレート
		range : function(c1, c2, dname, pos, input, memory, nt, layer){
			//console.log("range: c1 = " + c1 + ", c2 = " + c2);
			var ret = {pos: consts["FAIL_FUNC"], val: null};
			if(pos < input.length && pos != consts["END_INPUT"]){
				var c = input.charCodeAt(pos);
				if(c1 <= c && c <= c2){
					ret.pos = (pos+1 == input.length? consts["END_INPUT"] : pos+1);
					ret.val = input[pos];
				}
			}
			//console.log("range:[" + dname + "] end. ret = " + ret.pos);
			return ret;
		},

		//Dotテンプレート
		dot : function(dname, pos, input, memory, nt, layer){
			var ret = {pos: consts["FAIL_FUNC"], val: null};
			//とりあえずEOF以外全部
			if(pos < input.length && pos != consts["END_INPUT"]){
				ret.pos = pos + 1;
				ret.val = input[pos];
				if(ret.pos == input.length) ret.pos = consts["END_INPUT"];
			}
			else if(layer == 0) func.err(dname, pos, "any character", "EOF", "");
			//console.log("dot:[" + dname + "] end. ret = " + ret.pos);
			return ret;
		}
	};


	//汎用関数
	var func = {
		idx : 0,

		//sjoin : 再帰的にjoinして配列を文字列にする
		sjoin : function(ary){
			if(typeof(ary) == 'string') return ary;
			for(var i in ary) ary[i] = func.sjoin(ary[i]);
			return ary.join(deliminator='');
		},

		//remUniAry : [["a"]] -> "a"
		remUniAry : function(arg){
			//console.log("remUniAry invoked.");
			while(arg instanceof Array && arg.length == 1){
				arg = arg[0];
			}
			if(arg instanceof Array && arg.length == 0) arg = null;
			return arg;
		},

		//form : 位置情報を人間用に修正
		form : function(n, input){
			var str = "";
			switch(n){
			case consts["FAIL_FUNC"]:
				str = "FAIL_FUNC";
				break;
			case consts["END_INPUT"]:
				str = "END_INPUT [" + input.length + "]";
				break;
			default:
				str += n;
				break;
			}
			return str;
		},

		//clone : オブジェクトのクローンを作る
		clone : function(obj){
			return func.shallow_copy(obj);
		},
		//http://stackoverflow.com/questions/122102/most-efficient-way-to-clone-an-objec
		deep_copy : function(obj){
		//return JSON.parse(JSON.stringify(obj));
			if(obj == null || typeof(obj) != 'object') return obj;
			var temp = obj.constructor(); // changed
			for(var key in obj) temp[key] = func.clone(obj[key]);
			return temp;
		},
		shallow_copy : function(obj){
			//var extend = require('util')._extend;
			//return extend({}, obj);
			if(obj == null || typeof(obj) != 'object') return obj;
			var temp = obj.constructor(); // changed
			for(var key in obj) temp[key] = obj[key];
			return temp;
		},

		//err : エラーフォーマット
		err : function(dname, pos, expected, found, msg){
			throw new SyntaxError("in function [" + dname + "], expected '" + expected + "' , but '" + found + "' found.");
		}
	};


} start
	= Grammar

Grammar
// = c:Class SPACING {return c;}
	= SPACING fd:FirstDefinition Definition* EOF {
		return ns;
	}
//= SPACING Definition+ EOF

FirstDefinition
	= left:Identifier (Literal)? LEFTARROW right:Expression ";"?
{
	ns["START_SYMBOL"] = left;
  	ns[left] = right;
}

Definition
	= left:Identifier (Literal)? LEFTARROW right:Expression ";"?
{
  	ns[left] = right;
}
//{ return left + " <- " +  right; }

Expression
//  = s1:Sequence (SLASH s2:Sequence)* {console.log(typeof(s1)); return s1;}
	= s:Sequence SLASH e:Expression {return template["pri"].bind(null, s, e, "pri" + func.idx++);}
	/ s:Sequence {return s;}

Sequence
	= p:Prefix+ c:CodeBlock SPACING {/*console.log("code = " + typeof(c));*/return template["seq"].bind(null, p, "seq" + func.idx++);}
	/ p:Prefix+ SPACING {return template["seq"].bind(null, p, "seq" + func.idx++);}

//= p:Prefix*

CodeBlock
	= "{" c:Contents* "}" {return func.sjoin(c);}

Contents
	= CodeBlock / !"}" .

Prefix
//  = (AND / NOT)? Suffix
	= AND s:Suffix {return template["not"].bind(null, s, true, "and" + func.idx++);}
	/ NOT s:Suffix {return template["not"].bind(null, s, false, "not" + func.idx++);}
	/ s:Suffix {return s;}

Suffix
	= p:Primary STAR {return template["star"].bind(null, p, false, "star" + func.idx++);}
	/ p:Primary PLUS {return template["star"].bind(null, p, true, "plus" + func.idx++);}
	/ p:Primary QUESTION  {return template["question"].bind(null, p, "question" + func.idx++);}
	/ p:Primary {return p;}

Primary
	= Valuable? p:Primary2 {return p;}

Valuable
	= Identifier ":" SPACING

Primary2
	= i:Identifier !(Literal? LEFTARROW / [:]) {return template["identifier"].bind(null, i);}
	/ OPEN e:Expression CLOSE {return e;}
	/ l:Literal {
		//console.log("make:pliteral");
		return l;
	}
    / c:Class {return c;}
	/ DOT {return template["dot"].bind(null, "dot" + func.idx++);}

Literal
	= ['] l : (!['] Char)* ['] SPACING {return template["literal"].bind(null, func.sjoin(l), "literal" + func.idx++);}
	/ ["] l : (!["] Char)* ["] SPACING {/*console.log("make:literal = " + func.sjoin(l));*/return template["literal"].bind(null, func.sjoin(l), "literal" + func.idx++);}

Class
    = "[" c:ClassContents "]" SPACING {return c;}

ClassContents
    = "^" r:(!"]" Range)+ {return template["cls"].bind(null, r, true, "notcls" + func.idx++);}
    / r:(!"]" Range)* {return template["cls"].bind(null, r, false, "cls" + func.idx++);}

Range
    = c1:Char "-" !"]" c2:Char  {return template["range"].bind(null, c1.charCodeAt(0), c2.charCodeAt(0), "range" + func.idx++);}
	/ c:Char {return template["chr"].bind(null, c, "chr" + func.idx++);}

Char
//    = "\\" c:[nfbrt'"] {return "\\" + c;}
//	= "\\]"  { return "]";  }
//	/ "\\'"  { return "'";  }
//    / '\\"'  { return '"';  }
//    / "\\\\" { return "\\"; }
//    / "\\/"  { return "/";  }
    = "\\b"  { return "\b"; }
    / "\\f"  { return "\f"; }
    / "\\n"  { return "\n"; }
    / "\\r"  { return "\r"; }
    / "\\t"  { return "\t"; }
    / "\\v"  { return "\v"; }
    / "\\u" h1:hexDigit h2:hexDigit h3:hexDigit h4:hexDigit {return String.fromCharCode(parseInt("0x" + h1 + h2 + h3 + h4));}
	/ "\\x" h1:hexDigit h2:hexDigit {return String.fromCharCode(parseInt("0x" + h1 + h2));}

	/ "\\" n1:[0-2] n2:[0-7] n3:[0-7] {return String.fromCharCode(parseInt(n1 + n2 + n3));}
	/ "\\" n1:[0-7] n2:[0-7] {return String.fromCharCode(parseInt(n1 + n2));}
	/ "\\" n1:[0-7] {return String.fromCharCode(parseInt(n1));}
	/ "\\" c:. {return c;}
	/ !"\\" c:. {return c;}


hexDigit
	= h:[0-9a-fA-F] {return h;}

Identifier
	= is:Identstart ic:Identcont* SPACING
{//console.log(is + " " + func.sjoin(ic));
 return is + func.sjoin(ic);
}

Identstart
	= [a-zA-Z_]

Identcont
	= Identstart / [0-9]

STAR
	= "*" SPACING

PLUS
	= "+" SPACING

SLASH
	= "/" SPACING

AND
	= "&" SPACING

NOT
	= "!" SPACING

QUESTION
	= "?" SPACING

LEFTARROW
	= "=" SPACING

OPEN
	= "(" SPACING

CLOSE
	= ")" SPACING

DOT
	= "." SPACING

SPACING
	= (SPACE / COMMENT)*

SPACE
	= " " / "\\" / "\t" / EOL

COMMENT
//	= '#' (!EOF .)* EOL
	= '#' (!EOF !EOL .)* (EOL / EOF)
	/ '//' (!EOF !EOL .)* (EOL / EOF)
	/ '/*' (!'*/' .)* '*/'

EOF
	= !.

EOL
	= "\r\n" / "\n" / "\r"
