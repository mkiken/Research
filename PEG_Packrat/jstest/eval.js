var s = "2";
var f = "var a = function(){return 666;}";
var t = "var b = 3; return a + b;";
var f3 = "function(){" + t + "}";
var f2 = "var a = function(){return 666;}";
//var res = eval(f3);
var res = new Function("a", t);
//console.log(typeof(eval(f)));
console.log(res(5));
