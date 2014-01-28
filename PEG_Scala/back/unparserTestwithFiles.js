var args = process.argv;
var unparser = require('./json2scala.js');
var fs = require("fs");

for(var i = 2; i < args.length; i++){
	var name = args[i];
	// console.log("\n\nfile = " + name + "\n");
	var json = fs.readFileSync(name, 'utf8');
	var contents = JSON.parse(json);
	unparser.convert(contents, 1); // 1:stdout
	// console.log("\n\n");
}



