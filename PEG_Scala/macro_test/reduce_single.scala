Expression Reduce {
    Identifier op;
    Expression init, a, b;

    { Reduce (op) init [a, b] ->
			a op b
    }
}

object Main{
  def main(args : Array[String]){
    val a = Reduce (+) 0 [3, 4];
    val b = Reduce (*) 0 [3, 4];
    // val a = 3*5;
    println(a);
  }
}


