
// Expressions
ArgumentExpression: exprs
Block: states, res
BlockStat: annotations, modifier, def
ClassTemplateOpt: extend, body
CompilationUnit: packages, topStatseq
Definition: dcl, sp, body
Exprs: contents
FunctionApplicationPostfix: argument, postfix
FunctionSignature: id, funtype, param
Identifier: name
idSeqSimpleExpression: ids, suffix
ImportExpr: id, selector
ImportStatement: exprs
InfixExpression: left, ops, rights
Keyword: word
literalSimpleExpression: literal, suffix
ObjectDefinition: id, classTemplate
ObjectTemplateDefinition: prefix, def
Param: annotations, id, paramtype, expr
Params: params
ParamClause: params
ParamClauses: clauses, params
PostfixExpression: infix, id
PrefixExpression: op, expr
Procedure: signature, block
SimpleExpression: expr, under
StableId: contents
stringLiteral: value
TemplateBody: selftype, states
TemplateStatement: annotation, modifier, definition
TopStat: annotation, modifier, def
TopStatSeq: topstat
Variable: name

