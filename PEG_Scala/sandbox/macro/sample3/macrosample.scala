object macrosample{
  import Macros._
  // val f1 = file("hogehoge.txt")
  // val r1 = readFile(f1)
  val w1 = printWriter("output.txt") // ファイル名の文字列で渡す。
                                            // printWriterString_impl が展開される。
  try {
    // var line: String = null
    // while ({line = r1.readLine; line != null}){
    //   w1.println(line)
    //   println(line)
    // }
    w1.println("Hello, Scala!!\n")
  } finally {
    // r1.close
    w1.close
  }
}
