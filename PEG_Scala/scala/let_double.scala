// 一引数のLetマクロ
expression Let {
    identifier: id, id2;
    expression: e, body, e2;
    keyword: =;

    { Let (id = e, id2 = e2) { body } ->
      /* sss */
			//(function (id) { return body; })(e)
			((id, id2) => body)(e, e2)
			//println(((x: Int,y: Int) => x + y)(2, 3))
    }
}

// var a = Let (x = 3) { x * x };
a = Let (x = 3, y = 10) { x * y }


