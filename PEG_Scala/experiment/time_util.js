exports.getMean = function(ary){
	var ret = 0;
	for(var i = 0; i < ary.length; i++){
		ret += ary[i];
	}
	return ret / ary.length;
}

//standard deviation
exports.getSD = function(ary){
	const m = exports.getMean(ary);
	var ret = 0;
	for(var i = 0; i < ary.length; i++){
		ret += (ary[i] - m)*(ary[i] - m);;
	}
	return Math.sqrt(ret / ary.length);
}

//f関数にargs引数を入れてiter回繰り返した結果を返す
exports.time_watch = function(f, args, label, iter){
	var start, end, res = [], m, s, rep = iter;
	console.error("time_watch: %s", label);
	for(var i = 0; i < rep; i++){
		if(args.length == 1){
		start = new Date();
		f(args[0]);
		end = new Date();
		res.push(end - start);
		}
		else if(args.length == 2){
		start = new Date();
		f(args[0], args[1]);
		end = new Date();
		res.push(end - start);
		}
	}
	m = exports.getMean(res);
	s = exports.getSD(res);
	// console.error("time = " + m / 1000 + ", SD = " + s / 1000 + ", rep = " + rep);
	console.error("time = %d, SD = %d, rep = %d", m, s, rep);
	// require('util').error("time = " + m / 1000 + ", SD = " + s / 1000 + ", rep = " + rep);

}

// http://d.hatena.ne.jp/dany1468/20111008/1318050210
function at(date) {
  if (!date) return '';
  return '' + date.getFullYear() + '-' + ('00' + (date.getMonth() + 1)).slice(-2) + '-' + ('00' + date.getDate()).slice(-2);
}

