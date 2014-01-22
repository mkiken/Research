
Expression Abs {
    Identifier: num;
    // Expression: e, body, e2;
    // Keyword: =;

    { Abs num ->
      {
      def id(a: Int){
        println(a);
        id(a + 1);
      }
      val tmp = -num;
      if(num >= 0) num;
      else tmp;
      }
      //println(((x: Int,y: Int) => x + y)(2, 3))
    }
}


object Rec_Func{

  def main(args: Array[String]): Unit = {

    val tmp = 100;
    // 100;
    Abs tmp;
    // val b = Abs tmp;
    // println(b);

    }
}

