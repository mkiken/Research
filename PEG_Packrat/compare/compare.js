var PEG, contents, start, end, parser, parser2, fs, gram, parser, ns, names, args, arg;
args = process.argv;
arg = args[2];
/*
 arg =
 		0 : both(default)
 		1 : parse only pegjs
 		2 : parse only packrat_peg
 */
arg = arg || '0';
//console.log(typeof arg);
PEG = require("pegjs");
fs = require("fs");

names = [
	'../testcase/test008_dot.grm',
	'../testcase/test015_arith.grm',
	'../testcase/test016_json.grm',
	'../testcase/test017_css.grm',
	'../testcase/test018_javascript.grm',
	'../testcase/test019_json.grm',
	'../testcase/test020_css.grm',
	'../testcase/test021_q.grm',
	'../testcase/test023_codeinvestigate.grm',
	'../testcase/test026_sclass.grm',
	'../testcase/test027_jsstatement.grm',
	'../testcase/test033_err.grm', // 11
	'../testcase/test034_semicolon.grm',
	'../examples/arithmetics.pegjs', // 13
	'../examples/json.pegjs',
	'../examples/css.pegjs',
	'../examples/javascript.pegjs'

];
var grm = names[0];
contents = fs.readFileSync(grm).toString();

console.log("grammar = " + grm);
if(arg != "2"){
	console.log("PEG parser build start.");
	start = new Date();
	parser2 = PEG.buildParser(contents);
	end = new Date();
	console.log((end - start) / 1000);
}
if(arg != "1"){
	console.log("my parser build start.");
	gram = fs.readFileSync( '../packrat_peg_sync.pegjs' ).toString();
	start = new Date();
	parser = PEG.buildParser(gram);
	ns = parser.parse(contents);
	end = new Date();
	console.log((end - start) / 1000);
}

var readline = require('readline');
var rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: false
});
console.log("\n\ninput start.\n\n");

rl.on('line', function (cmd) {
	//console.log(cmd.length);
	cmd = cmd.slice(0, cmd.length-1);
	//console.log(ns["START_SYMBOL"]);
	var memory = {};
	if(arg != "2") console.log(parser2.parse(cmd));
	//memory = {};
	if(arg != "1") console.log("res = " + ns[ns["START_SYMBOL"]](0, cmd, memory, 0));
});
