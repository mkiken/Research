/************** Initializer **************/
{
	var fs = require("fs");
	var files = require("/Users/wakitalab/Desktop/repository/Research/PEG_Packrat/files");
	
	//namespace
	var ns = {};
	
	//定数
	var consts = {};
	consts["FAIL_FUNC"] = -1;
	consts["END_INPUT"] = -2;
	
	//入力情報
	var inputs = {};
	inputs["str"] = fs.readFileSync( files.input() ).toString();
	inputs["len"] = inputs["str"].length; //入力文字列長
	inputs["pos"] = 0; //開始位置
	
	//Packrat Parsingで使うメモリ
	var memory = {};
	
	//関数テンプレート
	var template = {};
	//Prioritized Choiceテンプレート
	template.pri = function(f1, f2, dname, pos){
		var cacheKey = dname + "@" + pos;
		if(memory[cacheKey]) return memory[cacheKey];
		var ret = f1(pos);
		if(ret == consts["FAIL_FUNC"]) ret = f2(pos);
		ret == inputs.len? consts["END_INPUT"] : ret;
		memory[cacheKey] = ret;
		return ret;
	};
	//Sequenceテンプレート
	template.seq = function(fary, dname, pos){
		var cacheKey = dname + "@" + pos;
		if(memory[cacheKey]) return memory[cacheKey];
		var ret = pos;
		for(var i = 0; i < fary.length; i++){
			ret = fary[i](ret);
			if(ret == consts["FAIL_FUNC"]) break;
		}
		ret == inputs.len? consts["END_INPUT"] : ret;
		memory[cacheKey] = ret;
		return ret;
	};
	//Starテンプレート
	template.star = function(f, dname, pos){
		var cacheKey = dname + "@" + pos;
		if(memory[cacheKey]) return memory[cacheKey];
		var ret = pos, backRet = pos;
		while(true){
			ret = f(ret);
			if(ret == consts["FAIL_FUNC"]) break;
			backRet = ret;
		}
		ret = backRet == inputs.len? consts["END_INPUT"] : backRet;
		memory[cacheKey] = ret;
		return ret;
	};
	//Plusテンプレート (syntax sugar)
	template.plus = function(f, dname, pos){
		var cacheKey = dname + "@" + pos;
		if(memory[cacheKey]) return memory[cacheKey];
		var ret = pos, backRet = consts["FAIL_FUNC"];
		while(true){
			ret = f(ret);
			if(ret == consts["FAIL_FUNC"]) break;
			backRet = ret;
		}
		ret = backRet == inputs.len? consts["END_INPUT"] : backRet;
		memory[cacheKey] = ret;
		return ret;
	};
	//Questionテンプレート (syntax sugar)
	template.question = function(f, dname, pos){
		var cacheKey = dname + "@" + pos;
		if(memory[cacheKey]) return memory[cacheKey];
		var ret = f(ret);
		if(ret == consts["FAIL_FUNC"]) ret = 0;
		memory[cacheKey] = ret;
		return ret;
	};
	//Andテンプレート (syntax sugar)
	template.and = function(f, dname, pos){
		var cacheKey = dname + "@" + pos;
		if(memory[cacheKey]) return memory[cacheKey];
		var ret = f(ret);
		if(ret != consts["FAIL_FUNC"]) ret = pos;
		memory[cacheKey] = ret;
		return ret;
	};
	//Notテンプレート
	template.not = function(f, dname, pos){
		var cacheKey = dname + "@" + pos;
		if(memory[cacheKey]) return memory[cacheKey];
		var ret = f(ret);
		ret = ret == consts["FAIL_FUNC"]? pos : consts["FAIL_FUNC"];
		memory[cacheKey] = ret;
		return ret;
	};
	//Identifierテンプレート
	template.identifier = function(dname, pos){
		var cacheKey = dname + "@" + pos;
		if(memory[cacheKey]) return memory[cacheKey];
		var ret = ns[dname](pos);
		memory[cacheKey] = ret;
		return ret;
	}
	//Literalテンプレート
	template.literal = function(lit, dname, pos){
		//console.log("literal = " + lit + ", pos = " + pos);
		var cacheKey = dname + "@" + pos;
		if(memory[cacheKey]) return memory[cacheKey];
		var ret = pos + lit.length - 1;
		if(ret < inputs["len"] && pos != consts["END_INPUT"]){
			ret++;
			if(inputs["str"].substring(pos, ret) == lit){
				ret = ret == inputs.len? consts["END_INPUT"] : ret;
				memory[cacheKey] = ret;
				return ret;
			}
		}
		memory[cacheKey] = consts["FAIL_FUNC"];
		return consts["FAIL_FUNC"];
	};
	
	//汎用関数
	var func = {};
	func.idx = 0;
	//sjoin : 再帰的にjoinして配列を文字列にする
	func.sjoin = function(ary){
		if(typeof(ary) == 'string') return ary;
		for(var i in ary) ary[i] = func.sjoin(ary[i]);
		return ary.join(deliminator='');
	};
	//form : 位置情報を人間用に修正
	func.form = function(n){
		var str = "";
		switch(n){
		case consts["FAIL_FUNC"]:
			str = "FAIL_FUNC";
			break;
		case consts["END_INPUT"]:
			str = "END_INPUT [" + inputs["len"] + "]";
			break;
		default:
			str += n;
			break;
		}
		return str;
	}
} start
  = Grammar

Grammar
  = SPACING fd:FirstDefinition Definition* EOF {return func.form(ns[fd](inputs["pos"]));}
  //= SPACING Definition+ EOF
  
FirstDefinition
  = left:Identifier LEFTARROW right:Expression 
  {
  	ns[left] = right;
  	return left;
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

SPACING
  = (SPACE)*

SPACE
  = " " / "\\" / EOL

EOF
  = !.

EOL
  = "\r\n" / "\n" / "\r"
