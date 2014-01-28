module.exports = (function () {

    var generator = { debug: false };

    var checkOuterMacro = 'CheckOuterMacro\n = { return outerMacro; }\n\n';
    var start = 'start\n = CompilationUnit\n\n';
		var characterStatement = 'CharacterStatement\n = &{}\n\n';
		var oneLine = 'OneLine\n = &{}\n\n';
    var macroExpression = 'ExpressionMacro\n = '
    var macroType = 'TypeMacro\n = '
    var rejectWords = 'RejectWords\n = '

    var pegObj = {
        // enclosing types
        Brace: { left: '"{"', right: '"}"' },
        Paren: { left: '"("', right: '")"' },
        Bracket: { left: '"["', right: '"]"' },

        // Repetition
        repetition: function(elements, mark) {
            return {
                type: 'Repetition',
                elements: elements,
                mark: mark,
                toCode: function (context) {
                    var template = context === 'template';
                    var len = mark.length;
                    var m = len>0 ? '__ "' + mark.join('" __ "') + '" ' : '';
                    return '(head:' + this.elements.toCode(context)
                        + '\n tail:(' + m + '__ ' + this.elements.toCode(context) + ')*\n'
                        + (template? 'ellipsis:(' + m + '__ "...")\n' : '')
                        + '{ var elements = [head];\n'
                        + '  for (var i=0; i<tail.length; i++) {\n'
                        + '    elements.push(tail[i][' + (len*2+1) +']);\n'
                        + '  }\n'
                        + (template? '  if (ellipsis) elements.push({ type: "Ellipsis" });\n' : '')
                        + '  return { type: "Repeat", elements: elements };\n'
                        + '})\n';
                        // + '})?\n';
                }
            };
        },

        // Enclosing
        enclosing: function (type, elements) {
            switch (type) {
            case 'RepBlock':
                return {
                    type: type,
                    elements: elements,
                    toCode: function (context) {
                        return '(' + (this.elements? 't0:' + this.elements.toCode(context) + ' __ ' : '') + '\n\
{ return { type: "RepBlock", elements: ' + (this.elements? 't0' : '[]') + ' }; })';
                    }
                };
                break;
            case 'Brace':
            case 'Paren':
            case 'Bracket':
                return {
                    type: type,
                    elements: elements,
                    toCode: function (context) {
                        return '(' + pegObj[type].left + ' __ ' + (this.elements? 't0:' + this.elements.toCode(context) + ' __ ' : '') + pegObj[type].right + '\n\
{ return { type: "' + type + '", elements: ' + (this.elements? 't0' : '[]') + ' }; })';
                    }
                };
                break;
            }
        },

        // Identifier
        identifier: function () {
            return {
                type: 'Identifier',
                toCode: function (context) { return 'MacroIdentifier'; }
            };
        },

        // Expression
        expression: function () {
            return {
                type: 'Expression',
                toCode: function (context) { return 'Expr'; }
            };
        },

       // Type
        type: function () {
            return {
                type: 'Type',
                toCode: function (context) { return 'Type'; }
            };
        },

        // symbol
        symbol: function () {
            return {
                type: 'Symbol',
                toCode: function (context) { return 'MacroSymbol'; }
            };
        },

        // keyword
        keyword: function (name) {
            return {
                type: 'LiteralKeyword',
                name: name,
                toCode: function (context) {
                     return '(v:MacroKeyword &{ return v.name === "' + name + '"; }\n\
{ return v; })';
                }
            };
        },

        // PunctuationMark
        punct: function(value) {
            return {
                type: 'PunctuationMark',
                value: value,
                toCode: function (context) {
                    return '("' + value + '"\n\
{ return { type: "PunctuationMark", value: "' + value + '" }; })';
                }
            };
        },

        // Literal
        literal: function(type, value) {
        	return {
              type: type,
              value: value,
              toCode: function (context) {
                return '(v:Literal &{ return v.type === "'+ type +'" && String(v.value) == "' + value + '"; }\n\
										{ return v; })';
              }
            };
        },

        // Macro name
        macroName: function (name) {
            return {
                type: 'MacroName',
                name: name,
                toCode: function (context) {
                    return '("' + name + '" !IdentifierPart\n\
{ return { type: "MacroName", name:"' + name + '" }; })';
                }
            };
        },

				//name : マクロ名、body: パターン
        macroForm: function (name, body) {
            var form = [name];
            var obj;
            for (var i=0; i<body.length; i++) {
                obj = convertToPegObj(body[i]);
                if (obj) // not null
                    form.push(obj);
            }
            form = pegObj.sequence(form);
            return {
                type: 'MacroForm',
                name: name.name,
                inputForm: form,
                toCode: function (context) {
                    var template = context === 'template';
                    return  'form:' + this.inputForm.toCode(context) + '\n\
{ return { type: "MacroForm", inputForm: form }; }';
                },
                makeSuffix: function () { // 接尾辞木に変換
                    return delete1Node(this.inputForm.elements, 1);
                }
            };
        },

        // Sequence
        sequence: function(elements) {
            return {
                type: 'Sequence',
                elements: elements,
                toCode: function (context) {
                    var es = [];
                    var tags = [];
                    for (var i=0, n=0; i<this.elements.length; i++) {
                        if (this.elements[i]) {
                            es.push('t' + n + ':' + this.elements[i].toCode(context));
                            tags.push('t' + n);
                            n++;
                        }
                    }
                    return '(' + es.join(' __ ') + ' { return [' + tags.join(', ') + ']; })';
                }
            };
        }//,
    };

    var jsMacroTypes = {

    // Repetition
		Repetition: function(obj) {
			var elements = convertToPegObj(obj.elements);
			return pegObj.repetition(elements, obj.punctuationMark);
		},

    // RepBlock [# ~ #] は 取り除く
		RepBlock: function(obj) {
			var elements = convertToPegObj(obj.elements);
			return pegObj.enclosing("RepBlock", elements);
		},

		// Brace
		Brace: function(obj) {
			var elements = convertToPegObj(obj.elements);
			return pegObj.enclosing("Brace", elements);
		},

		// Parentheses
		Paren: function(obj) {
			var elements = convertToPegObj(obj.elements);
			return pegObj.enclosing("Paren", elements);
		},

		// Bracket
		Bracket: function(obj) {
			var elements = convertToPegObj(obj.elements);
			return pegObj.enclosing("Bracket", elements);
		},

		// IdentifierVariable
		IdentifierVariable: function(obj) {
			return pegObj.identifier();
		},

		// ExpressionVariable
		ExpressionVariable: function(obj) {
			return pegObj.expression();
		},

		// TypeVariable
		TypeVariable: function(obj) {
			return pegObj.type();
		},

		// SymbolVariable
		SymbolVariable: function(obj) {
			return pegObj.symbol();
		},

		// LiteralKeyword
		LiteralKeyword: function(obj) {
			return pegObj.keyword(obj.name);
		},

		// PunctuationMark
		PunctuationMark: function(obj) {
			return pegObj.punct(obj.value);
		},

		// integerLiteral
		integerLiteral: function(obj) {
			return pegObj.literal(obj.type, obj.value);
		},
		floatingPointLiteral: function(obj) {
			return pegObj.literal(obj.type, obj.value);
		},
		booleanLiteral: function(obj) {
			return pegObj.literal(obj.type, obj.value);
		},
		characterLiteral: function(obj) {
			return pegObj.literal(obj.type, obj.value);
		},
		stringLiteral: function(obj) {
			return pegObj.literal(obj.type, obj.value);
		},
		symbolLiteral: function(obj) {
			return pegObj.literal(obj.type, obj.value);
		},
		nullLiteral: function(obj) {
			return pegObj.literal(obj.type, obj.value);
		}
    };

    var convertToPegObj = function(pattern) {
        var result = [];
        var obj, type;

				//配列だったら再帰
        if (pattern instanceof Array) {
            if (pattern.length === 0)
                return null;
            for (var i=0; i<pattern.length; i++) {
                obj = convertToPegObj(pattern[i]);
                if (obj)
                    result.push(obj);
            }
            return result.length > 0 ? pegObj.sequence(result) : null;
        }
        //nullでなかったら
        else if (pattern) {
                type = jsMacroTypes[pattern.type];
                //jsmacroTypesで型が合うやつがあったらそれにあった変換をする
                if (typeof type === 'function') {
                    return type(pattern);
                }
            return null;
        }
        return null;
    };

    // 引数として与えられたノードが削除できるノードかどうかを返す関数
    var canDeleteNode = function (element) {
        var type = element.type;
        if (type === 'Repetition') {
            if (element.elements === null) return true;
            return canDeleteNode(element.elements);
        } else if (type === 'RepBlock') {
            if (element.elements === null) return true;
            for (var i=0; i<element.elements.elements.length; i++) {
                if (i === element.elements.elements.length - 1 && element.elements.elements[i] !== null)
                    return canDeleteNode(element.elements.elements[i]);
                if (element.elements.elements[i] !== null)
                    return false;
            }
            return true;
        } else if (['Brace', 'Paren', 'Bracket'].indexOf(type) >= 0) {
            if (element.elements === null) return true;
            for (var i=0; i<element.elements.elements.length; i++) {
                if (element.elements.elements[i] !== null)
                    return false;
            }
            return true;
        } else if (['Identifier', 'Expression', 'Type', /*'Statement',*/ 'Symbol', 'LiteralKeyword', 'Punctuator', 'PunctuationMark', 'integerLiteral', 'floatingPointLiteral', 'booleanLiteral', 'characterLiteral', 'stringLiteral', 'symbolLiteral', 'nullLiteral'].indexOf(type) >= 0) {
            return true;
        } else {
            return false;
        }
    };

    // 引数で与えられたリストの最も左にある要素を削除(実際にはnullを代入)する関数
    var delete1Node = function (elements, start) {
        var result;
        for (var i=start; i<elements.length; i++) {
            if (elements[i] && canDeleteNode(elements[i])) {
                if (start && i === elements.length - 1)
                    return false;
                elements[i] = null;
                if (i === elements.length - 1)
                    return 'all';
                return true;
            }
            else if (elements[i]) { // elements[i] は RepBlock, Brace, Paren, Bracket, Repetition のいずれか
                if (elements[i].type === 'Repetition') {
                    return delete1Node([elements[i].elements], 0);
                }
                else {
                    result = delete1Node(elements[i].elements.elements, 0);
                    if (result === 'all')
                        elements[i].elements = null;
                    return result;
                }
            }
        }
        return false;
    };

generator.generate = function(jsObj) {

	if (jsObj.type === 'MacroDefinitions') {
    var elements = jsObj.defs;
    var macroDefs = [];
    var expressionMacros = [];
    var typeMacros = [];
    var keywords = []; //キーワードを覚えておいて、Identifierと区別出来るようにする
    var macros, pmacros, tmacros, macro, code;
    //MacroDefinitionがあったらMacrodefsに保存
    for (var i=0; i<elements.length; i++) {
      var element = elements[i];
      macroDefs.push(element);
      keywords = keywords.concat(element.marks, element.literals);
    }
    //各Macrodefinitionを解析
    for (var i=0; i<macroDefs.length; i++) {
      var macroDef = macroDefs[i];
      //pegObj.macroName : macroNameに対応するコードを吐くJSONを返す
      var macroName = pegObj.macroName(macroDef.macroName);
      var syntaxRules = macroDef.syntaxRules;
      var patterns = [];
      var p;

      macros = [];

			//syntaxrulesを解析
      for (var j=0; j<syntaxRules.length; j++) {
        macro = pegObj.macroForm(macroName, syntaxRules[j].pattern)
          patterns.push(macro);
        macros.push(macro.toCode('program'));
      }

      for (var j=0; j<patterns.length; j++) {
        code = patterns[j].toCode('template');
        if (macros.indexOf(code) < 0)
          macros.push('(&{ return macroType; } ' + code + ')');

							//todo: suffixは何なのか？とりあえず消してみる
							while (patterns[j].makeSuffix()) {
								code = patterns[j].toCode('template');
								if (macros.indexOf(code) < 0
									&& macros.indexOf(code = '(&{ return macroType; } ' + code + ')') < 0 )
									macros.push(code);
									}
                	}

                	pmacros = macros.slice(0, patterns.length);
                	tmacros = macros.slice(patterns.length);
                	pmacros.sort(function (a, b) { return b.length - a.length; }); // PEGコードが長い順に並び替え
                	tmacros.sort(function (a, b) { return b.length - a.length; }); // PEGコードが長い順に並び替え

									//todo: TypeMacroを定義？？
                	if (macroDef.type.indexOf('Expression') >= 0)
                  expressionMacros = expressionMacros.concat(tmacros, pmacros);
                  // expressionMacros = expressionMacros.concat(pmacros, tmacros);
									else if (macroDef.type.indexOf('Type') >= 0)
									typeMacros = typeMacros.concat(pmacros, tmacros);
                  // ellipsisが入ってる方を優先して選択する
                  // typeMacros = typeMacros.concat(tmacros, pmacros);
            			}

    return checkOuterMacro
			+ characterStatement
			+ oneLine
			+ start
			+ (expressionMacros.length > 0 ?  macroExpression + expressionMacros.join(' \n / ') + '\n\n' : '')
      + (typeMacros.length > 0 ?  macroType + typeMacros.join(' \n / ') + '\n\n' : '')
      + (keywords.length > 0 ?  rejectWords + keywords.map(function(e){return '"' + e + '"'}).join(' \n / ') + '\n\n' : '')
  }
  else {
    return 'error';
  }
}

return generator;
}());
