Expression 出力 {
    Expression: a, b;
    Keyword: ...;

    { makeArray[a ... b] ->
			Array.range(a, b)
    }
}

object PrintJapanese{
  def main(args: Array[String]): Unit = {
    val ary = makeArray[1 ... 100];
    println(ary);
  }
}
