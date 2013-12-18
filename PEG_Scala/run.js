var PEG, contents, parser, fs, names;

//PEG = require("pegjs");
PEG = require("/usr/local/share/npm/lib/node_modules/pegjs")
fs = require("fs");

names = [
	'scala.pegjs',
	'test.pegjs',
	'ex-scala.pegjs'
];
// var grm = names[1];
var grm = process.argv[2];
contents = fs.readFileSync(grm, 'utf8');

console.log("grammar = " + grm);
		parser = PEG.buildParser(contents);
//console.log(parser);


var readline = require('readline');
var rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: false
});

console.log("\n\ninput start.\n\n");
rl.on('line', function (cmd) {
	// cmd = cmd.slice(0, cmd.length-1);
	console.log("cmd = %s", cmd);
	console.log(JSON.stringify(parser.parse(cmd)));
	console.log("\n\ninput start.\n\n");
});
