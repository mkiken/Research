var PEG = require("pegjs");

var fs = require("fs");
var args = process.argv;
var gram = fs.readFileSync( './packrat_peg.pegjs' ).toString();
var parser = PEG.buildParser(gram);
var contents = fs.readFileSync( './test001.grammar' ).toString();
console.log(parser.parse(contents));
