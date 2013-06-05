var PEG = require("pegjs");
//var files = require("../files");
//var files2 = require("../files2");
names = [
	'../testcase/test012_plus.grm',
	'../testcase/test013_multi.grm',
	'../testcase/test015_arith.grm',
	'../testcase/test016_json.grm',
	'../testcase/test017_css.grm',
	'../testcase/test018_javascript.grm', // 5
	'../testcase/test019_json.grm',
	'../testcase/test020_css.grm',
	'../testcase/test021_q.grm',
	'../testcase/test023_codeinvestigate.grm',
	'../testcase/test026_sclass.grm', // 10
	'../testcase/test027_jsstatement.grm',
	'../testcase/test028_newop.grm',
	'../testcase/test029_jssync.grm',
	'../testcase/test030_js_without_action.grm',
	'../testcase/test031_newop_without_action.grm', //15
	'../testcase/test032_jssync_without_action.grm',
	'../examples/arithmetics.pegjs',
	'../examples/json.pegjs',
	'../examples/css.pegjs',
	'../examples/javascript.pegjs'

];
var start, end;
var fs = require("fs");
//var args = process.argv;
var gram = fs.readFileSync( '../packrat_peg_sync.pegjs' ).toString();
var parser = PEG.buildParser(gram);
//console.log(parser);
var contents = fs.readFileSync(  names[14] ).toString();
start = new Date();
var ns = parser.parse(contents);
end = new Date();
console.log("1st file took " + (end - start) / 1000);
var contents2 = fs.readFileSync(  names[15] ).toString();
start = new Date();
var ns2 = parser.parse(contents2);
end = new Date();
console.log("2nd file took " + (end - start) / 1000);
// console.log(ns);
// console.log(ns2);
//ns["A"] = ns2["C"];
//ns2["D"] = ns["B"];
start = new Date();
ns["MultiplicativeOperator"] = ns2["MyMultiplicativeOperator"];
end = new Date();
console.log("sync took " + (end - start) / 1000);

start = new Date();
var parserA = PEG.buildParser(contents);
end = new Date();
console.log("1st file took(PEG.js) " + (end - start) / 1000);

start = new Date();
var parserB = PEG.buildParser(contents2);
end = new Date();
console.log("2nd file took(PEG.js) " + (end - start) / 1000);

var contents3 = fs.readFileSync(  names[16] ).toString();
start = new Date();
var parserC = PEG.buildParser(contents3);
end = new Date();
console.log("sync file took(PEG.js) " + (end - start) / 1000);


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
	console.log("res = " + ns[ns["START_SYMBOL"]](0, cmd, memory, 0));
	//console.log("res = " + ns["A"](0, cmd, memory, 0));
});
