//パスはパーザールートからの相対パス

var prefix = [
	'test001_star',
	'test002_seq',
	'test003_plus',
	'test004_not',
	'test005_priority',
	'test006_cfg', //5
	'test008_dot',
	'test019_json',
	'test021_q',
	'test022_notclass'
];
var basename = prefix[9];
var parseFile = './packrat_peg_sync.pegjs'; //Packrat_PEGファイル
var inputFile = './testcase/' + basename + '.input'; //生成したパーザーで解析する入力
var gramFile = './testcase/' + basename + '.grm'; //パーザーに与えるPEGの文法ファイル
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
