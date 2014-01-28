Expression >> {
    Symbol from, s;

    { >> s from -> println(s + " from " + from)}
    { >> s -> println(s)}
}

object ForStmt{
  def main(args: Array[String]): Unit = {
    (>> おはよう 太郎);
    (>> いえーい);
    (>> hello! Bob);
  }
}
