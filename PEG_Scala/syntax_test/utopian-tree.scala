import java.util.Scanner

object Main  {
  val MOD = 1000000007;
  def main(args: Array[String]){
    doIt()
  }

  def doIt(){
    val sc = new Scanner(System.in);
    val t = sc.nextInt();
    0 until t foreach { //i =>/* code */
      var n = sc.nextInt();
      var ans = 1L;
      0 until n foreach{ //j =>
        if(j % 2 == 0) ans *= 2;
        else ans += 1;
      }
      println(ans);
    }
  }
}
