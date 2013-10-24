//var parser = require('./examples/javascript.js');
// var parser = require();
var PEG = require("/usr/local/share/npm/lib/node_modules/pegjs");
var fs = require("fs");
var gram = fs.readFileSync( './testcase/test030_js_without_action.grm' ).toString();
var parser = PEG.buildParser(gram);
var readline = require('readline');
var rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: false
});

rl.on('line', function (cmd) {
	var memory = {};
	cmd = cmd.slice(0, cmd.length - 1);
	console.log("res = ");
	console.log(JSON.stringify(parser.parse(cmd)));
});
