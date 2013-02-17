//パスはパーザールートからの相対パス

var basename = 'test009_comment';
var parseFile = './packrat_peg.pegjs'; //Packrat_PEGファイル
var inputFile = './testcase/' + basename + '.input'; //生成したパーザーで解析する入力
var gramFile = './testcase/' + basename + '.grammar'; //パーザーに与えるPEGの文法ファイル
var fs = require("fs");

exports.pp = function(){
	console.log("parse file : " + parseFile);
	return parseFile;
}


exports.input = function(){
	console.log("input file : " + inputFile);
	console.log("input : " + fs.readFileSync(inputFile).toString());
	return inputFile;
}

exports.gram = function(){
	console.log("gram file : " + gramFile);
	//console.log("grammar : " + gram);
	return gramFile;
}
