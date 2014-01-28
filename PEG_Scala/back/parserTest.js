var parser = require('./scala-parser.js');
var fs = require("fs");
var names = [
	'testcase/A.scala',
	'testcase/_A.scala',
	'testcase/anagram.scala',
	'testcase/Test.scala',
	'test.pegjs'
];
var name = names[0];
var contents = fs.readFileSync(name, 'utf8');

console.log("");

console.log(JSON.stringify(parser.parse(contents), null, 2));

// var readline = require('readline');
// var rl = readline.createInterface({
  // input: process.stdin,
  // output: process.stdout,
  // terminal: false
// });
// console.log("input start.\n");
// rl.on('line', function (cmd) {
	// var memory = {};
	// cmd = cmd.slice(0, cmd.length - 1);
	// console.log("res = ");
	// console.log(JSON.stringify(parser.parse(cmd)));
	// console.log("\n\ninput start.\n");
// });
