var args = process.argv;
var parser = require('./scala-parser.js');
var fs = require("fs");

for(var i = 2; i < args.length; i++){
	var name = args[i];
	var contents = fs.readFileSync(name, 'utf8');
	console.log("\n\nfile = " + name + "\n");
	console.log(JSON.stringify(parser.parse(contents), null, 2));
	// console.log("\n\n");
}

