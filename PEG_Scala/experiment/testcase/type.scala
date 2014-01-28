Type T {
    Keyword 1.1, 1.2;

    { T 1.1 -> Int }
    { T 1.2 -> Double }
}
Type L{
  Keyword 'str;
  {L 'str -> F(String)}
}
Type F{
  Identifier s;
  {F(s) -> (s, T 1.1) => T 1.2}
}

object makeArray{
  def main(args: Array[String]): Unit = {
    // val ary = makeArray[1 ... 100];
    type c = Int;
    type b = T 1.1;
    type d = T 1.2;
    type z = F(Double);
    type aa = L 'str;
    // val t = 'abc;
    // val n = null;
    // println(ary);
  }
}
