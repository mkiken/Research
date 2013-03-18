var PEG = require("pegjs");
var files = require("./files");
var files2 = require("./files2");

var fs = require("fs");
//var args = process.argv;
var gram = fs.readFileSync( './packrat_peg_sync.pegjs' ).toString();
var parser = PEG.buildParser(gram);
var contents = fs.readFileSync( files.gram() ).toString();
var ns = parser.parse(contents);

var contents2 = fs.readFileSync( files2.gram() ).toString();
var ns2 = parser.parse(contents2);
var inputs = {};
inputs["str"] = "aaaaa";
inputs["len"] = inputs["str"].length; //入力文字列長
inputs["pos"] = 0; //開始位置
console.log("ns = " + ns);
console.log(ns["A"](0));
console.log("ns2 = " + ns2);
console.log(ns2["A"](0));

//ns["D"] = ns2["D"];
ns["D"] = undefined;
console.log(ns);
console.log(ns["A"](0));
