var PEG = require("pegjs");
var names = [
	'./testcase/test003_plus.grm',
	'./testcase/test012_plus.grm',
	'./testcase/test013_multi.grm',
	'./testcase/test015_arith.grm',
	'./testcase/test016_json.grm',
	'./testcase/test017_css.grm', // 5
	'./testcase/test018_javascript.grm',
	'./testcase/test019_json.grm',
	'./testcase/test020_css.grm',
	'./testcase/test021_q.grm',
	'./testcase/test023_codeinvestigate.grm', // 10
	'./testcase/test026_sclass.grm',
	'./testcase/test027_jsstatement.grm',
	'./testcase/test028_newop.grm',
	'./testcase/test029_jssync.grm',
	'./testcase/test035_jsexp.grm',
	'./examples/arithmetics.pegjs',
	'./examples/json.pegjs', // 17
	'./examples/css.pegjs',
	'./examples/javascript.pegjs'
];
var fs = require("fs");
var name = names[15];
//var args = process.argv;
var gram = fs.readFileSync( './packrat_peg_action.pegjs', 'utf8');
var parser = PEG.buildParser(gram);
//var contents = fs.readFileSync(  './testcase/test015_arith.grm' ).toString();
var contents = fs.readFileSync(  name, 'utf8');
var ns = parser.parse(contents);

console.log(ns);
var memory = {};
var names = [ "START_SYMBOL",
			  "start",
			  "additive",
			  "multiplicative",
			  "primar",
			  "integer"];

//console.log("res = " + ns[names[0]](0, "3*2", memory, 0));


var readline = require('readline');
var rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: false
});
var start = ns["START_SYMBOL"];
rl.on('line', function (cmd) {
	var memory = {}, ret;
	cmd = cmd.slice(0, cmd.length - 1);
	ret = ns[start](0, cmd, memory, 0);
	console.log(ret);
	console.log(JSON.stringify(ret));
});
