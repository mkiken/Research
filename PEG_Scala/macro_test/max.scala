Expression Max {
    Expression e;

    { Max (e, ...) -> List(e, ...).max}
}

object GetMax{
  def main(args: Array[String]): Unit = {
    println(Max(100, 50, 200, 1000, 3, 0, -100));
  }
}
