var PEG = require("pegjs");

var fs = require("fs");
//var args = process.argv;
var gram = fs.readFileSync( './packrat_peg.pegjs' ).toString();
var parser = PEG.buildParser(gram);
//console.log(parser.parse(args[2]));

//var stdin = process.openStdin();
//stdin.on('data', function(chunk) { console.log(parser.parse(chunk.toString())); });

//from http://stackoverflow.com/questions/3430939/node-js-readsync-from-stdin

var readline = require('readline');

var rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: false
});

rl.on('line', function (cmd) { console.log(parser.parse(cmd)); });