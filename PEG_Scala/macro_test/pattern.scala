Expression FOR {
    Expression e, block, s;
    Identifier i;

    { FOR (i, e) block ->
        for(i <- List.range(0, e)) block}
    { FOR (i, s, e) block ->
        for(i <- List.range(s, e)) block}
}

object ForStmt{
  def main(args: Array[String]): Unit = {
    (FOR(a, 3){println(a);});
    (FOR(o, 10, 24){println(o);});
  }
}
