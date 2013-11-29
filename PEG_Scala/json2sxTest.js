var unparser = require('./json2sx.js');
var fs = require("fs");
var names = [
'./convert/let-jsexpr.scm',
'./convert/let.tree'
];
var name = names[1];
var json = fs.readFileSync(name, 'utf8');

// console.log(json); // {"key": "value"}
var contents = JSON.parse(json);
// var contents = '{type:"sss"}';

// console.log(contents);

unparser.convert(contents, 1); // 1:stdout
// console.log("");



