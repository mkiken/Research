object Macro {

  import language.experimental.macros
  import reflect.macros.Context


  def log(msg: String): Unit = macro impl
  def impl(c: Context)
  (msg: c.Expr[String]): c.Expr[Unit] = {
      import c.universe._
      reify {
        val a = "macro message : " + msg.splice;
          println(msg.splice)
          println("import? : ");
          println(a)
          // msg = ": macroSuffix"; //msg is val
          // println(msg.value); //reify(expr.eval) transate to expr
          // println(msg.eval); //reify(expr.eval) transate to expr (can't compile)
          msg.value = "after macro!"; //msg is val
      }
    }

  }
