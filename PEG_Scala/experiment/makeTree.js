//引数は解析対象ファイル、パーザーを作るpegjs

var PEG = require("pegjs");
var fs = require("fs");
var args = process.argv;
var gram = fs.readFileSync( args[3], 'utf8');
// var parser = PEG.buildParser(gram, {cache: true});
	var tu = require('./time_util.js');

var start, end, res = [], m, s, rep = 1;
	console.error("makeTree: 解析器作成（キャッシュあり）");
	for(var i = 0; i < rep; i++){
		start = new Date();
		parser = PEG.buildParser(gram, {cache: true});
		end = new Date();
		res.push(end - start);
		console.error(end - start);
	}
	m = tu.getMean(res);
	s = tu.getSD(res);
	console.error("time = %d, SD = %d, rep = %d", m, s, rep);
	// require('util').error("time = " + m / 1000 + ", SD = " + s / 1000 + ", rep = " + rep);
	var tw = tu.time_watch;
var scala = fs.readFileSync( args[2], 'utf8');
	tw(parser.parse, [scala], "構文木作成（キャッシュあり）", 10);

	res = [];
	console.error("makeTree: 解析器作成(キャッシュなし)");
	for(var i = 0; i < rep; i++){
		start = new Date();
		parser = PEG.buildParser(gram);
		end = new Date();
		res.push(end - start);
		console.error(end - start);
	}
	m = tu.getMean(res);
	s = tu.getSD(res);
	console.error("time = %d, SD = %d, rep = %d", m, s, rep);
	// require('util').error("time = " + m / 1000 + ", SD = " + s / 1000 + ", rep = " + rep);

console.log(JSON.stringify(parser.parse(scala), null,  2 ));


// parser = PEG.buildParser(gram);
	tw(parser.parse, [scala], "構文木作成(キャッシュなし)", 10);
