import java.util.Scanner
import java.math.BigInteger;


object Main  {
  val MOD = 1000000007;

  def mod_inverse(a: Int, m: Int):Int = {
    if(a == 0) 0;
    else ((new BigInteger(a.toString).modInverse(new BigInteger(m.toString)).longValue) % m).toInt;
  }

  def fact(n: Int, m: Int) = {
    var ans = 1L;
    for(i <- 2 to n) ans = ans * i % m;
    ans.toInt;
  }

  def main(args: Array[String]){
    doIt()
  }

  def doIt(){
    val sc = new Scanner(System.in);
    val r = sc.nextInt();
    val c = sc.nextInt();
    val x = sc.nextInt();
    val y = sc.nextInt();
    val d = sc.nextInt();
    val l = sc.nextInt();
    var ans = 1L;
    ans *= fact(d + l, MOD);
    ans = ans * mod_inverse(fact(d, MOD), MOD) % MOD;
    ans = ans * mod_inverse(fact(l, MOD), MOD) % MOD;
    ans = ans * (r - x + 1) % MOD;
    ans = ans * (c - y + 1) % MOD;
    println(ans);
  }
}
