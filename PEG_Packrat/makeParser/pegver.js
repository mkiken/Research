var PEG, contents, start, end, parser, parser2, fs, gram, parser, ns, names;
PEG = require("pegjs");
fs = require("fs");

names = [
	'../testcase/test015_arith.grm',
	'../testcase/test016_json.grm',
	'../testcase/test017_css.grm',
	'../testcase/test018_javascript.grm',
	'../testcase/test019_json.grm',
	'../testcase/test020_css.grm',
	'../examples/arithmetics.pegjs', // 6
	'../examples/json.pegjs',
	'../examples/css.pegjs',
	'../examples/javascript.pegjs'


];
var grm = names[6];
contents = fs.readFileSync(grm).toString();

console.log("grammar = " + grm);
console.log("PEG parser build start.");
start = new Date();
parser2 = PEG.buildParser(contents);
end = new Date();
console.log((end - start) / 1000);


console.log("my parser build start.");
gram = fs.readFileSync( '../packrat_peg_sync.pegjs' ).toString();
start = new Date();
parser = PEG.buildParser(gram);
ns = parser.parse(contents);
end = new Date();
console.log((end - start) / 1000);

var readline = require('readline');
var rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: false
});

rl.on('line', function (cmd) {
	//console.log(cmd.length);
	cmd = cmd.slice(0, cmd.length-1);
	//console.log(ns["START_SYMBOL"]);
	var memory = {};
	console.log(parser2.parse(cmd));
	//memory = {};
	console.log("res = " + ns[ns["START_SYMBOL"]](0, cmd, memory, ns));
});
