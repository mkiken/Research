var unparser = require(__dirname + '/sx2scala.js');
var fs = require("fs");
var name = process.argv[2];
var json = fs.readFileSync(name, 'utf8');

unparser.convert(json, 1); // 1:stdout
	var tw = require('./time_util.js').time_watch;tw(unparser.convert, [json, 1], "SEXP -> Scala", 10);
