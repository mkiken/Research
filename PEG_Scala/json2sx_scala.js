var util = require('util');
var fs = require('fs');
// const DEBUG = true;
const DEBUG = false;
const NULL = "#\\nul";
var ast = {};
var bTemplate = false;
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
  // l.splice(0, 0, tag);
  // console.log("enc = " + l);
  // return l;

  return [tag].concat(l);
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

// function disclose(e){
// if(Array.isArray(e)){
// if(e.length == 1) return disclose(e[0]);
// else return e.map(disclose);
// }
// else return e;
// }

function ax(t) {
	// console.log(JSON.stringify(t));
	if(DEBUG) console.log("ax( " + JSON.stringify(t) + " ) invoked.");
	if(t == null || t == "") return NULL;
	else if (!t) throw (new Error('Invalid AST node: ' + JSON.stringify(t) ));
  // if (typeof t === 'string') return literal(t);
  if (typeof(t) === 'string') return sx_string(t);
  if (Array.isArray(t)) return t.map(ax);

  var spec = ast[t.type];
  // ArrayLiteralとかが上手く働かない
  // if (literal_re.exec(t.type)) return literal(t);
	// console.log("TYPE = " + t.type);

  switch (t.type) {
  	//いまのところAnonymousFunction, Bindingなどを隠すと非Hygienic展開になる
  	//Anonymousは左辺が_でもやばいし、おそらくidのときもやばい。応急処置
  	case 'AnonymousFunction':
  		if(bTemplate){
  			//α変換の影響が出ないように、左辺の変数名と型を分離して、lambdaのbodyにいれておく
  			var params = [], types = [], bds = t.left.bindings;
  			console.error("Anonymous: " + JSON.stringify(bds, null, 1));
  			for(var i = 0; i < bds.length - 1; i++){
  				params.push(bds[i].id);
  				types.push(bds[i].tp);
  			}
  			if(bds[bds.length-1].type == 'Binding'){
					params.push(bds[bds.length-1].id);
  				types.push(bds[bds.length-1].tp);
  			}
  			else if(bds[bds.length-1].type == 'Ellipsis'){
					params.push(bds[bds.length-1]);
  				types.push(null);
  			}
        // console.error("Anonymous: |params| " + params.length);
        // console.error("Anonymous: |types| " + types.length);
        // console.error("Anonymous: params " + JSON.stringify(params));
        // console.error("Anonymous: types " + JSON.stringify(types));

  			return ScalaTag(t.type, [encloses('lambda', ax(params), ax(types), ax(t.right))]);
  		}
  		else return ScalaTag(t.type + "Plain", [encloses('lambda', ax(t.left), ax(t.right))]);
  	case 'AnonymousFunctionId':
 	 		return ScalaTag(t.type, [encloses('lambda', [ax(t.left)], ax(t.right))]);
    // case 'AnonymousFunctionWild':
        // return ScalaTag(t.type, ax(t.right));
    // case 'Binding': return ax(t.id);
  	case 'Bindings': return t.bindings.map(ax);
  	case 'CompilationUnit': return enclose('begin', ax(t.packages)).concat(ax(t.topStatseq));
  	case 'Empty': return NULL; //どうしよう。とりあえず空文字列を返しておく
  	case 'Ellipsis': return '...';
  	case 'ExpressionMacroDefinition':
										 // console.error("ExpressionMacroDefinition: %j\n", t.syntaxRules);
										 // console.error("ExpressionMacroDefinition: %j\n", ax(t.syntaxRules));

										 var srules = t.syntaxRules, output = [];
										 for(var i = 0; i < srules.length; i++){
										output.push(sx(ax(srules[i]))); }
                     // return enclose('define-syntax', [t.macroName + "-Macro", ["syntax-rules", ["V-" + t.literals], ax(t.syntaxRules)]] );
  									 return enclose('define-syntax', [t.macroName + "-Macro", ["syntax-rules", ["V-" + t.literals], output.join(' ')]] );
  	case 'ExpressionVariable':
  	case 'IdentifierVariable':
  	case 'TypeVariable':
  	case 'LiteralKeyword':
  	case 'Variable':
                		 // console.error("t.name = " + "V-" + t.name);
										 // return ScalaTag('Variable', ["V-" + t.name]);
										 return "V-" + t.name;
  	case 'integerLiteral': return t.value;
  	case 'MacroForm': return ax(t.inputForm);
  	case 'MacroName': return t.name + "-Macro";
  	case 'OneLine': return NULL; //とりあえずnull
										// case 'Paren':
										// console.error("Paren: eles = %j\n", t.elements);
										// console.error("Paren-2: eles = %j\n", ax(t.elements));
										// return ScalaTag('Paren2', ax(t.elements)); //fo debug
  	case 'Program': return enclose('begin', ax(t.elements));
		case 'PunctuationMark': return ''; //空文字列を返すと、joinで無視される
  	case 'RepBlock':
  	case 'Repetition': return ax(t.elements);
  	case 'Repeat': //List->Vector

  									 	 return t.elements.map(ax).map(sx).join(' ');
  	case 'SyntaxRule':
  										 console.error("json2sx: %j\n", t);
 	 										 var ptn, tmpl;
 	 										 ptn = ax(t.pattern);
 	 										 bTemplate = true;
 	 										 tmpl = ax(t.template);
 	 										 bTemplate = false;
                       // console.error("json2sx-2: %j\n", ptn);
                       // console.error("json2sx3: %j\n", enclose("_", ptn));
                       // console.error("json2sx4: %j\n", [enclose("_", ptn), tmpl]);
                       // console.error("json2sx5: %j\n", enclose("_", ptn).concat(tmpl));
                       // return [enclose("_", ptn), tmpl];
 	 										 return [enclose("_", ptn), tmpl];
		case 'TopStatSeq':
 	 										 return ax(t.topstat);


  	default:
											 var res = [];
											 // console.log(typeof(spec));
											 if(typeof(spec) == "undefined"){
											 	 console.error("%j", t);
											 	 throw new Error("undefined spec. : " + t.type);
											 }
											 // console.log(t);
											 spec.forEach(function (f, i) {
												 if(typeof(t[f]) == "undefined"){
											 	 console.error("%j", t);
												 	 throw new Error("defined member is undefined. type: " + t.type + ", member: " + f);
												 }
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
  	if(t.length == 0) return NULL;
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
