var parser = require('./javascript.js');
var program = 'var 123 = 123;';
console.log(JSON.stringify(parser.parse(program), null, 2));
