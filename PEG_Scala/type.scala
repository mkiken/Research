
object Main {
  def sum[M[_],T](xs: M[T])(implicit m: Monoid[T], fl: FoldLeft[M]): T ={
    fl.foldLeft(xs, m.mzero, m.mappend);
  }

}
