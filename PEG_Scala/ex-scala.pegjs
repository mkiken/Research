
/* Initializer written by homizu */

start
	= __ program:Program __ { return program; }

Program
  = elements:SourceElements? {
      return {
        type:     "Program",
        elements: elements !== "" ? elements : []
      };
    }

SourceElements
  = head:SourceElement tail:(__ SourceElement)* {
      var result=[head];
      for (var i = 0; i < tail.length; i++) {
        result.push(tail[i][1]);
      }
      return result;
    }

SourceElement
  = DeclarationStatement
  / OneLine

OneLine
  = (!LineTerminator SourceCharacter)* LineTerminator

LineTerminator
  = [\n\r\u2028\u2029]

SourceCharacter
  = .

DeclarationStatement // added
  = MacroDefinition
  /* / VariableStatement */
  /* / FunctionDeclaration */

MacroDefinition
  = type:(t:(ExpressionToken / StatementToken) {
        outerMacro = macroType; return macroType = t; }) __
    macroName:Identifier __ "{" __
    (MetaVariableDeclaration __)*
    syntaxRules:SyntaxRuleList __ "}"
    c:CheckOuterMacro {
        if (c)
           throw new JSMacroSyntaxError(line, column, "Unexpected macro definition. The macro definition must not be in the macro's template.");
        var type = type.charAt(0).toUpperCase() + type.slice(1) + "MacroDefinition";
        var literals = metaVariables.literal;
        macroType = false;
        for (var i in metaVariables)
            metaVariables[i] = [];
        return { type: type,
                 macroName: macroName,
                 literals: literals,
                 syntaxRules: syntaxRules };
    }


MetaVariableDeclaration
  = type:("identifier" / "expression" / "statement" / "symbol") __ ":" __ list:VariableList __ ";" {
        metaVariables[type] = metaVariables[type].concat(list);
    }
  / "keyword" __ ":" __ list:LiteralKeywordList __ ";" {
        metaVariables.literal = metaVariables.literal.concat(list);
    }

VariableList
  = head:IdentifierName tail:(__ "," __ IdentifierName)* {
        var result = [head];
        for (var i=0; i<tail.length; i++) {
            result.push(tail[i][3]);
        }
        return result;
    }

LiteralKeywordList
  = head:LiteralKeyword tail:(__ "," __ LiteralKeyword)* {
        var result = [head];
        for (var i=0; i<tail.length; i++) {
            result.push(tail[i][3]);
        }
        return result;
    }

// リテラルキーワード "=>" は禁止
LiteralKeyword
  = !MacroArrow (IdentifierName
  / Punctuator)

SyntaxRuleList
  = head:SyntaxRule tail:(__ SyntaxRule)* {
        var result = [head];
        for (var i=0; i<tail.length; i++) {
            result.push(tail[i][1]);
        }
        return result;
    }

SyntaxRule
  = "{" __ pat:Pattern __ MacroArrow __ temp:Template __ "}" {
        return { type: "SyntaxRule",
                 pattern: pat,
                 template: temp };
    }

// パターン
Pattern
  = ("_" / !"=>" Identifier) __ patterns:SubPatternList? { return patterns || []; }

SubPatternList
  = head:SubPattern middle:(__ SubPattern)* ellipsis:(__ "..." { return { line: line, column: column }; })?
    tail:(__ SubPattern)* {
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
            if (!elements)
                throw new JSMacroSyntaxError(ellipsis.line, ellipsis.column, "Bad ellipsis usage. Something except punctuation marks must be before ellipsis.");
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
  = g_open:("[#"/"("/"{"/"[") __ patterns:SubPatternList? __ g_close:("#]"/")"/"}"/"]")
    &{ return group[g_open].close === g_close; } {
       return {
         type: group[g_open].type,
         elements: patterns !== "" ? patterns : []
       };
    }
  / Literal
  / IdentifierVariable
  / ExpressionVariable
  / StatementVariable
  / SymbolVariable
  / name:LiteralKeyword &{ return metaVariables.literal.indexOf(name) >= 0; } {
        return {
            type: "LiteralKeyword",
            name: name
        };
    }
  / name:(IdentifierName / Punctuator / "," / ";" / "|") {
        return {
            type: "PunctuationMark",
            value: name
        };
    }

IdentifierVariable
  = name:IdentifierName &{ return metaVariables.identifier.indexOf(name) >= 0; } {
        return {
            type: "IdentifierVariable",
            name: name
        };
    }

ExpressionVariable
  = name:IdentifierName &{ return metaVariables.expression.indexOf(name) >= 0; } {
        return {
            type: "ExpressionVariable",
            name: name
        };
    }

StatementVariable
  = name:IdentifierName &{ return metaVariables.statement.indexOf(name) >= 0; } {
        return {
            type: "StatementVariable",
            name: name
        };
    }

SymbolVariable
  = name:IdentifierName &{ return metaVariables.symbol.indexOf(name) >= 0; } {
        return {
            type: "SymbolVariable",
            name: name
        };
    }

Punctuator
  =  puncs:PunctuatorSymbol+ !{ return puncs.join("") === "=>"; } { return puncs.join(""); }

	//todo:ここはこれでいいのか？
PunctuatorSymbol
  = "<" / ">" / "=" / "!" / "+"
  / "-" / "*" / "%" / "&" / "/"
  / "^" / "!" / "~" / "?" / ":"

// テンプレート(パーザー拡張前)
Template
  = head:Statement tail:(__ Statement)* {
      var result = [head];
      for (var i=0; i<tail.length; i++) {
          result.push(tail[i][1]);
      }
      return result;
    }

//todo: どうする？？
Statement
  = "statement"


//todo: ひとまず甫水さんの実装に合わせる
MacroArrow
  = "=>" !idrest

Identifier
  = id

IdentifierName
  = id

//todo?
CheckOuterMacro
  = { return false; }


ExpressionToken = "expression"       !idrest { return "expression"; } // added by homizu
StatementToken  = "statement"        !idrest { return "statement"; } // added by homizu





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
id = nm:plainid {return { type: "Identifier", name: nm }; }
	/ [`] str:stringLiteral [`] __ { return { type: "Identifier2", name: '`' + str + '`'}; }
idrest	= chars:(letter / digit)* '_' ops:op __ {return chars.join("") + '_' + ops;}
		/ chars:(letter / digit)* __ {return chars.join("");}

Literal =
minus:HYPHEN? val:floatingPointLiteral {return {type: "floatingPointLiteral", value: minus + val}; }
/ minus:HYPHEN? val:integerLiteral {return {type: "integerLiteral", value: minus + val}; }
/ booleanLiteral
/ val:characterLiteral {return {type: "characterLiteral", value: val}; }
/ stringLiteral
/ val:symbolLiteral {return {type: "symbolLiteral", value: val}; }
/ 'null' __ {return {type: "nullLiteral", value: "null"}; }
integerLiteral = ilit:(decimalNumeral / hexNumeral / octalNumeral) ll:('L' / 'l')? __ {
	return ilit + ll;
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
	= dp:digit+ '.' ds:digit* exp:exponentPart? type:floatType? __ {return dp.join("") + '.' + ds.join("") + exp + type;}
	/ '.' dp:digit+  exp:exponentPart? type:floatType? __ {return '.' + dp.join("") + exp + type;}
	/ dp:digit+ exp:exponentPart type:floatType? __ {return dp.join("") + exp + type;}
	/ dp:digit+ exp:exponentPart? type:floatType __ {return dp.join("") + exp + type;}

/* exponentPart ::= (‘E’ | ‘e’) [‘+’ | ‘-’] digit {digit} */
exponentPart = exp:('E' / 'e') sign:('+' / '-')? dt:digit+ {return exp + sign + dt.join("");}

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


comment = singleLineComment / multiLineComment
singleLineComment = '//' (!nl . )* nl+
multiLineComment = [/][*] ((&"/*" multiLineComment) / (!"*/" . ))* [*][/]
__ = (whitespace / comment)*
nl = ("\r\n" / "\n" / "\r") __
semi = (SEMICOLON nl* / nl+)
whitespace = [\u0020\u0009]

Empty = & {return true;} {return {type:"Empty"};}
/* Empty = (&. / !.) {return {type:"Empty", value:null};} */

PACKAGE = 'package' __ {return {type:"Keyword", word:"package"}}
SEMICOLON = ';' __ {return {type:"Keyword", word:";"}}
HYPHEN = '-' __ {return {type:"Keyword", word:"-"}}
DOT = '.' __ {return {type:"Keyword", word:"."}}
COMMA = ',' __ {return {type:"Keyword", word:","}}
THIS = 'this' __ {return {type:"Keyword", word:"this"}}
OPBRACKET = '[' __ {return {type:"Keyword", word:"["}}
CLBRACKET = ']' __ {return {type:"Keyword", word:"]"}}
ARROW = '=>' __ {return {type:"Keyword", word:"=>"}}
OPPAREN = '(' __ {return {type:"Keyword", word:"("}}
CLPAREN = ')' __ {return {type:"Keyword", word:")"}}
OPBRACE = '{' __ {return {type:"Keyword", word:String.fromCharCode(123)}} //'{'だとバグるので文字コードで回避
CLBRACE = '}' __ {return {type:"Keyword", word:String.fromCharCode(125)}}
TYPE = 'type' __ {return {type:"Keyword", word:"type"}}
VAL = 'val' __ {return {type:"Keyword", word:"val"}}

WITH = 'with' __ {return {type:"Keyword", word:"with"}}
COLON = ':' __ {return {type:"Keyword", word:":"}}
UNDER = '_' __ {return {type:"Keyword", word:"_"}}
STAR = '*' __ {return {type:"Keyword", word:"*"}}
IMPLICIT = 'implicit' __ {return {type:"Keyword", word:"implicit"}}
IF = 'if' __ {return {type:"Keyword", word:"if"}}
WHILE = 'while' __ {return {type:"Keyword", word:"while"}}
EQUAL = '=' !opchar __ {return {type:"Keyword", word:"="}} //==などはEQUALではないとして弾く
PLUS = '+' !opchar __ {return {type:"Keyword", word:"+"}}
NEW = 'new' __ {return {type:"Keyword", word:"new"}}
LAZY = 'lazy' __ {return {type:"Keyword", word:"lazy"}}
CASE = 'case' __ {return {type:"Keyword", word:"case"}}
AT = '@' __ {return {type:"Keyword", word:"@"}}
LEFTANGLE = '>:' __ {return {type:"Keyword", word:">:"}}
RIGHTANGLE = '<:' __ {return {type:"Keyword", word:"<:"}}
VAR = 'var' __ {return {type:"Keyword", word:"var"}}
DEF = 'def' __ {return {type:"Keyword", word:"def"}}
OBJECT = 'object' __ {return {type:"Keyword", word:"object"}}
EXTENDS = 'extends' __ {return {type:"Keyword", word:"extends"}}


