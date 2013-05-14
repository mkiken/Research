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
		pri : function(f1, f2, dname, pos, inputs, memory){
			var cacheKey = dname + "@" + pos;
			if(memory[cacheKey]) return memory[cacheKey];
			var ret = f1(pos, inputs, memory);
			if(ret == consts["FAIL_FUNC"]) ret = f2(pos, inputs, memory);
			memory[cacheKey] = ret;
			return ret;
		},

		//Sequenceテンプレート
		seq : function(fary, dname, pos, inputs, memory){
			//console.log("seq invoked. |fary| = " + fary.length);
			var cacheKey = dname + "@" + pos;
			if(memory[cacheKey]) return memory[cacheKey];
			var ret = pos;
			for(var i = 0; i < fary.length; i++){
				ret = fary[i](ret, inputs, memory);
				if(ret == consts["FAIL_FUNC"]) break;
			}
			memory[cacheKey] = ret;
			return ret;
		},

		//Starテンプレート（Plusテンプレート）
		star : function(f, bPlus, dname, pos, inputs, memory){
			var cacheKey = dname + "@" + pos;
			if(memory[cacheKey]) return memory[cacheKey];
			var ret = consts["FAIL_FUNC"], tmp;
			tmp = (bPlus? f(pos, inputs, memory) : pos);
			while(tmp != consts["FAIL_FUNC"]){
				ret = tmp;
				tmp = f(ret, inputs, memory);
			}
			memory[cacheKey] = ret;
			return ret;
		},

		//Questionテンプレート (syntax sugar)
		question : function(f, dname, pos, inputs, memory){
			var cacheKey = dname + "@" + pos;
			if(memory[cacheKey]) return memory[cacheKey];
			var ret = f(pos, inputs, memory);
			if(ret == consts["FAIL_FUNC"]) ret = pos;
			memory[cacheKey] = ret;
			return ret;
		},

		//Notテンプレート（Andテンプレート (syntax sugar)）
		not : function(f, bAnd, dname, pos, inputs, memory){
			var cacheKey = dname + "@" + pos;
			if(memory[cacheKey]) return memory[cacheKey];
			var ret = f(pos, inputs, memory);
			if(bAnd){
				if(ret != consts["FAIL_FUNC"]) ret = pos;
			}
			else ret = (ret == consts["FAIL_FUNC"]? pos : consts["FAIL_FUNC"]);
			memory[cacheKey] = ret;
			return ret;
		},

		//Identifierテンプレート
		identifier : function(dname, pos, inputs, memory){
			console.log(dname + " invoked. pos = [" + pos + "]");
			var cacheKey = dname + "@" + pos;
			if(memory[cacheKey]) return memory[cacheKey];
			var ret = ns[dname](pos, inputs, memory);
			memory[cacheKey] = ret;
			//console.log("ret = " + ret);
			return ret;
		},

		//Literalテンプレート
		literal : function(lit, dname, pos, inputs, memory){
			//console.log("literal = " + lit);
			//console.log("literal : pos = " + pos);
			var cacheKey = dname + "@" + pos;
			//console.log("lit : cache = " + cacheKey);
			//if(memory[cacheKey]) return memory[cacheKey];
			var tmp = pos + lit.length - 1, ret = consts["FAIL_FUNC"];
			if(tmp < inputs.length && pos != consts["END_INPUT"]){
				tmp++;
				//console.log("lit : subs = " + inputs.substring(pos, ret));
				if(inputs.substring(pos, tmp) == lit){
					ret = (tmp == inputs.length? consts["END_INPUT"] : tmp);
					//console.log("lit : ret = " + ret);
				}
			}
			memory[cacheKey] = ret;
			return ret;
		},

		//Classテンプレート
		cls : function(fary, bHat, dname, pos, inputs, memory){
			var cacheKey = dname + "@" + pos;
			if(memory[cacheKey]) return memory[cacheKey];
			var ret = pos;
			for(var i = 0; i < fary.length; i++){
				//console.log("class -> " + typeof(fary[0][1]));
				//pegjsの仕様上、fary[i][1]に関数が入っている
				ret = fary[i][1](pos, inputs, memory);
				if(ret != consts["FAIL_FUNC"]) break;
			}
			if(bHat) ret = (ret == consts["FAIL_FUNC"]? pos+1 : consts["FAIL_FUNC"]);
			if(ret == inputs.length) ret = consts["END_INPUT"];
			memory[cacheKey] = ret;
			return ret;
		},

		//Charテンプレート
		chr : function(c, dname, pos, inputs, memory){
			//console.log("chr invoked. [" + c[1] + "]");
			var cacheKey = dname + "@" + pos;
			if(memory[cacheKey]) return memory[cacheKey];
			var ret = consts["FAIL_FUNC"];
			if(pos < inputs.length && pos != consts["END_INPUT"]){
				if(inputs[pos] == c){
					ret = (pos+1 == inputs.length? consts["END_INPUT"] : pos+1);
				}
			}
			memory[cacheKey] = ret;
			return ret;
		},

		//Rangeテンプレート
		range : function(c1, c2, dname, pos, inputs, memory){
			console.log("range: c1 = " + c1 + ", c2 = " + c2);
			var cacheKey = dname + "@" + pos;
			if(memory[cacheKey]) return memory[cacheKey];
			var ret = consts["FAIL_FUNC"];
			if(pos < inputs.length && pos != consts["END_INPUT"]){
				var c = inputs.charCodeAt(pos);
				if(c1 <= c && c <= c2) ret = (pos+1 == inputs.length? consts["END_INPUT"] : pos+1);
			}
			memory[cacheKey] = ret;
			return ret;
		},

		//Dotテンプレート
		dot : function(dname, pos, inputs, memory){
			var cacheKey = dname + "@" + pos;
			if(memory[cacheKey]) return memory[cacheKey];
			var ret = consts["FAIL_FUNC"];
			//とりあえずEOF以外全部
			if(pos < inputs.length && pos != consts["END_INPUT"]){
				ret = pos + 1;
				if(ret == inputs.length) ret = consts["END_INPUT"];
			}
			memory[cacheKey] = ret;
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
	= left:Identifier (Literal)? LEFTARROW right:Expression
{
	ns["START_SYMBOL"] = left;
  	ns[left] = right;
}

Definition
	= left:Identifier (Literal)? LEFTARROW right:Expression
{
  	ns[left] = right;
}
//{ return left + " <- " +  right; }

Expression
//  = s1:Sequence (SLASH s2:Sequence)* {console.log(typeof(s1)); return s1;}
	= s:Sequence SLASH e:Expression {return template["pri"].bind(null, s, e, "pri" + func.idx++);}
	/ s:Sequence {return s;}
//  = Sequence

Sequence
	= p:Prefix+ CodeBlock? SPACING {return template["seq"].bind(null, p, "seq" + func.idx++);}
//= p:Prefix*

CodeBlock
	= "{" Contents* "}"

Contents
	= CodeBlock / !"}" .

Prefix
//  = (AND / NOT)? Suffix
	= AND s:Suffix {return template["not"].bind(null, s, true, "and" + func.idx++);}
	/ NOT s:Suffix {return template["not"].bind(null, s, false, "not" + func.idx++);}
	/ s:Suffix {return s;}

Suffix
//  = Primary STAR?
	= p:Primary STAR {return template["star"].bind(null, p, false, "star" + func.idx++);}
	/ p:Primary PLUS {return template["star"].bind(null, p, true, "plus" + func.idx++);}
	/ p:Primary QUESTION  {return template["question"].bind(null, p, "question" + func.idx++);}
	/ p:Primary {return p;}
//  = Primary

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
    = "^" r:(!"]" Range)* {return template["cls"].bind(null, r, true, "notcls" + func.idx++);}
    / r:(!"]" Range)* {return template["cls"].bind(null, r, false, "cls" + func.idx++);}

Range
    = c1:Char "-" c2:Char  {return template["range"].bind(null, c1[1].charCodeAt(0), c2[1].charCodeAt(0), "range" + func.idx++);}
	/ c:Char {return template["chr"].bind(null, c[1], "chr" + func.idx++);}

Char
//    = "\\" [nrt']
	= "\\" [0-2][0-7][0-7]
	/ "\\" [0-7][0-7]?
	/ !"\\" .
	/ "\\" .

Identifier
//	= is:Identstart ic:Identcont* (SPACING Literal)? SPACING {console.log(is + " " + func.sjoin(ic));return is + func.sjoin(ic);}

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
