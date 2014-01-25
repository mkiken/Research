Type T {
    Keyword: a, f;

    { T a -> Int }
    { T f -> (String, T a) => Double }
}
Type L{
  Keyword: w;
  {L w -> F e}
}
Type F{
  Keyword: e;
  {F e -> T f}
}

object makeArray{
  def main(args: Array[String]): Unit = {
    // val ary = makeArray[1 ... 100];
    type c = Int;
    type b = T a;
    type d = T f;
    type z = F e;
    type aa = L w;
    println(ary);
  }
}
