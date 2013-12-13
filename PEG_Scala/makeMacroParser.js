var generator = require(__dirname + '/pegjs-generator2.js');
var fs = require("fs");
var names = [
'./convert/let-jsexpr.scm',
'./test.tree',
'./convert/let.tree'
];
var args = process.argv;
// var name = names[2];
var name = args[2];
console.error("args is %s.", args);
console.error("file is %s.", name);
var json = fs.readFileSync(name, 'utf8');

// console.log(json); // {"key": "value"}
var contents = JSON.parse(json);
// var contents = '{type:"sss"}';

// console.log(contents);

console.log(generator.generate(contents)); // 1:stdout
// console.log("");



