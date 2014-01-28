Expression Abs {
    Identifier num;
    // Expression: num;
    // Expression: e, body, e2;
    // Keyword: |;

    { Abs num ->
      {
      // def id(a: Int){
        // println(a);
        // id(a + 1);
      // }

      // ext(5);
      // a = 10;
      // val tmp = -num;
      // if(num >= 0) num;
      // else tmp;
      num = 10;
      }
      //println(((x: Int,y: Int) => x + y)(2, 3))
    }
}


object Abs_Hygienic{

  def main(args: Array[String]): Unit = {
val b = 10;
    def id(a: Int){
      println(a);
      b = b + 1;
      id(a + 1);
    }
    // def ext(a: Int){
      // println(a);
      // id(a + 1);
    // }

    val tmp = -100;
    val a = 3;
    // val a = +++ 100;
    // val a = ||| abc;
    // 100;
    println(Abs tmp);
    id(3);
    // val b = Abs tmp;
    // println(b);

    }
}
