import java.util.Scanner
object Main {
  def main(args: Array[String]): Unit = {doIt()}
  def doIt(){

    // val sc = new Scanner(System.in);
    // val t = sc.nextInt();
    // val m = sc.next().toCharArray();
    val list = List(3,4,5)
    val +++ = 1;
    //val ;;; = 1;
    val `"a"` = 1000;
    //val '"b"' = 1000; //cannot
    //val "c" = 2000; //cannot
    //val 'd' = 3000; //can compile, but cannot use?
    //val `'e'` = 4000;
    // println(`'e'`);
    //println(`'a'`); //cannot
    println("a = " + `"a"`);
    println(+++);

    for(i <- list){
      //val input = sc.next().toCharArray();
      // val f = conv(_:Char, m);
      // val ans = input.map(f);
      println(i);

    }

  }
  def conv(c: Char, m:Array[Char]):Char = {
    if('a' <= c && c <= 'z') return m(c - 'a');
    else if('A' <= c && c <= 'Z') return (m(c - 'A') - ('a' - 'A')).toChar;
    else if(c == '_') return ' ';
    else return c;
  }
}
