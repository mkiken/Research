var PEG = require("pegjs");
var files = require("./files");

var fs = require("fs");
//var args = process.argv;
//var pegfile = files.pp();
var pegfile = './packrat_peg_sync.pegjs';
var gram = fs.readFileSync( pegfile ).toString();
var parser = PEG.buildParser(gram);
//console.log(parser.parse(args[2]));

//var stdin = process.openStdin();
//stdin.on('data', function(chunk) { console.log(parser.parse(chunk.toString())); });

//from http://stackoverflow.com/questions/3430939/node-js-readsync-from-stdin

var readline = require('readline');
console.log("pegfile = " + pegfile);

var rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: false
});

rl.on('line', function (cmd) { console.log(parser.parse(cmd)); });
