SimpleExpr = NEW (ClassTemplate / TemplateBody)
/ BlockExpr
/ SimpleExpr1 UNDER?


SimpleExpr1 = OPPAREN Exprs? CLPAREN _SimpleExpr1
/* / SimpleExpr DOT id */
/ NEW (ClassTemplate / TemplateBody) DOT id _SimpleExpr1
/ BlockExpr DOT id _SimpleExpr1
/* / SimpleExpr1 UNDER DOT id */
/* / SimpleExpr TypeArgs */
/ NEW (ClassTemplate / TemplateBody) TypeArgs _SimpleExpr1
/ BlockExpr TypeArgs _SimpleExpr1
/* / SimpleExpr1 UNDER TypeArgs */
/* / SimpleExpr1 ArgumentExprs */
/ XmlExpr _SimpleExpr1
/ Path _SimpleExpr1
/ Literal _SimpleExpr1
/ UNDER _SimpleExpr1
_SimpleExpr1 = UNDER? DOT id _SimpleExpr1
/ UNDER? TypeArgs _SimpleExpr1
/ ArgumentExprs _SimpleExpr1
/ Empty




/* SimpleExpr ::= ‘new’ (ClassTemplate | TemplateBody) */
/* | BlockExpr */
/* | SimpleExpr1 [‘_’] */
SimpleExpr = NEW (ClassTemplate / TemplateBody) _SimpleExpr
/ BlockExpr _SimpleExpr
/ OPPAREN Exprs? CLPAREN UNDER? _SimpleExpr
/ SimpleExpr1 UNDER? _SimpleExpr
/ XmlExpr UNDER? _SimpleExpr
/ Literal UNDER? _SimpleExpr
/ Path UNDER? _SimpleExpr
/ UNDER UNDER? _SimpleExpr
_SimpleExpr = DOT id UNDER? _SimpleExpr
			/ TypeArgs UNDER? _SimpleExpr
			/ Empty

/* SimpleExpr1 ::= Literal */
/* | Path */
/* | ‘_’ */
/* | ‘(’ [Exprs] ‘)’ */
/* | SimpleExpr ‘.’ id */
/* | SimpleExpr TypeArgs */
/* | SimpleExpr1 ArgumentExprs */
/* | XmlExpr */
SimpleExpr1 = NEW (ClassTemplate / TemplateBody) _SimpleExpr DOT id
/ BlockExpr _SimpleExpr DOT id _SimpleExpr1

/ OPPAREN Exprs? CLPAREN UNDER? _SimpleExpr DOT id _SimpleExpr1
/ XmlExpr UNDER? _SimpleExpr DOT id _SimpleExpr1
/ Literal UNDER? _SimpleExpr DOT id _SimpleExpr1
/ Path UNDER? _SimpleExpr DOT id _SimpleExpr1
/ UNDER UNDER? _SimpleExpr DOT id _SimpleExpr1
/ NEW (ClassTemplate / TemplateBody) _SimpleExpr TypeArgs _SimpleExpr1
/ BlockExpr _SimpleExpr TypeArgs _SimpleExpr1
/ OPPAREN Exprs? CLPAREN UNDER? _SimpleExpr TypeArgs _SimpleExpr1
/ XmlExpr UNDER? _SimpleExpr TypeArgs _SimpleExpr1
/ Literal UNDER? _SimpleExpr TypeArgs _SimpleExpr1
/ Path UNDER? _SimpleExpr TypeArgs _SimpleExpr1
/ UNDER UNDER? _SimpleExpr TypeArgs _SimpleExpr1
/ XmlExpr _SimpleExpr1
/ Literal _SimpleExpr1
/ Path _SimpleExpr1
/ UNDER _SimpleExpr1
/ OPPAREN Exprs? CLPAREN _SimpleExpr1
_SimpleExpr1 = ArgumentExprs UNDER? _SimpleExpr DOT id _SimpleExpr1
/  ArgumentExprs UNDER? _SimpleExpr TypeArgs _SimpleExpr1
/  ArgumentExprs _SimpleExpr1
/ Empty


