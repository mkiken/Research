var PEG = require("pegjs");
var files = require("./files");
var files2 = require("./files2");

var fs = require("fs");
//var args = process.argv;
var gram = fs.readFileSync( './packrat_peg_sync.pegjs' ).toString();
var parser = PEG.buildParser(gram);
var contents = fs.readFileSync(  './testcase/test012_plus.grammar' ).toString();
var ns = parser.parse(contents);

var contents2 = fs.readFileSync(  './testcase/test013_multi.grammar' ).toString();
var ns2 = parser.parse(contents2);
//var inputs = fs.readFileSync( files.input() ).toString();
/*var inputs = "2*3*1234";
var memory = {};
console.log("input = [ " + inputs + " ]");
console.log(ns["S"](0, inputs, memory, ns));*/
console.log(ns);
console.log(ns2);
ns["B"] = ns2["C"];
ns["C"] = ns2["C"]
ns["D"] = ns2["D"];
console.log(ns);


var readline = require('readline');
var rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: false
});

rl.on('line', function (cmd) {
	var memory = {};
	console.log("res = " + ns["S"](0, cmd, memory, ns));
});
