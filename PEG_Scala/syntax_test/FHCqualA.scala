import java.util.Scanner

object Main  {
  import java.{util => ju}
  import scala.annotation._
  import scala.collection._
  import scala.collection.{mutable => mu}
  import scala.collection.JavaConverters._
  import scala.math._
  val MOD = 1000000007;
  def main(args: Array[String]){
    doIt()
  }

  def doIt(){
    val sc = new Scanner(System.in);
    val t = sc.nextInt();
    for (tt <- 1 to t){
      val n = sc.nextInt();
      val f = (1 to n) map (_ => sc.next());
      var si, sj, ver, hor = -1;
      var bSeq = false;
      for(i <- 0 until n){
        for(j <- 0 until n){
          if(si == -1 && f(i)(j) == '#'){
            bSeq = true;
            si = i;
            sj = j;
            ver = 0;
            hor = 0;
            for(ii <- i until n){
              if(bSeq && f(ii)(j) == '#') ver += 1;
              else bSeq = false;
            }
            bSeq = true;
            for(jj <- j until n){
              if(bSeq && f(i)(jj) == '#') hor += 1;
              else bSeq = false;
            }
          }
        }
      }
      var bOK = if(ver == hor) true else false;
      for(i <- 0 until n){
        for(j <- 0 until n){
          if(si <= i && i < si + ver && sj <= j && j < sj + hor){
            if(f(i)(j) == '.') bOK = false;
          }
          else{
            if(f(i)(j) == '#') bOK = false;
          }
        }
      }
      printf("Case #%d: %s\n", tt, if(bOK) "YES" else "NO");
    }
  }
}
