var memo = [];
var ret = {pos : 2, val : "abc"};
var chr = "A";
memo[chr] = ret;
ret.pos = 10;
var ans = memo[chr];
console.log(JSON.stringify(ans));
