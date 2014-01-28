import java.util.Scanner

object Main {

  def main(args: Array[String]): Unit = {doIt()}

  def doIt(){

    val m = sc.next().toCharArray();
    val sc = new Scanner(System.in);
    // val t = sc.nextInt();
    val list = List(3,4,5)
    val +++ = 1;
    //val ;;; = 1;
    val `"a"` = 1000;
    //val '"b"' = 1000; //cannot
    //val "c" = 2000; //cannot
    //val 'd' = 3000; //can compile, but cannot use?
    //val `'ea'` = 4000; //動くけど、仕様上は駄目なはず・・・
    //println(`'ea'`);
    //println(`'a'`); //cannot
    println("a = " + `"a"`);
    println(+++);

    for(i <- list){
      //val input = sc.next().toCharArray();
      val f = conv(_:Char, m);
      val ans = input.map(f);
      println(i);

  }
  def conv(c: Char, m:Array[Char]):Char = {
    a.b = 3;
     if(m <= "aaaa") return 1;
    println(x*yz);
    println(x * yz);
     if('a' < c && c < 'z') return m(c - 'a');
     else if('A' <= c && c <= 'Z') return (m(c - 'A') - ('a' - 'A')).toChar;
     else if(c == '_') return ' ';
     else return c;
  }

    }

  }
