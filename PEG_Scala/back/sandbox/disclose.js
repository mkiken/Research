function disclose(e){
	if(Array.isArray(e) && e.length == 1) return disclose(e[0]);
	return e;
}

var a = [2, 3];
var b = [a];

console.log(disclose(b));
