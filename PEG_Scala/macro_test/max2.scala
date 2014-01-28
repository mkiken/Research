Expression Max {
    Expression e;
    // Keyword and;

    { Max (e and ...) -> List(e, ...).max}
}

object GetMax{
  def main(args: Array[String]): Unit = {
    println(Max(100 and 50 and 200 and 1000));
    // println(Max(100 and 50 and 200 and ));
  }
}
