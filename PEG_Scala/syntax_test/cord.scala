trait FoldLeft[F[_]] {
  def foldLeft[A, B](xs: F[A], b: B, f: (B,A) => B): B
}

object FoldLeft {
  implicit object FoldLeftList extends FoldLeft[List]{
    def foldLeft[A, B](xs: List[A], b: B, f: (B,A) => B):B = xs.foldLeft(b)(f)
  }
}

trait Monoid[A] {
  def mappend(a1: A, a2:A):A
  def mzero: A
}

object Monoid {
  implicit object IntMonoid extends Monoid[Int]{
    def mappend(a: Int, b: Int): Int = a + b
    def mzero: Int = 0
  }

  implicit object StringMonoid extends Monoid[String] {
    def mappend(a: String, b: String): String = a + b
    def mzero: String = ""
  }
}
object Main {

  // def implicitly[T](implicit t: T): T = t
  import Monoid._, FoldLeft._

  val multMonoid = new Monoid[Int] {
    def mappend(a:Int, b: Int): Int = a * b
    def mzero: Int = 1
  }


  def sum[M[_],T](xs: M[T])(implicit m: Monoid[T], fl: FoldLeft[M]): T =
    fl.foldLeft(xs, m.mzero, m.mappend)


  def p(a: Any) {println("###> " + a)}
  def main(args: Array[String]) {
    println

    p(sum(List(1,2,3,4)))
    p(sum(List("a","b","c","d")))
    // p(sum(List(1,2,3,4))(multMonoid))  // 今はエラーになるのでコメントアウト
    p(sum(List(1,2,3,4))(multMonoid, implicitly[FoldLeft[List]]))

    println
  }
}
