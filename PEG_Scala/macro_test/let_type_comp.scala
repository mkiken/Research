// 一引数のLetマクロ
Expression Let {
    // Identifier: id, id2;
    Identifier id, id2, t1;
    Expression e, body, e2;
    // Type: t1, t2;
    Type t2;
    Keyword =;

    { Let (id = e, t1, id2 = e2, t2) { body } ->
			((id:t1, id2:t2) => body)(e, e2)
			//println(((x: Int,y: Int) => x + y)(2, 3))
    }
}


object Append1{

  def main(args: Array[String]): Unit = {
    // var $body = Append 2 to 3;
    // var $body = Append 2 to 3;
    // var $body = Append {2, 3, 4};
    // println($body);
    // println(args(2));
    val a = 3;
    type t1 = Int;
    println(Let (x = 3*5, Int, y = 10, t1) { x * y });
    }
  }
