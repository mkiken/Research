//最後の_以前の*を_に変換する。a*b_+*をa_b_+*に変換する
function convertAsterisk(str){
	const opchars = "+-*/><=!&|%:~^|";
	var last = str.lastIndexOf('_');
	var buf = new Buffer(str.length);
	var bOp = true;

	for(var i = 0; i <= last; i++){
		if(str[i] == '*') buf[i] = '_'.charCodeAt(0);
		else buf[i] = str[i].charCodeAt(0);
	}
	//_以降が全て演算子であるか？
	for(var i = last + 1; i < str.length; i++){
		if(opchars.indexOf(str[i]) < 0){
			bOp = false;
			break;
		}
	}
	if(!bOp){
		for(var i = last + 1; i < str.length; i++){
			if(str[i] == '*') buf[i] = '_'.charCodeAt(0);
			else buf[i] = str[i].charCodeAt(0);
		}
	}
	else{
		for(var i = last + 1; i < str.length; i++) buf[i] = str[i].charCodeAt(0);
	}
	return buf.toString();
}

function test(){
	console.log(convertAsterisk("x_x60_29*"));
	console.log(convertAsterisk("x_x60*_29*"));
	console.log(convertAsterisk("x_x60*_+-*"));
}

test();
