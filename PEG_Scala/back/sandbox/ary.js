var func = {
	a, b: function(){return 0;}
		 // b:func.a
};
function aa(){return 1;};
var tst = "a";
console.log(func);
console.log("%j", func["abc"]);
console.log("aa = %j", aa);
console.log(aa);

console.log(func[tst]);
if(undefined) console.log("aaaaaaa");
