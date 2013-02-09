/************** Initializer **************/
{
	var fs = require("fs");
	
	//namespace
	var ns = {};
	
	//定数
	var consts = {};
	consts["FAIL_FUNC"] = -1;
	consts["END_INPUT"] = -2;
	
	//入力情報
	var inputs = {};
	//inputs["str"] = "abcabcab"; //入力文字列
	inputs["str"] = fs.readFileSync( './test001.input' ).toString();
	inputs["len"] = inputs["str"].length; //入力文字列長
	inputs["pos"] = 0; //開始位置
	
	//Packrat Parsingで使うメモリ
	var memory = {};
	
	//関数テンプレート
	var template = {};
	//Starテンプレート
	template.star = function(f, dname, pos){
		var cacheKey = dname + "@" + pos;
		if(memory[cacheKey]) return memory[cacheKey];
		var ret = pos, backRet = pos;
		while(true){
			ret = f(ret);
			//console.log("ret = " + ret);
			if(ret == consts["FAIL_FUNC"]){
				ret = backRet == inputs.len? consts["END_INPUT"] : backRet;
				memory[cacheKey] = ret;
				return ret;
			}
			backRet = ret;
		}
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
//  = Sequence (SLASH Sequence)*
  = Sequence

Sequence
//  = p:Prefix*  {return template["star"].bind(null, p[0], "star" + func.idx++);}
  = Prefix

Prefix
//  = (AND / NOT)? Suffix
  = Suffix

Suffix
//  = Primary STAR?
  = p:Primary STAR {return template["star"].bind(null, p, "star" + func.idx++);}
  / p:Primary {return p;}
//  = Primary

Primary
  = i:Identifier !LEFTARROW {return template["identifier"].bind(null, i);}
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

SLASH
  = "/" SPACING

AND
  = "&" SPACING

NOT
  = "!" SPACING

LEFTARROW
  = "<-" SPACING

SPACING
  = (SPACE)*

SPACE
  = " " / "\\" / EOL

EOF
  = !.

EOL
  = "\r\n" / "\n" / "\r"