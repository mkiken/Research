var util = require('util');
var fs = require('fs');
// const DEBUG = true;
const DEBUG = false;
var ast = {};
fs.readFileSync(__dirname + '/ast.spec', 'utf8').split('\n').forEach(function (line) {
    var spec = line.split(': ');
    if (spec.length === 1) return;
    var type = spec[0], keys = spec[1].split(', ');
    keys.splice(0, 0, 'type');
    ast[type] = keys;
  });


function sx_string(s) { return '"' + s + '"'; }

var literal_table = [], literal_id = 0;
function literal(l) {
  literal_table.push(l);
  // return sx_string(util.format('L-%d', literal_id++));
  literal_id++;
  return sx_string(l);
}

function encloses(){
	var ls = [];
	for(var i = 1; i < arguments.length; i++){
		ls.push(arguments[i]);
	}
	return enclose(arguments[0], ls);
}

function enclose(tag, l) {
  // l = ax(l);
  if(arguments.length != 2) throw new Error("enclose: too many arguments => " + arguments.length);
  l.splice(0, 0, tag);
  // console.log("enc = " + l);
  return l;
}

function ScalaTag(name, elements){
	var exprs = [sx_string("Scala"), sx_string(name)];
	// if(arguments[0] != "")
	for(var i = 0; i < elements.length; i++){
		exprs.push(elements[i]);
		// exprs.push(ax(elements[i]));
	}
	return exprs;
}

function disclose(e){
	if(Array.isArray(e)){
		if(e.length == 1) return disclose(e[0]);
		else return e.map(disclose);
	}
	else return e;
}

function ax(t) {
	// console.log(JSON.stringify(t));
	if(DEBUG) console.log("ax( " + JSON.stringify(t) + " ) invoked.");
	if(t == null) return "#\\nul";
	else if (!t) throw (new Error('Invalid AST node: ' + JSON.stringify(t) ));
  // if (typeof t === 'string') return literal(t);
  if (typeof(t) === 'string') return sx_string(t);
  if (Array.isArray(t)) return t.map(ax);

  var spec = ast[t.type];
  // ArrayLiteralとかが上手く働かない
  // if (literal_re.exec(t.type)) return literal(t);
	// console.log("TYPE = " + t.type);

  switch (t.type) {
  // case 'Variable':
  // case 'IdentifierVariable':
  // case 'ExpressionVariable':
  // case 'StatementVariable':
  // case 'SymbolVariable':
  // case 'LiteralKeyword':
	  // return util.format('V-%s', t.name);
  // case 'VariableStatement': return enclose('begin', ax(t.declarations));
  // case 'VariableDeclaration':
    // return ['define', 'V-' + t.name, ax(t.value)];
  // case 'CatchStatement':
    // throw (new Error({ message: 'Not implemented yet: ', t: t }));
  // case 'CompilationUnit':
	  // return encloses('begin', ax(t.packages), ax(t.topStatseq));
	  // return enclose('begin', ax(t.packages));
  case 'Empty': return null; //どうしよう。とりあえず空文字列を返しておく
  // case 'ImportStatement': return enclose('import', ax(t.exprs));
  // case 'Identifier': return ScalaTag('identifier', t.name);
  // case 'ImportStatement': return ScalaTag('import', t.exprs);
  // case 'ExpressionMacroDefinition': return [util.format('define-syntax %s-Macro', t.macroName), ["syntax-rules", t.literals.map(function(x){return util.format("V-%s", x)}), ax(t.syntaxRules)]];
  // case 'Ellipsis': return "...";
  // case 'Brace':
  // case 'Paren':
  // case 'Bracket':
				   // return JSTag(t.type.toLowerCase(), t.elements);
  // case 'MacroName': return sx_string(util.format("%s-Macro", t.name));
  // case 'SyntaxRule': return [["_", ax(t.pattern)], ax(t.template)];
  // // case 'PunctuationMark': return [];
  // case 'ArrayLiteral': return JSTag("array", t.elements);
  // case 'NumericLiteral':
  // case 'BooleanLiteral':
  // case 'RegularExpressionLiteral': return JSTag("const", literal(t.value));
  // case 'BinaryExpression': return JSTag("binary", sx_string(t.operator), t.left, t.right);
  // case 'FunctionCall': return JSTag("funcCall", ax(t.name), ax(t.elements));
  // case 'Function': return JSTag("function", ax(t.name), ax(t.params));

  // case 'PrettyPrint': return t.str;
  // case 'JSXLiteral': return t.str;
  default:
	var res = [];
	// console.log(typeof(spec));
	if(typeof(spec) == "undefined") throw new Error("undefined spec. : " + t.type);
	// console.log(t);
	spec.forEach(function (f, i) {
        // switch (sx_style) {
        // case SX_STYLE_ALIST:
          // res.push( i === 0 ? util.format('"%s"', t[f]) : [ sx_string(f), ax(t[f]) ]);
        // case SX_STYLE_SIMPLE:
          // res.push( i === 0 ? util.format('"%s"', t[f]) : ax(t[f]));
        // case SX_STYLE_JSX:
		if(typeof(t[f]) == "undefined") throw new Error("defined member is undefined. type: " + t.type + ", member: " + f);
          // if(0 < i) res.push(ax(t[f]));
          if(0 < i) res.push(ax(t[f]));
        // }
      });
	if(DEBUG) console.log("type: " + t.type + ", res = " + JSON.stringify(res));
	// return res;
	return ScalaTag(t.type, res);
  }
}

function sx(t) {
  if (Array.isArray(t)) return '(' + t.map(sx).join(' ') + ')';
  return t;
}

// for PrettyPrint
// function pp(str) {
  // return {type: "PrettyPrint", str: str};
// }

exports.convert = function (t, output) {
  var fd = typeof output === 'number' ? output :
  typeof output === 'string' ? fs.openSync(output, 'w') : false;

  var s = sx(ax(t));
  // var s = sx(disclose(ax(t)));
  if (fd) {
    // fs.writeSync(fd, JSON.stringify(s, null, "  "));
    fs.writeSync(fd, s);
    fs.writeSync(fd, "\n");
    fs.closeSync(fd);
  }
  return s;
};
