object Abs_Hygienic{
  def main(args: Array[String]):Unit = {
    val b_x60_31_  = 10;
    def id_x60_31_(a_x60_31_: Int){
      println(a_x60_31_);
      b_x60_31_ = b_x60_31_ + 1;
      id_x60_31_(a_x60_31_ + 1);
    };
    val tmp_x60_31_  = -100;
    val a_x60_31_  = 3;
    println({
      tmp_x60_31_ = 10;
    });
    id_x60_31_(3);
  };
}

