import java.util.Scanner

object Main  {
  val MOD = 1000000007;
  def main(args: Array[String]){
    doIt()
  }

  def doIt(){
    val sc = new Scanner(System.in);
    val t = sc.nextInt();
    sc.nextLine();
    for(ii <- 1 to t){
      val fs = sc.nextLine();
      val et = sc.nextLine();
      val alp = new Array[Int](26);
      et.foreach(//c =>
          if('a' <= c && c <= 'z') alp(c - 'a') += 1
          else if('A' <= c && c <= 'Z') alp(c - 'A') += 1);

      // println("alp = " + alp.mkString);
      val al = alp.zipWithIndex.sorted;
      // println("al = " + al.mkString);
      val als = new Array[Char](26);
      // al.foreach(c => als(c._2) = fs(c._1));
      for(i <- 0 until 26){
        als(al(i)._2) = fs(i);
      }
      // println("als = " + als.mkString);
      println(et.map(//c =>
      if('a' <= c && c <= 'z') als(c - 'a')
      else if('A' <= c && c <= 'Z') als(c - 'A').toUpper
      else c));
      }
    }
  }
