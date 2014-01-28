import scala.math._

case class Complex(re: Double, im: Double) extends Ordered[Complex] {
  private val modulus = sqrt(pow(re, 2) + pow(im, 2))

  // コンストラクタ
  def this(re: Double) = this(re, 0)

  // 単項演算子
  def unary_+ = this
  def unary_- = new Complex(-re, -im)
  def unary_~ = new Complex(re, -im) // 複素共役
  def unary_! = modulus

  // 比較
  def compare(that: Complex) = !this compare !that

  // 算術演算
  def +(c: Complex) = new Complex(re + c.re, im + c.im)
  def -(c: Complex) = this + -c
  def *(c: Complex) =
    new Complex(re * c.re - im * c.im, im * c.re + re * c.im)
  def /(c: Complex) = {
    require(c.re != 0 || c.im != 0)
    val d = pow(c.re, 2) + pow(c.im, 2)
    new Complex((re * c.re + im * c.im) / d, (im * c.re - re * c.im) / d)
  }

  // 文字列表現
  override def toString() =
    this match {
      case Complex.i => "i"
      case Complex(re, 0) => re.toString
      case Complex(0, im) => im.toString + "*i"
      case _ => asString
    }
  private def asString =
    re + (if (im < 0) "-" + -im else "+" + im) + "*i"
}

object Complex {
  // 虚数単位
  val i = new Complex(0, 1)

  // ファクトリメソッド
  def apply(re: Double) = new Complex(re)

  // 暗黙の変換
  implicit def fromDouble(d: Double) = new Complex(d)
  implicit def fromFloat(f: Float) = new Complex(f)
  implicit def fromLong(l: Long) = new Complex(l)
  implicit def fromInt(i: Int) = new Complex(i)
  implicit def fromShort(s: Short) = new Complex(s)
}

import Complex._
