import java.util.Scanner

object Main  {
  val MOD = 1000000007;
  def main(args: Array[String]){
    doIt()
  }

  def doIt(){
    val sc = new Scanner(System.in);
    val t = sc.nextInt();
    for(tt <- 1 to t){
      val n, m, p = sc.nextInt();
      var members = new Array[(Int, Int, String)](n);
      for(i <- 0 until n){
        val name = sc.next();
        val percentage = sc.nextInt();
        val height = sc.nextInt();
        members(i) = (percentage, height, name);
        // println(members(i));
      }
      members = members.sorted.reverse;
      println(members.mkString(" "));
      val t1 = n / 2 + n % 2;
      val t2 = n / 2;
      val team1 = new Array[(Int, Int, String)](t1);
      val team2 = new Array[(Int, Int, String)](t2);
      var ans = new Array[String](p*2);
      var p1, p2 = 0;
      for(i <- 0 until n){
        if(i % 2 == 0){
          team1(p1) = members(i);
          p1 += 1;
        }
        else{
          team2(p2) = members(i);
          p2 += 1;
        }
      }
      println(team1.mkString(" "));
      println(team2.mkString(" "));
      var pos = 0;
      for(i <- m until m+p){
        ans(pos) = team1(i % t1)._3;
        pos += 1;
        ans(pos) = team2(i % t2)._3;
        pos += 1;
      }
      println(ans.mkString(" "));
      ans = ans.sorted;
      printf("Case #%d: %s\n", tt, ans.mkString(" "));
    }
  }
}
