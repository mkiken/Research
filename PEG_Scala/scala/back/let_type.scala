// 一引数のLetマクロ
Expression Let {
    Identifier: id, id2;
    Expression: e, body, e2;
    Type: t1, t2;
    Keyword: =;

    { Let (id = e, t1, id2 = e2, t2) { body } ->
			((id:t1, id2:t2) => body)(e, e2)
			//println(((x: Int,y: Int) => x + y)(2, 3))
    }
}

a = Let (x = 3*5, Int, y = 10, Int) { x * y }


