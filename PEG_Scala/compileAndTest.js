// var PEG = require("pegjs");
PEG = require("/usr/local/share/npm/lib/node_modules/pegjs");
var names = [
	'./scala.pegjs',
	'./_scala.pegjs',
	'./test.pegjs',
	'./ex-scala.pegjs'
];
var fs = require("fs");
var name = names[3];
var dt = new Date();
console.log(dt);
console.log("grammar is " + name);
//var args = process.argv;
var gram = fs.readFileSync( name, 'utf8');
var parser = PEG.buildParser(gram);
//var contents = fs.readFileSync(  './testcase/test015_arith.grm' ).toString();

console.log("parser built!");

//console.log(ns);

var scalas = [
	'./testcase/A2.scala',
	'./testcase/totr.scala',
	'./testcase/utopian-tree.scala',
	'./testcase/counter.scala',
	'./testcase/power-of-large-numbers.scala',
	'./testcase/leballs.scala', //5
	'./testcase/anagram.scala',
	'./testcase/bday-gift.scala',
	'./testcase/A.scala',
	'./testcase/Test.scala',
	'./testcase/util.scala', //10
	'./input.txt',
	'./input.tmp'
];
var sname = scalas[12];
var scala = fs.readFileSync( sname, 'utf8');
console.log("scala file is " + sname);
	console.log(JSON.stringify(parser.parse(scala), null,  2 ));

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
// http://d.hatena.ne.jp/dany1468/20111008/1318050210
function at(date) {
  if (!date) return '';
  return '' + date.getFullYear() + '-' + ('00' + (date.getMonth() + 1)).slice(-2) + '-' + ('00' + date.getDate()).slice(-2);
}
