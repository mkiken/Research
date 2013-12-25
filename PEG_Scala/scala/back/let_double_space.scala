// 一引数のLetマクロ
Expression Let {
    Identifier: id, id2;
    Expression: e, body, e2;
    Keyword: =;

    { Let (id = e id2 = e2) { body } ->
			((id, id2) => body)(e, e2)
			//println(((x: Int,y: Int) => x + y)(2, 3))
    }
}


object Append1{

  def main(args: Array[String]): Unit = {
    // var $body = Append 2 to 3;
    // var $body = Append 2 to 3;
    // var $body = Append {2, 3, 4};
    // println($body);
    println(args(2));
    val a = Let (x = 3 + 5 * 7 - 9 y = 10) { x * y };
    }
}

