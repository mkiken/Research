object Ttype{
  def main(args: Array[String]){
    println(3);
    println(plus[Int](3, 5));
    println(id[Int](1000));
  }

  def plus[T](a:T, b:T): T = {
    a + b;
  }
  def id[T](a:T): T = {
    a;
  }
}
