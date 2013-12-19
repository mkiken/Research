expression Or {
    identifier: miss;
    expression: base;

    { Or (base, miss) ->
      // [> sss <]
     ((f) => {
       if(f) f;
       else miss;
     })(base)
    }
}

a = false;
f = -1;
a = Or (false, f);


