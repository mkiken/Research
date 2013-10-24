object ClosureSample extends App {

  def makeCounter() = {
    var count = 0;
    () => {
      count += 1
      count
    }
  }
  var count = 100;
  val counter = makeCounter()

  println(counter()) // 1
  println(counter()) // 2
  println(counter()) // 3

  val counter2 = makeCounter()

  println("------------")
  println(counter2()) // 1
}
