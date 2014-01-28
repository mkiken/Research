//引数は解析対象ファイル、パーザーを作るpegjs

var PEG = require("pegjs");
var fs = require("fs");
var args = process.argv;
var gram = fs.readFileSync( args[3], 'utf8');
var parser = PEG.buildParser(gram, {cache: true});

var scala = fs.readFileSync( args[2], 'utf8');
console.log(JSON.stringify(parser.parse(scala), null,  2 ));

