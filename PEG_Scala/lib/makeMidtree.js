var parser = require('./scala-parser.js');
var fs = require("fs");
var sname = process.argv[2];
var scala = fs.readFileSync( sname, 'utf8');

	console.log(JSON.stringify(parser.parse(scala), null,  2 ));

