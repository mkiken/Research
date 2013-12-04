/*
 * A converter from JavaScript AST to S-expression.
 * The JS AST is in JSON format and it is converted to a textual output
 * in a Scheme-`read'able S-expression.
 */

var util = require('util');
var fs = require('fs');

var SX_STYLE_ALIST = 'SX Style Alist';
var SX_STYLE_SIMPLE = 'SX Style Simple';
var SX_STYLE_JSX = 'SX Style test';
var sx_style = SX_STYLE_JSX;

var ast = {};
fs.readFileSync(__dirname + '/ast.spec', 'utf8').split('\n').forEach(function (line) {
    var spec = line.split(': ');
    if (spec.length === 1) return;
    var type = spec[0], keys = spec[1].split(', ');
    keys.splice(0, 0, 'type');
    ast[type] = keys;
  });

var literal_re = new RegExp('^(.*Literal|This)$');
var property_re = new RegExp('^Property.*|[GS]etterDefinition$');

function sx_string(s) { return '"' + s + '"'; }

var literal_table = [], literal_id = 0;
function literal(l) {
  literal_table.push(l);
  // return sx_string(util.format('L-%d', literal_id++));
  literal_id++;
  return sx_string(l);
}

function enclose(tag, l) {
  // l = ax(l);
  l.splice(0, 0, tag);
  // console.log("enc = " + l);
  return l;
}

function JSTag(){
	var exprs = [sx_string("JS"), sx_string(arguments[0])];
	// if(arguments[0] != "")
	for(var i = 1; i < arguments.length; i++){
		exprs.push(ax(arguments[i]));
	}
	return exprs;
}

function disclose(e){
	if(Array.isArray(e) && e.length == 1) return disclose(e[0]);
	return e;
}

function ax(t) {
	// console.log(JSON.stringify(t));
	if(t == null) return "#\\nul";
	else if (!t) throw (new Error('Invalid AST node: ' + JSON.stringify(t) ));
  // if (typeof t === 'string') return literal(t);
  if (typeof t === 'string') return t;
  if (Array.isArray(t)) return t.map(ax);

  var spec = ast[t.type];
  // ArrayLiteralとかが上手く働かない
  // if (literal_re.exec(t.type)) return literal(t);
	// console.log("TYPE = " + t.type);

  switch (t.type) {
  case 'Variable':
  case 'IdentifierVariable':
  case 'ExpressionVariable':
  case 'StatementVariable':
  case 'SymbolVariable':
  case 'LiteralKeyword':
	  return util.format('V-%s', t.name);
  case 'VariableStatement': return enclose('begin', ax(t.declarations));
  case 'VariableDeclaration':
    return ['define', 'V-' + t.name, ax(t.value)];
  case 'CatchStatement':
    throw (new Error({ message: 'Not implemented yet: ', t: t }));
  case 'Program': return enclose('begin', ax(t.elements));
  case 'ExpressionMacroDefinition': return [util.format('define-syntax %s-Macro', t.macroName), ["syntax-rules", t.literals.map(function(x){return util.format("V-%s", x)}), ax(t.syntaxRules)]];
  case 'Ellipsis': return "...";
  case 'Brace':
  case 'Paren':
  case 'Bracket':
				   return JSTag(t.type.toLowerCase(), t.elements);
  case 'MacroName': return sx_string(util.format("%s-Macro", t.name));
  case 'SyntaxRule': return [["_", ax(t.pattern)], ax(t.template)];
  // case 'PunctuationMark': return [];
  case 'ArrayLiteral': return JSTag("array", t.elements);
  case 'NumericLiteral':
  case 'BooleanLiteral':
  case 'RegularExpressionLiteral': return JSTag("const", literal(t.value));
  case 'BinaryExpression': return JSTag("binary", sx_string(t.operator), t.left, t.right);
  case 'FunctionCall': return JSTag("funcCall", ax(t.name), ax(t.elements));
  case 'Function': return JSTag("function", ax(t.name), ax(t.params));

  // case 'PrettyPrint': return t.str;
  // case 'JSXLiteral': return t.str;
  default:
	var res = [];
	// console.log(typeof(spec));
	if(typeof(spec) == "undefined") throw new Error("undefined spec. : " + JSON.stringify(t));
	// console.log(t);
	spec.forEach(function (f, i) {
        switch (sx_style) {
        case SX_STYLE_ALIST:
          res.push( i === 0 ? util.format('"%s"', t[f]) : [ sx_string(f), ax(t[f]) ]);
        case SX_STYLE_SIMPLE:
          res.push( i === 0 ? util.format('"%s"', t[f]) : ax(t[f]));
        case SX_STYLE_JSX:
          if(0 < i) res.push(ax(t[f]));
        }
      });
	return res;
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
  // console.log(typeof(s));
  // console.log("RESULT");
  // console.log(JSON.stringify(s));
  if (fd) {
    // fs.writeSync(fd, JSON.stringify(s, null, "  "));
    fs.writeSync(fd, s);
    fs.writeSync(fd, "\n");
    // fs.writeSync(fd, s, 0, s.length, null);
    fs.closeSync(fd);
  }
  return s;
};
