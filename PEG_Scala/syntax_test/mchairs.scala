import java.util.Scanner

object Main  {
  val MOD = 1000000007;
  def main(args: Array[String]){
    doIt()
  }

  def pow(n1:Int, p1:Int, m:Int):Int = {
    var n = n1.toLong;
    var p = p1;
	var ans = 1L;
	while (p != 0) {
	  if((p&1) == 1) ans = (ans*n) % m;
	  n = (n*n) % m;
	  p = p>>1;
	}
	return ans.toInt;
  }

  def doIt(){
    val sc = new Scanner(System.in);
    var t, n, ans = 0;
    t = sc.nextInt();
    while(0 < t){
      n = sc.nextInt();
      ans = pow(2, n, MOD) - 1;
      if(ans < 0) ans += MOD;
      println(ans);
      t -= 1;
    }
    //println(pow(100, 1000, MOD));
  }
}
