var files = require("./files");

var parser = require('./packrat_peg_sync');
var fs = require("fs");
//var args = process.argv;
var contents = fs.readFileSync( files.gram() ).toString();
var ns = parser.parse(contents);
var readline = require('readline');
var rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: false
});
var start = ns["START_SYMBOL"];
console.log(ns);

rl.on('line', function (cmd) {
	var memory = {};
	cmd = cmd.slice(0, cmd.length - 1);
	console.log("res = " + ns[start](0, cmd, memory, 0));
});
