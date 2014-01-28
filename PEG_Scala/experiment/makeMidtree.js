var parser = require('./scala-parser.js');
var fs = require("fs");
var sname = process.argv[2];
var scala = fs.readFileSync( sname, 'utf8');

	console.log(JSON.stringify(parser.parse(scala), null,  2 ));

	var tw = require('./time_util.js').time_watch;tw(parser.parse, [scala], "マクロ定義の構文木作成", 10);

