(begin
  (define-syntax Let-Macro
    (syntax-rules (V-=)
      ((_ ("JS" "paren" (V-id V-= V-e) ...) ("JS" "brace" V-body))
       ("JS" "array" ("JS" "array" V-id V-e) ...))))
  (begin
    (define V-a
      (Let-Macro
       ("JS" "paren" (V-x V-= ("JS" "const" "3")) (V-y V-= ("JS" "const" "4")))
       ("JS" "brace" ("JS" "binary" "*" V-x V-y))))))
