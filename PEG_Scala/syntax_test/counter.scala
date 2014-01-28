object ClosureSample extends App {

  def makeCounter() = {
    var count = 0;
    () => {
      count += 1
      count
    }
  }
  var count = 100;
  val counter = makeCounter();

  // println(counter()); // 1
  // println(counter()); // 2
  // println(counter()) // 333333
  myFunc(); // 333333

  // val counter2 = makeCounter()
  // val acounter = makeCounter() //55555

  println("------------"); //3
  println(counter2())
  // aaaaa 1
}
