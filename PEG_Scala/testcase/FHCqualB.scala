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
      // println(members.mkString(" "));
      val t1 = n / 2 + n % 2;
      val t2 = n / 2;
      val team1 = new Array[(Int, Int, String)](t1);
      val team2 = new Array[(Int, Int, String)](t2);
      var ans = new Array[String](p*2);
      var p1, p2 = 0;
      var pos = 0;
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
      // println(team1.mkString(" "));
      // println(team2.mkString(" "));
      val bIn1 = Array.fill(t1)(false);
      val nIn1 = Array.fill(t1)(0);
      for(i <-0 until p){
        bIn1(i) = true;
        nIn1(i) = 1;
      }
      for(i <- 0 until m){
        var idxIn, nIn, idxOut, nOut = -1;
        nIn = MOD;
        for(j <- 0 until t1){
          //who is leave?
          if(bIn1(j) && nOut <= nIn1(j)){
            nOut = nIn1(j);
            idxOut = j;
          }
          if(!bIn1(j) && nIn > nIn1(j)){
            nIn = nIn1(j);
            idxIn = j;
          }
        }
        if(nIn != MOD && 0 <= nOut){
          bIn1(idxIn) = true;
          bIn1(idxOut) = false;
        }
        for(j <- 0 until t1){
          if(bIn1(j)) nIn1(j) += 1;
        }
      }
      for(i <- 0 until t1){
          if(bIn1(i)){
            // println(team1(i));
            ans(pos) = team1(i)._3;
            pos += 1;
          }
      }

      val bIn2 = Array.fill(t2)(false);
      val nIn2 = Array.fill(t2)(0);
      for(i <-0 until p){
        bIn2(i) = true;
        nIn2(i) = 1;
      }
      for(i <- 0 until m){
        var idxIn, nIn, idxOut, nOut = -1;
        nIn = MOD;
        for(j <- 0 until t2){
          //who is leave?
          if(bIn2(j) && nOut <= nIn2(j)){
            nOut = nIn2(j);
            idxOut = j;
          }
          if(!bIn2(j) && nIn > nIn2(j)){
            nIn = nIn2(j);
            idxIn = j;
          }
        }
        if(nIn != MOD && 0 <= nOut){
          bIn2(idxIn) = true;
          bIn2(idxOut) = false;
        }
        for(j <- 0 until t2){
          if(bIn2(j)) nIn2(j) += 1;
        }
      }
      for(i <- 0 until t2){
          if(bIn2(i)){
            // println(team2(i));
            ans(pos) = team2(i)._3;
            pos += 1;
          }
      }

      // println(ans.mkString(" "));
      ans = ans.sorted;
      printf("Case #%d: %s\n", tt, ans.mkString(" "));
    }
  }
}
