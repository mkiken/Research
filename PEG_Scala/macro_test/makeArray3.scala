Expression makeArray {
    Expression a, b;
    Keyword &;

    { makeArray[a & b] ->
			Array.range(a, b)
    }
}

object makeArray{
  def main(args: Array[String]): Unit = {
    val ary = makeArray[1 & 100];
    println(ary);
  }
}
