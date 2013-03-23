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
			ret == inputs.length? consts["END_INPUT"] : ret;
			memory[cacheKey] = ret;
			return ret;
		},

		//Sequenceテンプレート
		seq : function(fary, dname, pos, inputs, memory){
			var cacheKey = dname + "@" + pos;
			if(memory[cacheKey]) return memory[cacheKey];
			var ret = pos;
			for(var i = 0; i < fary.length; i++){
				ret = fary[i](ret, inputs, memory);
				if(ret == consts["FAIL_FUNC"]) break;
			}
			ret == inputs.length? consts["END_INPUT"] : ret;
			memory[cacheKey] = ret;
			return ret;
		},

		//Starテンプレート
		star : function(f, dname, pos, inputs, memory){
			var cacheKey = dname + "@" + pos;
			if(memory[cacheKey]) return memory[cacheKey];
			var ret = pos, backRet = pos;
			while(true){
				ret = f(ret, inputs, memory);
				if(ret == consts["FAIL_FUNC"]) break;
				backRet = ret;
			}
			ret = backRet == inputs.length? consts["END_INPUT"] : backRet;
			memory[cacheKey] = ret;
			return ret;
		},

		//Plusテンプレート (syntax sugar)
		plus : function(f, dname, pos, inputs, memory){
			var cacheKey = dname + "@" + pos;
			if(memory[cacheKey]) return memory[cacheKey];
			var ret = pos, backRet = consts["FAIL_FUNC"];
			while(true){
				ret = f(ret, inputs, memory);
				if(ret == consts["FAIL_FUNC"]) break;
				backRet = ret;
			}
			ret = backRet == inputs.length? consts["END_INPUT"] : backRet;
			memory[cacheKey] = ret;
			return ret;
		},

		//Questionテンプレート (syntax sugar)
		question : function(f, dname, pos, inputs, memory){
			var cacheKey = dname + "@" + pos;
			if(memory[cacheKey]) return memory[cacheKey];
			var ret = f(ret, inputs, memory);
			if(ret == consts["FAIL_FUNC"]) ret = 0;
			memory[cacheKey] = ret;
			return ret;
		},

		//Andテンプレート (syntax sugar)
		and : function(f, dname, pos, inputs, memory){
			var cacheKey = dname + "@" + pos;
			if(memory[cacheKey]) return memory[cacheKey];
			var ret = f(pos, inputs, memory);
			if(ret != consts["FAIL_FUNC"]) ret = pos;
			memory[cacheKey] = ret;
			//console.log("ret = " + ret);
			return ret;
		},

		//Notテンプレート
		not : function(f, dname, pos, inputs, memory){
			var cacheKey = dname + "@" + pos;
			if(memory[cacheKey]) return memory[cacheKey];
			var ret = f(pos, inputs, memory);
			ret = ret == consts["FAIL_FUNC"]? pos : consts["FAIL_FUNC"];
			memory[cacheKey] = ret;
			return ret;
		},

		//Identifierテンプレート
		identifier : function(dname, pos, inputs, memory){
			//console.log(dname + " invoked.");
			var cacheKey = dname + "@" + pos;
			if(memory[cacheKey]) return memory[cacheKey];
			var ret = ns[dname](pos, inputs, memory);
			memory[cacheKey] = ret;
			//console.log("ret = " + ret);
			return ret;
		},

		//Literalテンプレート
		literal : function(lit, dname, pos, inputs, memory){
			//console.log("literal = " + lit + ", pos = " + pos);
			var cacheKey = dname + "@" + pos;
			if(memory[cacheKey]) return memory[cacheKey];
			var ret = pos + lit.length - 1;
			if(ret < inputs.length && pos != consts["END_INPUT"]){
				ret++;
				if(inputs.substring(pos, ret) == lit){
					ret = ret == inputs.length? consts["END_INPUT"] : ret;
					memory[cacheKey] = ret;
					return ret;
				}
			}
			memory[cacheKey] = consts["FAIL_FUNC"];
			return consts["FAIL_FUNC"];
		},


		//Dotテンプレート
		dot : function(dname, pos, inputs, memory){
			var cacheKey = dname + "@" + pos;
			if(memory[cacheKey]) return memory[cacheKey];
			var ret = pos;
			//とりあえずEOF以外全部
			if(ret < inputs.length && pos != consts["END_INPUT"]){
				ret++;
				ret = ret == inputs.length? consts["END_INPUT"] : ret;
				memory[cacheKey] = ret;
				return ret;
			}
			memory[cacheKey] = consts["FAIL_FUNC"];
			return consts["FAIL_FUNC"];
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
	= SPACING fd:FirstDefinition Definition* EOF {
		return ns;
	}
//= SPACING Definition+ EOF

FirstDefinition
	= left:Identifier LEFTARROW right:Expression
{
  	ns[left] = right;
}

Definition
	= left:Identifier LEFTARROW right:Expression
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
	= p:Prefix+ {return template["seq"].bind(null, p, "seq" + func.idx++);}
//= p:Prefix*

Prefix
//  = (AND / NOT)? Suffix
	= AND s:Suffix {return template["and"].bind(null, s, "and" + func.idx++);}
	/ NOT s:Suffix {return template["not"].bind(null, s, "not" + func.idx++);}
	/ Suffix

Suffix
//  = Primary STAR?
	= p:Primary STAR {return template["star"].bind(null, p, "star" + func.idx++);}
	/ p:Primary PLUS {return template["plus"].bind(null, p, "plus" + func.idx++);}
	/ p:Primary QUESTION  {return template["question"].bind(null, p, "question" + func.idx++);}
	/ p:Primary {return p;}
//  = Primary

Primary
	= i:Identifier !LEFTARROW {return template["identifier"].bind(null, i);}
	/ OPEN e:Expression CLOSE {return e;}
	/ l:Literal {return l;}
	/ DOT {return template["dot"].bind(null, "dot" + func.idx++);}

Literal
	= ['] l : (!['] Char)* ['] SPACING {return template["literal"].bind(null, func.sjoin(l), "literal" + func.idx++);}

							Char
							= //'\\' [nrt']
"\\" [0-2][0-7][0-7]
	/ "\\" [0-7][0-7]?
	/ !"\\" .

Identifier
	= is:Identstart ic:Identcont* SPACING {return is + ic;}

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
	= "<-" SPACING

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

EOF
	= !.

EOL
	= "\r\n" / "\n" / "\r"
