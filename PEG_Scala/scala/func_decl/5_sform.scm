(begin (define-syntax Decl-Macro (syntax-rules (V-) ((_ ("Scala" "Paren" (V-base  V-miss))) (("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "TupleExpression" ("Scala" "Exprs" (("Scala" "AnonymousFunction" (lambda (V-f) (#\nul) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "BlockExpression" ("Scala" "Block" (letrec* ((V-d ((val variable) (#\nul) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "literalSimpleExpression" 3 #\nul) #\nul)) #\nul #\nul) #\nul)))) (("Scala" "BlockStat" #\nul #\nul #\nul) ("Scala" "IfStatement" ("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-f #\nul) #\nul)) #\nul #\nul) #\nul) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-base #\nul) #\nul)) #\nul #\nul) #\nul) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-d #\nul) #\nul)) #\nul #\nul) #\nul))) #\nul)))) #\nul #\nul) #\nul))))) ("Scala" "FunctionApplicationPostfix" ("Scala" "ArgumentExpression" ("Scala" "Exprs" (("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-base #\nul) #\nul)) #\nul #\nul) #\nul)))) #\nul)) #\nul)) #\nul #\nul) #\nul))))) ("Scala" "TopStat" #\nul #\nul ("Scala" "ObjectTemplateDefinition" #\nul ("Scala" "ObjectDefinition" V-Append1 ("Scala" "ClassTemplateOpt" #\nul ("Scala" "TemplateBody" (letrec* ((V-e ((val variable) (("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (V-Int)) #\nul) #\nul) #\nul #\nul) #\nul #\nul))) #\nul)) (V-f ((var variable) (("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (V-Int)) #\nul) #\nul) #\nul #\nul) #\nul #\nul))) #\nul))) #\nul (("Scala" "TemplateStatement" #\nul #\nul #\nul) ("Scala" "TemplateStatement" #\nul #\nul #\nul) ("Scala" "TemplateStatement" #\nul #\nul ("Scala" "Definition" ("Scala" "FunctionDefinition" ("Scala" "FunctionSignature" V-main #\nul ("Scala" "ParamClauses" (("Scala" "ParamClause" ("Scala" "Params" (("Scala" "Param" #\nul V-args ("Scala" "RepeatedParamType" ("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (V-Array)) (("Scala" "TypeArgs" ("Scala" "Types" (("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (V-String)) #\nul) #\nul) #\nul #\nul) #\nul #\nul))))))) #\nul) #\nul #\nul) #\nul #\nul)) #\nul) #\nul))))) #\nul)) ("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (V-Unit)) #\nul) #\nul) #\nul #\nul) #\nul #\nul)) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "BlockExpression" ("Scala" "Block" (letrec* ((V-args ((val variable) (("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (V-Int)) #\nul) #\nul) #\nul #\nul) #\nul #\nul))) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "literalSimpleExpression" 2 #\nul) #\nul)) #\nul #\nul) #\nul))) (V-main ((val variable) (("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (V-Int)) #\nul) #\nul) #\nul #\nul) #\nul #\nul))) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "literalSimpleExpression" 2 #\nul) #\nul)) #\nul #\nul) #\nul))) (V-d ((val variable) (#\nul) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "literalSimpleExpression" ("Scala" "booleanLiteral" "false") #\nul) #\nul)) #\nul #\nul) #\nul))) (V-c ((var variable) (#\nul) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "literalSimpleExpression" ("Scala" "booleanLiteral" "false") #\nul) #\nul)) #\nul #\nul) #\nul))) (V-f ((val variable) (("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (V-Int)) #\nul) #\nul) #\nul #\nul) #\nul #\nul))) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" ("Scala" "Keyword" "-") ("Scala" "SimpleExpression" ("Scala" "literalSimpleExpression" 1 #\nul) #\nul)) #\nul #\nul) #\nul))) (V-h ((val variable) (("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (V-Int)) #\nul) #\nul) #\nul #\nul) #\nul #\nul))) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" ("Scala" "Keyword" "-") ("Scala" "SimpleExpression" ("Scala" "literalSimpleExpression" 1 #\nul) #\nul)) #\nul #\nul) #\nul))) (V-a ((val variable) (#\nul) (#\nul (Decl-Macro ("Scala" "Paren" (("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-d #\nul) #\nul)) #\nul #\nul) #\nul)  V-f))) #\nul))) (V-g ((val variable) (#\nul) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-f #\nul) #\nul)) #\nul #\nul) #\nul))) (V-z ((var variable) (("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (V-Int)) #\nul) #\nul) #\nul #\nul) #\nul #\nul))) ("Scala" "Keyword" "_"))) (V-y ((var variable) (("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (V-Int)) #\nul) #\nul) #\nul #\nul) #\nul #\nul))) ("Scala" "Keyword" "_"))) (V-func ((val variable) (#\nul) ("Scala" "AnonymousFunction" (lambda (V-a) (("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (V-Int)) #\nul) #\nul) #\nul #\nul) #\nul #\nul))) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "literalSimpleExpression" 1000 #\nul) #\nul)) #\nul #\nul) #\nul))))) (V-func2 ((val variable) (#\nul) ("Scala" "AnonymousFunction" (lambda (V--WILDCARD-) (("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (V-Int)) #\nul) #\nul) #\nul #\nul) #\nul #\nul))) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "literalSimpleExpression" 1000 #\nul) #\nul)) #\nul #\nul) #\nul)))))) (("Scala" "BlockStat" #\nul #\nul #\nul) ("Scala" "BlockStat" #\nul #\nul #\nul) ("Scala" "BlockStat" #\nul #\nul #\nul) ("Scala" "BlockStat" #\nul #\nul #\nul) ("Scala" "BlockStat" #\nul #\nul #\nul) ("Scala" "BlockStat" #\nul #\nul #\nul) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-println ("Scala" "FunctionApplicationPostfix" ("Scala" "ArgumentExpression" ("Scala" "Exprs" (("Scala" "PostfixExpression" ("Scala" "InfixExpression" ("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-$body #\nul) #\nul)) #\nul #\nul) #\nul)))) #\nul)) #\nul)) #\nul #\nul) #\nul) ("Scala" "BlockStat" #\nul #\nul #\nul) ("Scala" "BlockStat" #\nul #\nul #\nul) ("Scala" "BlockStat" #\nul #\nul #\nul) ("Scala" "BlockStat" #\nul #\nul #\nul)) #\nul)))) #\nul #\nul) #\nul)))) #\nul))))))) #\nul)
