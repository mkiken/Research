// 複数引数のLetマクロ
Expression Let {
    Identifier id;
    Expression e, body;
    Keyword =;

    { Let ([# id = e #], ...) { body } ->
      // 1000
//        [[id, e], ...]
     ( (id, ...) => body )(e, ...)
    }
}

object Append1{

  def main(args: Array[String]): Unit = {
    // var $body = Append 2 to 3;
    // var $body = Append 2 to 3;
    // var $body = Append {2, 3, 4};
    // println($body);
    // println(args(2));
    var a = Let (x = 3, y = 4) { x * y };
  }
}
