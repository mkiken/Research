object Block {

  def main(args: Array[String]): Unit = {
    val a = 3;
    val b = {10;};
    println(a + b);
    println({val a = 10; a+10;} + a);
  }
  }
