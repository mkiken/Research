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
		pri : function(f1, f2, dname, pos, inputs, memory, layer){
			var ret = f1(pos, inputs, memory, layer+1);
			if(ret == consts["FAIL_FUNC"]) ret = f2(pos, inputs, memory, layer);
			if(ret == consts["FAIL_FUNC"] && layer == 0) func.err(dname, pos, "matching at least one prioritized choice", "matching not", "");

			return ret;
		},

		//Sequenceテンプレート
		seq : function(fary, dname, pos, inputs, memory, layer){
			//console.log("seq invoked. |fary| = " + fary.length);
			var ret = {pos: pos, val: null}, vals = [], tmp;
			for(var i = 0; i < fary.length; i++){
				tmp = fary[i](ret.pos, inputs, memory, layer);
				ret.pos = tmp.pos;
				if(ret.pos == consts["FAIL_FUNC"]) break;
				vals.push(tmp.val);
				console.log("seq: tmp.val = " + vals[i]);
			}
			if(ret.pos != consts["FAIL_FUNC"]) ret.val = vals;
			//console.log("seq: ret = " + ret.val);
			return ret;
		},

		//Starテンプレート（Plusテンプレート）
		star : function(f, bPlus, dname, pos, inputs, memory, layer){
			var ret = consts["FAIL_FUNC"], tmp;
			if(bPlus){

			}
			tmp = (bPlus? f(pos, inputs, memory, layer) : pos);
			while(tmp != consts["FAIL_FUNC"]){
				ret = tmp;
				tmp = f(ret, inputs, memory, layer+1);
			}
			return ret;
		},

		//Questionテンプレート (syntax sugar)
		question : function(f, dname, pos, inputs, memory, layer){
			var ret = f(pos, inputs, memory, layer+1);
			if(ret == consts["FAIL_FUNC"]) ret.pos = pos;
			return ret;
		},

		//Notテンプレート（Andテンプレート (syntax sugar)）
		not : function(f, bAnd, dname, pos, inputs, memory, layer){
			var ret = f(pos, inputs, memory, layer+1);
			if(bAnd){
				if(ret.pos != consts["FAIL_FUNC"]) ret.pos = pos;
			}
			else ret.pos = (ret.pos == consts["FAIL_FUNC"]? pos : consts["FAIL_FUNC"]);
			if(ret.pos == consts["FAIL_FUNC"] && layer == 0) func.err(dname, pos, "predicate matching", "matching not", "");
			ret.val = null;
			return ret;
		},

		//Identifierテンプレート
		identifier : function(dname, pos, inputs, memory, layer){
			//console.log(dname + " invoked. pos = [" + pos + "]");
			var cacheKey = dname + "@" + pos, ret;
			if(memory[cacheKey]) ret = memory[cacheKey];
			else{
				ret = ns[dname](pos, inputs, memory, layer);
				memory[cacheKey] = ret;
			}
			//console.log("ret = " + ret);
			//console.log(dname + "[" + pos + "] end. ret = " + ret);
			return ret;
		},

		//Literalテンプレート
		literal : function(lit, dname, pos, inputs, memory, layer){
			var tmp = pos + lit.length - 1, ret = {pos: consts["FAIL_FUNC"], val: null};
			if(tmp < inputs.length && pos != consts["END_INPUT"]){
				tmp++;
				//console.log("lit : subs = " + inputs.substring(pos, ret.pos));
				if(inputs.substring(pos, tmp) == lit){
					ret.pos = (tmp == inputs.length? consts["END_INPUT"] : tmp);
					ret.val = lit;
					//console.log("lit : ret = " + ret);
				}
			}
			if(ret.pos == consts["FAIL_FUNC"] && layer == 0) func.err(dname, pos, lit, inputs.substring(pos, tmp), "");
			return ret;
		},

		//Classテンプレート
		cls : function(fary, bHat, dname, pos, inputs, memory, layer){
			var ret = {pos: consts["FAIL_FUNC"], val: null};
			for(var i = 0; i < fary.length; i++){
				//console.log("class -> " + typeof(fary[0][1]));
				//pegjsの仕様上、fary[i][1]に関数が入っている
				ret = fary[i][1](pos, inputs, memory, layer+1);
				if(ret.pos != consts["FAIL_FUNC"]) break;
			}
			if(bHat) ret.pos = (ret.pos == consts["FAIL_FUNC"]? pos+1 : consts["FAIL_FUNC"]);
			if(ret.pos == inputs.length) ret.pos = consts["END_INPUT"];
			if(ret.pos == consts["FAIL_FUNC"] && layer == 0) func.err(dname, pos, "class", "not match", "");
			return ret;
		},

		//Charテンプレート
		chr : function(c, dname, pos, inputs, memory, layer){
			//console.log("chr invoked. [" + c + "]");
			var ret = {pos: consts["FAIL_FUNC"], val: null};
			if(pos < inputs.length && pos != consts["END_INPUT"]){
				if(inputs[pos] == c){
					ret.pos = (pos+1 == inputs.length? consts["END_INPUT"] : pos+1);
					ret.val = c;
				}
			}
			//if(ret == consts["FAIL_FUNC"]) func.err(dname, pos, c, inputs[pos], "");
			return ret;
		},

		//Rangeテンプレート
		range : function(c1, c2, dname, pos, inputs, memory, layer){
			//console.log("range: c1 = " + c1 + ", c2 = " + c2);
			var ret = {pos: consts["FAIL_FUNC"], val: null};
			if(pos < inputs.length && pos != consts["END_INPUT"]){
				var c = inputs.charCodeAt(pos);
				if(c1 <= c && c <= c2){
					ret.pos = (pos+1 == inputs.length? consts["END_INPUT"] : pos+1);
					ret.val = inputs[pos];
				}
			}
			return ret;
		},

		//Dotテンプレート
		dot : function(dname, pos, inputs, memory, layer){
			var ret = {pos: consts["FAIL_FUNC"], val: null};
			//とりあえずEOF以外全部
			if(pos < inputs.length && pos != consts["END_INPUT"]){
				ret.pos = pos + 1;
				ret.val = inputs[pos];
				if(ret.pos == inputs.length) ret.pos = consts["END_INPUT"];
			}
			else if(layer == 0) func.err(dname, pos, "any character", "EOF", "");
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

		//form : 位置情報を人間用に修正
		form : function(n){
			var str = "";
			switch(n){
			case consts["FAIL_FUNC"]:
				str = "FAIL_FUNC";
				break;
			case consts["END_INPUT"]:
				str = "END_INPUT [" + inputs.length + "]";
				break;
			default:
				str += n;
				break;
			}
			return str;
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
	= " " / "\\" / EOL

COMMENT
//	= '#' (!EOF .)* EOL
	= '#' (!EOF !EOL .)* (EOL / EOF)
	/ '//' (!EOF !EOL .)* (EOL / EOF)
	/ '/*' (!'*/' .)* '*/'

EOF
	= !.

EOL
	= "\r\n" / "\n" / "\r"
