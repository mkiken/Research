var extend = require('util')._extend;
var a = []

var obj = {pos: 3, val: [1, 2, 3]};
a[0] = shallow_copy(obj);
a[1] = extend({}, obj);
a[2] = JSON.parse(JSON.stringify(obj));
a[3] = Object.create(obj);
a[4] = clone(obj);
obj.val[0] = 100;
for(var i = 0; i < a.length; i++) console.log(JSON.stringify(a[i]));


function clone(obj){
    if(obj == null || typeof(obj) != 'object') return obj;
    var temp = obj.constructor(); // changed
    for(var key in obj) temp[key] = clone(obj[key]);
    return temp;
}

function shallow_copy(obj){
	//var extend = require('util')._extend;
	//return extend({}, obj);
	if(obj == null || typeof(obj) != 'object') return obj;
	var temp = obj.constructor(); // changed
	for(var key in obj) temp[key] = obj[key];
	return temp;
}

