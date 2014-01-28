// // var $body = Append [$title, $menu, $main] to $('body');
// var $body = Append $title and $menu and $main to $('body');
Expression Append {
    Expression: obj, c1, c2;
    // Expression: obj;
    Keyword: to;

//    { _ [] to obj => obj }
//    { _ [c1, c2, ...] to obj => Append [c2, ...] to obj.append(c1) }
    // { Append to obj -> obj }
    // { _ c1 to obj -> obj + c1 }
    // { _ c1 and c2 and ... to obj -> Append c2 and ... to obj + c1 }
    { _ c1 to obj -> obj.append(c1) }
    { _ c1 and c2 and ... to obj -> Append c2 and ... to obj.append(c1) }
    // { _ [c1] -> c1 }
    // { _ [c1, c2] -> (Append [c2]) + c1 }
    // { _ [c1, c2, ...] -> (Append [c2, ...]) + c1 }
    // { _ c1  -> c1 }
    // { _ c1 and c2 and ...  -> (Append c2 and ...) && c1 }
}


object Append1{

  def main(args: Array[String]): Unit = {
    // var $body = Append 2 to 3;
    // var $body = Append 2 to 3;
    // var $body = Append {2, 3, 4};
    // var $body = Append [2, 3, 4];
    var $body = Append 1 and 2 * 3 and c to obj;
    // var $body = Append 1 and 2 * 3 and c;
    println($body);
  }
}
