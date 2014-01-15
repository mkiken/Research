
/* Initializer written by homizu */
{
  var group = { "[#": { close: "#]", type: "RepBlock" },
                "(": { close: ")", type: "Paren" },
                "{": { close: "}", type: "Brace" },
                "[": { close: "]", type: "Bracket"} }; // 括弧を表すオブジェクト
  var macroType = false;                // マクロの種類(expression, statement)を表す変数
  var outerMacro = false;               // マクロ内マクロを検出するための変数
  var metaVariables = { Identifier: [],
                        Expression: [],
                        Type: [],
                        /* statement: [], */
                        Symbol: [],
                        literal: [],
  marks: [] //punctuationMarkをとっておく
  };
  // メタ変数のリストを保持するオブジェクト
  /* var bTemplate = false; */
  var cTemplate = 0;
  var cExpression = 0;
  const arrow = "->";

  //引数をフィルターして適切な形に変形する
	//もしidxが入っていればarg[idx]を戻り値とする
	function ftr(arg, idx){
		//空文字列はnull
		if(typeof idx === 'undefined') idx = -1;
		if(isNull(arg)) return null;
		return idx == -1? arg : arg[idx];
	}

	//eがnullでなければeを返し，eがnullならば""を返す
	function ftr2(e){
		//空文字列はnull
		if(isNull(e)) return "";
		return e;
	}

	//e?でマッチ成功したかどうかを判定
	//PEG.js0.7では""
	//0.8ではnull
	function isNull(e){
		//for version 0.8
		if(e == null) return true;
		//for version 0.7
		else if(e == "") return true;
		else return false;
	}

	//keyをキーワードとする
	function makeKeyword(key){
		return {type:"Keyword", word:key};
	}

	//typeをvariableに変える
	function toVariable(obj){
		switch(obj.type){
			case 'Identifier':
			case 'Identifier2':
		/* obj.type = "Variable"; */
		/* return obj; */
				return {type: 'Variable', name: obj.name};
			case 'Ellipsis':
				return obj;
			default:
				throw new Error("toVariable: unexpected type: %s", obj.type);
		}
	}

	function dbg(){
		const range = 10;
		console.error("dbg : offset = %d, input = %s", offset, input.substr(Math.max(0, offset - range), Math.min(input.length - offset, 2*range)));
	}

	//[]をnullに変換
	/* function convertEmptyArray(a){ */
		/* if(Array.isArray(a) && a.length == 0) return null; */
		/* else return a; */
	/* } */


  // シンタックスエラーを表すオブジェクト
  function JSMacroSyntaxError(line, column, message) {
      this.line = line;
      this.column = column;
      this.message = message;
  }

  // misplacedエラーのメッセージを作成する関数
  var buildMisplacedMessage = function (name) {
      return "Misplaced " + name + ". The " + name + " must be at the top of the function body or in the body of the top-level program.";
  }

  // line, column がないときのための予備
  /* var line = undefined, column = undefined; */
  var line = -1, column = -1;
}

start = eles:(MacroDefinition / . )* {
	/* console.error("ex-scala[start], eles = " + JSON.stringify(eles)); */
	return {type: "MacroDefinitions",
		defs: eles.filter(function(item, index){
        /* if (item.type == 'MacroDefinition') return true; */
				if (typeof(item.type) != 'undefined' && item.type.indexOf('MacroDefinition') >= 0) return true;
				else return false;
  			}
  			)
	};
}
  /* = CompilationUnit */
	/* = ___ program:Program ___ { return program; } */


CompilationUnit = __ pcs:(PACKAGE QualId semi)* tss:TopStatSeq {
      var result = [];
      for (var i = 0; i < pcs.length; i++) {
        result.push(pcs[i][1]);
      }
	  return {type: "CompilationUnit", packages:result, topStatseq:tss};
    }

TopStatSeq = tp:TopStat tps:(semi TopStat)*{
      var result = [tp];
	  for (var i = 0; i < tps.length; i++) {
        result.push(tps[i][1]);
	  }
	  return {type:"TopStatSeq", topstat:result};
    }

TopStat = MacroDefinition
/ an:(Annotation nl?)* md:Modifier* td:TmplDef{
      var result = [];
	  for (var i = 0; i < an.length; i++) {
        result.push(an[i][0]);
	  }
	  return {type:"TopStat", annotation:an, modifier:md, def:td};
    }
/ Import
/ Packaging
/ PackageObject
/ OneLine //マクロ使用があっても無視できるようにしておく
/ Empty

Packaging = PACKAGE qi:QualId nl? OPBRACE tss:TopStatSeq CLBRACE {return {type:"Packaging", qualId:qi, topStatseq:tss}; }

PackageObject = PACKAGE OBJECT od:ObjectDef {return {type:"PackageObject", def:od}; }

QualId = head:id tail:(DOT id)* {
      var result = [head];
      for (var i = 0; i < tail.length; i++) {
        result.push(tail[i][1]);
      }
      return result;
    }


Program
  = elements:SourceElements? {
      return {
        type:     "Program",
        elements: isNull(elements) ? [] : elements
      };
    }

SourceElements
  = head:SourceElement tail:(___ SourceElement)* {
      var result=[head];
      for (var i = 0; i < tail.length; i++) {
        result.push(tail[i][1]);
      }
      return result;
    }

SourceElement
  = DeclarationStatement
  / st:Statement semi? {return st;}
	/ OneLine

OneLine
  /* = cs:(!LineTerminator SourceCharacter)* LineTerminator { */
  = cs:(!LineTerminator SourceCharacter)* {
  	var ary = [];
  	cs.forEach(function(e){ary.push(e[1]);});
  	return {type: "OneLine", contents: ary.join('')};
  }

LineTerminator
  = [\n\r\u2028\u2029]
LineTerminatorSequence "end of line"
  = "\n"
  / "\r\n"
  / "\r"
  / "\u2028" // line separator
  / "\u2029" // paragraph separator

SourceCharacter
  = .


/* StatementInTemplate */
//todo: 代入文の問題
  /* = &{ return macroType === "expression"; } */
    /* e:(ae:AssignmentExpression (";" { */
        /* throw new JSMacroSyntaxError(line, column, "Unexpected semicolon. The expression macro's template must be an expression."); */
       /* })? { return ae; } */
       /* /  */
       /* = Statement { throw new JSMacroSyntaxError(line, column, "Unexpected statement. The expression macro's template must be an expression."); }) { */
      /* return e; */
    /* } */
  /* / */
 /* = &{ return macroType === "statement"; } s:Statement { return s; } */

//todo: とりあえず
/* ForbiddenInStatement */
/*  = /*VariableStatement {
      throw new JSMacroSyntaxError(line, column, buildMisplacedMessage("var declaration"));
    }
	/MacroDefinition { */
      /* throw new JSMacroSyntaxError(line, column, buildMisplacedMessage("macro definition")); */
    /* } */
  /* / FunctionDeclaration { */
      /* throw new JSMacroSyntaxError(line, column, buildMisplacedMessage("function declaration")); */
    /* } */
  /* / WithStatement { */
      /* throw new JSMacroSyntaxError(line, column, "Invalid with statement. The with statement must not be used."); */
    /* } */

MacroIdentifier
  = name:IdentifierName {
      return { type: "Variable", name: name };
    }

MacroSymbol
  = name:IdentifierName {
      return { type: "StringLiteral", value: name };
    }

MacroKeyword
  = name:LiteralKeyword {
      return { type: "LiteralKeyword", name: name };
    }

DeclarationStatement // added
  = MacroDefinition
  /* / VariableStatement */
  /* / FunctionDeclaration */

MacroDefinition
  = type:(t:(ExpressionToken
        /* / StatementToken */
  			/ TypeToken
  			) {
        outerMacro = macroType; return macroType = t; })
	___
		macroName:Identifier ___ OPBRACE ___
		(MetaVariableDeclaration ___)*
		syntaxRules:SyntaxRuleList ___
		CLBRACE
		c:CheckOuterMacro
{
				/* if (c) */
           /* throw new JSMacroSyntaxError(line, column, "Unexpected macro definition. The macro definition must not be in the macro's template."); */
        var type = type.charAt(0).toUpperCase() + type.slice(1) + "MacroDefinition";
        var literals = metaVariables.literal;
        var marks = metaVariables.marks;
        macroType = false;
        for (var i in metaVariables)
            metaVariables[i] = [];
        return { type: type,
                 macroName: macroName,
                 literals: literals,
                 syntaxRules: syntaxRules,
        marks: marks};
    }


MetaVariableDeclaration
  = type:( "Identifier" / "Expression" / "Type" /* / "statement"  */
  		/ "Symbol") ___ ":" ___ list:VariableList ___ ";" {
        metaVariables[type] = metaVariables[type].concat(list);
        /* console.log("meta = " + JSON.stringify(metaVariables[type])); */
    }
  / "Keyword" ___ ":" ___ list:LiteralKeywordList ___ ";" {
        metaVariables.literal = metaVariables.literal.concat(list);
    }

VariableList
  = head:IdentifierName tail:(___ "," ___ IdentifierName)* {
        var result = [head];
        for (var i=0; i<tail.length; i++) {
            result.push(tail[i][3]);
        }
        return result;
    }

LiteralKeywordList
  = head:LiteralKeyword tail:(___ "," ___ LiteralKeyword)* {
        var result = [head];
        for (var i=0; i<tail.length; i++) {
            result.push(tail[i][3]);
        }
        return result;
    }

// リテラルキーワード "=>" は禁止
LiteralKeyword
  = !MacroArrow key:(IdentifierName / Punctuator) {return key;}

SyntaxRuleList
	= head:SyntaxRule tail:(___ SyntaxRule)* {
				var result = [head];
				for (var i=0; i<tail.length; i++) {
						result.push(tail[i][1]);
				}
				return result;
		}

SyntaxRule
	= OPRULE ___ pat:MacroPattern ___ MacroArrow ___ temp:Template ___ CLRULE {
				return { type: "SyntaxRule",
								 pattern: pat,
								 template: temp };
		}

OPRULE = OPBRACE
CLRULE = CLBRACE

// パターン
MacroPattern
	= (UNDER / !MacroArrow Identifier) ___ patterns:SubPatternList? { return patterns || []; }

SubPatternList
  /* = head:SubPattern middle:(___ SubPattern)* ellipsis:(___ "..." { return { line: line, column: column }; })? */
  = head:SubPattern middle:(___ SubPattern)* ellipsis:(___ "..." )?
    tail:(___ SubPattern)* {
        var result = [head];
        for (var i=0; i<middle.length; i++) {
            result.push(middle[i][1]);
        }
        if (ellipsis) {
            var elements, mark=[];
            for (var i=result.length-1; i>=0; i--) {
                if (result[i].type === 'PunctuationMark') {
                    mark.push(result.pop().value);
                } else {
                    elements = result.pop();
                    break;
                }
            }
            if (!elements){
								throw new JSMacroSyntaxError(ellipsis.line, ellipsis.column, "Bad ellipsis usage. Something except punctuation marks must be before ellipsis.");
                /* throw new Error("Bad ellipsis usage. Something except punctuation marks must be before ellipsis."); */
            }
            result.push({ type: "Repetition",
                          elements: elements,
                          punctuationMark: mark.reverse() });
            result.push({ type: "Ellipsis" });
        }
        for (var i=0; i<tail.length; i++) {
            result.push(tail[i][1]);
        }
        return result;
    }

SubPattern
  = g_open:("[#"/"("/"{"/"[") ___ patterns:SubPatternList? ___ g_close:("#]"/")"/"}"/"]")
    &{ return group[g_open].close === g_close; } {
       return {
         type: group[g_open].type,
         elements: isNull(patterns) ? [] : patterns
       };
    }
  / Literal
  / IdentifierVariable
  / ExpressionVariable
  / TypeVariable
  /* / StatementVariable */
  / SymbolVariable
  / name:LiteralKeyword &{ return metaVariables.literal.indexOf(name) >= 0; } {
        return {
            type: "LiteralKeyword",
            name: name
        };
    }
  / name:(IdentifierName / Punctuator / "," / ";" / "|") {
  	if(metaVariables.marks.indexOf(name) < 0) metaVariables.marks.push(name); //マークを覚えておく
        return {
            type: "PunctuationMark",
            value: name
        };
    }

IdentifierVariable
  = name:IdentifierName &{ return metaVariables.Identifier.indexOf(name) >= 0; } {
        return {
            type: "IdentifierVariable",
            name: name
        };
    }

ExpressionVariable
  = name:IdentifierName &{ return metaVariables.Expression.indexOf(name) >= 0; } {
        return {
            type: "ExpressionVariable",
            name: name
        };
    }

TypeVariable
  = name:IdentifierName &{ return metaVariables.Type.indexOf(name) >= 0; } {
        return {
            type: "TypeVariable",
            name: name
        };
    }
/* StatementVariable */
  /* = name:IdentifierName &{ return metaVariables.statement.indexOf(name) >= 0; } { */
        /* return { */
            /* type: "StatementVariable", */
            /* name: name */
        /* }; */
    /* } */

SymbolVariable
  = name:IdentifierName &{ return metaVariables.Symbol.indexOf(name) >= 0; } {
        return {
            type: "SymbolVariable",
            name: name
        };
    }

Punctuator
  =  puncs:PunctuatorSymbol+ !{ return puncs.join("") === arrow; } { return puncs.join(""); }

	//todo:ここはこれでいいのか？
PunctuatorSymbol
  = "<" / ">" / "=" / "!" / "+"
  / "-" / "*" / "%" / "&" / "/"
  / "^" / "!" / "~" / "?" / ":"

// テンプレート(パーザー拡張前)
Template
  = &{cTemplate++; return true;} head:Statement tail:(___ Statement)* &{cTemplate--; return true;}{
      var result = [head];
      for (var i=0; i<tail.length; i++) {
          result.push(tail[i][1]);
      }
      return result;
    }
/ &{cTemplate--; return false;}


//Expression用Ellipsis
ExprEllipsis = &{return cTemplate > 0} "..." __ {return {type: "Ellipsis"};}


//todo: どうする？？とりあえずExpressionでやってみる
Statement
	= Expr
	/ CharacterStatement   // added
  /* = "sss" */

CharacterStatement
	= !ExcludeWord char:.
		 { return { type: "Characterstmt", value: char }; }

ExcludeWord
	= EOS
  /* / CaseClause */
  /* / DefaultClause */

EOS
	= __ ";"
	/ _ LineTerminatorSequence
	/ _ &"}"
	/ __ EOF

_
	= (WhiteSpace / MultiLineCommentNoLineTerminator / singleLineComment)*

EOF
	= !.

MultiLineCommentNoLineTerminator
  = "/*" (!("*/" / LineTerminator) SourceCharacter)* "*/"

//todo: ひとまず甫水さんの実装に合わせる
MacroArrow
  = "->" !IdentifierPart

Identifier
  /* = !MacroArrow id */
  = !MacroArrow id:id {return id.name;}

IdentifierName
  = !MacroArrow id:id2 {return id.name;}

id2
= !KEYWORDS
name:(
		nm:plainid {return { type: "Variable", name: nm }; }
	/ [`] str:stringLiteral [`] __ { return { type: "Identifier2", name: '`' + str + '`'}; }
	) {return name;}

//todo?
CheckOuterMacro
  = { return false; }

___
  = (WhiteSpace / LineTerminatorSequence / comment)*

WhiteSpace "whitespace"
  = [\t\v\f \u00A0\uFEFF]
  / Zs
// Separator, Space
Zs = [\u0020\u00A0\u1680\u180E\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200A\u202F\u205F\u3000]

/* IdentifierToken = tok:"Identifier"       !IdentifierPart { return tok; } // added by homizu */
ExpressionToken = tok:"Expression"       !IdentifierPart { return tok; } // added by homizu
TypeToken = tok:"Type"       !IdentifierPart { return tok; } // added by kmori
/* SymbolToken = tok:"Symbol"       !IdentifierPart { return tok; } // added by kmori */
/* KeywordToken = tok:"Keyword"       !IdentifierPart { return tok; } // added by kmori */
/* StatementToken  = "statement"        !IdentifierPart { return "statement"; } // added by homizu */

IdentifierPart
  = letter / digit / opchar

RejectWords = &{}


/*Scalaコード*/

upper = [A-Z] / '$' / '_'
lower = [a-z]
letter = upper / lower
digit = [0-9]
opchar = [\+\-\*/><=!&|%:~\^|]
op = !("/*" / "//" / EQUAL) chars:opchar+ __ {return chars.join("");}
varid = start:lower parts:idrest {return start + parts;}
plainid = start:upper parts:idrest {return start + parts;}
		/ varid
		/ op
id
/* = ExprEllipsis */
= &(&{/*console.error("id invoked.");*/return cExpression == 0} / !RejectWords)
/* e:(nm:plainid {return { type: "Identifier", name: nm }; } */
	!KEYWORDS
name:(
 e:(nm:plainid {return { type: "Variable", name: nm }; }
	/ [`] str:stringLiteral [`] __ { return { type: "Variable2", name: '`' + str + '`'}; })
 /* {[>console.error("id is %j %d", e, cExpression);<]return e;} */
 ){return name;}

idrest	= chars:(letter / digit)* '_' ops:op __ {return chars.join("") + '_' + ops;}
		/ chars:(letter / digit)* __ {return chars.join("");}

Literal =
minus:HYPHEN? val:floatingPointLiteral {return {type: "floatingPointLiteral", value: ftr2(minus) + val}; }
/ minus:HYPHEN? val:integerLiteral {return {type: "integerLiteral", value: ftr2(minus) + val}; }
/ booleanLiteral
/ val:characterLiteral {return {type: "characterLiteral", value: val}; }
/ stringLiteral
/ val:symbolLiteral {return {type: "symbolLiteral", value: val}; }
/ 'null' __ {return {type: "nullLiteral", value: "null"}; }
integerLiteral = ilit:(decimalNumeral / hexNumeral / octalNumeral) ll:('L' / 'l')? __ {
	return ilit + ftr2(ll);
}
decimalNumeral	= '0'
				/ start:nonZeroDigit parts:digit* __ {return start + parts.join("");}

/* hexNumeral ::= ‘0’ ‘x’ hexDigit {hexDigit} */
hexNumeral = '0' 'x' parts:hexDigit+ __ {return "0x" + parts.join("");}

hexDigit = [0-9A-Fa-f]
/* octalNumeral ::= ‘0’ octalDigit {octalDigit} */
octalNumeral = '0' parts:octalDigit+ __ {return '0' + parts.join("");}

/* digit ::= ‘0’ | nonZeroDigit */
/* digit = '0' / nonZeroDigit */

/* nonZeroDigit ::= ‘1’ | ... | ‘9’ */
nonZeroDigit = [1-9]

/* octalDigit ::= ‘0’ | ... | ‘7’ */
octalDigit = [0-7]


floatingPointLiteral
	= dp:digit+ '.' ds:digit* exp:exponentPart? type:floatType? __ {return dp.join("") + '.' + ds.join("") + ftr2(exp) + ftr2(type);}
	/ '.' dp:digit+  exp:exponentPart? type:floatType? __ {return '.' + dp.join("") + ftr2(exp) + ftr2(type);}
	/ dp:digit+ exp:exponentPart type:floatType? __ {return dp.join("") + exp + ftr2(type);}
	/ dp:digit+ exp:exponentPart? type:floatType __ {return dp.join("") + ftr2(exp) + type;}

/* exponentPart ::= (‘E’ | ‘e’) [‘+’ | ‘-’] digit {digit} */
exponentPart = exp:('E' / 'e') sign:('+' / '-')? dt:digit+ {return exp + ftr2(sign) + dt.join("");}

/* floatType ::= ‘F’ | ‘f’ | ‘D’ | ‘d’*/
floatType = 'F' / 'f' / 'D' / 'd'

/* booleanLiteral ::= ‘true’ | ‘false’ */
booleanLiteral = ret:('true' / 'false') __ {return {type: "booleanLiteral", value: ret};}

/* characterLiteral ::= ‘\’’ printableChar ‘\’’ */
/* | ‘\’’ charEscapeSeq ‘\’’ */
characterLiteral = ['] chr:( printableChar / charEscapeSeq ) ['] __ {return chr;}
printableChar = !charEscapeSeq chr:. {return chr;}
charEscapeSeq	= '\\b' / '\\u0008'
				/ '\\t' / '\\u0009'
				/ '\\n' / '\\u000a'
				/ '\\f' / '\\u000c'
				/ '\\r' / '\\u000d'
				/ '\\"' / '\\u0022'
				/ "\\'" / '\\u0027'
				/ '\\' / '\\u005c'
printableCharNoDoubleQuote = !'"' chr:printableChar {return chr;}
charNoDoubleQuote = !'"' chr:. {return chr;}
/* stringLiteral ::= ‘"’ {stringElement} ‘"’ */
/* | ‘"""’ multiLineChars ‘"""’ */
stringLiteral	= '"' ele:stringElement* '"' __ {return {type: "stringLiteral", value: ele.join("")};}
				/ '"""' chrs:multiLineChars __ {return {type: "stringLiteralMulti", value: chrs};}

/* stringElement ::= printableCharNoDoubleQuote */
/* | charEscapeSeq */
stringElement	= printableCharNoDoubleQuote
				/ charEscapeSeq

/* multiLineChars ::= {[‘"’] [‘"’] charNoDoubleQuote} {‘"’} */
//check : これ結構解決難し・・・
multiLineChars	= eles:multiLineCharsElements* ('"""""' / '""""' / '"""') {return eles.join("");}

multiLineCharsElements = chrs:('"'? '"'? charNoDoubleQuote) {return chrs.join("");}
/* symbolLiteral ::= ‘’’ plainid */
symbolLiteral = "'" pi:plainid __ {return "'" + pi;}

Ascription = COLON infix:InfixType {return {type:"Ascription", contents:[infix]}; }
/ COLON as:Annotation+ {return {type:"Ascription", contents:as}; }
/ COLON ud:UNDER st:STAR {return {type:"Ascription", contents:[us,st]}; }

ExpressionMacro
  = &{}

TypeMacro
  = &{}


Expr
/* = ExprEllipsis */
= &{cExpression++;return true;} ExpressionMacro &{cExpression--;return true;}
/* / &{cExpression--;console.error("exprMacro 2"); return true;} ExpressionVariable */
/&{cExpression--;return true;} left:Bindings ARROW right:Expr {return {type:"AnonymousFunction", left:left, right:right}; }
/ impl:IMPLICIT? id:id ARROW right:Expr {return {type:"AnonymousFunctionId", impl:ftr(impl), id:id, right:right}; }
/ UNDER ARROW right:Expr {return {type:"AnonymousFunctionWild", right:right}; }
/ Expr1
Expr1 = IF OPPAREN condition:Expr CLPAREN nl* ifStatement:Expr elseStatement:(semi? ELSE Expr)? {
      return {
        type:          "IfStatement",
        condition:     condition,
        ifStatement:   ifStatement,
        elseStatement: ftr(elseStatement, 2)
      };
    }
/ WHILE OPPAREN condition:Expr CLPAREN nl* statement:Expr {
      return {
        type: "WhileStatement",
        condition: condition,
        statement: statement
      };
    }
/ TRY OPBRACE block:Block CLBRACE catch_:(CATCH OPBRACE CaseClauses CLBRACE)? finally_:(FINALLY Expr)?{
      return {
        type:      "TryStatement",
        block:     block,
        "catch":   ftr(catch_, 3),
        "finally": ftr(finally_, 2)
      };
    }
/ DO statement:Expr semi? WHILE OPPAREN condition:Expr CLPAREN {
      return {
        type: "DoWhileStatement",
        condition: condition,
        statement: statement
      };
    }
/ FOR enums:(OPPAREN Enumerators CLPAREN / OPBRACE Enumerators CLBRACE) nl* yield:('yield' __)? statement:Expr {
      return {
        type:        "ForStatement",
        enumrator: enums[1],
        yield:     ftr(yield, 0),
        statement:   statement
      };
    }
/ THROW exception:Expr {
      return {
        type:      "ThrowStatement",
        exception: exception
      };
    }
/ RETURN value:Expr? {
      return {
        type:  "ReturnStatement",
        value: ftr(value)
      };
    }
/ se1:SimpleExpr1 ae:ArgumentExprs EQUAL exp:Expr {return {type:"AssignmentFunction", func:se1, arg:ae, right:exp}; }
/ pe:PostfixExpr as:Ascription {return {type:"ExpressionWithAscription", postfix:pe, ascription:as}; }
/ pe:PostfixExpr MATCH OPBRACE cases:CaseClauses CLBRACE {return {type:"PatternMatchingExpression", postfix:pe, cases:cc}; }
/* / se:(SimpleExpr DOT)? id:id EQUAL exp:Expr {return {type:"AssignmentExpression", prefix:ftr(se), id:toVariable(id), right:exp}; } */
/ se:(SimpleExpr DOT)? id:id EQUAL exp:Expr {return {type:"AssignmentExpression", prefix:ftr(se), id:id, right:exp}; }
/ PostfixExpr

PostfixExpr = infix:InfixExpr id:(id nl?)? {return {type:"PostfixExpression", infix:infix, id: ftr(id, 0)};}

InfixExpr = head:PrefixExpr tails:(id nl? InfixExpr)* {
      var ids = [], exps = [];
	for (var i = 0; i < tails.length; i++) {
        ids.push(tails[i][0]);
        exps.push(tails[i][2]);
	  }
	return {type:"InfixExpression", left:head, ops:ids, rights:exps};
    }

PrefixExpr = op:(HYPHEN / PLUS / TILDE / BANG)? expr:SimpleExpr {
	return {type:"PrefixExpression", op:ftr(op), expr:expr};
}

SimpleExpr =
NEW arg:(ClassTemplate / TemplateBody) DOT id:id se1:_SimpleExpr1 {return {type:"InstanceCreationExpressionWithId", arg:arg, id:id, suffix:se1}; }
/ NEW arg:(ClassTemplate / TemplateBody) ta:TypeArgs se1:_SimpleExpr1 {return {type:"InstanceCreationExpressionWithTypes", arg:arg, types:ta, suffix:se1}; }
/ NEW arg:(ClassTemplate / TemplateBody) {
	return {type:"InstanceCreationExpression", arg:arg};
}
/ expr:SimpleExpr1 ud:UNDER? {
	return {type:"SimpleExpression", expr:expr, under:ftr(ud)};
}
/ BlockExpr

SimpleExpr1 = OPPAREN exp:Exprs? CLPAREN se1:_SimpleExpr1 {return {type:"TupleExpression", expr:exp, suffix:se1}; }
/ NEW arg:(ClassTemplate / TemplateBody) DOT id:id se1:_SimpleExpr1 {return {type:"InstanceCreationExpressionWithId", arg:arg, id:id, suffix:se1}; }
/ NEW arg:(ClassTemplate / TemplateBody) ta:TypeArgs se1:_SimpleExpr1 {return {type:"InstanceCreationExpressionWithTypes", arg:arg, types:ta, suffix:se1}; }
/ bk:BlockExpr DOT id:id se1:_SimpleExpr1 {return {type:"blockExpressionWithId", block:bk, id:id, suffix:se1}; }
/ bk:BlockExpr ta:TypeArgs se1:_SimpleExpr1 {return {type:"blockExpressionWithTypes", block:bk, types:ta, suffix:se1}; }
//todo: xmlどうしよう
/* / xml:XmlExpr se1:_SimpleExpr1 {return {type:"XmlSimpleExpression", xml:xml, suffix:se1}; } */

/ lt:Literal se1:_SimpleExpr1 {return {type:"literalSimpleExpression", literal:lt, suffix:se1}; }
/* / path:id !EQUAL se1:_SimpleExpr1 { return {type:"idSeqSimpleExpression", ids:toVariable(path), suffix:se1}; } */
/ path:id !EQUAL se1:_SimpleExpr1 { return {type:"idSeqSimpleExpression", ids:path, suffix:se1}; }
/* / path:id !EQUAL se1:_SimpleExpr1 { return {type:"idSeqSimpleExpression", ids:path, suffix:se1}; } */
/* _SimpleExpr1 = ud:UNDER? !(DOT id EQUAL) DOT id:id se1:_SimpleExpr1 {return {type:"DesignatorPostfix", under:ftr(ud), id:id, postfix:se1}; } */
_SimpleExpr1 = ud:UNDER? DOT id:id !EQUAL se1:_SimpleExpr1 {return {type:"DesignatorPostfix", under:ftr(ud), id:id, postfix:se1}; }
/ ud:UNDER? ta:TypeArgs se1:_SimpleExpr1 {return {type:"TypeApplicationPostfix", under:ftr(ud), typeArgument:ta, postfix:se1}; }
/ ud:UNDER se1:_SimpleExpr1 {return {type:"suffixSimpleExpression", expr:ud, suffix:se1}; }
/ ae:ArgumentExprs !EQUAL se1:_SimpleExpr1 {return {type:"FunctionApplicationPostfix", argument:ae, postfix:se1}; }
/ Empty

Exprs = expr:Expr exprs:(COMMA Expr)* el:(COMMA ExprEllipsis)? {
      var result = [expr];
	  for (var i = 0; i < exprs.length; i++) {
        result.push(exprs[i][1]);
	  }
	  if(!isNull(el)){
	  	result.push(el[1]);
	  }
	  return {type:"Exprs", contents:result};
    }

ArgumentExprs = OPPAREN exprs:Exprs? CLPAREN {return {type:"ArgumentExpression", exprs:ftr(exprs)}; }
/ OPPAREN exprs:(Exprs COMMA)? pfe:PostfixExpr COLON UNDER STAR CLPAREN {return {type:"ArgumentExprsWithRepeated", exprs:ftr(exprs, 0), postfixExpr:pfe}; }
/ nl? block:BlockExpr {return block; }

BlockExpr = OPBRACE block:CaseClauses CLBRACE {return {type: "PatternMatchingAnonymousFunction", block:block};}
/ OPBRACE block:Block CLBRACE {return {type: "BlockExpression", block:block}; }

Block = blocks:(BlockStat semi)* res:ResultExpr? {
      var result = [];
	  for (var i = 0; i < blocks.length; i++) {
        result.push(blocks[i][0]);
	  }
	  return {type:"Block", states:result,res:ftr(res)};
    }

BlockStat = Import
/ an:Annotation* md:(IMPLICIT / LAZY)? def:Def {return {type:"BlockStat", annotations:an, modifier:ftr(md), def:def}; }
/ an:Annotation* lm:LocalModifier* td:TmplDef {return {type:"TmplBlockStat", annotations:an, modifier:lm, def:td}; }
/ Expr1
/ Empty

ResultExpr =
left:(Bindings / (IMPLICIT? id / UNDER) COLON CompoundType) ARROW right:Block
{return {type:"AnonymousFunctionWithCompound", left:left, right:right}; }
/ Expr1

Bindings = OPPAREN bds:_Bindings? CLPAREN {
	return {type: "Bindings", bindings:ftr(bds)}
}

_Bindings = bd:Binding bds:(COMMA Binding)* el:(COMMA ExprEllipsis)? {
  var result = [bd];
	for (var i = 0; i < bds.length; i++) {
    result.push(bds[i][1]);
	}
	if(!isNull(el)){
		result.push(el[1]);
	}
	return result;
}

Binding = ud:UNDER tp:(COLON Type)? {return {type:"BindingAny", tp:ftr(tp, 1), ud:ud}; }
/* / id:id tp:(COLON Type)? {return {type:"Binding", id:toVariable(id), tp:ftr(tp, 1)}; } */
/ id:id tp:(COLON Type)? {return {type:"Binding", id:id, tp:ftr(tp, 1)}; }

Enumerators = gen:Generator enums:(semi Enumerator)* {
      var result = [];
	  for (var i = 0; i < enums.length; i++) {
        result.push(enums[i][1]);
	  }
	  return {type:"Enumerators", gen:gen, enums:result};
}
Enumerator = Generator
/ Guard
/ VAL pt1:Pattern1 EQUAL exp:Expr {return {type:"Enumerator", left:pt1, right:exp}; }

Generator = pt1:Pattern1 LEFTARROW expr:Expr guard:Guard? {return {type: "Generator", pt1:pt1, expr:expr, guard:guard}; }

CaseClauses = cls:CaseClause+ {return {type: "CaseClauses", cls:cls};}
CaseClause = CASE pt:Pattern guard:Guard? ARROW block:Block {return {type: "Generator", pt:pt, guard:ftr(guard), block:block}; }
Guard = IF postfix:PostfixExpr {return {type: "Guard", postfix:postfix};}
Type	= TypeMacro
/ TypeVariable
/ funcarg:FunctionArgTypes ARROW tp:Type {return {type:"FunctionType", left:funcarg, right:tp};}
		/ tp:InfixType ext:ExistentialClause? {return {type:"Type", exClause:ftr(ext), inType:tp};}
FunctionArgTypes	= InfixType
/ OPPAREN tps:( ParamType (COMMA ParamType )* )? CLPAREN {
  var result = [];
	if(!isNull(tps)){
		result.push(tps[0]);
		for (var i = 0; i < tps[1].length; i++) {
      result.push(tps[1][i][1]);
	  }
	}
	return {type:"FunctionArgTypes", contents:result};
}
ExistentialClause = FORSOME OPBRACE ex:ExistentialDcl exs:(semi ExistentialDcl)* CLBRACE {
  var result = [];
	result.push(ex);
	for (var i = 0; i < exs.length; i++) {
    result.push(exs[i][1]);
	}	  return {type:"ExistentialClause", contents:result};
}
ExistentialDcl	= tp:TYPE dcl:TypeDcl {return {type:"ExistentialDcl", pre:tp, dcl:dcl}}
				/ vl:VAL dcl:ValDcl {return {type:"ExistentialDcl", pre:vl, dcl:dcl}}


InfixType = head:CompoundType tails:(id nl? CompoundType)* {
      var ids = [], cts = [];
	for (var i = 0; i < tails.length; i++) {
        ids.push(tails[i][0]);
        cts.push(tails[i][2]);
	  }	  return {type:"InfixType", compoundType:head, ids:ids, compoundTypes:cts};
    }

CompoundType	= at:AnnotType wat:(WITH AnnotType)? ref:Refinement? {return {type:"CompoundType", annotType:at, withType:ftr(wat), ref:ftr(ref)};}
/ Refinement

AnnotType = st:SimpleType annotation:Annotation* {return {type:"AnnotType", simpleType:st, annotation:annotation}; }

SimpleType =
path:Path dot:DOT tp:TYPE  tails:(TypeArgs / withId)* {return {type:"SimplePathType", path:path, postfix:tails}; }
/ si:StableId tails:(TypeArgs / withId)* {return {type:"SimpleType", id:si, postfix:tails}; }
/ op:OPPAREN tps:Types cl:CLPAREN  tails:(TypeArgs / withId)* {return {type:"SimpleTypes", id:tps, postfix:tails}; }
withId = SHARP id:id {return {type:"withId", id:id};}
Annotation = AT stype:SimpleType exprs:ArgumentExprs* {return {type:"Annotation", stype:tp, exprs:exprs};}
ClassTemplate = ed:EarlyDefs? cp:ClassParents tb:TemplateBody? {return {type:"ClassTemplate", def:ftr(ed), classParent:cp, body:ftr(tb)}; }

TemplateBody = nl? OPBRACE tp:SelfType? nl? ts:TemplateStat tss:(semi TemplateStat)* nl? CLBRACE {
      var result = [ts];
	  for (var i = 0; i < tss.length; i++) {
        result.push(tss[i][1]);
	  }
	  return {type:"TemplateBody", selftype:ftr(tp), states:result};
}

TemplateStat = Import
/ ats:(Annotation nl?)* modifier:Modifier* def:(Def / Dcl) {
      var result = [];
	  for (var i = 0; i < ats.length; i++) {
        result.push(ats[i][0]);
	  }
	  return {type:"TemplateStatement", annotation:result, modifier:modifier, definition:def};
    }
/ Expr
/ Empty

SelfType = id:id tp:(COLON Type)? ARROW {return {type:"SelfType", id:id, tp:ftr(tp,1)};}
/ id:THIS COLON tp:Type ARROW {return {type:"SelfType", id:id, tp:tp};}

Import = IMPORT head:ImportExpr tail:(COMMA ImportExpr)* {
	var result = [head];
	for (var i = 0; i < tail.length; i++) {
		result.push(tail[i][1]);
	}
	return {type:"ImportStatement", exprs:result};
}

ImportExpr = id:StableId sel:(DOT (UNDER / ImportSelectors))? {return {type:"ImportExpr", id:id, selector:ftr(sel,1)};}

ImportSelectors = OPBRACE heads:(ImportSelector COMMA)* tail:(ImportSelector / UNDER) CLBRACE {
	var result = [];
	for (var i = 0; i < heads.length; i++) {
		result.push(heads[i][0]);
	}
	result.push(tail);
	return {type:"ImportSelectors", selectors:result};
}

ImportSelector = head:id tail:(ARROW id / ARROW UNDER)? {return {type:"ImportSelector", src:head, dest:ftr(tail,1)};}
TypeArgs = OPBRACKET types:Types CLBRACKET {return {type:"TypeArgs", types:types}; }

Types = tp:Type tps:(COMMA Type)* {
      var result = [tp];
	  for (var i = 0; i < tps.length; i++) {
        result.push(tps[i][1]);
	  }
	  return {type:"Types", contents:result};
}
PatVarDef = dcl:VAL body:PatDef {return {type:"PatValDef", body:body};}
/ dcl:VAR body:VarDef {return {type:"PatVarDef", body:body};}

Def = PatVarDef
/ DEF body:FunDef {return {type:"Definition", body:body};}
/ TYPE nl* body:TypeDef {return {type:"TypeDefinition", body:body};}
/ TmplDef

/* PatDef = ptn:Pattern2 ptns:(COMMA Pattern2)* tp:(COLON Type)? EQUAL expr:Expr{ */
	/* var result = [ptn]; */
	/* for (var i = 0; i < ptns.length; i++) { */
		/* result.push(ptns[i][1]); */
	/* } */
	/* return {type:"PatDef", patterns:result, tp:ftr(tp, 1), expr:expr}; */
/* } */
PatDef = ptn:Pattern2 ptns:(COMMA Pattern2)* tp:(COLON Type)? EQUAL expr:Expr{
	var result = [ptn];
	var patterns = [];
	var ttype = ftr(tp, 1);
	for (var i = 0; i < ptns.length; i++) {
		result.push(ptns[i][1]);
	}
	for (var i = 0; i < result.length; i++) {
		var e = result[i];
		if(e.type == "InfixOperatorPattern"){
			if(e.ids.length){
			throw new Error("ex-scala.PatDef : ids exist. => " + e.type);
			}
			if(typeof e.simplePattern !== 'string'){
			throw new Error("ex-scala.PatDef : pattern is not string type. => " + e.type);
			}
			patterns.push({type: "PatDefVariable", id: e.simplePattern, tp: ttype});
		}
		else{
			throw new Error("ex-scala.PatDef : type is not infix operator pattern. => " + e.type);
		}
	}
	return {type:"PatDef", patterns:patterns, expr:expr};
}

VarDef = PatDef
/ id:ids COLON tp:Type EQUAL ud:UNDER {
	var patterns = [];
		console.error("VarDef0: => %j", id);
	for (var i = 0; i < id.ids.length; i++) {
		var e = id.ids[i];
		console.error("VarDef: => %j", e);
		if(e.type == "Variable" || e.type == "Variable2"){
			patterns.push({type: "VarDefVariable", id: e.name, tp: tp});
		}
		else{
			throw new Error("ex-scala.VarDef : type is not infix operator pattern. => " + e.type);
		}
	}
	/* return {type:"VarDef", ids:id, tp:tp}; */
	return {type:"VarDef", patterns:patterns, expr:ud};
}

FunDef = fs:FunSig tp:(COLON Type)? EQUAL exp:Expr {return {type:"FunctionDefinition", signature:fs, tp:ftr(tp, 1), expr:exp}; }
/ fs:FunSig nl? OPBRACE bk:Block CLBRACE {return {type:"Procedure", signature:fs, block:bk}; }
/ THIS pc:ParamClause pcs:ParamClauses body:(EQUAL ConstrExpr / nl? ConstrBlock) {return {type:"ConstructorDefinition", param:pc, params:pcs, body:body}; }

TmplDef = cs:CASE? CLASS def:ClassDef {return {type:"ClassTemplateDefinition", prefix:ftr(cs), def:def}; }
/ cs:CASE? OBJECT def:ObjectDef {return {type:"ObjectTemplateDefinition", prefix:ftr(cs), def:def}; }
/ TRAIT def:TraitDef {return {type:"TraitTemplateDefinition", def:def}; }
Pattern = pt1:Pattern1 pt1s:( BAR Pattern1 )* {
      var result = [pt1];
	  for (var i = 0; i < pt1s.length; i++) {
        result.push(pt1s[i][2]);
	  }
	  return {type:"PatternAlternatives", pts:result};
}
Pattern1 = id:varid COLON tp:TypePat {return {type: "TypedPattern", id:id, tp:tp};}
/ id:UNDER COLON tp:TypePat {return {type: "TypedPattern", id:id, tp:tp};}
/ Pattern2

/* Pattern2 ::= varid [‘@’ Pattern3] */
/* | Pattern3 */
Pattern2 = Pattern3
/ id:varid pt:(AT Pattern3)? {return {type: "PatternBinder", id:id, pt:ftr(pt, 1)};}

/* Pattern3 ::= SimplePattern */
/* | SimplePattern { id [nl] SimplePattern } */
Pattern3 =
//SimplePattern
head:SimplePattern tails:( !EQUAL id nl? SimplePattern )* {
      var ids = [], cts = [];
	for (var i = 0; i < tails.length; i++) {
        ids.push(tails[i][0]);
        cts.push(tails[i][2]);
	  }	  return {type:"InfixOperatorPattern", simplePattern:head, ids:ids, simplePatterns:cts};
    }

/* SimplePattern ::= ‘_’ */
/* | varid */
/* | Literal */
/* | StableId */
/* | StableId ‘(’ [Patterns ‘)’ */
/* | StableId ‘(’ [Patterns ‘,’] [varid ‘@’] ‘_’ ‘*’ ‘)’ */
/* | ‘(’ [Patterns] ‘)’ */
/* | XmlPattern */
SimplePattern = UNDER
/ Literal
/ si:StableId OPPAREN pts:Patterns? CLPAREN {return {type: "ConstructorPattern", id:si, pattern:pts};}
/ id:StableId OPPAREN pts:(Patterns COMMA)? vi:(varid AT)? UNDER STAR CLPAREN {return {type: "PatternSequences", id:si, pattern:ftr(pts, 0), varid:ftr(vi, 0)};}
/ varid
/ StableId
/ OPPAREN pts:Patterns? CLPAREN {return {type: "TuplePattern", id:null, pattern:ftr(pts)};}
//todo:Xml...
/* / XmlPattern */
ParamClauses = pc:ParamClause* pm:(nl? OPPAREN IMPLICIT Params CLPAREN)? {return {type: "ParamClauses", clauses:pc, params:ftr(pm, 3)};}

/* ParamClause ::= [nl] ‘(’ [Params] ’)’ */
ParamClause = nl? OPPAREN pm:Params? CLPAREN {return {type: "ParamClause", params:ftr(pm)};}

/* Params ::= Param {‘,’ Param} */
Params = param:Param params:(COMMA Param)* {
      var result = [param];
	  for (var i = 0; i < params.length; i++) {
        result.push(params[i][1]);
	  }
	  return {type:"Params", params:result};
    }

/* Param ::= {Annotation} id [‘:’ ParamType] [‘=’ Expr] */
/* Param = an:Annotation* id:id pt:(COLON ParamType)? expr:(EQUAL Expr)? {return {type:"Param", annotations:an, id:toVariable(id), paramType:ftr(pt, 1), expr:ftr(expr, 1)}; } */
Param = an:Annotation* id:id pt:(COLON ParamType)? expr:(EQUAL Expr)? {return {type:"Param", annotations:an, id:id, paramType:ftr(pt, 1), expr:ftr(expr, 1)}; }


ParamType = ar:ARROW tp:Type {return {type:"ByNameParamType", tp:tp}; }
/ tp:Type st:STAR? {return {type:"RepeatedParamType", tp:tp, star:ftr(st)}; }

Dcl = VAL body:ValDcl {return body;}
/ VAR body:VarDcl {return body;}
/ DEF body:FunDcl {return body;}
/ TYPE nl* body:TypeDcl {return body;}

TypeParamClause = OPBRACKET param:VariantTypeParam params:(COMMA VariantTypeParam)* CLBRACKET {
      var result = [param];
	  for (var i = 0; i < params.length; i++) {
        result.push(params[i][1]);
	  }
	  return {type:"TypeParamClause", params:result};
}

ConstrAnnotation = AT tp:SimpleType exprs:ArgumentExprs {return {type:"ConstrAnnotation", stype:tp, exprs:exprs};}
Constr = at:AnnotType ae:ArgumentExprs* {return {type:"Constr", annotType:at, exprs:ae}; }
ClassQualifier = OPBRACKET qual:id CLBRACKET {return {type: "ClassQualifier", id:qual};}
VariantTypeParam = ans:Annotation* sign:(PLUS / HYPHEN)? param:TypeParam {return {type: "VariantTypeParam", annotations:ans, sign:ftr(sign), param:param};}

FunTypeParamClause = OPBRACKET param:TypeParam params:(COMMA TypeParam)* CLBRACKET {
      var result = [param];
	  for (var i = 0; i < params.length; i++) {
        result.push(params[i][1]);
	  }
	  return {type:"FunTypeParamClause", params:result};
}

TypeParam = id:(id / UNDER) cl:TypeParamClause? lower:(LEFTANGLE Type)? upper:(RIGHTANGLE Type)? view:(VIEW Type)* context:(COLON Type)*
{
	var views = [];
	for (var i = 0; i < view.length; i++) {
    views.push(view[i][2]);
	}
	var contexts = [];
	for (var i = 0; i < context.length; i++) {
    contexts.push(context[i][1]);
	}


	return {type: "TypeParam",
	id:id,
	 clause: ftr(cl),
	 lower: ftr(lower, 1),
	 upper: ftr(upper, 1),
	 view: views,
	 context: contexts};}


/* ValDcl ::= ids ‘:’ Type */
/* ValDcl = id:ids COLON tp:Type {return {type:"ValueDeclaration", id:id, tp:tp};} */
ValDcl = id:ids COLON tp:Type {
	var patterns = [];
	for (var i = 0; i < id.ids.length; i++) {
		var e = id.ids[i];
		if(e.type == "Variable" || e.type == "Variable2"){
			patterns.push({type: "VarDefVariable", id: e.name, tp: tp});
		}
		else{
			throw new Error("ex-scala.VarDef : type is not infix operator pattern. => " + e.type);
		}
	}
	/* return {type:"VarDef", ids:id, tp:tp}; */
	return {type:"ValueDeclaration", patterns:patterns};
}



/* VarDcl ::= ids ‘:’ Type */
/* VarDcl = id:ids COLON tp:Type {return {type:"VariableDeclaration", id:id, tp:tp};} */
VarDcl = id:ids COLON tp:Type {
	var patterns = [];
	for (var i = 0; i < id.ids.length; i++) {
		var e = id.ids[i];
		if(e.type == "Variable" || e.type == "Variable2"){
			patterns.push({type: "VarDefVariable", id: e.name, tp: tp});
		}
		else{
			throw new Error("ex-scala.VarDef : type is not infix operator pattern. => " + e.type);
		}
	}
	/* return {type:"VarDef", ids:id, tp:tp}; */
	return {type:"VariableDeclaration", patterns:patterns};
}

/* FunDcl ::= FunSig [‘:’ Type] */
FunDcl = sig:FunSig tp:(COLON Type)? {return {type:"FunctionDeclaration", signature:sig, tp:ftr(tp, 1)};}

/* FunSig ::= id [FunTypeParamClause] ParamClauses */
FunSig = id:id funtype:FunTypeParamClause? param:ParamClauses {return {type:"FunctionSignature", id:id, funtype:ftr(funtype), param:param};}


/* TypeDcl = id:id tpc:TypeParamClause? t1:(LEFTANGLE Type)? t2:(RIGHTANGLE Type)? {return {type:"TypeDeclaration", id:id, typeparam:ftr(tpc), type1:ftr(t1), type2:ftr(t2)};} */
TypeDcl = id:id tpc:TypeParamClause? t1:(LEFTANGLE Type)? t2:(RIGHTANGLE Type)? {
	var pattern = {type: "TypeDclVariable", id: id.name, tpc: ftr(tpc), left:ftr(t1, 1), right:ftr(t2, 1)};

	return {type:"TypeDeclaration", pattern:pattern};
}

Refinement = nl? OPBRACE ref:RefineStat refs:(semi RefineStat)* CLBRACE {
      var result = [ref];
	  for (var i = 0; i < refs.length; i++) {
        result.push(refs[i][1]);
	  }
	  return {type:"Refinement", contents:result};
    }

/* RefineStat ::= Dcl */
/* | ‘type’ TypeDef */
/* | */
RefineStat = Dcl
/ TYPE td:TypeDef {return {type:"RefineStat", typedef:td}; }
/ Empty
ids = head:id tail:(COMMA id)* {
      var result = [head];
      for (var i = 0; i < tail.length; i++) {
        result.push(tail[i][1]);
      }
      return {type:"ids", ids:result};
    }


Path	= StableId
		/ pre:(id DOT)? THIS {return {type:"Path", id:ftr(pre, 0)};}

/* StableId ::= id */
/* | Path ‘.’ id */
/* | [id ’.’] ‘super’ [ClassQualifier] ‘.’ id */
/* StableId	= id _StableId */
StableId	= base:id accessors:(DOT id)* {
      var result = [base];
      for (var i = 0; i < accessors.length; i++) {
        result.push(accessors[i][1]);
	  }
      return {type:"StableId", contents:result};
    }
			/* / (id DOT)? THIS DOT id _StableId */
/ pre:(id DOT)? th:THIS accessors:(DOT id)+ {
      var result = !isNull(pre) ? [pre[0], th] : [th];
      for (var i = 0; i < accessors.length; i++) {
        result.push(accessors[i][1]);
	  }
	  return {type:"StableId", contents:result};
    }

			/* / (id DOT)? 'super' __ ClassQualifier? DOT id _StableId */
/ pre:(id DOT)? sp:SUPER cl:ClassQualifier? accessors:(DOT id)+ {
  var result = !isNull(pre) ? [pre[0], sp] : [sp];
	if(!isNull(cl)){
		result.push(cl);
	}
	for (var i = 0; i < accessors.length; i++) {
    result.push(accessors[i][1]);
	}
	return {type:"StableId", contents:result};
}
EarlyDefs = OPBRACE eds:(EarlyDef (semi EarlyDef)*)? CLBRACE WITH {
      var result = ftr(eds);
	  if(eds !== null){
		  for (var i = 0; i < eds[1].length; i++) {
			  result.push(eds[1][i][1]);
		  }
	  }
	  return {type:"EarlyDefs", earlyDefs:result};
    }

/* EarlyDef ::= {Annotation [nl]} {Modifier} PatVarDef */
EarlyDef = an:(Annotation nl?)* md:Modifier* pvd:PatVarDef {
      var result = [];
	  for (var i = 0; i < an.length; i++) {
        result.push(an[i][0]);
	  }
	  return {type:"EarlyDef", annotation:an, modifier:md, def:pvd};
    }

ClassParents = cst:Constr ats:(WITH AnnotType)* {return {type:"ClassParents", constr:cst, annotType:ats}; }
Modifier = LocalModifier
/ AccessModifier
/ OVERRIDE

/* LocalModifier ::= ‘abstract’ */
/* | ‘final’ */
/* | ‘sealed’ */
/* | ‘implicit’ */
/* | ‘lazy’ */
LocalModifier = ABSTRACT
/ FINAL
/ SEALED
/ IMPLICIT
/ LAZY

/* AccessModifier ::= (‘private’ | ‘protected’) [AccessQualifier] */
AccessModifier = md:(PRIVATE / PROTECTED)  qual:AccessQualifier? {return {type:"AccessModifier", modifier:md, qual:ftr(qual)};}

/* AccessQualifier ::= ‘[’ (id | ‘this’) ‘]’ */
AccessQualifier = OPBRACKET id:(id / THIS) CLBRACKET {return {type:"AccessQualifier", id:id};}

/* TypeDef = id:id pm:TypeParamClause? EQUAL tp:Type {return {type:"TypeDef", id:id, param:ftr(pm), tp:tp}; } */
TypeDef = id:id pm:TypeParamClause? EQUAL tp:Type {
	var pattern = {type: "TypeDefVariable", id: id.name, paramClause: ftr(pm), tp:tp};
	return {type:"TypeDef", pattern:pattern};
}

ConstrExpr = SelfInvocation
/ ConstrBlock

/* ConstrBlock ::= ‘{’ SelfInvocation {semi BlockStat} ‘}’ */
ConstrBlock = OPBRACE si:SelfInvocation bss:(semi BlockStat)* CLBRACE{
      var result = [];
	  for (var i = 0; i < bss.length; i++) {
        result.push(bss[i][1]);
	  }
	  return {type:"TypeParamClause", params:result};
    }
ClassTemplateOpt = ext:EXTENDS ct:ClassTemplate {return {type:"ClassTemplateOpt", extend:ext, body:ct}; }
/ tmpl:(EXTENDS? TemplateBody)? {return {type:"ClassTemplateOpt", extend:ftr(ftr(tmpl, 0)), body:ftr(tmpl, 1)}; }
TraitTemplateOpt = ext:EXTENDS tt:TraitTemplate {return {type:"TraitTemplateOpt", extend:ext, body:tt}; }
/ tmpl:(EXTENDS? TemplateBody)? {return {type:"TraitTemplateOpt", extend:ftr(ftr(tmpl, 0)), body:ftr(tmpl, 1)}; }

TraitTemplate = ed:EarlyDefs? tp:TraitParents tb:TemplateBody? {return {type:"TraitTemplate", def:ftr(ed), traitParent:tp, body:ftr(tb)}; }

TraitParents = at:AnnotType ats:(WITH AnnotType)* {return {type:"TraitParents", annotType:at, annotType:ats}; }
/* SelfInvocation ::= ‘this’ ArgumentExprs {ArgumentExprs} */
SelfInvocation = THIS ae:ArgumentExprs+ {return {type:"SelfInvocation", exprs:ae}; }
ClassParamClauses = cls:ClassParamClause* params:(nl? OPPAREN IMPLICIT ClassParams CLPAREN)? {return {type:"ClassParamClauses", cls:cls, params:ftr(params, 3)}; }

/* ClassParamClause ::= [nl] ‘(’ [ClassParams] ’)’ */
ClassParamClause = nl? OPPAREN cp:ClassParams? CLPAREN {return {type:"ClassParamClause", params:ftr(cp)}; }

/* ClassParams ::= ClassParam {‘’ ClassParam} */
ClassParams = param:ClassParam params:(' ' ClassParam)*
{
      var result = [param];
	  for (var i = 0; i < params.length; i++) {
        result.push(params[i][1]);
	  }
	  return {type:"ClassParams", params:result};
    }

/* ClassParam ::= {Annotation} [{Modifier} (‘val’ | ‘var’)] */
/* id ‘:’ ParamType [‘=’ Expr] */
ClassParam = an:Annotation* md:(Modifier* (VAL / VAR))? id:id COLON pt:ParamType exp:(EQUAL Expr)? {return {type:"ClassParam", annotations:an, modifier:ftr(md, 0), vax:ftr(md, 1), id:id, paramType:pt, exp:ftr(exp, 1)}; }


ClassDef = id:id tpc:TypeParamClause? ca:ConstrAnnotation* am:AccessModifier? cpc:ClassParamClauses cto:ClassTemplateOpt {return {type:"ClassDef", id:id, typeParam:ftr(tpc), annotation:ca, modifier:ftr(am), classParam:cpc, classTemplate:cto}; }

TraitDef = id:id tpc:TypeParamClause? tto:TraitTemplateOpt {return {type:"TraitDef", id:id, typeParam:tpc, traitTemplate:tto}; }
ObjectDef = id:id cto:ClassTemplateOpt {return {type:"ObjectDefinition", id:id, classTemplate:cto}; }
TypePat = Type

Patterns = head:Pattern tail:(COMMA Patterns)? {return {type: "Patterns", pattern:[head, tail]};}



comment = singleLineComment / multiLineComment
singleLineComment = '//' (!nl . )* nl+
multiLineComment = [/][*] ((&"/*" multiLineComment) / (!"*/" . ))* [*][/]
__ = (whitespace / comment)*
nl = ("\r\n" / "\n" / "\r") __
semi = (SEMICOLON nl* / nl+)
whitespace = [\u0020\u0009]

Empty = & {return true;} {return {type:"Empty"};}
/* Empty = (&. / !.) {return {type:"Empty", value:null};} */

KEYWORDS = PACKAGE / SEMICOLON / DOT / COMMA / THIS / OPBRACKET / CLBRACKET / ARROW / LEFTARROW / OPPAREN / CLPAREN / OPBRACE / CLBRACE / TYPE / VAL / WITH / COLON / UNDER / IMPLICIT / IF / ELSE / WHILE / TRY / CATCH / FINALLY / DO / FOR / THROW / RETURN / MATCH / EQUAL / TILDE / BANG / BAR / NEW / LAZY / CASE / SUPER / AT / SHARP / LEFTANGLE / RIGHTANGLE / VIEW / VAR / DEF / OBJECT / EXTENDS / IMPORT / FORSOME / ABSTRACT / FINAL / CLASS / TRAIT / OVERRIDE / SEALED / PRIVATE / PROTECTED

PACKAGE = 'package' !IdentifierPart __ {return {type:"Keyword", word:"package"}}
SEMICOLON = ';' __ {return {type:"Keyword", word:";"}}
HYPHEN = '-' __ {return {type:"Keyword", word:"-"}}
DOT = '.' __ {return {type:"Keyword", word:"."}}
COMMA = ',' __ {return {type:"Keyword", word:","}}
THIS = 'this' !IdentifierPart __ {return {type:"Keyword", word:"this"}}
OPBRACKET = '[' ___ {return {type:"Keyword", word:"["}}
CLBRACKET = ']' __ {return {type:"Keyword", word:"]"}}
ARROW = '=>' __ {return {type:"Keyword", word:"=>"}}
LEFTARROW = '<-' __ {return {type:"Keyword", word:"<-"}}
OPPAREN = '(' ___ {return {type:"Keyword", word:"("}}
CLPAREN = ')' __ {return {type:"Keyword", word:")"}}
OPBRACE = '{' ___ {return {type:"Keyword", word:String.fromCharCode(123)}} //'{'だとバグるので文字コードで回避
CLBRACE = '}' __ {return {type:"Keyword", word:String.fromCharCode(125)}}
TYPE = 'type' !IdentifierPart __ {return {type:"Keyword", word:"type"}}
VAL = 'val' !IdentifierPart __ {return {type:"Keyword", word:"val"}}

WITH = 'with' !IdentifierPart __ {return {type:"Keyword", word:"with"}}
COLON = ':' __ {return {type:"Keyword", word:":"}}
UNDER = '_' __ {return {type:"Keyword", word:"_"}}
STAR = '*' __ {return {type:"Keyword", word:"*"}}
IMPLICIT = 'implicit' !IdentifierPart __ {return {type:"Keyword", word:"implicit"}}
IF = 'if' !IdentifierPart __ {return {type:"Keyword", word:"if"}}
ELSE = 'else' !IdentifierPart __ {return {type:"Keyword", word:"else"}}
WHILE = 'while' !IdentifierPart __ {return {type:"Keyword", word:"while"}}
TRY = 'try' !IdentifierPart __ {return {type:"Keyword", word:"try"}}
CATCH = 'catch' !IdentifierPart __ {return {type:"Keyword", word:"catch"}}
FINALLY = 'finally' !IdentifierPart __ {return {type:"Keyword", word:"finally"}}
DO = 'do' !IdentifierPart __ {return {type:"Keyword", word:"do"}}
FOR = 'for' !IdentifierPart __ {return {type:"Keyword", word:"for"}}
THROW = 'throw' !IdentifierPart __ {return {type:"Keyword", word:"throw"}}
RETURN = 'return' !IdentifierPart __ {return {type:"Keyword", word:"return"}}
MATCH = 'match' !IdentifierPart __ {return {type:"Keyword", word:"match"}}
EQUAL = '=' !opchar ___ {return {type:"Keyword", word:"="}} //==などはEQUALではないとして弾く
PLUS = '+' !opchar __ {return {type:"Keyword", word:"+"}}
TILDE = '~' !opchar __ {return {type:"Keyword", word:"~"}}
BANG = '!' !opchar __ {return {type:"Keyword", word:"!"}}
BAR = '|' !opchar __ {return {type:"Keyword", word:"|"}}
NEW = 'new' !IdentifierPart __ {return {type:"Keyword", word:"new"}}
LAZY = 'lazy' !IdentifierPart __ {return {type:"Keyword", word:"lazy"}}
CASE = 'case' !IdentifierPart __ {return {type:"Keyword", word:"case"}}
SUPER = 'super' !IdentifierPart __ {return {type:"Keyword", word:"super"}}
AT = '@' __ {return {type:"Keyword", word:"@"}}
SHARP = '#' __ {return {type:"Keyword", word:"#"}}
LEFTANGLE = '>:' __ {return {type:"Keyword", word:">:"}}
RIGHTANGLE = '<:' __ {return {type:"Keyword", word:"<:"}}
VIEW = '<%' __ {return {type:"Keyword", word:"<%"}}
VAR = 'var' !IdentifierPart __ {return {type:"Keyword", word:"var"}}
DEF = 'def' !IdentifierPart __ {return {type:"Keyword", word:"def"}}
OBJECT = 'object' !IdentifierPart __ {return {type:"Keyword", word:"object"}}
EXTENDS = 'extends' !IdentifierPart __ {return {type:"Keyword", word:"extends"}}
IMPORT = 'import' !IdentifierPart __ {return {type:"Keyword", word:"import"}}
FORSOME = 'forSome' !IdentifierPart __ {return {type:"Keyword", word:"forSome"}}
ABSTRACT = 'abstract' !IdentifierPart __ {return {type:"Keyword", word:"abstract"}}
FINAL = 'final' !IdentifierPart __ {return {type:"Keyword", word:"final"}}
CLASS = 'class' !IdentifierPart __ {return {type:"Keyword", word:"class"}}
TRAIT = 'trait' !IdentifierPart __ {return {type:"Keyword", word:"trait"}}
OVERRIDE = 'override' !IdentifierPart __ {return {type:"Keyword", word:"override"}}
SEALED = 'sealed' !IdentifierPart __ {return {type:"Keyword", word:"sealed"}}
PRIVATE = 'private' !IdentifierPart __ {return {type:"Keyword", word:"private"}}
PROTECTED = 'protected' !IdentifierPart __ {return {type:"Keyword", word:"protected"}}


CheckOuterMacro
 = { return outerMacro; }

CharacterStatement
 = &{}

OneLine
 = &{}

start
 = CompilationUnit

ExpressionMacro
 = (&{ return macroType; } form:(t0:("Decl" !IdentifierPart
{ return { type: "MacroName", name:"Decl" }; }) __ t1:("(" __ t0:(t0:(","
{ return { type: "PunctuationMark", value: "," }; }) __ t1:MacroIdentifier __ t2:(","
{ return { type: "PunctuationMark", value: "," }; }) __ t3:Type { return [t0, t1, t2, t3]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / (&{ return macroType; } form:(t0:("Decl" !IdentifierPart
{ return { type: "MacroName", name:"Decl" }; }) __ t1:("(" __ t0:(t0:MacroIdentifier __ t1:(","
{ return { type: "PunctuationMark", value: "," }; }) __ t2:Type { return [t0, t1, t2]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / (&{ return macroType; } form:(t0:("Decl" !IdentifierPart
{ return { type: "MacroName", name:"Decl" }; }) __ t1:("(" __ t0:(t0:(","
{ return { type: "PunctuationMark", value: "," }; }) __ t1:Type { return [t0, t1]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / (&{ return macroType; } form:(t0:("Decl" !IdentifierPart
{ return { type: "MacroName", name:"Decl" }; }) __ t1:("(" __ t0:(t0:Type { return [t0]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / (&{ return macroType; } form:(t0:("Decl" !IdentifierPart
{ return { type: "MacroName", name:"Decl" }; }) __ t1:("(" __ ")"
{ return { type: "Paren", elements: [] }; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / form:(t0:("Decl" !IdentifierPart
{ return { type: "MacroName", name:"Decl" }; }) __ t1:("(" __ t0:(t0:Expr __ t1:(","
{ return { type: "PunctuationMark", value: "," }; }) __ t2:MacroIdentifier __ t3:(","
{ return { type: "PunctuationMark", value: "," }; }) __ t4:Type { return [t0, t1, t2, t3, t4]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; }

RejectWords
 = ","


