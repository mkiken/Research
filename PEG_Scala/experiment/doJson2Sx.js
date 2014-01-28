var unparser = require(__dirname + '/json2sx_scala.js');
var fs = require("fs");
var json = fs.readFileSync(process.argv[2], 'utf8');
var contents = JSON.parse(json);
unparser.convert(contents, 1); // 1:stdout
	var tw = require('./time_util.js').time_watch;tw(unparser.convert, [contents, 1], "JSON -> Sexp", 10);
