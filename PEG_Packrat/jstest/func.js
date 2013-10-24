
function a(){
	return function(){
		return 100;
	};
}

function doIt(){
	console.log(a()());
}

doIt()
