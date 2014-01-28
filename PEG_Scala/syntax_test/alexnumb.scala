import java.util.Scanner

object Main  {
  val MOD = 1000000007;
  def main(args: Array[String]){
    doIt()
  }

  def doIt(){
    val sc = new Scanner(System.in);
    val t = sc.nextInt();
    var l = 0L;
    for(i <- 0 until t){
      val n = sc.nextInt();
      for(j <- 0 until n) sc.nextInt();
      l = n;
      println(l*(l-1)/2);
    }

  }
}
