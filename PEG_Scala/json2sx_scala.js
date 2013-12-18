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
	// console.error("ScalaTag: " + exprs);
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

  case 'Empty': return null; //どうしよう。とりあえず空文字列を返しておく
  case 'Ellipsis': return '...';
  case 'ExpressionMacroDefinition':
                // console.error("ExpressionMacroDefinition: %s", t);
  							return enclose('define-syntax', [t.macroName + "-Macro", ["syntax-rules", ["V-" + t.literals], ax(t.syntaxRules)[0]]] );
  case 'ExpressionVariable':
  case 'IdentifierVariable':
  case 'LiteralKeyword':
  case 'Variable':
                // console.error("t.name = " + "V-" + t.name);
																		// return ScalaTag('Variable', ["V-" + t.name]);
																		return "V-" + t.name;
  case 'integerLiteral': return t.value;
  case 'MacroForm': return ax(t.inputForm);
  case 'MacroName': return t.name + "-Macro";
  case 'OneLine': return null; //とりあえずnull
	// case 'Paren':
									// console.error("Paren: eles = %j\n", t.elements);
									// console.error("Paren-2: eles = %j\n", ax(t.elements));
									// return ScalaTag('Paren2', ax(t.elements)); //fo debug
  case 'Program': return enclose('begin', ax(t.elements));
  case 'RepBlock':
  case 'Repetition': return ax(t.elements);
  case 'Repeat': //List->Vector

  									 return t.elements.map(ax).map(sx).join(' ');
  case 'SyntaxRule':
                    // console.error("syntaxRule : %j", t);
                    // console.error("syntaxRule2 : %j", encloses(["_", ax(t.pattern)], ax(t.template)));
  									return [enclose("_", ax(t.pattern)), ax(t.template)];

  default:
	var res = [];
	// console.log(typeof(spec));
	if(typeof(spec) == "undefined") throw new Error("undefined spec. : " + t.type);
	// console.log(t);
	spec.forEach(function (f, i) {
		if(typeof(t[f]) == "undefined") throw new Error("defined member is undefined. type: " + t.type + ", member: " + f);
          // if(0 < i) res.push(ax(t[f]));
          if(0 < i) res.push(ax(t[f]));
      });
	if(DEBUG) console.log("type: " + t.type + ", res = " + JSON.stringify(res));
	// return res;
	return ScalaTag(t.type, res);
  }
}

function sx(t) {
  if (Array.isArray(t)) {
  	if(t.length == 0) return null;
  	else return '(' + t.map(sx).join(' ') + ')';
  }
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
  // console.log(ax(t));
  // var s = sx(disclose(ax(t)));
  if (fd) {
    // fs.writeSync(fd, JSON.stringify(s, null, "  "));
    fs.writeSync(fd, s);
    fs.writeSync(fd, "\n");
    fs.closeSync(fd);
  }
  return s;
};
