var args = process.argv;
var parser = require('./scala-parser.js');
var fs = require("fs");
// var names = [
	// 'testcase/_A.scala',
	// 'test.pegjs'
// ];

for(var i = 2; i < args.length; i++){
	var name = args[i];
	var contents = fs.readFileSync(name, 'utf8');
	console.log("\n\nfile = " + name + "\n");
	console.log(JSON.stringify(parser.parse(contents)));
	console.log("\n\n");
}


// for(var e in args){
	// console.log(e);
// }
//args.forEach(function(element){console.log(element);});

//console.log("");


// var readline = require('readline');
// var rl = readline.createInterface({
  // input: process.stdin,
  // output: process.stdout,
  // terminal: false
// });
// console.log("input start.\n");
// rl.on('line', function (cmd) {
	// var memory = {};
	// cmd = cmd.slice(0, cmd.length - 1);
	// console.log("res = ");
	// console.log(JSON.stringify(parser.parse(cmd)));
	// console.log("\n\ninput start.\n");
// });
