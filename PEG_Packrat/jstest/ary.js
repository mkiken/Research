var func = function(){
	return {pos: 1, action: [2, 3, 4]};
}

var remUniAry = function(arg){
	while(arg instanceof Array && arg.length == 1){
		arg = arg[0];
	}
	return arg;
}

var test = [[1]];

//console.log(func().action);
//remUniAry();
console.log(remUniAry(test));

console.log(test);
