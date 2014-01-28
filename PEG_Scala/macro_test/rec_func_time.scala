// 一引数のLetマクロ
Expression Rec {
    Identifier id, id2;
    Expression e, body, e2;
    Keyword =;

    { Rec (id) ->
      {
      def id(a: Int){
        println(a);
        id(a + 1);
      }
      }
      //println(((x: Int,y: Int) => x + y)(2, 3))
    }
}


object Rec_Func{

  def main(args: Array[String]): Unit = {
    // var $body = Append 2 to 3;
    // var $body = Append 2 to 3;
    // var $body = Append {2, 3, 4};
    // println($body);
    // type A = Int;
    // def a(c: A){
      // println(c);
      // b(c + 1);
    // }
    // def b(c: A){
      // println(c);
      // a(c + 2);
    // }
    // def d(c: Int){
      // println(c);
      // d(c + 1);
    // }
    val a = Rec(b);
    println(args(2));
    // val a = Let (x = 3 + 5 * 7 - 9, y = 10) { x * y };
    // val a = Let (x = 3 + 5 * 7 - 9, y = 10) { x };
    }
}

