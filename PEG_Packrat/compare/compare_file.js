var PEG, contents, start, end, parser, parser2, fs, gram, ns, names, args, arg, files;
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
	'../testcase/test033_err.grm',
	'../examples/arithmetics.pegjs', // 11
	'../examples/json.pegjs',
	'../examples/css.pegjs',
	'../examples/javascript.pegjs'

];
files = [
	'../testcase/test018_js.ipt',
	'../examples/arithmetics.js',
	'../examples/javascript.js'
];
var grm = names[14];
var file = files[0];
contents = fs.readFileSync(grm).toString();

console.log("grammar = " + grm);
console.log("file = " + file);
if(arg != "2"){
	console.log("PEG parser build start.");
	start = new Date();
	parser2 = PEG.buildParser(contents);
	//parser2 = PEG.buildParser(contents, true);
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

var memory = {};
var cmd = fs.readFileSync(file).toString();
if(arg != "2"){
	console.log("PEG parser parse start.");
	start = new Date();
	console.log(parser2.parse(cmd));
	end = new Date();
	console.log((end - start) / 1000);
}
if(arg != "1"){
	console.log("my parser parse start.");
	start = new Date();
	console.log("res = " + ns[ns["START_SYMBOL"]](0, cmd, memory, 0));
	end = new Date();
	console.log((end - start) / 1000);
}
