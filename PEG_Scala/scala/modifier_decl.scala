// Expression Decl {
    // Identifier: miss;
    // Expression: base;
    // Type: tp;

    // { Decl(base, miss, tp) ->
      // // [> sss <]
     // ((f) => {
       // type tb = tp;
       // val d:tb = 3;
       // if(f) base;
       // else d;
     // })(base)
    // }
// }

object Append1{
  // type ta;
  // private type tb;
  // val t:Int;
  // private val g:Int;
  // var w:Int;
  // private var q:Int;
  // val c:Int = 10;
  // private val a:Int = 3;
  // var d:Int = 10;
  // private var b:Int = 10;
  sealed def main(args: Array[String]): Unit = {

    type tb = Int;
    implicit type f = Int;
    // type ta ;
    // sealed val b = 1000;;
    lazy var b = 1000;;
    val c = 1001;;
    lazy var d = 1000;;
    var r = 1001;;
    // val a = Decl(10, f, tb);
    println(a);

  }
}

