// 複数引数のLetマクロ
expression Let {
    identifier: id;
    expression: e, body;
    keyword: =;

    { Let ([# id = e #], ...) { body } ->
      // 1000
//        [[id, e], ...]
     ( (id, ...) => body )(e, ...)
    }
}

// a = Let (x = 3, y = 4) { x * y };
a = Let (x = 3, y = 4) { x * y };
