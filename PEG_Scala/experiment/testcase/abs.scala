Expression Abs {
    Identifier num;
    { Abs num ->
      {
      num = 10;
      }
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
    val tmp = -100;
    val a = 3;

    println(Abs tmp);
    id(3);

    }
}
