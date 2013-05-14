var PEG = require("pegjs");
var files = require("./files");

var fs = require("fs");
//var args = process.argv;
var gram = fs.readFileSync( files.pp() ).toString();
var parser = PEG.buildParser(gram);
var contents = fs.readFileSync( files.gram() ).toString();
var ns = parser.parse(contents);
var readline = require('readline');
var rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: false
});
var start = ns["START_SYMBOL"];

rl.on('line', function (cmd) {
	var memory = {};
	cmd = cmd.slice(0, cmd.length - 1);
	console.log("res = " + ns[start](0, cmd, memory, ns));
});
