// 一引数のLetマクロ
expression Let {
    identifier: id;
    expression: e, body;
    keyword: =;

    { Let (id = e) { body } ->
      /* sss */
			//(function (id) { return body; })(e)
			((id) => body)(e)
			//println(((x: Int,y: Int) => x + y)(2, 3))
    }
}

// var a = Let (x = 3) { x * x };
a = Let (x = 3) { x * x }


