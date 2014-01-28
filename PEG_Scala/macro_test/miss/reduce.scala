Expression Reduce {
    Identifier op;
    Expression init, e1, e2;
    // {Reduce [a] -> a}
    // {Reduce [a, b, ...] -> Reduce [b, ...] + a}

    // { Reduce [a] (op) init  ->
      // init op a
    // }
    { Reduce [] (op) init  ->
      init
    }
    { Reduce [e1] (op) init  ->
      e1
    }

    // { Reduce [e1, e2, ...] (op) init ->
      // (Reduce [e2, ...] (op) init) op e1
      // // Reduce [b, ...] (op) init * a
    // }
    { Reduce (op) init [e1, e2, ...]  ->
      (Reduce (op) init [e2, ...] ) op e1
      // Reduce [b, ...] (op) init * a
    }
}

object Main{
  def main(args : Array[String]){
    // val a = b[4];
    // val a = Reduce (+) 0 [3, 4];
    // val b = Reduce (*) 0 [3, 4];
    // val a = 3*5;
    // var c = Reduce [3, 4, 5]
    var c = Reduce [3, 4, 5] (*) 1
    var d = Reduce [10, 20] (+) 0
    var f = Reduce [1000] (*) 1
    var e = Reduce [] (-) 0
    println(a);
  }
}


