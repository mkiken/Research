Expression Or {
    Identifier miss;
    Expression base;

    { Or (base, miss) ->
      // [> sss <]
     ((f) => {
       if(f) f;
       else miss;
       // 3;
     })(base)
     // (() => 1)
     // 1
    }
    // { Or (miss) ->
      // miss
    // }
}

object Append1{

  def main(args: Array[String]): Unit = {
    val a = false;
    var f = -1;
    val b = Or (false, f);
    // val b = Or (f);
    println(b);
  }
}
