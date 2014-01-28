Expression Let {
    Identifier id;
    Expression e, body;
    Type tp;
    Keyword =, ::;

    { Let ([# id = e :: tp #], ...) { body } ->
			((id:tp, ...) => body)(e, ...)
    }
}

object Main{
  def main(args : Array[String]){
    val a = Let (x = 3*5 :: Int, y = 10 :: Int) { x * y };
    println(a);
  }
}


