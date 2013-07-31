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
	'../testcase/test019_json.grm', // 5
	'../testcase/test020_css.grm',
	'../testcase/test021_q.grm',
	'../testcase/test023_codeinvestigate.grm',
	'../testcase/test026_sclass.grm',
	'../testcase/test027_jsstatement.grm', // 10
	'../testcase/test028_mul.grm',
	'../testcase/test030_js_without_action.grm',
	'../testcase/test033_err.grm', // 13
	'../testcase/test034_semicolon.grm',
	'../examples/arithmetics.pegjs', // 15
	'../examples/json.pegjs',
	'../examples/css.pegjs',
	'../examples/javascript.pegjs'

];
var grm = names[17];
contents = fs.readFileSync(grm, 'utf8');

function getMean(ary){
	var ret = 0;
	for(var i = 0; i < ary.length; i++){
		ret += ary[i];
	}
	return ret / ary.length;
}

function getSD(ary, m){
	var ret = 0;
	for(var i = 0; i < ary.length; i++){
		ret += (ary[i] - m)*(ary[i] - m);;
	}
	return Math.sqrt(ret / ary.length);
}


//console.log(getMean([1, 2, 3]));

console.log("grammar = " + grm);
var rep = 1;
if(arg != "2"){
	var res = [];
	console.log("PEG parser build start.");
	var sum = 0, m, s;
	for(var i = 0; i < rep; i++){
		start = new Date();
		parser2 = PEG.buildParser(contents);
		end = new Date();
		//sum += end - start;
		res.push(end - start);
	}
	m = getMean(res);
	s = getSD(res, m);
	console.log("time = " + m / 1000 + ", SD = " + s / 1000 + ", rep = " + rep);
}
if(arg != "1"){
	console.log("my parser build start.");
	gram = fs.readFileSync( '../back/_packrat_peg_sync_onlypos.pegjs', 'utf8' );
	var sum = 0, res = [], m, s;
	for(var i = 0; i < rep; i++){
		parser = PEG.buildParser(gram);
		start = new Date();
		ns = parser.parse(contents);
		end = new Date();
		res.push(end - start);
		//sum += end - start;
	}
	m = getMean(res);
	s = getSD(res, m);
	//console.log("time = " + m / 1000 + ", rep = " + rep);
	console.log("time = " + m / 1000 + ", SD = " + s / 1000 + ", rep = " + rep);
	//gram = fs.readFileSync( '../packrat_peg_action.pegjs', 'utf8' );
}

var readline = require('readline');
var rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: false
});

//console.log(JSON.stringify(ns));
console.log(ns);

console.log("\n\ninput start.\n\n");
rl.on('line', function (cmd) {
	//console.log(cmd.length);
	cmd = cmd.slice(0, cmd.length-1);
	//console.log(ns["START_SYMBOL"]);
	var memory = {};
	if(arg != "2") console.log(JSON.stringify(parser2.parse(cmd)));
	//memory = {};
	if(arg != "1") console.log("res = " + JSON.stringify(ns[ns["START_SYMBOL"]](0, cmd, memory, 0)));
	console.log("\n\ninput start.\n\n");
});
