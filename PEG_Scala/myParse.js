var PEG = require("/usr/local/share/npm/lib/node_modules/pegjs");
var names = [
	'./scala.pegjs',
	'./test.pegjs'
];
var fs = require("fs");
var name = names[0];
console.log("grammar is " + name);
//var args = process.argv;
var gram = fs.readFileSync( './packrat_peg_action.pegjs', 'utf8');
var parser = PEG.buildParser(gram);
//var contents = fs.readFileSync(  './testcase/test015_arith.grm' ).toString();
var contents = fs.readFileSync(  name, 'utf8');
var ns = parser.parse(contents);

console.log("parser built!");

//console.log(ns);
var memory = {};
var start = ns["START_SYMBOL"]

var scalas = [
	'./testcase/_A.scala',
	'./testcase/Test.scala',
	'./testcase/util.scala',
	'./input.txt'
];
var scala = fs.readFileSync( scalas[1], 'utf8');
console.log("input length = " + scala.length);
	ret = ns[start](0, scala, memory, ns, 0);
	console.log(ret);
	console.log(JSON.stringify(ret));

// var readline = require('readline');
// var rl = readline.createInterface({
  // input: process.stdin,
  // output: process.stdout,
  // terminal: false
// });

// console.log("\n\ninput start.\n\n");
// rl.on('line', function (cmd) {
	// cmd = cmd.slice(0, cmd.length-1);
	// console.log(JSON.stringify(ns[start](0, cmd, memory, ns, 0)));
	// console.log("\n\ninput start.\n\n");
// });
