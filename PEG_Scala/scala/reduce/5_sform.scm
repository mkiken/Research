(begin (define-syntax Reduce-Macro (syntax-rules () ((_ ("Scala" "Bracket") ("Scala" "Paren" V-op) V-init) (("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-init #\nul) #\nul)) #\nul #\nul) #\nul))) ((_ ("Scala" "Bracket" V-e1) ("Scala" "Paren" V-op) V-init) (("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-e1 #\nul) #\nul)) #\nul #\nul) #\nul))) ((_ ("Scala" "Bracket" V-e1  V-e2 ...) ("Scala" "Paren" V-op) V-init) (("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "TupleExpression" ("Scala" "Exprs" ((#\nul (Reduce-Macro ("Scala" "Bracket" ("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-e2 #\nul) #\nul)) #\nul #\nul) #\nul) ...) ("Scala" "Paren" V-op) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-init #\nul) #\nul)) #\nul #\nul) #\nul)) #\nul))) #\nul) #\nul)) (V-op) (("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-e1 #\nul) #\nul)) #\nul #\nul))) #\nul))))) ("Scala" "TopStat" #\nul #\nul ("Scala" "ObjectTemplateDefinition" #\nul ("Scala" "ObjectDefinition" V-Main ("Scala" "ClassTemplateOpt" #\nul ("Scala" "TemplateBody" (letrec* ((R-main- ((lambda () (function Procedure) (#\nul #\nul) ("Scala" "FunctionSignature" R-main- #\nul ("Scala" "ParamClauses" (("Scala" "ParamClause" ("Scala" "Params" (("Scala" "Param" #\nul R-args- ("Scala" "RepeatedParamType" ("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (R-Array-)) (("Scala" "TypeArgs" ("Scala" "Types" (("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (R-String-)) #\nul) #\nul) #\nul #\nul) #\nul #\nul))))))) #\nul) #\nul #\nul) #\nul #\nul)) #\nul) #\nul))))) #\nul)) #\nul ("Scala" "Block" (letrec* ((V-c ((var variable) (#\nul) (#\nul (Reduce-Macro ("Scala" "Bracket" ("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "literalSimpleExpression" 3 #\nul) #\nul)) #\nul #\nul) #\nul)  ("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "literalSimpleExpression" 4 #\nul) #\nul)) #\nul #\nul) #\nul) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "literalSimpleExpression" 5 #\nul) #\nul)) #\nul #\nul) #\nul)) ("Scala" "Paren" V-*) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "literalSimpleExpression" 1 #\nul) #\nul)) #\nul #\nul) #\nul)) #\nul) (#\nul #\nul))) (V-d ((var variable) (#\nul) (#\nul (Reduce-Macro ("Scala" "Bracket" ("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "literalSimpleExpression" 10 #\nul) #\nul)) #\nul #\nul) #\nul)  ("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "literalSimpleExpression" 20 #\nul) #\nul)) #\nul #\nul) #\nul)) ("Scala" "Paren" V-+) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "literalSimpleExpression" 0 #\nul) #\nul)) #\nul #\nul) #\nul)) #\nul) (#\nul #\nul))) (V-f ((var variable) (#\nul) (#\nul (Reduce-Macro ("Scala" "Bracket" ("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "literalSimpleExpression" 1000 #\nul) #\nul)) #\nul #\nul) #\nul)) ("Scala" "Paren" V-*) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "literalSimpleExpression" 1 #\nul) #\nul)) #\nul #\nul) #\nul)) #\nul) (#\nul #\nul))) (V-e ((var variable) (#\nul) (#\nul (Reduce-Macro ("Scala" "Bracket") ("Scala" "Paren" V--) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "literalSimpleExpression" 0 #\nul) #\nul)) #\nul #\nul) #\nul)) #\nul) (#\nul #\nul)))) (#\nul #\nul #\nul #\nul ("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-println ("Scala" "FunctionApplicationPostfix" ("Scala" "ArgumentExpression" ("Scala" "Exprs" (("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-a #\nul) #\nul)) #\nul #\nul) #\nul)))) #\nul)) #\nul)) #\nul #\nul) #\nul)) #\nul)))))) #\nul (#\nul #\nul))))))) #\nul)
