Expression Plus {
    Expression a, b;

    { Plus a b ->
			a + b
    }
}

object makeArray{
  def main(args: Array[String]): Unit = {
    val a = 100;
    val b = -20;
    val ary = Plus a b;
    println(ary);
  }
}
