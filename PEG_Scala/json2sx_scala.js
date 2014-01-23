var util = require('util');
var fs = require('fs');
// const DEBUG = true;
const DEBUG = false;
const NULL = "#\\nul";
var ast = {};
var bTemplate = false;

//変数定義を格納するための変数
var blockLevel = 0;
var varDefines = [];

//lambdaに入れる変数名を格納するための変数
var lambdaLevel = 0;
var bSave = false;
var varNames = [];

//予約語のリスト．
//ここに載っているものはHygienic変換を行わない
const reservedWords = [
'main',
'Int',
'Array',
'String',
'Unit',
'args',
'Double'
];
function isReserved(e) {
	// reservedWords.forEach(function(word){
		// console.error("isReserved: " + e + ", " + word + ", " + e === word);
		// if(e === word) return true;
	// }
			// );
	// return false;
	var idx = reservedWords.indexOf(e);
	return idx == -1? false : true;
}

function convertName(e){
	var name = e;
	// console.error("convName: " + e + ", " + typeof e)
	//ラムダに足す場合は接頭辞がA-になっている
	if(name.length > 2 && name[0] == 'A' && name[1] == '-'){
		name = name.splice(2);
		if(bSave) varNames[lambdaLevel].push(name);
	}

	if(isReserved(name)){
		name = "R-" + name + "-";
	}
	else name = "V-" + name;
	return name;
}

fs.readFileSync(__dirname + '/ast.spec', 'utf8').split('\n').forEach(function (line) {
  var spec = line.split(': ');
  if (spec.length === 1) return;
  var type = spec[0], keys = spec[1].split(', ');
  keys.splice(0, 0, 'type');
  ast[type] = keys;
});


function sx_string(s) { return '"' + s + '"'; }
// function isNull(e) {
		// return typeof(e) == "object" && e.name == "__nul";
	// }

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
	if(t === null || t === "") return null;
	else if (!t) throw (new Error('Invalid AST node: ' + JSON.stringify(t) ));
  // if (typeof t === 'string') return literal(t);
  else if (typeof(t) === 'string') return sx_string(t);
  else if (Array.isArray(t)){
    // console.error("mmap!!");
  	return t.map(ax);
  }

  var spec = ast[t.type];
  // ArrayLiteralとかが上手く働かない
  // if (literal_re.exec(t.type)) return literal(t);
	// console.error("TYPE = " + t.type);

  switch (t.type) {
  	//いまのところAnonymousFunction, Bindingなどを隠すと非Hygienic展開になる
  	//Anonymousは左辺が_でもやばいし、おそらくidのときもやばい。応急処置
  	case 'AnonymousFunction':
      // if(bTemplate){
  			//α変換の影響が出ないように、左辺の変数名と型を分離して、lambdaのbodyにいれておく
  			var params = [], types = [];
				console.error("Anonymous: " + JSON.stringify(bds, null, 1));
  			//引数が存在すれば
  			if(t.left.bindings){
  				var bds = t.left.bindings;
					for(var i = 0; i < bds.length - 1; i++){
  					params.push(bds[i].id);
  					types.push(bds[i].tp);
  				}

  				if(bds[bds.length-1].type == 'Ellipsis'){
						params.push(bds[bds.length-1]);
  					types.push(bds[bds.length-1]);
  				}
  				else if(bds[bds.length-1].type == 'Binding'){
						params.push(bds[bds.length-1].id);
  					types.push(bds[bds.length-1].tp);
  				}
  				else if(bds[bds.length-1].type == 'BindingAny'){
						// params.push({ type: "Variable", name: "V-_" });
						// params.push({ type: "WildCard"});
						params.push({type: "Variable", name:"-WILDCARD-"});
						// params.push(bds[bds.length-1].ud);
  					types.push(bds[bds.length-1].tp);
  				}
          // else if(bds[bds.length-1] == null){
          // types.push(NULL);
          // }
  				else{
  					throw new Error("ax . AnonymousFunction:unintended case. => " + bds[bds.length-1].type);
  				}
        	// console.error("Anonymous: |params| " + params.length);
        	// console.error("Anonymous: |types| " + types.length);
        	// console.error("Anonymous: params " + JSON.stringify(params));
        	// console.error("Anonymous: types " + JSON.stringify(types));
          // console.error("ano . types => %j", types);
          // console.error("ano . types => %j", types.map(ax));
          // console.error("ano . types => %j", typeof types);
          // console.error("ano . types => %j", Array.isArray(types));
          // console.error("ano . ax.types => %j", ax(types));
          // console.error("anonymousFinction! => %j", ScalaTag(t.type, [encloses('lambda', ax(params), ax(types), ax(t.right))]));
				return ScalaTag(t.type, [encloses('lambda', ax(params), ax(types), ax(t.right))]);
  			}
  			else{ //引数がなかったら
					// params.push({notDelete:true});
					// console.error("Anonymous: params " + JSON.stringify(params));
					// console.error("Anonymous: params " + JSON.stringify(ax(params)));
					// console.error("Anonymous: types " + JSON.stringify(types));
          // 型が空だとマクロ展開でinvalidと言われるので適当にnullを入れておく．
          // types.push(null);
				return ScalaTag(t.type, [encloses('lambda', [{notDelete:true}], [null], ax(t.right))]);
  			}
				// return ScalaTag(t.type, [encloses('lambda', ax(params), ax(types), ax(t.right))]);
      // }
      // else return ScalaTag(t.type + "Plain", [encloses('lambda', ax(t.left), ax(t.right))]);
  	case 'AnonymousFunctionId':
 	 		return ScalaTag(t.type, [encloses('lambda', [ax(t.left)], ax(t.right))]);
    	// case 'AnonymousFunctionWild':
      // return ScalaTag(t.type, ax(t.right));
    	// case 'Binding': return ax(t.id);
  	case 'Bindings': return t.bindings? t.bindings.map(ax) : null;
  	case 'Block':
  									 var res, sts, result;
  									 blockLevel++;
  									 //定義を初期化
  									 varDefines[blockLevel] = [];
  									 sts = ax(t.states);
  									 res = ax(t.res);
                     // result = encloses('begin', varDefines[blockLevel], ax(t.states), ax(t.res));
  									 if(varDefines[blockLevel].length == 0){
  									 //空だとnullになってしまうので，消えないようにしておく
  									 	 varDefines[blockLevel].push({notDelete:true});
  									 }
  									 result = encloses('letrec*', varDefines[blockLevel], sts, res);
  									 blockLevel--;
  									 return ScalaTag("Block", [result]);
  	case 'Bracket':
  	case 'Brace':
  	case 'Paren':
  	case 'RepBlock':
  									 //elementsが空の時でもnulにしない
  									 if(t.elements.length == 0) return ScalaTag(t.type, {notDelete:true});
										 else return ScalaTag(t.type, ax(t.elements));

  	case 'TemplateBody':
  									 var selftype, sts, result;
  									 blockLevel++;
  									 //定義を初期化
  									 varDefines[blockLevel] = [];
  									 selftype = ax(t.selftype);
  									 sts = ax(t.states);
  									 if(varDefines[blockLevel].length == 0){
  									 //空だとnullになってしまうので，消えないようにしておく
  									 	 varDefines[blockLevel].push({notDelete:true});
  									 }
  									 result = encloses('letrec*', varDefines[blockLevel], selftype, sts);
  									 blockLevel--;
  									 return ScalaTag("TemplateBody", [result]);
  	case 'TemplateStatement':
  									 //後付けだけど・・・
  									 //ラムダの情報を補完する
  									 var annotation = ax(t.annotation), modifier = ax(t.modifier), def = ax(t.definition);
  									 console.error("def => " + def);
  									 if(def !== null && typeof def.type !== 'undefined'){
  									 	 if(def.type === "PatValDefInfo"
  									 	 		 || def.type === "PatVarDefInfo"
  									 	 		 || def.type === "ValDclInfo"
  									 	 		 || def.type === "VarDclInfo"
  									 	 		 || def.type === "TypeDclInfo"
  									 	 		 || def.type === "TypeDefInfo"
  									 	 		 ){
                           // console.error("json2.PatValInfo => " + annotation);
												varDefines[def.blockLevel][def.index][1][3].push(annotation);
												varDefines[def.blockLevel][def.index][1][3].push(modifier);
  									 	 }
  									 	 else if(def.type === "FuncDefInfo"
  									 	 		 || def.type === "FuncDclInfo"
  									 	 		 || def.type == "ProcedureInfo"){
                           // console.error("FuncDefInfo!!!");
												varDefines[def.blockLevel][def.index][1][0][3].push(annotation);
												varDefines[def.blockLevel][def.index][1][0][3].push(modifier);
  									 	 }
  									 	 else{
  									 	 	 throw new Error("json2.TemplateStat: unintended type => " + def.type);
  									 	 }
  									 }
                     // return ScalaTag(t.type, [annotation, modifier, null])
  									 return null;
  	case 'BlockStat':
  									 //後付けだけど・・・
  									 var annotation = ax(t.annotations), modifier = ax(t.modifier), def = ax(t.def);
  									 console.error("def => " + def);
  									 if(def !== null && typeof def.type !== 'undefined'){
  									 	 if(def.type === "PatValDefInfo"
  									 	 		 || def.type === "PatVarDefInfo"
  									 	 		 || def.type === "TypeDefInfo"){
  									 	 	 		 console.error("json2.PatValInfo => " + annotation);
														 varDefines[def.blockLevel][def.index][1][3].push(annotation);
														 varDefines[def.blockLevel][def.index][1][3].push(modifier);
  									 	 		 }
											 else if(def.type === "FuncDefInfo"
  									 	 		 || def.type == "ProcedureInfo"){
                           	 // console.error("FuncDefInfo!!!");
														 varDefines[def.blockLevel][def.index][1][0][3].push(annotation);
														 varDefines[def.blockLevel][def.index][1][0][3].push(modifier);
  									 	 		 }

  									 	 else{
  									 	 	 throw new Error("json2.BlockStat: unintended type => " + def.type);
  									 	 }
  									 }
                     // return ScalaTag(t.type, [annotation, modifier, null])
  									 return null;

  	case 'CompilationUnit': return enclose('begin', ax(t.packages)).concat(ax(t.topStatseq));
  	case 'Empty': return null; //どうしよう。とりあえず空文字列を返しておく
  	case 'Ellipsis': return '...';
  	case 'ExpressionMacroDefinition':
										 // console.error("ExpressionMacroDefinition: %j\n", t.syntaxRules);
										 // console.error("ExpressionMacroDefinition: %j\n", ax(t.syntaxRules));

										 var srules = t.syntaxRules, output = [];
										 for(var i = 0; i < srules.length; i++){
											 output.push(sx(ax(srules[i])));
										 }
										 var lits = t.literals;
										 if(lits.length == 0) lits.push({notDelete: true});
										 else lits = lits.map(convertName);
                     // return enclose('define-syntax', [t.macroName + "-Macro", ["syntax-rules", ["V-" + t.literals], ax(t.syntaxRules)]] );
										 // return enclose('define-syntax', [t.macroName + "-Macro", ["syntax-rules", ["V-" + t.literals], output.join(' ')]] );
										 return enclose('define-syntax', [t.macroName + "-Macro", ["syntax-rules", lits, output.join(' ')]] );
  	case 'ExpressionVariable':
  	case 'IdentifierVariable':
  	case 'TypeVariable':
  	case 'LiteralKeyword':
  	case 'Variable':
  	case 'SymbolVariable':
                		 // console.error("t.name = " + "V-" + t.name);
										 // return ScalaTag('Variable', ["V-" + t.name]);
										 var name = convertName(t.name);
										 // if(bSave) varNames[lambdaLevel].push(name);
										 return name;
  	case 'FunctionDeclaration':
  									 //Signatureを解析して，必要な変数を全て読み出す
  									 var params = [], sig = t.signature, name = convertName(sig.id.name);
  									 lambdaLevel++;
										 bSave = true;
										 varNames[lambdaLevel] = [];
  									 sig = ax(sig);
  									 params = varNames[lambdaLevel];
  									 lambdaLevel--;
  									 bSave = false;
  									 //本体はラムダの中につっこんでおく

										 if(params.length == 0){
										 	 params.push({notDelete: true});
										 }
										 else if(name === params[0]) params.shift();
										 varDefines[blockLevel].push([name, [encloses('lambda', params, ["function", "FunctionDeclaration"], [], sig, ax(t.tp), null)]]);
										 return {type:"FuncDclInfo", blockLevel: blockLevel, index:varDefines[blockLevel].length-1};
  	case 'FunctionDefinition':
  									 //Signatureを解析して，必要な変数を全て読み出す
  									 var params = [], sig = t.signature, name = convertName(sig.id.name);
  									 //....
  									 lambdaLevel++;
										 bSave = true;
										 varNames[lambdaLevel] = [];
  									 sig = ax(sig);
  									 params = varNames[lambdaLevel];
  									 lambdaLevel--;
  									 bSave = false;
  									 //本体はラムダの中につっこんでおく

										 if(params.length == 0){
										 	 params.push({notDelete: true});
										 }
										 else{
												// console.error("aaaarguments[0] = %j, name = %s\n", params[0], name);
										 	 if(name === params[0]){
										 	 	 //解析順序より，最初に入っているのがnameであるはず．．．
										 	 	 //nameがラムダの引数に入っていると，相互再帰関数を書いたときにバグるので，取り除く
										 	 	 params.shift();
										 	 }
										 }
										 varDefines[blockLevel].push([name, [encloses('lambda', params, ["function", "FunctionDefinition"], [], sig, ax(t.tp), ax(t.expr))]]);
				// return ScalaTag(t.type, [encloses('lambda', params, ax(sig), ax(t.tp), ax(t.expr))]);
										 // return null;
										 return {type:"FuncDefInfo", blockLevel: blockLevel, index:varDefines[blockLevel].length-1};
		case 'Procedure':
  									 //Signatureを解析して，必要な変数を全て読み出す
  									 var params = [], sig = t.signature, name = convertName(sig.id.name);
  									 //....
  									 lambdaLevel++;
										 bSave = true;
										 varNames[lambdaLevel] = [];
  									 sig = ax(sig);
  									 params = varNames[lambdaLevel];
  									 lambdaLevel--;
  									 bSave = false;
  									 //本体はラムダの中につっこんでおく

										 if(params.length == 0){
										 	 params.push({notDelete: true});
										 }
										 else if(name === params[0]) params.shift();
										 varDefines[blockLevel].push([name, [encloses('lambda', params, ["function", "Procedure"], [], sig, null, ax(t.block))]]);
				// return ScalaTag(t.type, [encloses('lambda', params, ax(sig), ax(t.tp), ax(t.expr))]);
										 // return null;
										 return {type:"ProcedureInfo", blockLevel: blockLevel, index:varDefines[blockLevel].length-1};



  	case 'integerLiteral': return t.value;
  	case 'MacroForm': return ax(t.inputForm);
  	case 'MacroName': return t.name + "-Macro";
    // case 'notDelete': return t; //最後までとっておく
  	case 'OneLine': return null; //とりあえずnull
										// case 'Paren':
										// console.error("Paren: eles = %j\n", t.elements);
										// console.error("Paren-2: eles = %j\n", ax(t.elements));
										// return ScalaTag('Paren2', ax(t.elements)); //fo debug
		case 'PatValDef':
										var patterns = t.body.patterns;
										var expr = t.body.expr;
										var res = [];
										for(var i = 0; i < patterns.length; i++){
											var e = patterns[i];
											//(define 変数名 ((val or var) (変数名についている情報) (右辺)))
										// res.push(encloses('define', convertName(e.id), ["VAL_Variable", [ax(e.tp)], ax(expr)]));
										// varDefines[blockLevel].push(encloses('define', "V-" + e.id, ["VAL_Variable", [ax(e.tp)], ax(expr)]));
										varDefines[blockLevel].push([convertName(e.id), [["val", "variable"], [ax(e.tp)], ax(expr), []]]);
										}
										// return res;
										// 何を返す？とりあえずnull
										// return null;
										return {type:"PatValDefInfo", blockLevel: blockLevel, index:varDefines[blockLevel].length-1};
		case 'PatVarDef':
										var patterns = t.body.patterns;
										var expr = t.body.expr;
										var res = [];
										for(var i = 0; i < patterns.length; i++){
											var e = patterns[i];
											//(define 変数名 ((val or var) (変数名についている情報) (右辺)))
										varDefines[blockLevel].push([convertName(e.id), [["var", "variable"], [ax(e.tp)], ax(expr), []]]);
										}
										// 何を返す？とりあえずnull
										return {type:"PatVarDefInfo", blockLevel: blockLevel, index:varDefines[blockLevel].length-1};
		// case 'TypeDefinition':
										// var patterns = t.body.patterns;
										// var expr = t.body.expr;
										// var res = [];
										// for(var i = 0; i < patterns.length; i++){
											// var e = patterns[i];
											// //(define 変数名 ((val or var) (変数名についている情報) (右辺)))
										// varDefines[blockLevel].push(["V-" + e.id, [["var", "variable"], [ax(e.tp)], ax(expr)]]);
										// }
										// // 何を返す？とりあえずnull
										// return null;
		case 'ValueDeclaration':
										var patterns = t.patterns;
										// var expr = t.body.expr;
										var res = [];
										for(var i = 0; i < patterns.length; i++){
											var e = patterns[i];
											//(define 変数名 ((val or var) (変数名についている情報) (右辺)))
										varDefines[blockLevel].push([convertName(e.id), [["val", "variable"], [ax(e.tp)], ax(null), []]]);
										}
										// return res;
										// 何を返す？とりあえずnull
										// return null;
										return {type:"ValDclInfo", blockLevel: blockLevel, index:varDefines[blockLevel].length-1};
		case 'VariableDeclaration':
										var patterns = t.patterns;
										// var expr = t.body.expr;
										var res = [];
										for(var i = 0; i < patterns.length; i++){
											var e = patterns[i];
											//(define 変数名 ((val or var) (変数名についている情報) (右辺)))
										varDefines[blockLevel].push([convertName(e.id), [["var", "variable"], [ax(e.tp)], ax(null), []]]);
										}
										// return res;
										// 何を返す？とりあえずnull
										// return null;
										return {type:"VarDclInfo", blockLevel: blockLevel, index:varDefines[blockLevel].length-1};
		case 'TypeDeclaration':
											var e = t.pattern;
											//(define 変数名 ((val or var) (変数名についている情報) (右辺)))
										varDefines[blockLevel].push([convertName(e.id), [["type", "TypeDeclaration"], [ax(e.tpc), ax(e.left), ax(e.right)], ax(null), []]]);
										// 何を返す？とりあえずnull
										// return null;
										return {type:"TypeDclInfo", blockLevel: blockLevel, index:varDefines[blockLevel].length-1};
	// case 'TypeDefinition':
	case 'TypeDefinition':
											var e = t.body.pattern;
											//(define 変数名 ((val or var) (変数名についている情報) (右辺)))
										varDefines[blockLevel].push([convertName(e.id), [["type", "TypeDefinition"], [ax(e.paramClause)], ax(e.tp), []]]);
										// 何を返す？とりあえずnull
										// return null;
										return {type:"TypeDefInfo", blockLevel: blockLevel, index:varDefines[blockLevel].length-1};
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
      // case 'WildCard':
                         // return "_";


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
  	if(t.length == 1){
  		var e = t[0];
  		if(e !== null && e.notDelete !== undefined) return "()";
  		else return '(' + sx(e) + ')';
  	}
  	else return '(' + t.map(sx).join(' ') + ')';
  }
  else if(t == null) return NULL;
  else return t;
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
