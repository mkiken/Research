import java.util.Scanner

object Main  {
  val MOD = 1000000007;
  def main(args: Array[String]){
    doIt()
  }

  def pow(n1:Int, p1:BigInt, m:Int):Long = {
    var n = n1.toLong;
    var p = p1;
	var ans = 1L;
	while (p != 0) {
	  if((p&1) == 1) ans = (ans*n) % m;
	  n = (n*n) % m;
	  p = p>>1;
	}
	return ans.toLong;
  }

  def doIt(){
    val sc = new Scanner(System.in);
    var t, n = 0;
    var bin = "";
    var ans = 0L;
    // t = sc.nextInt();
    t = 100000;
    for(ii <- 1 to t){
      // n = sc.nextInt();
      n = 100;
      bin = Integer.toString(n, 2);
      ans = pow(2, BigInt(bin), MOD);
      ans = ans * ans % MOD;
      // println(ans);
    }
  }
}
