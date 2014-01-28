Expression makeArray {
    Expression a, b;

    { makeArray a b ->
			Array.range(a, b)
    }
}

object makeArray{
  def main(args: Array[String]): Unit = {
    val a = 1;
    val b = 100;
    // val ary = makeArray a b + 100;
    val ary2 = makeArray a b;
    // val ary3 = makeArray 3 b;
    val ary4 = makeArray 3 (b + 100);
    println(ary);
  }
}
