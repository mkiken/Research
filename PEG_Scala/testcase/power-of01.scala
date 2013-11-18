import java.util.Scanner;
import java.math.BigInteger;

object Main  {
  val MOD = new BigInteger("1000000007");
  def main(args: Array[String]){
    doIt()
  }

  def doIt(){
    val sc = new Scanner(System.in);
    val t = sc.nextInt();
    0 until t foreach{ //ii =>
      val as = sc.next();
      val bs = sc.next();
      val a = new BigInteger(as).mod(MOD).longValue();
      var b = new BigInteger(bs).toString(2);
      // println(a);
      // println(b);
      var ans = 1L;
      var base = a;
      b.length()-1 to 0 by -1 foreach{ //jj =>
        if(b(jj) == '1') ans = ans * base % 1000000007;
        base = base * base % 1000000007;
        // println("ans = " + ans + ", base = " + base);
      }
      println(ans);
    }
  }
}
