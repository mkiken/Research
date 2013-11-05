import java.util.Scanner

object Main  {
  def main(args: Array[String]){
    doIt()
  }

  def doIt(){
    val sc = new Scanner(System.in);
    var t, n, k, e = 0;
    t = sc.nextInt();
    while(0 < t){
      n = sc.nextInt();

      val ar = Array.fill(n)(sc.nextInt())
      k = sc.nextInt();
      e = ar(k-1);
      println(ar.sorted.indexOf(e) + 1);
      t -= 1;
    }
  }
}
