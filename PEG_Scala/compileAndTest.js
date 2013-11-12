var PEG = require("pegjs");
var names = [
	'./scala.pegjs',
	'./test.pegjs'
];
var fs = require("fs");
var name = names[0];
console.log("grammar is " + name);
//var args = process.argv;
var gram = fs.readFileSync( name, 'utf8');
var parser = PEG.buildParser(gram);
//var contents = fs.readFileSync(  './testcase/test015_arith.grm' ).toString();

console.log("parser built!");

//console.log(ns);

var scalas = [
	'./testcase/A.scala',
	'./testcase/Test.scala',
	'./testcase/util.scala',
	'./input.txt'
];
var scala = fs.readFileSync( scalas[0], 'utf8');
	console.log(JSON.stringify(parser.parse(scala)));

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
