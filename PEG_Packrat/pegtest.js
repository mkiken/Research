var PEG = require("pegjs");

var fs = require("fs");
//var args = process.argv;
var gram = fs.readFileSync( './packrat_peg_action.pegjs' ).toString();
var parser = PEG.buildParser(gram);
//var contents = fs.readFileSync(  './testcase/test015_arith.grm' ).toString();
var contents = fs.readFileSync(  './testcase/test002_seq.grm' ).toString();
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
});
