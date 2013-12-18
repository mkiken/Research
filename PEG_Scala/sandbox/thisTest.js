
var A = {
	a : function(){
		console.log(A);
		console.log(this);
		console.log("a");
		this.b();
	},
	b : function(){
		console.log(A);
		console.log(this);
		console.log("b");
	}
}
A.a();
