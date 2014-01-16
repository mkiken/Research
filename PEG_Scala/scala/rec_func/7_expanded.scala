object Rec_Func{
  def main(args: Array[String]):Unit = {
    type A_x60_31_  = Int;
    def a_x60_31_(c: A_x60_31_){
      println(c);
      b_x60_31_(c + 1);
    };
    def b_x60_31_(c: A_x60_31_){
      println(c);
      a_x60_31_(c + 2);
    };
  };
}

