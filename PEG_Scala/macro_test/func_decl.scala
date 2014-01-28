Expression Decl {
    Identifier miss;
    Expression base;

    { Decl(base, miss) ->
      // [> sss <]
     ((f) => {
       val d = 3;
       if(f) base;
       else d;
     })(base)
    }
}

object Append1{

  val e:Int;
  var f:Int;
  def main(args: Array[String]): Unit = {

    val args:Int = 2;
    val main:Int = 2;
    // val e:Int;
    // var e:Int;
    val d = false;
    var c = false;
    val f, h:Int = -1;
    // val f:Int = -1;
    val a = Decl(d, f);
    println($body);
    val g = f;
    var z, y:Int = _;
    // val func = (_:Int) => 1000;
    val func = (a:Int) => 1000;
    val func2 = (_:Int) => 1000;

    }

  // val d:Int;
  }

