var PEG = require("pegjs");
//var files = require("./files");
//var files2 = require("./files2");
names = [
	'./testcase/test012_plus.grm',
	'./testcase/test013_multi.grm',
	'./testcase/test015_arith.grm',
	'./testcase/test016_json.grm',
	'./testcase/test017_css.grm',
	'./testcase/test018_javascript.grm', // 5
	'./testcase/test019_json.grm',
	'./testcase/test020_css.grm',
	'./testcase/test021_q.grm',
	'./testcase/test023_codeinvestigate.grm',
	'./testcase/test026_sclass.grm', // 10
	'./testcase/test027_jsstatement.grm',
	'./testcase/test028_newop.grm',
	'./examples/arithmetics.pegjs',
	'./examples/json.pegjs',
	'./examples/css.pegjs',
	'./examples/javascript.pegjs'

];

var fs = require("fs");
//var args = process.argv;
var gram = fs.readFileSync( './packrat_peg_action.pegjs' ).toString();
var parser = PEG.buildParser(gram);
var contents = fs.readFileSync(  names[5] ).toString();
var ns = parser.parse(contents);

var contents2 = fs.readFileSync(  names[12] ).toString();
var ns2 = parser.parse(contents2);
console.log(ns);
console.log(ns2);
//ns["A"] = ns2["C"];
//ns2["D"] = ns["B"];

ns["MultiplicativeOperator"] = ns2["MyMultiplicativeOperator"];

var readline = require('readline');
var rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: false
});

rl.on('line', function (cmd) {
	var memory = {};
	//console.log(ns["START_SYMBOL"](0, "1+3", memory, ns));
	cmd = cmd.slice(0, cmd.length - 1);
	console.log("res = " + JSON.stringify(ns[ns["START_SYMBOL"]](0, cmd, memory, 0)));
	//console.log("res = " + ns["A"](0, cmd, memory, 0));
});
