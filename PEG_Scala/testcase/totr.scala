import java.util.Scanner

//http://www.codechef.com/MARCH13/problems/TOTR/
object Main {
  def main(args: Array[String]): Unit = {doIt()}
  def doIt(){
    val sc = new Scanner(System.in);
    val t = sc.nextInt();
    val m = sc.next().toCharArray();
    for(i <- 1 to t){
      val input = sc.next().toCharArray();
      val f = conv(_:Char, m);
      val ans = input.map(f);
      println(ans.mkString(""));
    }
  }
  def conv(c: Char, m:Array[Char]):Char = {
    if('a' <= c && c <= 'z') return m(c - 'a');
    else if('A' <= c && c <= 'Z') return (m(c - 'A') - ('a' - 'A')).toChar;
    else if(c == '_') return ' ';
    else return c;
  }
}
