(begin (define-syntax Let-Macro (syntax-rules (V-=) ((_ ("Scala" "Paren" ((V-id V-= V-e) ...)) ("Scala" "Brace" (V-body))) (("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "TupleExpression" ("Scala" "Exprs" (("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "TupleExpression" ("Scala" "Exprs" (("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-id ) #\nul))  ) #\nul) ...)) ) #\nul)) (("Scala" "Identifier" "=>")) (("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-body ) #\nul))  ))) #\nul))) ("Scala" "FunctionApplicationPostfix" ("Scala" "ArgumentExpression" ("Scala" "Exprs" (("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-e ) #\nul))  ) #\nul) ...))) )) #\nul))  ) #\nul))))) ("Scala" "AssignmentExpression" #\nul V-a (Let-Macro ("Scala" "Paren" ((V-x V-= ("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "literalSimpleExpression" 3 ) #\nul))  ) #\nul)) (V-y V-= ("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "literalSimpleExpression" 4 ) #\nul))  ) #\nul)))) ("Scala" "Brace" (("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-x ) #\nul)) (("Scala" "Identifier" "*")) (("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-y ) #\nul))  ))) #\nul))))))
