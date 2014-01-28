Expression Let {
    Identifier id;
    Expression e, body;
    Type tp;
    Keyword =, ::;

    { Let ((id = e :: tp ), ...) { body } ->
			((id:tp, ...) => body)(e, ...)
			//println(((x: Int,y: Int) => x + y)(2, 3))
    }
}

object Main{
  def main(args : Array[String]){
    val a = Let ( (x = 4*6 :: Int), (y = 11 :: Int)) { x * y };
    // val a = 3*5;
    println(a);
  }
}


