var unparser = require('./json2sx.js');
var fs = require("fs");
var arg = process.argv[2];
var names = [
'./convert/let-jsexpr.scm',
'./test.tree',
'./convert/let.tree'
];
// var name = names[2];
var name = arg;
console.log(arg);
var json = fs.readFileSync(name, 'utf8');

// console.log(json); // {"key": "value"}
var contents = JSON.parse(json);
// var contents = '{type:"sss"}';

console.log(contents);

unparser.convert(contents, 1); // 1:stdout
// console.log("");



