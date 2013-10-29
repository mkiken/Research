function exe(){
	for(var c = "\u0020".charCodeAt(0); c <= "\u007F".charCodeAt(0); c++){
		console.log(String.fromCharCode(c));
		if(String.fromCharCode(c) == "."
				|| String.fromCharCode(c) == "["
				|| String.fromCharCode(c) == "]"
				|| String.fromCharCode(c) == "("
				|| String.fromCharCode(c) == ")"
				|| String.fromCharCode(c) == "{"
				|| String.fromCharCode(c) == "}"){
					console.log("except = " + c.toString(16));
				}
	}
	console.log("end.");
}

exe();
