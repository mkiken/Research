// 一引数のLetマクロ
Expression ルート{
    Symbol A, B, T;
    Keyword から, まで, で;

    { Route (A から B まで T で) ->
			(A, B, T)
			//println(((x: Int,y: Int) => x + y)(2, 3))
    }
}


object Append1{

  def main(args: Array[String]): Unit = {
    val a = ルート(東京 から 京都 まで 新幹線 で);
    println(args(2));
    }
}
