
// Expressions
AccessModifier: modifier, qual
AnnotType: simpleType, annotation
AnonymousFunction: left, right
AnonymousFunctionWild: right
ArgumentExpression: exprs
AssignmentExpression: prefix, id, right
Binding: id, tp
Bindings: bindings
Block: states, res
BlockExpression: block
BlockStat: annotations, modifier, def
booleanLiteral: value
Brace: elements
Bracket: elements
ByNameParamType: tp
ClassTemplateOpt: extend, body
CompilationUnit: packages, topStatseq
CompoundType: annotType, withType, ref
Definition: body
DesignatorPostfix: under, id, postfix
Exprs: contents
FunctionApplicationPostfix: argument, postfix
FunctionDefinition: signature, tp, expr
FunctionSignature: id, funtype, param
Identifier: name
idSeqSimpleExpression: ids, suffix
IfStatement: condition, ifStatement, elseStatement
ImportExpr: id, selector
ImportStatement: exprs
InfixExpression: left, ops, rights
InfixOperatorPattern: simplePattern, ids, simplePatterns
InfixType: compoundType, ids, compoundTypes
Keyword: word
literalSimpleExpression: literal, suffix
MacroForm: inputForm
ObjectDefinition: id, classTemplate
ObjectTemplateDefinition: prefix, def
Param: annotations, id, paramType, expr
Params: params
ParamClause: params
ParamClauses: clauses, params
Paren: elements
# PatDef: patterns, tp, expr
PatDef: patterns, expr
PatternBinder: id, pt
PatValDef: body
PatVarDef: body
PostfixExpression: infix, id
PrefixExpression: op, expr
Procedure: signature, block
PunctuationMark: value
RepeatedParamType: tp, star
SimpleExpression: expr, under
StableId: contents
stringLiteral: value
SimpleType: id, postfix
TemplateBody: selftype, states
TemplateStatement: annotation, modifier, definition
TopStat: annotation, modifier, def
TopStatSeq: topstat
TupleExpression: expr, suffix
Type: exClause, inType
TypeArgs: types
Types: contents

