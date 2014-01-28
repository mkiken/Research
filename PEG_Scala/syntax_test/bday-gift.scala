import java.util.Scanner

object Solution  {
  val MOD = 1000000000 + 7;
  def main(args: Array[String]){
    doIt()
  }

  def doIt(){
    val sc = new Scanner(System.in);
    val n = sc.nextInt();
    val balls = (1 to n) map (_ => sc.nextLong());
    val sum = balls.fold(0L)(_ + _);
    // println(sum / 2.0);
    printf("%.1f\n", sum / 2.0);
  }
}
