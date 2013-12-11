
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
  = "//" (!LineTerminator SourceCharacter)*

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
