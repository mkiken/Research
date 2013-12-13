object Main  {
  def main(args: Array[String]){
    doIt()
  }

  def doIt(){
    println(((x: Int,y: Int) => x + y)(2, 3))
    println(((x: Object,y: Object) => x.toInt - y)(2, 3))
  }
}
