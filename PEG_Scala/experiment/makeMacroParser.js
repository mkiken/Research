var generator = require(__dirname + '/pegjs-generator.js');
var fs = require("fs");
var name = process.argv[2];
var json = fs.readFileSync(name, 'utf8');
var contents = JSON.parse(json);
console.log(generator.generate(contents)); // 1:stdout

	var tw = require('./time_util.js').time_watch;tw(generator.generate, [contents], "マクロ定義の解析器作成", 10);

