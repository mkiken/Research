/*
   Scala Syntax in PEG form
   syntax from http://www.scala-lang.org/docu/files/ScalaReference.pdf
   latest update : 2013/10/22
 */

/*
Chapter A
Scala Syntax Summary
The lexical syntax of Scala is given by the following grammar in EBNF form.
 */


/* upper ::= ‘A’ | ... | ‘Z’ | ‘$’ | ‘_’ and Unicode category Lu */
upper = [A-Z] / '$' / '_'

/* lower ::= ‘a’ | ... | ‘z’ and Unicode category Ll */
lower = [a-z]

/* letter ::= upper | lower and Unicode categories Lo, Lt, Nl */
letter = upper / lower

/* digit ::= ‘0’ | ... | ‘9’ */
digit = [0-9]

/* opchar ::= “all other characters in \u0020-007F and Unicode categories Sm, So except parentheses ([]) and periods” */
opchar = [^\u0020-\u007F]

/* op ::= opchar {opchar} */
op = opchar+

/* varid ::= lower idrest */
varid = lower idrest

/* plainid ::= upper idrest
| varid
| op */
plainid = upper idrest
		/ varid
		/ op

/* id ::= plainid */
/* | ‘\‘’ stringLit ‘\‘’ */
id	= plainid
	/ [`] stringLiteral [`]

/* idrest ::= {letter | digit} [‘_’ op] */
idrest = (letter / digit)* ('_' op)?

/* integerLiteral ::= (decimalNumeral | hexNumeral | octalNumeral) [‘L’ | ‘l’] */
integerLiteral = (decimalNumeral / hexNumeral / octalNumeral) ('L' / 'l')?

/* decimalNumeral ::= ‘0’ | nonZeroDigit {digit} */
decimalNumeral = '0' / nonZeroDigit digit*

/* hexNumeral ::= ‘0’ ‘x’ hexDigit {hexDigit} */
hexNumeral = '0' 'x' hexDigit+

/* octalNumeral ::= ‘0’ octalDigit {octalDigit} */
octalNumeral = '0' octalDigit+

/* digit ::= ‘0’ | nonZeroDigit */
digit = '0' / nonZeroDigit

/* nonZeroDigit ::= ‘1’ | ... | ‘9’ */
nonZeroDigit = [1-9]

/* octalDigit ::= ‘0’ | ... | ‘7’ */
octalDigit = [0-7]

/* floatingPointLiteral */
/* ::= digit {digit} ‘.’ {digit} [exponentPart] [floatType] */
/* | ‘.’ digit {digit} [exponentPart] [floatType] */
/* | digit {digit} exponentPart [floatType] */
/* | digit {digit} [exponentPart] floatType */
floatingPointLiteral
	= digit+ '.' digit* exponentPart? floatType?
	/ '.' digit+  exponentPart? floatType?
	/ digit+ exponentPart floatType?
	/ digit+ exponentPart? floatType

/* exponentPart ::= (‘E’ | ‘e’) [‘+’ | ‘-’] digit {digit} */
exponentPart = ('E' / 'e') ('+' / '-')? digit+

/* floatType ::= ‘F’ | ‘f’ | ‘D’ | ‘d’*/
floatType = 'F' / 'f' / 'D' / 'd'

/* booleanLiteral ::= ‘true’ | ‘false’ */
booleanLiteral = 'true' / 'false'

/* characterLiteral ::= ‘\’’ printableChar ‘\’’ */
/* | ‘\’’ charEscapeSeq ‘\’’ */
characterLiteral	= ['] printableChar [']
					/ ['] charEscapeSeq [']

/* stringLiteral ::= ‘"’ {stringElement} ‘"’ */
/* | ‘"""’ multiLineChars ‘"""’ */
stringLiteral	= '"' stringElement* '"'
				/ '"""' multiLineChars '"""'

/* stringElement ::= printableCharNoDoubleQuote */
/* | charEscapeSeq */
stringElement	= printableCharNoDoubleQuote
				/ charEscapeSeq

/* multiLineChars ::= {[‘"’] [‘"’] charNoDoubleQuote} {‘"’} */
multiLineChars = ('"'? '"'? charNoDoubleQuote)* '"'*

/* symbolLiteral ::= ‘’’ plainid */
symbolLiteral = "'" plainid

// comment ::= ‘/*’ “any sequence of characters” ‘*/’ */
/* | ‘//’ “any sequence of characters up to end of line” */
comment	= [/][*] (!"*/" . )* [*][/]
		/ '//' (!'\n' . )* '\n'

/* nl ::= “new line character” */
//とりあえずJavaScriptと同じ改行にしておく
nl = "\r\n" / "\n" / "\r"

/* semi ::= ‘;’ | nl {nl} */
semi = ';' / nl+



/* The context-free syntax of Scala is given by the following EBNF grammar. */

/* Literal ::= [‘-’] integerLiteral */
/* | [‘-’] floatingPointLiteral */
/* | booleanLiteral */
/* | characterLiteral */
/* | stringLiteral */
/* | symbolLiteral */
/* | ‘null’ */
Literal = '-'? integerLiteral
/ '-'? floatingPointLiteral
/ booleanLiteral
/ characterLiteral
/ stringLiteral
/ symbolLiteral
/ 'null'

/* QualId ::= id {‘.’ id} */
QualId = id ('.' id)*

/* ids ::= id {‘,’ id} */
ids = id (',' id)*

/* Path ::= StableId */
/* | [id ‘.’] ‘this’ */
Path	= StableId
		/ (id '.')? 'this'

/* StableId ::= id */
/* | Path ‘.’ id */
/* | [id ’.’] ‘super’ [ClassQualifier] ‘.’ id */
StableId	= id
			/ Path '.' id
			/ (id '.')? 'super' ClassQualifier? '.' id

/* ClassQualifier ::= ‘[’ id ‘]’ */
ClassQualifier = '[' id ']'

/* Type ::= FunctionArgTypes ‘=>’ Type */
/* | InfixType [ExistentialClause] */
Type	= FunctionArgTypes '=>' Type
		/ InfixType ExistentialClause?

/* FunctionArgTypes ::= InfixType */
/* | ‘(’ [ ParamType {‘,’ ParamType } ] ‘)’ */
FunctionArgTypes	= InfixType
					/ '(' ( ParamType (',' ParamType )* )? ')'

/* ExistentialClause ::= ‘forSome’ ‘{’ ExistentialDcl {semi ExistentialDcl} ‘}’ */
ExistentialClause = 'forSome' '{' ExistentialDcl (semi ExistentialDcl)* '}'

/* ExistentialDcl ::= ‘type’ TypeDcl */
/* | ‘val’ ValDcl */
ExistentialDcl	= 'type' TypeDcl
				/ 'val' ValDcl

/* InfixType ::= CompoundType {id [nl] CompoundType} */
InfixType = CompoundType (id nl? CompoundType)*

/* CompoundType ::= AnnotType {‘with’ AnnotType} [Refinement] */
/* | Refinement */
CompoundType	= AnnotType ('with' AnnotType)? Refinement?
				/ Refinement

/* AnnotType ::= SimpleType {Annotation} */
AnnotType = SimpleType Annotation*

/* SimpleType ::= SimpleType TypeArgs */
/* | SimpleType ‘#’ id */
/* | StableId */
/* | Path ‘.’ ‘type’ */
/* | ‘(’ Types ’)’ */
SimpleType = SimpleType TypeArgs
/ SimpleType '#' id
/ StableId
/ Path '.' 'type'
/ '(' Types ')'

/* TypeArgs ::= ‘[’ Types ‘]’ */
TypeArgs = '[' Types ']'

/* Types ::= Type {‘,’ Type} */
Types = Type (',' Type)*

/* Refinement ::= [nl] ‘{’ RefineStat {semi RefineStat} ‘}’ */
Refinement = nl? '{' RefineStat (semi RefineStat)* '}'

/* RefineStat ::= Dcl */
/* | ‘type’ TypeDef */
/* | */
RefineStat = Dcl
/ 'type' TypeDef
/ Empty

/* TypePat ::= Type */
TypePat = Type

/* Ascription ::= ‘:’ InfixType */
/* | ‘:’ Annotation {Annotation} */
/* | ‘:’ ‘_’ ‘*’ */
Ascription = ':' InfixType
/ ':' Annotation+
/ ":_*"

/* Expr ::= (Bindings | [‘implicit’] id | ‘_’) ‘=>’ Expr */
/* | Expr1 */
Expr = (Bindings / 'implicit'? id / '_') '=>' Expr
/ Expr1

/* Expr1 ::= ‘if’ ‘(’ Expr ‘)’ {nl} Expr [[semi] else Expr] */
/* | ‘while’ ‘(’ Expr ‘)’ {nl} Expr */
/* | ‘try’ ‘{’ Block ‘}’ [‘catch’ ‘{’ CaseClauses ‘}’] */
/* [‘finally’ Expr] */
/* | ‘do’ Expr [semi] ‘while’ ‘(’ Expr ’)’ */
/* | ‘for’ (‘(’ Enumerators ‘)’ | ‘{’ Enumerators ‘}’) */
/* {nl} [‘yield’] Expr */
/* | ‘throw’ Expr */
/* | ‘return’ [Expr] */
/* | [SimpleExpr ‘.’] id ‘=’ Expr */
/* | SimpleExpr1 ArgumentExprs ‘=’ Expr */
/* | PostfixExpr */
/* | PostfixExpr Ascription */
/* | PostfixExpr ‘match’ ‘{’ CaseClauses ‘}’ */
Expr1 = 'if' '(' Expr ')' nl* Expr (semi? "else" Expr)?
/ 'while' '(' Expr ')' nl* Expr
/ 'try' '{' Block '}' ('catch' '{' CaseClauses '}')? ('finally' Expr)?
/ 'do' Expr semi? 'while' '(' Expr ')'
/ 'for' ('(' Enumerators ')' / '{' Enumerators '}') nl* 'yield'? Expr
/ 'throw' Expr
/ 'return' Expr?
/ (SimpleExpr '.')? id '=' Expr
/ SimpleExpr1 ArgumentExprs '=' Expr
/ PostfixExpr
/ PostfixExpr Ascription
/ PostfixExpr 'match' '{' CaseClauses '}'

/* PostfixExpr ::= InfixExpr [id [nl]] */
PostfixExpr = InfixExpr (id nl?)?

/* InfixExpr ::= PrefixExpr */
/* | InfixExpr id [nl] InfixExpr */
InfixExpr = PrefixExpr
/ InfixExpr id nl? InfixExpr

/* PrefixExpr ::= [‘-’ | ‘+’ | ‘~’ | ‘!’] SimpleExpr */
PrefixExpr = ('-' / '+' / '~' / '!')? SimpleExpr

/* SimpleExpr ::= ‘new’ (ClassTemplate | TemplateBody) */
/* | BlockExpr */
/* | SimpleExpr1 [‘_’] */
SimpleExpr = 'new' (ClassTemplate / TemplateBody)
/ BlockExpr
/ SimpleExpr1 '_'?

/* SimpleExpr1 ::= Literal */
/* | Path */
/* | ‘_’ */
/* | ‘(’ [Exprs] ‘)’ */
/* | SimpleExpr ‘.’ id */
/* | SimpleExpr TypeArgs */
/* | SimpleExpr1 ArgumentExprs */
/* | XmlExpr */
SimpleExpr1 = Literal
/ Path
/ '_'
/ '(' Exprs? ')'
/ SimpleExpr '.' id
/ SimpleExpr TypeArgs
/ SimpleExpr1 ArgumentExprs
/ XmlExpr

/* Exprs ::= Expr {‘,’ Expr} */
Exprs = Expr (',' Expr)*

/* ArgumentExprs ::= ‘(’ [Exprs] ‘)’ */
/* | ‘(’ [Exprs ‘,’] PostfixExpr ‘:’ ‘_’ ‘*’ ’)’ */
/* | [nl] BlockExpr */
ArgumentExprs = '(' Exprs? ')'
/ '(' (Exprs ',')? PostfixExpr ":_*)"
/ nl? BlockExpr

/* BlockExpr ::= ‘{’ CaseClauses ‘}’ */
/* | ‘{’ Block ‘}’ */
BlockExpr = '{' CaseClauses '}'
/ '{' Block '}'

/* Block ::= {BlockStat semi} [ResultExpr] */
Block = (BlockStat semi)* ResultExpr?

/* BlockStat ::= Import */
/* | {Annotation} [‘implicit’ | ‘lazy’] Def */
/* | {Annotation} {LocalModifier} TmplDef */
/* | Expr1 */
/* | */
BlockStat = Import
/ Annotation* ('implicit' / 'lazy')? Def
/ Annotation* LocalModifier* TmplDef
/ Expr1
/ Empty

/* ResultExpr ::= Expr1 */
/* | (Bindings | ([‘implicit’] id | ‘_’) ‘:’ CompoundType) ‘=>’ Block */
ResultExpr = Expr1
/ (Bindings / ('implicit'? id / '_') ':' CompoundType) '=>' Block

/* Enumerators ::= Generator {semi Enumerator} */
Enumerators = Generator (semi Enumerator)*

/* Enumerator ::= Generator */
/* | Guard */
/* | ‘val’ Pattern1 ‘=’ Expr */
Enumerator = Generator
/ Guard
/ 'val' Pattern1 '=' Expr

/* Generator ::= Pattern1 ‘<-’ Expr [Guard] */
Generator = Pattern1 '<-' Expr Guard?

/* CaseClauses ::= CaseClause { CaseClause } */
CaseClauses = CaseClause+

/* CaseClause ::= ‘case’ Pattern [Guard] ‘=>’ Block */
CaseClause = 'case' Pattern Guard? '=>' Block

/* Guard ::= ‘if’ PostfixExpr */
Guard = 'if' PostfixExpr

/* Pattern ::= Pattern1 { ‘|’ Pattern1 } */
Pattern = Pattern1 ( '/' Pattern1 )*

/* Pattern1 ::= varid ‘:’ TypePat */
/* | ‘_’ ‘:’ TypePat */
/* | Pattern2 */
Pattern1 = varid ':' TypePat
/ '_' ':' TypePat
/ Pattern2

/* Pattern2 ::= varid [‘@’ Pattern3] */
/* | Pattern3 */
Pattern2 = varid ('@' Pattern3)?
/ Pattern3

/* Pattern3 ::= SimplePattern */
/* | SimplePattern { id [nl] SimplePattern } */
Pattern3 = SimplePattern
/ SimplePattern ( id nl? SimplePattern )*

/* SimplePattern ::= ‘_’ */
/* | varid */
/* | Literal */
/* | StableId */
/* | StableId ‘(’ [Patterns ‘)’ */
/* | StableId ‘(’ [Patterns ‘,’] [varid ‘@’] ‘_’ ‘*’ ‘)’ */
/* | ‘(’ [Patterns] ‘)’ */
/* | XmlPattern */
SimplePattern = '_'
/ varid
/ Literal
/ StableId
/ StableId '(' Patterns? ')'
/ StableId '(' (Patterns ',')? (varid '@')? "_*)"
/ '(' Patterns? ')'
/ XmlPattern

/* Patterns ::= Pattern [‘,’ Patterns] */
/* | ‘_’ * */
Patterns = Pattern (',' Patterns)?
/ '_' *

/* TypeParamClause ::= ‘[’ VariantTypeParam {‘,’ VariantTypeParam} ‘]’ */
TypeParamClause = '[' VariantTypeParam (',' VariantTypeParam)* ']'

/* FunTypeParamClause::= ‘[’ TypeParam {‘,’ TypeParam} ‘]’ */
FunTypeParamClause = '[' TypeParam (',' TypeParam)* ']'

/* VariantTypeParam ::= {Annotation} [‘+’ | ‘-’] TypeParam */
VariantTypeParam = Annotation* ('+' / '-')? TypeParam

/* TypeParam ::= (id | ‘_’) [TypeParamClause] [‘>:’ Type] [‘<:’ Type]*/
/* {‘<%’ Type} {‘:’ Type} */
TypeParam = (id / '_') TypeParamClause? ('>:' Type)? ('<:' Type)?
('<%' Type)* (':' Type)*

/* ParamClauses ::= {ParamClause} [[nl] ‘(’ ‘implicit’ Params ‘)’] */
ParamClauses = ParamClause* (nl? '(' 'implicit' Params ')')?

/* ParamClause ::= [nl] ‘(’ [Params] ’)’ */
ParamClause = nl? '(' Params? ')'

/* Params ::= Param {‘,’ Param} */
Params = Param (',' Param)*

/* Param ::= {Annotation} id [‘:’ ParamType] [‘=’ Expr] */
Param = Annotation* id (':' ParamType)? ('=' Expr)?

/* ParamType ::= Type */
/* | ‘=>’ Type */
/* | Type ‘*’ */
ParamType = Type
/ '=>' Type
/ Type '*'

/* ClassParamClauses ::= {ClassParamClause} */
/* [[nl] ‘(’ ‘implicit’ ClassParams ‘)’] */
ClassParamClauses = ClassParamClause* (nl? '(' 'implicit' ClassParams ')')?

/* ClassParamClause ::= [nl] ‘(’ [ClassParams] ’)’ */
ClassParamClause = nl? '(' ClassParams? ')'

/* ClassParams ::= ClassParam {‘’ ClassParam} */
ClassParams = ClassParam ('' ClassParam)*

/* ClassParam ::= {Annotation} [{Modifier} (‘val’ | ‘var’)] */
/* id ‘:’ ParamType [‘=’ Expr] */
ClassParam = Annotation* (Modifier* ('val' / 'var'))? id ':' ParamType ('=' Expr)?

/* Bindings ::= ‘(’ Binding {‘,’ Binding ‘)’ */
//多分'(' Binding (',' Binding ')')*ってこと？？
Bindings = '(' Binding (',' Binding ')')*

/* Binding ::= (id | ‘_’) [‘:’ Type] */
Binding = (id / '_') (':' Type)?

/* Modifier ::= LocalModifier */
/* | AccessModifier */
/* | ‘override’ */
Modifier = LocalModifier
/ AccessModifier
/ 'override'

/* LocalModifier ::= ‘abstract’ */
/* | ‘final’ */
/* | ‘sealed’ */
/* | ‘implicit’ */
/* | ‘lazy’ */
LocalModifier = 'abstract'
/ 'final'
/ 'sealed'
/ 'implicit'
/ 'lazy'

/* AccessModifier ::= (‘private’ | ‘protected’) [AccessQualifier] */
AccessModifier = ('private' / 'protected') AccessQualifier?

/* AccessQualifier ::= ‘[’ (id | ‘this’) ‘]’ */
AccessQualifier = '[' (id / 'this') ']'

/* Annotation ::= ‘@’ SimpleType {ArgumentExprs} */
Annotation = '@' SimpleType ArgumentExprs*

/* ConstrAnnotation ::= ‘@’ SimpleType ArgumentExprs */
ConstrAnnotation = '@' SimpleType ArgumentExprs

/* NameValuePair ::= ‘val’ id ‘=’ PrefixExpr */
NameValuePair = 'val' id '=' PrefixExpr

/* TemplateBody ::= [nl] ‘{’ [SelfType] TemplateStat {semi TemplateStat} ‘}’ */
TemplateBody = nl? '{' SelfType? TemplateStat (semi TemplateStat)* '}'

/* TemplateStat ::= Import */
/* | {Annotation [nl]} {Modifier} Def */
/* | {Annotation [nl]} {Modifier} Dcl */
/* | Expr */
/* | */
TemplateStat = Import
/ (Annotation nl?)* Modifier* Def
/ (Annotation nl?)* Modifier* Dcl
/ Expr
/ Empty

/* SelfType ::= id [‘:’ Type] ‘=>’ */
/* | ‘this’ ‘:’ Type ‘=>’ */
SelfType = id (':' Type)? '=>'
/ 'this' ':' Type '=>'

/* Import ::= ‘import’ ImportExpr {‘,’ ImportExpr} */
Import = 'import' ImportExpr (',' ImportExpr)*

/* ImportExpr ::= StableId ‘.’ (id | ‘_’ | ImportSelectors) */
ImportExpr = StableId '.' (id / '_' / ImportSelectors)

/* ImportSelectors ::= ‘{’ {ImportSelector ‘,’} (ImportSelector | ‘_’) ‘}’ */
ImportSelectors = '{' (ImportSelector ',')* (ImportSelector / '_') '}'

/* ImportSelector ::= id [‘=>’ id | ‘=>’ ‘_’] */
ImportSelector = id ('=>' id / '=>' '_')?

/* Dcl ::= ‘val’ ValDcl */
/* | ‘var’ VarDcl */
/* | ‘def’ FunDcl */
/* | ‘type’ {nl} TypeDcl */
Dcl = 'val' ValDcl
/ 'var' VarDcl
/ 'def' FunDcl
/ 'type' nl* TypeDcl

/* ValDcl ::= ids ‘:’ Type */
ValDcl = ids ':' Type

/* VarDcl ::= ids ‘:’ Type */
VarDcl = ids ':' Type

/* FunDcl ::= FunSig [‘:’ Type] */
FunDcl = FunSig (':' Type)?

/* FunSig ::= id [FunTypeParamClause] ParamClauses */
FunSig = id FunTypeParamClause? ParamClauses

/* TypeDcl ::= id [TypeParamClause] [‘>:’ Type] [‘<:’ Type] */
TypeDcl = id TypeParamClause? ('>:' Type)? ('<:' Type)?

/* PatVarDef ::= ‘val’ PatDef */
/* | ‘var’ VarDef */
PatVarDef = 'val' PatDef
/ 'var' VarDef

/* Def ::= PatVarDef */
/* | ‘def’ FunDef */
/* | ‘type’ {nl} TypeDef */
/* | TmplDef */
Def = PatVarDef
/ 'def' FunDef
/ 'type' nl* TypeDef
/ TmplDef

/* PatDef ::= Pattern2 {‘,’ Pattern2} [‘:’ Type] ‘=’ Expr */
PatDef = Pattern2 (',' Pattern2)* (':' Type)? '=' Expr

/* VarDef ::= PatDef */
/* | ids ‘:’ Type ‘=’ ‘_’ */
VarDef = PatDef
/ ids ':' Type '=' '_'

/* FunDef ::= FunSig [‘:’ Type] ‘=’ Expr */
/* | FunSig [nl] ‘{’ Block ‘}’ */
/* | ‘this’ ParamClause ParamClauses */
/* (‘=’ ConstrExpr | [nl] ConstrBlock) */
FunDef = FunSig (':' Type)? '=' Expr
/ FunSig nl? '{' Block '}'
/ 'this' ParamClause ParamClauses ('=' ConstrExpr / nl? ConstrBlock)

/* TypeDef ::= id [TypeParamClause] ‘=’ Type */
TypeDef = id TypeParamClause? '=' Type

/* TmplDef ::= [‘case’] ‘class’ ClassDef */
/* | [‘case’] ‘object’ ObjectDef */
/* | ‘trait’ TraitDef */
TmplDef = 'case'? 'class' ClassDef
/ 'case'? 'object' ObjectDef
/ 'trait' TraitDef

/* ClassDef ::= id [TypeParamClause] {ConstrAnnotation} [AccessModifier] */
/* ClassParamClauses ClassTemplateOpt */
ClassDef = id TypeParamClause? ConstrAnnotation* AccessModifier? ClassParamClauses ClassTemplateOpt

/* TraitDef ::= id [TypeParamClause] TraitTemplateOpt */
TraitDef = id TypeParamClause? TraitTemplateOpt

/* ObjectDef ::= id ClassTemplateOpt */
ObjectDef = id ClassTemplateOpt

/* ClassTemplateOpt ::= ‘extends’ ClassTemplate | [[‘extends’] TemplateBody] */
ClassTemplateOpt = 'extends' ClassTemplate / ('extends'? TemplateBody)?

/* TraitTemplateOpt ::= ‘extends’ TraitTemplate | [[‘extends’] TemplateBody] */
TraitTemplateOpt = 'extends' TraitTemplate / ('extends'? TemplateBody)?

/* ClassTemplate ::= [EarlyDefs] ClassParents [TemplateBody] */
ClassTemplate = EarlyDefs? ClassParents TemplateBody?

/* TraitTemplate ::= [EarlyDefs] TraitParents [TemplateBody] */
TraitTemplate = EarlyDefs? TraitParents TemplateBody?

/* ClassParents ::= Constr {‘with’ AnnotType} */
ClassParents = Constr ('with' AnnotType)*

/* TraitParents ::= AnnotType {‘with’ AnnotType} */
TraitParents = AnnotType ('with' AnnotType)*

/* Constr ::= AnnotType {ArgumentExprs} */
Constr = AnnotType ArgumentExprs*

/* EarlyDefs ::= ‘{’ [EarlyDef {semi EarlyDef}] ‘}’ ‘with’ */
EarlyDefs = '{' (EarlyDef (semi EarlyDef)*)? '}' 'with'

/* EarlyDef ::= {Annotation [nl]} {Modifier} PatVarDef */
EarlyDef = (Annotation nl?)* Modifier* PatVarDef

/* ConstrExpr ::= SelfInvocation */
/* | ConstrBlock */
ConstrExpr = SelfInvocation
/ ConstrBlock

/* ConstrBlock ::= ‘{’ SelfInvocation {semi BlockStat} ‘}’ */
ConstrBlock = '{' SelfInvocation (semi BlockStat)* '}'

/* SelfInvocation ::= ‘this’ ArgumentExprs {ArgumentExprs} */
SelfInvocation = 'this' ArgumentExprs+

/* TopStatSeq ::= TopStat {semi TopStat} */
TopStatSeq = TopStat (semi TopStat)*

/* TopStat ::= {Annotation [nl]} {Modifier} TmplDef */
/* | Import */
/* | Packaging */
/* | PackageObject */
/* | */
TopStat = (Annotation nl?)* Modifier* TmplDef
/ Import
/ Packaging
/ PackageObject
/ Empty
/* Packaging ::= ‘package’ QualId [nl] ‘{’ TopStatSeq ‘}’ */
Packaging = 'package' QualId nl? '{' TopStatSeq '}'

/* PackageObject ::= ‘package’ ‘object’ ObjectDef */
PackageObject = 'package' 'object' ObjectDef

/* CompilationUnit ::= {‘package’ QualId semi} TopStatSeq */
CompilationUnit = ('package' QualId semi)* TopStatSeq



//ここからオリジナル定義
/*
1.3.6 Escape Sequences
The following escape sequences are recognized in character and string literals.
\b \u0008: backspace BS
\t \u0009: horizontal tab HT
\n \u000a: linefeed LF
\f \u000c: formfeed FF
\r \u000d: carriage return CR
\" \u0022: double quote "
\’ \u0027: single quote ’
\\ \u005c: backslash \
 */

charEscapeSeq	= '\\b' / '\\u0008'
				/ '\\t' / '\\u0009'
				/ '\\n' / '\\u000a'
				/ '\\f' / '\\u000c'
				/ '\\r' / '\\u000d'
				/ '\\"' / '\\u0022'
				/ "\\'" / '\\u0027'
				/ '\\' / '\\u005c'

hexDigit = [0-9A-Fa-f]

//とりあえずエスケープシーケンスじゃなければなんでもOK
printableChar = !charEscapeSeq .

printableCharNoDoubleQuote = !'"' printableChar

charNoDoubleQuote = !'"' .

Empty = & {return true;}

/*
   10.1 XML expressions
Syntax:

XmlExpr ::= XmlContent {Element}
Element ::= EmptyElemTag
| STag Content ETag
EmptyElemTag ::= ‘<’ Name {S Attribute} [S] ‘/>’
STag ::= ‘<’ Name {S Attribute} [S] ‘>’
ETag ::= ‘</’ Name [S] ’>’
Content ::= [CharData] {Content1 [CharData]}
Content1 ::= XmlContent
| Reference
| ScalaExpr
XmlContent ::= Element
| CDSect
| PI
| Comment
Attribute ::= Name Eq AttValue
AttValue ::= ‘"’ {CharQ | CharRef} ‘"’
| ‘’’ {CharA | CharRef} ‘’’
| ScalaExpr
ScalaExpr ::= Block
CharData ::= { CharNoRef } without {CharNoRef}‘{’CharB {CharNoRef}
and without {CharNoRef}‘]]>’{CharNoRef}
BaseChar, Char, Comment, CombiningChar, Ideographic, NameChar, S, Reference
::= “as in W3C XML”
Char1 ::= Char without ‘<’ | ‘&’
CharQ ::= Char1 without ‘"’
CharA ::= Char1 without ‘’’
CharB ::= Char1 without ’{’
Name ::= XNameStart {NameChar}
XNameStart ::= ‘_’ | BaseChar | Ideographic
(as in W3C XML, but without ‘:’

   10.2 XML patterns
Syntax:

XmlPattern ::= ElementPattern
ElemPattern ::= EmptyElemTagP
| STagP ContentP ETagP
EmptyElemTagP ::= ‘<’ Name [S] ‘/>’
STagP ::= ‘<’ Name [S] ‘>’
ETagP ::= ‘</’ Name [S]‘>’
ContentP ::= [CharData] {(ElemPattern|ScalaPatterns) [CharData]}
ContentP1 ::= ElemPattern
| Reference
| CDSect
| PI
| Comment
| ScalaPatterns
ScalaPatterns ::= ‘{’ Patterns ‘}’
 */

XmlExpr = XmlContent Element*
Element	= EmptyElemTag
		/ STag Content ETag
EmptyElemTag = '<' Name (S Attribute)* S? '/>'
STag = '<' Name (S Attribute)* S? '>'
ETag = '</' Name S? '>'
Content = CharData? (Content1 CharData?)*
Content1	= XmlContent
			/ Reference
			/ ScalaExpr
XmlContent	= Element
			/ CDSect
			/ PI
			/ Comment
Attribute = Name Eq AttValue
AttValue	= '"' (CharQ / CharRef)* '"'
			/ "'" (CharA / CharRef)* "'"
			/ ScalaExpr
ScalaExpr = Block
CharData = !(CharNoRef* '{' CharB CharNoRef*) !(CharNoRef* ']]>' CharNoRef*) CharNoRef*
Char1 = !('<' / '&') Char
CharQ = !'"' Char1
CharA = !"'" Char1
CharB = !'{' Char1
Name = XNameStart NameChar*
// (as in W3C XML, but without ':'
XNameStart = !':' ('_' / BaseChar / Ideographic)

/*BaseChar, Char, Comment, CombiningChar, Ideographic, NameChar, S, Reference
= “as in W3C XML
http://www.w3.org/TR/xml/
 */

// http://www.w3.org/TR/xml/#NT-Char
/* any Unicode character, excluding the surrogate blocks, FFFE, and FFFF. */
Char = '\u0009' / '\u000A' / '\u000D' / [\u0020-\uD7FF] / [\uE000-\uFFFD] / [\u10000-\u10FFFF]

// http://www.w3.org/TR/xml/#dt-comment
// Comment	   ::=   	'<!--' ((Char - '-') | ('-' (Char - '-')))* '-->'
Comment	= '<!--' ((!'-' Char) / ('-' (!'-' Char)))* '-->'

// http://www.w3.org/TR/xml/#NT-Eq
Eq = S? '=' S?

// not used
// CombiningChar = [\u0300-\u0345] / [\u0360-\u0361] / [\u0483-\u0486] / [\u0591-\u05A1] / [\u05A3-\u05B9] / [\u05BB-\u05BD] / '\u05BF' / [\u05C1-\u05C2] / '\u05C4' / [\u064B-\u0652] / '\u0670' / [\u06D6-\u06DC] / [\u06DD-\u06DF] / [\u06E0-\u06E4] / [\u06E7-\u06E8] / [\u06EA-\u06ED] / [\u0901-\u0903] / '\u093C' / [\u093E-\u094C] / '\u094D' / [\u0951-\u0954] / [\u0962-\u0963] / [\u0981-\u0983] / '\u09BC' / '\u09BE' / '\u09BF' / [\u09C0-\u09C4] / [\u09C7-\u09C8] / [\u09CB-\u09CD] / '\u09D7' / [\u09E2-\u09E3] / '\u0A02' / '\u0A3C' / '\u0A3E' / '\u0A3F' / [\u0A40-\u0A42] / [\u0A47-\u0A48] / [\u0A4B-\u0A4D] / [\u0A70-\u0A71] / [\u0A81-\u0A83] / '\u0ABC' / [\u0ABE-\u0AC5] / [\u0AC7-\u0AC9] / [\u0ACB-\u0ACD] / [\u0B01-\u0B03] / '\u0B3C' / [\u0B3E-\u0B43] / [\u0B47-\u0B48] / [\u0B4B-\u0B4D] / [\u0B56-\u0B57] / [\u0B82-\u0B83] / [\u0BBE-\u0BC2] / [\u0BC6-\u0BC8] / [\u0BCA-\u0BCD] / '\u0BD7' / [\u0C01-\u0C03] / [\u0C3E-\u0C44] / [\u0C46-\u0C48] / [\u0C4A-\u0C4D] / [\u0C55-\u0C56] / [\u0C82-\u0C83] / [\u0CBE-\u0CC4] / [\u0CC6-\u0CC8] / [\u0CCA-\u0CCD] / [\u0CD5-\u0CD6] / [\u0D02-\u0D03] / [\u0D3E-\u0D43] / [\u0D46-\u0D48] / [\u0D4A-\u0D4D] / '\u0D57' / '\u0E31' / [\u0E34-\u0E3A] / [\u0E47-\u0E4E] / '\u0EB1' / [\u0EB4-\u0EB9] / [\u0EBB-\u0EBC] / [\u0EC8-\u0ECD] / [\u0F18-\u0F19] / '\u0F35' / '\u0F37' / '\u0F39' / '\u0F3E' / '\u0F3F' / [\u0F71-\u0F84] / [\u0F86-\u0F8B] / [\u0F90-\u0F95] / '\u0F97' / [\u0F99-\u0FAD] / [\u0FB1-\u0FB7] / '\u0FB9' / [\u20D0-\u20DC] / '\u20E1' / [\u302A-\u302F] / '\u3099' / '\u309A'

// http://www.w3.org/TR/xml/#NT-Ideographic
Ideographic	= [\u4E00-\u9FA5] / '\u3007' / [\u3021-\u3029]

NameChar = NameStartChar / "-" / "." / [0-9] / '\u00B7' / [\u0300-\u036F] / [\u203F-\u2040]
NameStartChar = ":" / [A-Z] / "_" / [a-z] / [\u00C0-\u00D6] / [\u00D8-\u00F6] / [\u00F8-\u02FF] / [\u0370-\u037D] / [\u037F-\u1FFF] / [\u200C-\u200D] / [\u2070-\u218F] / [\u2C00-\u2FEF] / [\u3001-\uD7FF] / [\uF900-\uFDCF] / [\uFDF0-\uFFFD] / [\u10000-\uEFFFF]

// http://www.w3.org/TR/xml/#NT-Reference
Reference = EntityRef / CharRef
EntityRef = '&' Name ';'
CharRef	= '&#' [0-9]+ ';'
		/ '&#x' [0-9a-fA-F]+ ';'

// http://www.w3.org/TR/xml/#NT-BaseChar
BaseChar = [\u0041-\u005A] / [\u0061-\u007A] / [\u00C0-\u00D6] / [\u00D8-\u00F6] / [\u00F8-\u00FF] / [\u0100-\u0131] / [\u0134-\u013E] / [\u0141-\u0148] / [\u014A-\u017E] / [\u0180-\u01C3] / [\u01CD-\u01F0] / [\u01F4-\u01F5] / [\u01FA-\u0217] / [\u0250-\u02A8] / [\u02BB-\u02C1] / '\u0386' / [\u0388-\u038A] / '\u038C' / [\u038E-\u03A1] / [\u03A3-\u03CE] / [\u03D0-\u03D6] / '\u03DA' / '\u03DC' / '\u03DE' / '\u03E0' / [\u03E2-\u03F3] / [\u0401-\u040C] / [\u040E-\u044F] / [\u0451-\u045C] / [\u045E-\u0481] / [\u0490-\u04C4] / [\u04C7-\u04C8] / [\u04CB-\u04CC] / [\u04D0-\u04EB] / [\u04EE-\u04F5] / [\u04F8-\u04F9] / [\u0531-\u0556] / '\u0559' / [\u0561-\u0586] / [\u05D0-\u05EA] / [\u05F0-\u05F2] / [\u0621-\u063A] / [\u0641-\u064A] / [\u0671-\u06B7] / [\u06BA-\u06BE] / [\u06C0-\u06CE] / [\u06D0-\u06D3] / '\u06D5' / [\u06E5-\u06E6] / [\u0905-\u0939] / '\u093D' / [\u0958-\u0961] / [\u0985-\u098C] / [\u098F-\u0990] / [\u0993-\u09A8] / [\u09AA-\u09B0] / '\u09B2' / [\u09B6-\u09B9] / [\u09DC-\u09DD] / [\u09DF-\u09E1] / [\u09F0-\u09F1] / [\u0A05-\u0A0A] / [\u0A0F-\u0A10] / [\u0A13-\u0A28] / [\u0A2A-\u0A30] / [\u0A32-\u0A33] / [\u0A35-\u0A36] / [\u0A38-\u0A39] / [\u0A59-\u0A5C] / '\u0A5E' / [\u0A72-\u0A74] / [\u0A85-\u0A8B] / '\u0A8D' / [\u0A8F-\u0A91] / [\u0A93-\u0AA8] / [\u0AAA-\u0AB0] / [\u0AB2-\u0AB3] / [\u0AB5-\u0AB9] / '\u0ABD' / '\u0AE0' / [\u0B05-\u0B0C] / [\u0B0F-\u0B10] / [\u0B13-\u0B28] / [\u0B2A-\u0B30] / [\u0B32-\u0B33] / [\u0B36-\u0B39] / '\u0B3D' / [\u0B5C-\u0B5D] / [\u0B5F-\u0B61] / [\u0B85-\u0B8A] / [\u0B8E-\u0B90] / [\u0B92-\u0B95] / [\u0B99-\u0B9A] / '\u0B9C' / [\u0B9E-\u0B9F] / [\u0BA3-\u0BA4] / [\u0BA8-\u0BAA] / [\u0BAE-\u0BB5] / [\u0BB7-\u0BB9] / [\u0C05-\u0C0C] / [\u0C0E-\u0C10] / [\u0C12-\u0C28] / [\u0C2A-\u0C33] / [\u0C35-\u0C39] / [\u0C60-\u0C61] / [\u0C85-\u0C8C] / [\u0C8E-\u0C90] / [\u0C92-\u0CA8] / [\u0CAA-\u0CB3] / [\u0CB5-\u0CB9] / '\u0CDE' / [\u0CE0-\u0CE1] / [\u0D05-\u0D0C] / [\u0D0E-\u0D10] / [\u0D12-\u0D28] / [\u0D2A-\u0D39] / [\u0D60-\u0D61] / [\u0E01-\u0E2E] / '\u0E30' / [\u0E32-\u0E33] / [\u0E40-\u0E45] / [\u0E81-\u0E82] / '\u0E84' / [\u0E87-\u0E88] / '\u0E8A' / '\u0E8D' / [\u0E94-\u0E97] / [\u0E99-\u0E9F] / [\u0EA1-\u0EA3] / '\u0EA5' / '\u0EA7' / [\u0EAA-\u0EAB] / [\u0EAD-\u0EAE] / '\u0EB0' / [\u0EB2-\u0EB3] / '\u0EBD' / [\u0EC0-\u0EC4] / [\u0F40-\u0F47] / [\u0F49-\u0F69] / [\u10A0-\u10C5] / [\u10D0-\u10F6] / '\u1100' / [\u1102-\u1103] / [\u1105-\u1107] /'\u1109' / [\u110B-\u110C] / [\u110E-\u1112] / '\u113C' / '\u113E' / '\u1140' / '\u114C' / '\u114E' / '\u1150' / [\u1154-\u1155] / '\u1159' / [\u115F-\u1161] / '\u1163' / '\u1165' / '\u1167' / '\u1169' / [\u116D-\u116E] / [\u1172-\u1173] / '\u1175' / '\u119E' / '\u11A8' / '\u11AB' / [\u11AE-\u11AF] / [\u11B7-\u11B8] / '\u11BA' / [\u11BC-\u11C2] / '\u11EB' / '\u11F0' / '\u11F9' / [\u1E00-\u1E9B] / [\u1EA0-\u1EF9] / [\u1F00-\u1F15] / [\u1F18-\u1F1D] / [\u1F20-\u1F45] / [\u1F48-\u1F4D] / [\u1F50-\u1F57] / '\u1F59' / '\u1F5B' / '\u1F5D' / [\u1F5F-\u1F7D] / [\u1F80-\u1FB4] / [\u1FB6-\u1FBC] / '\u1FBE' / [\u1FC2-\u1FC4] / [\u1FC6-\u1FCC] / [\u1FD0-\u1FD3] / [\u1FD6-\u1FDB] / [\u1FE0-\u1FEC] / [\u1FF2-\u1FF4] / [\u1FF6-\u1FFC] / '\u2126' / [\u212A-\u212B] / '\u212E' / [\u2180-\u2182] / [\u3041-\u3094] / [\u30A1-\u30FA] / [\u3105-\u312C] / [\uAC00-\uD8A3]

/* http://www.w3.org/TR/xml/#NT-S
   S (white space) consists of one or more space (#x20) characters, carriage returns, line feeds, or tabs.
   S	   ::=   	(#x20 | #x9 | #xD | #xA)+
 */
S = ('\x20' / '\x09' / '\x0d' / '\x0a')+



XmlPattern = ElemPattern
ElemPattern	= EmptyElemTagP
			/ STagP ContentP ETagP
EmptyElemTagP = '<' Name S? '/>'
STagP = '<' Name S? '>'
ETagP = '</' Name S?'>'
ContentP = CharData? ((ElemPattern / ScalaPatterns) CharData?)*

/* not used
ContentP1 = ElemPattern
/ Reference
/ CDSect
/ PI
/ Comment
/ ScalaPatterns
*/

ScalaPatterns = '{' Patterns '}'

// http://www.w3.org/TR/xml/#sec-cdata-sect
CDSect = CDStart CData CDEnd
CDStart	= '<![CDATA['
CData = !(Char* ']]>' Char*) Char*
CDEnd = ']]>'

//http://www.w3.org/TR/xml/#dt-pi
PI = '<?' PITarget (S (!(Char* '?>' Char*) Char*))? '?>'
PITarget = !(('X' / 'x') ('M' / 'm') ('L' / 'l')) Name

// CharNoRef is used in the production for CharData in section 10.1, and not defined anywhere. It should be replaced by Char1.
// https://issues.scala-lang.org/browse/SI-5141
CharNoRef = Char1

