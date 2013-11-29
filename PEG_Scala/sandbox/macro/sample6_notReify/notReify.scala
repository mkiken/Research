// import scala.reflect.macros.Context
// import scala.language.experimental.macros
import language.experimental.macros
import reflect.macros.Context
object Asserts {
  def assert(cond: Boolean, msg:Any) = macro Asserts.assertImpl

  def raise(msg: Any) = throw new AssertionError(msg)
  def assertImpl(c: Context)
    (cond: c.Expr[Boolean], msg: c.Expr[Any]) : c.Expr[Unit] ={


   if (assertionsEnabled)
      // <[ if (!cond) raise(msg) ]>
      c.Expr[Unit](
        Select((Ident(newTermName("Asserts")), newTermName("raise")),
        Apply(Ident(newTermName("raise")), List(msg)),
        Literal(Constant())))
      else
      c.Expr[Unit]()
      //


      //x < 10
      c.Expr[Unit](Apply(
        Select(
          Ident(newTermName("x")),
          newTermName("$less"),
          List(Literal(Constant(10)))
        )
        ));

      }
}
