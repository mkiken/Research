import java.util.Scanner

object Main extends App {
  def main(args: Array[String]){
    doIt()
  }

  def doIt(){
    val sc = new Scanner(System.in);
    var x, y = 0;
    x = sc.nextInt();
    y = sc.nextInt();

    printf("%d\n", Math.max(x, y));


  }
}
