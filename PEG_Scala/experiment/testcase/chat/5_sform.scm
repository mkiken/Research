(begin (define-syntax >>-Macro (syntax-rules () ((_ V-s V-from) (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-println ("Scala" "FunctionApplicationPostfix" ("Scala" "ArgumentExpression" ("Scala" "Exprs" (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-s #\nul) #\nul)) V-+ ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "literalSimpleExpression" ("Scala" "stringLiteral" " from ") #\nul) #\nul)) V-+ ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-from #\nul) #\nul)))))))) #\nul)))) #\nul)) #\nul)))) #\nul))) ((_ V-s) (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-println ("Scala" "FunctionApplicationPostfix" ("Scala" "ArgumentExpression" ("Scala" "Exprs" (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-s #\nul) #\nul)))) #\nul)))) #\nul)) #\nul)))) #\nul))))) ("Scala" "TopStat" #\nul #\nul ("Scala" "ObjectTemplateDefinition" #\nul ("Scala" "ObjectDefinition" V-ForStmt ("Scala" "ClassTemplateOpt" #\nul ("Scala" "TemplateBody" (letrec* ((R-main- ((lambda () (function FunctionDefinition) (#\nul #\nul) ("Scala" "FunctionSignature" R-main- #\nul ("Scala" "ParamClauses" (("Scala" "ParamClause" ("Scala" "Params" (("Scala" "Param" #\nul R-args- ("Scala" "RepeatedParamType" ("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (R-Array-)) (("Scala" "TypeArgs" ("Scala" "Types" (("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (R-String-)) #\nul) #\nul) #\nul #\nul) #\nul #\nul))))))) #\nul) #\nul #\nul) #\nul #\nul)) #\nul) #\nul))))) #\nul)) ("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (R-Unit-)) #\nul) #\nul) #\nul #\nul) #\nul #\nul)) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "BlockExpression" ("Scala" "Block" (letrec* () (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "TupleExpression" ("Scala" "Exprs" ((#\nul (>>-Macro ("Scala" "stringLiteral" "おはよう") ("Scala" "stringLiteral" "太郎")) #\nul))) #\nul) #\nul)))) #\nul) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "TupleExpression" ("Scala" "Exprs" ((#\nul (>>-Macro ("Scala" "stringLiteral" "いえーい")) #\nul))) #\nul) #\nul)))) #\nul) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "TupleExpression" ("Scala" "Exprs" ((#\nul (>>-Macro ("Scala" "stringLiteral" "hello!") ("Scala" "stringLiteral" "Bob")) #\nul))) #\nul) #\nul)))) #\nul)) #\nul)))))) #\nul))))) #\nul (#\nul #\nul))))))) #\nul)
(begin (define-syntax >>-Macro (syntax-rules (V-[object Object]) ((_ V-s V-from) (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-println ("Scala" "FunctionApplicationPostfix" ("Scala" "ArgumentExpression" ("Scala" "Exprs" (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-s #\nul) #\nul)) V-+ ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "literalSimpleExpression" ("Scala" "stringLiteral" " from ") #\nul) #\nul)) V-+ ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-from #\nul) #\nul)))))))) #\nul)))) #\nul)) #\nul)))) #\nul))) ((_ V-s) (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-println ("Scala" "FunctionApplicationPostfix" ("Scala" "ArgumentExpression" ("Scala" "Exprs" (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-s #\nul) #\nul)))) #\nul)))) #\nul)) #\nul)))) #\nul))))) ("Scala" "TopStat" #\nul #\nul ("Scala" "ObjectTemplateDefinition" #\nul ("Scala" "ObjectDefinition" V-ForStmt ("Scala" "ClassTemplateOpt" #\nul ("Scala" "TemplateBody" (letrec* ((R-main- ((lambda () (function FunctionDefinition) (#\nul #\nul) ("Scala" "FunctionSignature" R-main- #\nul ("Scala" "ParamClauses" (("Scala" "ParamClause" ("Scala" "Params" (("Scala" "Param" #\nul R-args- ("Scala" "RepeatedParamType" ("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (R-Array-)) (("Scala" "TypeArgs" ("Scala" "Types" (("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (R-String-)) #\nul) #\nul) #\nul #\nul) #\nul #\nul))))))) #\nul) #\nul #\nul) #\nul #\nul)) #\nul) #\nul))))) #\nul)) ("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (R-Unit-)) #\nul) #\nul) #\nul #\nul) #\nul #\nul)) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "BlockExpression" ("Scala" "Block" (letrec* () (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "TupleExpression" ("Scala" "Exprs" ((#\nul (>>-Macro ("Scala" "stringLiteral" "おはよう") ("Scala" "stringLiteral" "太郎")) #\nul))) #\nul) #\nul)))) #\nul) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "TupleExpression" ("Scala" "Exprs" ((#\nul (>>-Macro ("Scala" "stringLiteral" "いえーい")) #\nul))) #\nul) #\nul)))) #\nul) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "TupleExpression" ("Scala" "Exprs" ((#\nul (>>-Macro ("Scala" "stringLiteral" "hello!") ("Scala" "stringLiteral" "Bob")) #\nul))) #\nul) #\nul)))) #\nul)) #\nul)))))) #\nul))))) #\nul (#\nul #\nul))))))) #\nul)
(begin (define-syntax >>-Macro (syntax-rules (V-[object Object]) ((_ V-s V-from) (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-println ("Scala" "FunctionApplicationPostfix" ("Scala" "ArgumentExpression" ("Scala" "Exprs" (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-s #\nul) #\nul)) V-+ ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "literalSimpleExpression" ("Scala" "stringLiteral" " from ") #\nul) #\nul)) V-+ ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-from #\nul) #\nul)))))))) #\nul)))) #\nul)) #\nul)))) #\nul))) ((_ V-s) (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-println ("Scala" "FunctionApplicationPostfix" ("Scala" "ArgumentExpression" ("Scala" "Exprs" (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-s #\nul) #\nul)))) #\nul)))) #\nul)) #\nul)))) #\nul))))) ("Scala" "TopStat" #\nul #\nul ("Scala" "ObjectTemplateDefinition" #\nul ("Scala" "ObjectDefinition" V-ForStmt ("Scala" "ClassTemplateOpt" #\nul ("Scala" "TemplateBody" (letrec* ((R-main- ((lambda () (function FunctionDefinition) (#\nul #\nul) ("Scala" "FunctionSignature" R-main- #\nul ("Scala" "ParamClauses" (("Scala" "ParamClause" ("Scala" "Params" (("Scala" "Param" #\nul R-args- ("Scala" "RepeatedParamType" ("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (R-Array-)) (("Scala" "TypeArgs" ("Scala" "Types" (("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (R-String-)) #\nul) #\nul) #\nul #\nul) #\nul #\nul))))))) #\nul) #\nul #\nul) #\nul #\nul)) #\nul) #\nul))))) #\nul)) ("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (R-Unit-)) #\nul) #\nul) #\nul #\nul) #\nul #\nul)) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "BlockExpression" ("Scala" "Block" (letrec* () (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "TupleExpression" ("Scala" "Exprs" ((#\nul (>>-Macro ("Scala" "stringLiteral" "おはよう") ("Scala" "stringLiteral" "太郎")) #\nul))) #\nul) #\nul)))) #\nul) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "TupleExpression" ("Scala" "Exprs" ((#\nul (>>-Macro ("Scala" "stringLiteral" "いえーい")) #\nul))) #\nul) #\nul)))) #\nul) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "TupleExpression" ("Scala" "Exprs" ((#\nul (>>-Macro ("Scala" "stringLiteral" "hello!") ("Scala" "stringLiteral" "Bob")) #\nul))) #\nul) #\nul)))) #\nul)) #\nul)))))) #\nul))))) #\nul (#\nul #\nul))))))) #\nul)
(begin (define-syntax >>-Macro (syntax-rules (V-[object Object]) ((_ V-s V-from) (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-println ("Scala" "FunctionApplicationPostfix" ("Scala" "ArgumentExpression" ("Scala" "Exprs" (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-s #\nul) #\nul)) V-+ ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "literalSimpleExpression" ("Scala" "stringLiteral" " from ") #\nul) #\nul)) V-+ ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-from #\nul) #\nul)))))))) #\nul)))) #\nul)) #\nul)))) #\nul))) ((_ V-s) (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-println ("Scala" "FunctionApplicationPostfix" ("Scala" "ArgumentExpression" ("Scala" "Exprs" (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-s #\nul) #\nul)))) #\nul)))) #\nul)) #\nul)))) #\nul))))) ("Scala" "TopStat" #\nul #\nul ("Scala" "ObjectTemplateDefinition" #\nul ("Scala" "ObjectDefinition" V-ForStmt ("Scala" "ClassTemplateOpt" #\nul ("Scala" "TemplateBody" (letrec* ((R-main- ((lambda () (function FunctionDefinition) (#\nul #\nul) ("Scala" "FunctionSignature" R-main- #\nul ("Scala" "ParamClauses" (("Scala" "ParamClause" ("Scala" "Params" (("Scala" "Param" #\nul R-args- ("Scala" "RepeatedParamType" ("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (R-Array-)) (("Scala" "TypeArgs" ("Scala" "Types" (("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (R-String-)) #\nul) #\nul) #\nul #\nul) #\nul #\nul))))))) #\nul) #\nul #\nul) #\nul #\nul)) #\nul) #\nul))))) #\nul)) ("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (R-Unit-)) #\nul) #\nul) #\nul #\nul) #\nul #\nul)) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "BlockExpression" ("Scala" "Block" (letrec* () (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "TupleExpression" ("Scala" "Exprs" ((#\nul (>>-Macro ("Scala" "stringLiteral" "おはよう") ("Scala" "stringLiteral" "太郎")) #\nul))) #\nul) #\nul)))) #\nul) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "TupleExpression" ("Scala" "Exprs" ((#\nul (>>-Macro ("Scala" "stringLiteral" "いえーい")) #\nul))) #\nul) #\nul)))) #\nul) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "TupleExpression" ("Scala" "Exprs" ((#\nul (>>-Macro ("Scala" "stringLiteral" "hello!") ("Scala" "stringLiteral" "Bob")) #\nul))) #\nul) #\nul)))) #\nul)) #\nul)))))) #\nul))))) #\nul (#\nul #\nul))))))) #\nul)
(begin (define-syntax >>-Macro (syntax-rules (V-[object Object]) ((_ V-s V-from) (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-println ("Scala" "FunctionApplicationPostfix" ("Scala" "ArgumentExpression" ("Scala" "Exprs" (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-s #\nul) #\nul)) V-+ ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "literalSimpleExpression" ("Scala" "stringLiteral" " from ") #\nul) #\nul)) V-+ ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-from #\nul) #\nul)))))))) #\nul)))) #\nul)) #\nul)))) #\nul))) ((_ V-s) (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-println ("Scala" "FunctionApplicationPostfix" ("Scala" "ArgumentExpression" ("Scala" "Exprs" (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-s #\nul) #\nul)))) #\nul)))) #\nul)) #\nul)))) #\nul))))) ("Scala" "TopStat" #\nul #\nul ("Scala" "ObjectTemplateDefinition" #\nul ("Scala" "ObjectDefinition" V-ForStmt ("Scala" "ClassTemplateOpt" #\nul ("Scala" "TemplateBody" (letrec* ((R-main- ((lambda () (function FunctionDefinition) (#\nul #\nul) ("Scala" "FunctionSignature" R-main- #\nul ("Scala" "ParamClauses" (("Scala" "ParamClause" ("Scala" "Params" (("Scala" "Param" #\nul R-args- ("Scala" "RepeatedParamType" ("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (R-Array-)) (("Scala" "TypeArgs" ("Scala" "Types" (("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (R-String-)) #\nul) #\nul) #\nul #\nul) #\nul #\nul))))))) #\nul) #\nul #\nul) #\nul #\nul)) #\nul) #\nul))))) #\nul)) ("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (R-Unit-)) #\nul) #\nul) #\nul #\nul) #\nul #\nul)) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "BlockExpression" ("Scala" "Block" (letrec* () (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "TupleExpression" ("Scala" "Exprs" ((#\nul (>>-Macro ("Scala" "stringLiteral" "おはよう") ("Scala" "stringLiteral" "太郎")) #\nul))) #\nul) #\nul)))) #\nul) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "TupleExpression" ("Scala" "Exprs" ((#\nul (>>-Macro ("Scala" "stringLiteral" "いえーい")) #\nul))) #\nul) #\nul)))) #\nul) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "TupleExpression" ("Scala" "Exprs" ((#\nul (>>-Macro ("Scala" "stringLiteral" "hello!") ("Scala" "stringLiteral" "Bob")) #\nul))) #\nul) #\nul)))) #\nul)) #\nul)))))) #\nul))))) #\nul (#\nul #\nul))))))) #\nul)
(begin (define-syntax >>-Macro (syntax-rules (V-[object Object]) ((_ V-s V-from) (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-println ("Scala" "FunctionApplicationPostfix" ("Scala" "ArgumentExpression" ("Scala" "Exprs" (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-s #\nul) #\nul)) V-+ ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "literalSimpleExpression" ("Scala" "stringLiteral" " from ") #\nul) #\nul)) V-+ ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-from #\nul) #\nul)))))))) #\nul)))) #\nul)) #\nul)))) #\nul))) ((_ V-s) (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-println ("Scala" "FunctionApplicationPostfix" ("Scala" "ArgumentExpression" ("Scala" "Exprs" (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-s #\nul) #\nul)))) #\nul)))) #\nul)) #\nul)))) #\nul))))) ("Scala" "TopStat" #\nul #\nul ("Scala" "ObjectTemplateDefinition" #\nul ("Scala" "ObjectDefinition" V-ForStmt ("Scala" "ClassTemplateOpt" #\nul ("Scala" "TemplateBody" (letrec* ((R-main- ((lambda () (function FunctionDefinition) (#\nul #\nul) ("Scala" "FunctionSignature" R-main- #\nul ("Scala" "ParamClauses" (("Scala" "ParamClause" ("Scala" "Params" (("Scala" "Param" #\nul R-args- ("Scala" "RepeatedParamType" ("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (R-Array-)) (("Scala" "TypeArgs" ("Scala" "Types" (("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (R-String-)) #\nul) #\nul) #\nul #\nul) #\nul #\nul))))))) #\nul) #\nul #\nul) #\nul #\nul)) #\nul) #\nul))))) #\nul)) ("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (R-Unit-)) #\nul) #\nul) #\nul #\nul) #\nul #\nul)) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "BlockExpression" ("Scala" "Block" (letrec* () (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "TupleExpression" ("Scala" "Exprs" ((#\nul (>>-Macro ("Scala" "stringLiteral" "おはよう") ("Scala" "stringLiteral" "太郎")) #\nul))) #\nul) #\nul)))) #\nul) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "TupleExpression" ("Scala" "Exprs" ((#\nul (>>-Macro ("Scala" "stringLiteral" "いえーい")) #\nul))) #\nul) #\nul)))) #\nul) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "TupleExpression" ("Scala" "Exprs" ((#\nul (>>-Macro ("Scala" "stringLiteral" "hello!") ("Scala" "stringLiteral" "Bob")) #\nul))) #\nul) #\nul)))) #\nul)) #\nul)))))) #\nul))))) #\nul (#\nul #\nul))))))) #\nul)
(begin (define-syntax >>-Macro (syntax-rules (V-[object Object]) ((_ V-s V-from) (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-println ("Scala" "FunctionApplicationPostfix" ("Scala" "ArgumentExpression" ("Scala" "Exprs" (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-s #\nul) #\nul)) V-+ ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "literalSimpleExpression" ("Scala" "stringLiteral" " from ") #\nul) #\nul)) V-+ ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-from #\nul) #\nul)))))))) #\nul)))) #\nul)) #\nul)))) #\nul))) ((_ V-s) (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-println ("Scala" "FunctionApplicationPostfix" ("Scala" "ArgumentExpression" ("Scala" "Exprs" (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-s #\nul) #\nul)))) #\nul)))) #\nul)) #\nul)))) #\nul))))) ("Scala" "TopStat" #\nul #\nul ("Scala" "ObjectTemplateDefinition" #\nul ("Scala" "ObjectDefinition" V-ForStmt ("Scala" "ClassTemplateOpt" #\nul ("Scala" "TemplateBody" (letrec* ((R-main- ((lambda () (function FunctionDefinition) (#\nul #\nul) ("Scala" "FunctionSignature" R-main- #\nul ("Scala" "ParamClauses" (("Scala" "ParamClause" ("Scala" "Params" (("Scala" "Param" #\nul R-args- ("Scala" "RepeatedParamType" ("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (R-Array-)) (("Scala" "TypeArgs" ("Scala" "Types" (("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (R-String-)) #\nul) #\nul) #\nul #\nul) #\nul #\nul))))))) #\nul) #\nul #\nul) #\nul #\nul)) #\nul) #\nul))))) #\nul)) ("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (R-Unit-)) #\nul) #\nul) #\nul #\nul) #\nul #\nul)) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "BlockExpression" ("Scala" "Block" (letrec* () (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "TupleExpression" ("Scala" "Exprs" ((#\nul (>>-Macro ("Scala" "stringLiteral" "おはよう") ("Scala" "stringLiteral" "太郎")) #\nul))) #\nul) #\nul)))) #\nul) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "TupleExpression" ("Scala" "Exprs" ((#\nul (>>-Macro ("Scala" "stringLiteral" "いえーい")) #\nul))) #\nul) #\nul)))) #\nul) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "TupleExpression" ("Scala" "Exprs" ((#\nul (>>-Macro ("Scala" "stringLiteral" "hello!") ("Scala" "stringLiteral" "Bob")) #\nul))) #\nul) #\nul)))) #\nul)) #\nul)))))) #\nul))))) #\nul (#\nul #\nul))))))) #\nul)
(begin (define-syntax >>-Macro (syntax-rules (V-[object Object]) ((_ V-s V-from) (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-println ("Scala" "FunctionApplicationPostfix" ("Scala" "ArgumentExpression" ("Scala" "Exprs" (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-s #\nul) #\nul)) V-+ ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "literalSimpleExpression" ("Scala" "stringLiteral" " from ") #\nul) #\nul)) V-+ ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-from #\nul) #\nul)))))))) #\nul)))) #\nul)) #\nul)))) #\nul))) ((_ V-s) (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-println ("Scala" "FunctionApplicationPostfix" ("Scala" "ArgumentExpression" ("Scala" "Exprs" (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-s #\nul) #\nul)))) #\nul)))) #\nul)) #\nul)))) #\nul))))) ("Scala" "TopStat" #\nul #\nul ("Scala" "ObjectTemplateDefinition" #\nul ("Scala" "ObjectDefinition" V-ForStmt ("Scala" "ClassTemplateOpt" #\nul ("Scala" "TemplateBody" (letrec* ((R-main- ((lambda () (function FunctionDefinition) (#\nul #\nul) ("Scala" "FunctionSignature" R-main- #\nul ("Scala" "ParamClauses" (("Scala" "ParamClause" ("Scala" "Params" (("Scala" "Param" #\nul R-args- ("Scala" "RepeatedParamType" ("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (R-Array-)) (("Scala" "TypeArgs" ("Scala" "Types" (("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (R-String-)) #\nul) #\nul) #\nul #\nul) #\nul #\nul))))))) #\nul) #\nul #\nul) #\nul #\nul)) #\nul) #\nul))))) #\nul)) ("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (R-Unit-)) #\nul) #\nul) #\nul #\nul) #\nul #\nul)) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "BlockExpression" ("Scala" "Block" (letrec* () (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "TupleExpression" ("Scala" "Exprs" ((#\nul (>>-Macro ("Scala" "stringLiteral" "おはよう") ("Scala" "stringLiteral" "太郎")) #\nul))) #\nul) #\nul)))) #\nul) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "TupleExpression" ("Scala" "Exprs" ((#\nul (>>-Macro ("Scala" "stringLiteral" "いえーい")) #\nul))) #\nul) #\nul)))) #\nul) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "TupleExpression" ("Scala" "Exprs" ((#\nul (>>-Macro ("Scala" "stringLiteral" "hello!") ("Scala" "stringLiteral" "Bob")) #\nul))) #\nul) #\nul)))) #\nul)) #\nul)))))) #\nul))))) #\nul (#\nul #\nul))))))) #\nul)
(begin (define-syntax >>-Macro (syntax-rules (V-[object Object]) ((_ V-s V-from) (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-println ("Scala" "FunctionApplicationPostfix" ("Scala" "ArgumentExpression" ("Scala" "Exprs" (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-s #\nul) #\nul)) V-+ ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "literalSimpleExpression" ("Scala" "stringLiteral" " from ") #\nul) #\nul)) V-+ ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-from #\nul) #\nul)))))))) #\nul)))) #\nul)) #\nul)))) #\nul))) ((_ V-s) (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-println ("Scala" "FunctionApplicationPostfix" ("Scala" "ArgumentExpression" ("Scala" "Exprs" (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-s #\nul) #\nul)))) #\nul)))) #\nul)) #\nul)))) #\nul))))) ("Scala" "TopStat" #\nul #\nul ("Scala" "ObjectTemplateDefinition" #\nul ("Scala" "ObjectDefinition" V-ForStmt ("Scala" "ClassTemplateOpt" #\nul ("Scala" "TemplateBody" (letrec* ((R-main- ((lambda () (function FunctionDefinition) (#\nul #\nul) ("Scala" "FunctionSignature" R-main- #\nul ("Scala" "ParamClauses" (("Scala" "ParamClause" ("Scala" "Params" (("Scala" "Param" #\nul R-args- ("Scala" "RepeatedParamType" ("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (R-Array-)) (("Scala" "TypeArgs" ("Scala" "Types" (("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (R-String-)) #\nul) #\nul) #\nul #\nul) #\nul #\nul))))))) #\nul) #\nul #\nul) #\nul #\nul)) #\nul) #\nul))))) #\nul)) ("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (R-Unit-)) #\nul) #\nul) #\nul #\nul) #\nul #\nul)) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "BlockExpression" ("Scala" "Block" (letrec* () (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "TupleExpression" ("Scala" "Exprs" ((#\nul (>>-Macro ("Scala" "stringLiteral" "おはよう") ("Scala" "stringLiteral" "太郎")) #\nul))) #\nul) #\nul)))) #\nul) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "TupleExpression" ("Scala" "Exprs" ((#\nul (>>-Macro ("Scala" "stringLiteral" "いえーい")) #\nul))) #\nul) #\nul)))) #\nul) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "TupleExpression" ("Scala" "Exprs" ((#\nul (>>-Macro ("Scala" "stringLiteral" "hello!") ("Scala" "stringLiteral" "Bob")) #\nul))) #\nul) #\nul)))) #\nul)) #\nul)))))) #\nul))))) #\nul (#\nul #\nul))))))) #\nul)
(begin (define-syntax >>-Macro (syntax-rules (V-[object Object]) ((_ V-s V-from) (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-println ("Scala" "FunctionApplicationPostfix" ("Scala" "ArgumentExpression" ("Scala" "Exprs" (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-s #\nul) #\nul)) V-+ ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "literalSimpleExpression" ("Scala" "stringLiteral" " from ") #\nul) #\nul)) V-+ ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-from #\nul) #\nul)))))))) #\nul)))) #\nul)) #\nul)))) #\nul))) ((_ V-s) (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-println ("Scala" "FunctionApplicationPostfix" ("Scala" "ArgumentExpression" ("Scala" "Exprs" (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-s #\nul) #\nul)))) #\nul)))) #\nul)) #\nul)))) #\nul))))) ("Scala" "TopStat" #\nul #\nul ("Scala" "ObjectTemplateDefinition" #\nul ("Scala" "ObjectDefinition" V-ForStmt ("Scala" "ClassTemplateOpt" #\nul ("Scala" "TemplateBody" (letrec* ((R-main- ((lambda () (function FunctionDefinition) (#\nul #\nul) ("Scala" "FunctionSignature" R-main- #\nul ("Scala" "ParamClauses" (("Scala" "ParamClause" ("Scala" "Params" (("Scala" "Param" #\nul R-args- ("Scala" "RepeatedParamType" ("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (R-Array-)) (("Scala" "TypeArgs" ("Scala" "Types" (("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (R-String-)) #\nul) #\nul) #\nul #\nul) #\nul #\nul))))))) #\nul) #\nul #\nul) #\nul #\nul)) #\nul) #\nul))))) #\nul)) ("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (R-Unit-)) #\nul) #\nul) #\nul #\nul) #\nul #\nul)) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "BlockExpression" ("Scala" "Block" (letrec* () (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "TupleExpression" ("Scala" "Exprs" ((#\nul (>>-Macro ("Scala" "stringLiteral" "おはよう") ("Scala" "stringLiteral" "太郎")) #\nul))) #\nul) #\nul)))) #\nul) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "TupleExpression" ("Scala" "Exprs" ((#\nul (>>-Macro ("Scala" "stringLiteral" "いえーい")) #\nul))) #\nul) #\nul)))) #\nul) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "TupleExpression" ("Scala" "Exprs" ((#\nul (>>-Macro ("Scala" "stringLiteral" "hello!") ("Scala" "stringLiteral" "Bob")) #\nul))) #\nul) #\nul)))) #\nul)) #\nul)))))) #\nul))))) #\nul (#\nul #\nul))))))) #\nul)
(begin (define-syntax >>-Macro (syntax-rules (V-[object Object]) ((_ V-s V-from) (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-println ("Scala" "FunctionApplicationPostfix" ("Scala" "ArgumentExpression" ("Scala" "Exprs" (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-s #\nul) #\nul)) V-+ ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "literalSimpleExpression" ("Scala" "stringLiteral" " from ") #\nul) #\nul)) V-+ ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-from #\nul) #\nul)))))))) #\nul)))) #\nul)) #\nul)))) #\nul))) ((_ V-s) (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-println ("Scala" "FunctionApplicationPostfix" ("Scala" "ArgumentExpression" ("Scala" "Exprs" (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "idSeqSimpleExpression" V-s #\nul) #\nul)))) #\nul)))) #\nul)) #\nul)))) #\nul))))) ("Scala" "TopStat" #\nul #\nul ("Scala" "ObjectTemplateDefinition" #\nul ("Scala" "ObjectDefinition" V-ForStmt ("Scala" "ClassTemplateOpt" #\nul ("Scala" "TemplateBody" (letrec* ((R-main- ((lambda () (function FunctionDefinition) (#\nul #\nul) ("Scala" "FunctionSignature" R-main- #\nul ("Scala" "ParamClauses" (("Scala" "ParamClause" ("Scala" "Params" (("Scala" "Param" #\nul R-args- ("Scala" "RepeatedParamType" ("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (R-Array-)) (("Scala" "TypeArgs" ("Scala" "Types" (("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (R-String-)) #\nul) #\nul) #\nul #\nul) #\nul #\nul))))))) #\nul) #\nul #\nul) #\nul #\nul)) #\nul) #\nul))))) #\nul)) ("Scala" "Type" #\nul ("Scala" "InfixType" ("Scala" "CompoundType" ("Scala" "AnnotType" ("Scala" "SimpleType" ("Scala" "StableId" (R-Unit-)) #\nul) #\nul) #\nul #\nul) #\nul #\nul)) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "BlockExpression" ("Scala" "Block" (letrec* () (("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "TupleExpression" ("Scala" "Exprs" ((#\nul (>>-Macro ("Scala" "stringLiteral" "おはよう") ("Scala" "stringLiteral" "太郎")) #\nul))) #\nul) #\nul)))) #\nul) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "TupleExpression" ("Scala" "Exprs" ((#\nul (>>-Macro ("Scala" "stringLiteral" "いえーい")) #\nul))) #\nul) #\nul)))) #\nul) ("Scala" "PostfixExpression" ("Scala" "InfixExpression" (("Scala" "PrefixExpression" #\nul ("Scala" "SimpleExpression" ("Scala" "TupleExpression" ("Scala" "Exprs" ((#\nul (>>-Macro ("Scala" "stringLiteral" "hello!") ("Scala" "stringLiteral" "Bob")) #\nul))) #\nul) #\nul)))) #\nul)) #\nul)))))) #\nul))))) #\nul (#\nul #\nul))))))) #\nul)