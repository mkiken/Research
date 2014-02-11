var PEG, contents, start, end, parser, fs, parser, args;
args = process.argv;

PEG = require("pegjs");
fs = require("fs");


var grm = args[2];
contents = fs.readFileSync(grm, 'utf8');

console.log("grammar = " + grm);
var rep = 10;
var res = [];
console.log("PEG parser build start.");
var sum = 0, m, s;
for(var i = 0; i < rep; i++){
	start = new Date();
	parser = PEG.buildParser(contents);
	end = new Date();
	//sum += end - start;
	res.push(end - start);
	console.log("loop %d: %d", i, end - start);
}
m = getMean(res);
s = getSD(res, m);
console.log("time = %d, SD = %d, rep = %d", m, s, rep);
console.log(parser);


var readline = require('readline');
var rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
    terminal: false
});

console.log("\n\ninput start.\n\n");
rl.on('line', function (cmd) {
    // console.log("cmd = %s", cmd);
	console.log(JSON.stringify(parser.parse(cmd)));
	console.log("\n\ninput start.\n\n");
});


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
