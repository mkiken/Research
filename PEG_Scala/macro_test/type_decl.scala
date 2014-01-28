Expression Decl {
    Identifier miss;
    Expression base;
    Type tp;

    { Decl(base, miss, tp) ->
      // [> sss <]
     ((f) => {
       type tb = tp;
       val d:tb = 3;
       if(f) base;
       else miss;
     })(base)
    }
}

object Append1{
  type ta;
  // private val tta:Int;
  private val tta:Int = 3;
  private var ttb:Int;
  def main(args: Array[String]): Unit = {

    type tb = Int;
    type f = Int;
    // type ta ;
    lazy val b = 1000;;
    val a = Decl(10, f, tb);
    println(a);

  }
}

