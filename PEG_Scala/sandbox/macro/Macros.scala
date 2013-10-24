object Macro {

  import language.experimental.macros
  import reflect.macros.Context

  def log(message: String): Unit = macro log_impl

  def log_impl(c: Context)(message: c.Expr[String]): c.Expr[Unit] = {
    import c.universe._
    c.Expr[Unit](
      reify {
        println(c.Expr[Any](message.tree).splice)
      }.tree
    )
  }
}
