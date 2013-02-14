var PEG = require("pegjs");
var files = require("./files");

var fs = require("fs");
//var args = process.argv;
var gram = fs.readFileSync( files.pp() ).toString();
var parser = PEG.buildParser(gram);
var contents = fs.readFileSync( files.gram() ).toString();
console.log(parser.parse(contents));
