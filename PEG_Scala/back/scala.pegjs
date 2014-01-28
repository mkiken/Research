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

/*Initializer*/
{
	//引数をフィルターして適切な形に変形する
	//もしidxが入っていればarg[idx]を戻り値とする
	function ftr(arg, idx){
		//空文字列はnull
		if(typeof idx === 'undefined') idx = -1;
		if(arg === "" | arg == null) return null;
		return idx == -1? arg : arg[idx];
	}

	//keyをキーワードとする
	function makeKeyword(key){
		return {type:"Keyword", word:key};
	}

	//typeをvariableに変える
	function toVariable(obj){
		obj.type = "Variable";
		return obj;
	}

}

/* CompilationUnit ::= {‘package’ QualId semi} TopStatSeq */
CompilationUnit = __ pcs:(PACKAGE QualId semi)* tss:TopStatSeq {
      var result = [];
      for (var i = 0; i < pcs.length; i++) {
        result.push(pcs[i][1]);
      }
	  return {type: "CompilationUnit", packages:result, topStatseq:tss};
    }

/* upper ::= ‘A’ | ... | ‘Z’ | ‘$’ | ‘_’ and Unicode category Lu */
upper = [A-Z] / '$' / '_'

/* lower ::= ‘a’ | ... | ‘z’ and Unicode category Ll */
lower = [a-z]

/* letter ::= upper | lower and Unicode categories Lo, Lt, Nl */
letter = upper / lower

/* digit ::= ‘0’ | ... | ‘9’ */
digit = [0-9]

/* opchar ::= “all other characters in \u0020-007F and Unicode categories Sm, So except parentheses ([]) and periods” */
// (:28, ):29, .:2e, [:5b, ]:5d, {:7b, }:7d
//opchar = [\u0020-\u007F]
/*

!
"
#
$
%
&
'
(
)
*
+
,
-
.
/
0-9
:
;
<
=
>
?
@
A-Z
[
\
]
^
_
`
a-z
{
|
}
~
 */
//opchar = [\u0021-\u0027] / [\u0030-\u002d] / [\u002f-\u005a] / [005c] / [\u005e-\u007a] / [\u007c] / [\u007e]
//よく分からないのでとりあえず
opchar = [\+\-\*/><=!&|%:~\^|]

/* operator precedence
(all letters)
|
^
&
< >
= !
:
+ -
* / %
(all other special characters)
 */
/* op ::= opchar {opchar} */
//op = ([%] / [+\-] / ':' / [=!] / [<>] / '&' / '^' / '|' / opchar+) __ */
//op = (">>>" / "<<" / ">>" / "<=" / ">=" / "==" / "!=" / "eq" / "ne" / "&&" / "||" / [*/%] / [+\-] / ':' / [!~] / [<>] / '&' / '^' / '|' / opchar+) __
/* op =  chars:opchar+ __ {return chars.join("");} */
op = !("/*" / "//" / EQUAL) chars:opchar+ __ {return chars.join("");}

/* varid ::= lower idrest */
varid = start:lower parts:idrest {return start + parts;}

/* plainid ::= upper idrest
| varid
| op */
plainid = start:upper parts:idrest {return start + parts;}
		/ varid
		/ op

/* id ::= plainid */
/* | ‘\‘’ stringLit ‘\‘’ */
id = nm:plainid {return { type: "Identifier", name: nm }; }
	/ [`] str:stringLiteral [`] __ { return { type: "Identifier2", name: '`' + str + '`'}; }

/* idrest ::= {letter | digit} [‘_’ op] */
idrest	= chars:(letter / digit)* '_' ops:op {return chars.join("") + '_' + ops;}
		/ chars:(letter / digit)* __ {return chars.join("");}

/* integerLiteral ::= (decimalNumeral | hexNumeral | octalNumeral) [‘L’ | ‘l’] */
integerLiteral = ilit:(decimalNumeral / hexNumeral / octalNumeral) ll:('L' / 'l')? __ {
	return ilit + ll;
}


/* decimalNumeral ::= ‘0’ | nonZeroDigit {digit} */
/* decimalNumeral	= '0' {return {type: "decimalNumeral", value: '0'};} */
decimalNumeral	= '0'
				/ start:nonZeroDigit parts:digit* __ {return start + parts.join("");}

/* hexNumeral ::= ‘0’ ‘x’ hexDigit {hexDigit} */
hexNumeral = '0' 'x' parts:hexDigit+ __ {return "0x" + parts.join("");}

/* octalNumeral ::= ‘0’ octalDigit {octalDigit} */
octalNumeral = '0' parts:octalDigit+ __ {return '0' + parts.join("");}

/* digit ::= ‘0’ | nonZeroDigit */
/* digit = '0' / nonZeroDigit */

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
	= dp:digit+ '.' ds:digit* exp:exponentPart? type:floatType? __ {return dp.join("") + '.' + ds.join("") + exp + type;}
	/ '.' dp:digit+  exp:exponentPart? type:floatType? __ {return '.' + dp.join("") + exp + type;}
	/ dp:digit+ exp:exponentPart type:floatType? __ {return dp.join("") + exp + type;}
	/ dp:digit+ exp:exponentPart? type:floatType __ {return dp.join("") + exp + type;}

/* exponentPart ::= (‘E’ | ‘e’) [‘+’ | ‘-’] digit {digit} */
exponentPart = exp:('E' / 'e') sign:('+' / '-')? dt:digit+ {return exp + sign + dt.join("");}

/* floatType ::= ‘F’ | ‘f’ | ‘D’ | ‘d’*/
floatType = 'F' / 'f' / 'D' / 'd'

/* booleanLiteral ::= ‘true’ | ‘false’ */
booleanLiteral = ret:('true' / 'false') __ {return {type: "booleanLiteral", value: ret};}

/* characterLiteral ::= ‘\’’ printableChar ‘\’’ */
/* | ‘\’’ charEscapeSeq ‘\’’ */
characterLiteral = ['] chr:( printableChar / charEscapeSeq ) ['] __ {return chr;}

/* stringLiteral ::= ‘"’ {stringElement} ‘"’ */
/* | ‘"""’ multiLineChars ‘"""’ */
stringLiteral	= '"' ele:stringElement* '"' __ {return {type: "stringLiteral", value: ele.join("")};}
				/ '"""' chrs:multiLineChars __ {return {type: "stringLiteralMulti", value: chrs};}

/* stringElement ::= printableCharNoDoubleQuote */
/* | charEscapeSeq */
stringElement	= printableCharNoDoubleQuote
				/ charEscapeSeq

/* multiLineChars ::= {[‘"’] [‘"’] charNoDoubleQuote} {‘"’} */
//check : これ結構解決難し・・・
multiLineChars	= eles:multiLineCharsElements* ('"""""' / '""""' / '"""') {return eles.join("");}

multiLineCharsElements = chrs:('"'? '"'? charNoDoubleQuote) {return chrs.join("");}
/* symbolLiteral ::= ‘’’ plainid */
symbolLiteral = "'" pi:plainid __ {return "'" + pi;}

// comment ::= ‘/*’ “any sequence of characters” ‘*/’ */
/* | ‘//’ “any sequence of characters up to end of line” */
comment = singleLineComment / multiLineComment

singleLineComment = '//' (!nl . )* //nl+
/* singleLineComment = '//' a:(!nl . )* {console.log("singleLineComment invoked. : " + a); return a;} */
multiLineComment = [/][*] ((&"/*" multiLineComment) / (!"*/" . ))* [*][/]

__ = (whitespace / comment)*
___ = (whitespace / comment / nl)*

/* nl ::= “new line character” */
//とりあえずJavaScriptと同じ改行にしておく
nl = ("\r\n" / "\n" / "\r") __

/* semi ::= ‘;’ | nl {nl} */
semi = (SEMICOLON nl* / nl+)

//' ','\t','\r','\n'
//whitespace = [\u0020\u0009\u000D\u000A]
whitespace = [\u0020\u0009]

/* The context-free syntax of Scala is given by the following EBNF grammar. */

/* Literal ::= [‘-’] integerLiteral */
/* | [‘-’] floatingPointLiteral */
/* | booleanLiteral */
/* | characterLiteral */
/* | stringLiteral */
/* | symbolLiteral */
/* | ‘null’ */
Literal =
minus:HYPHEN? val:floatingPointLiteral {return {type: "floatingPointLiteral", value: minus + val}; }
/ minus:HYPHEN? val:integerLiteral {return {type: "integerLiteral", value: minus + val}; }
/ booleanLiteral
/ val:characterLiteral {return {type: "characterLiteral", value: val}; }
/ stringLiteral
/ val:symbolLiteral {return {type: "symbolLiteral", value: val}; }
/ 'null' __ {return {type: "nullLiteral", value: "null"}; }

/* QualId ::= id {‘.’ id} */
QualId = head:id tail:(DOT id)* {
      var result = [head];
      for (var i = 0; i < tail.length; i++) {
        result.push(tail[i][1]);
      }
      return result;
    }

/* ,ids ::= id {‘,’ id} */
ids = head:id tail:(COMMA id)* {
      var result = [head];
      for (var i = 0; i < tail.length; i++) {
        result.push(tail[i][1]);
      }
      return {type:"ids", ids:result};
    }

/* Path ::= StableId */
/* | [id ‘.’] ‘this’ */
Path	= StableId
		/ pre:(id DOT)? THIS {return {type:"Path", id:ftr(pre, 0)};}

/* StableId ::= id */
/* | Path ‘.’ id */
/* | [id ’.’] ‘super’ [ClassQualifier] ‘.’ id */
/* StableId	= id _StableId */
StableId	= base:id accessors:(DOT id)* {
      var result = [base];
      for (var i = 0; i < accessors.length; i++) {
        result.push(accessors[i][1]);
	  }
      return {type:"StableId", contents:result};
    }
			/* / (id DOT)? THIS DOT id _StableId */
/ pre:(id DOT)? th:THIS accessors:(DOT id)+ {
      var result = pre !==""? [pre[0], th] : [th];
      for (var i = 0; i < accessors.length; i++) {
        result.push(accessors[i][1]);
	  }
	  return {type:"StableId", contents:result};
    }

			/* / (id DOT)? 'super' __ ClassQualifier? DOT id _StableId */
/ pre:(id DOT)? 'super' __ cl:ClassQualifier? accessors:(DOT id)+ {
      var result = pre !== ""? [pre[0], {type:"Keyword", word:"super"}] : [{type:"Keyword", word:"super"}];
if(cl !== ""){
	result.push(cl);
}
	  for (var i = 0; i < accessors.length; i++) {
        result.push(accessors[i][1]);
	  }
	  return {type:"StableId", contents:result};
    }

/* _StableId	= DOT id _StableId {return } */
			/* / Empty */

/* ClassQualifier ::= ‘[’ id ‘]’ */
ClassQualifier = OPBRACKET qual:id CLBRACKET {return {type: "ClassQualifier", id:qual};}

/* Type ::= FunctionArgTypes ‘=>’ Type */
/* | InfixType [ExistentialClause] */
Type	= funcarg:FunctionArgTypes ARROW tp:Type {return {type:"FunctionType", left:funcarg, right:tp};}
		/ tp:InfixType ext:ExistentialClause? {return {type:"Type", ext:ftr(ext), tp:tp};}


/* FunctionArgTypes ::= InfixType */
/* | ‘(’ [ ParamType {‘,’ ParamType } ] ‘)’ */
FunctionArgTypes	= InfixType
/ OPPAREN tps:( ParamType (COMMA ParamType )* )? CLPAREN {
      var result = [];
if(tps !== ""){
	result.push(tps[0]);
	for (var i = 0; i < tps[1].length; i++) {
        result.push(tps[1][i][1]);
	  }
}
	  return {type:"FunctionArgTypes", contents:result};
}


/* ExistentialClause ::= ‘forSome’ ‘{’ ExistentialDcl {semi ExistentialDcl} ‘}’ */
ExistentialClause = 'forSome' __ OPBRACE ex:ExistentialDcl exs:(semi ExistentialDcl)* CLBRACE {
      var result = [{type:"Keyword", word:"forSome"}];
	  result.push(ex);
	for (var i = 0; i < exs.length; i++) {
        result.push(exs[i][1]);
	  }	  return {type:"ExistentialClause", contents:result};
    }

/* ExistentialDcl ::= ‘type’ TypeDcl */
/* | ‘val’ ValDcl */
ExistentialDcl	= tp:TYPE dcl:TypeDcl {return {type:"ExistentialDcl", pre:tp, dcl:dcl}}
				/ vl:VAL dcl:ValDcl {return {type:"ExistentialDcl", pre:vl, dcl:dcl}}

/* InfixType ::= CompoundType {id [nl] CompoundType} */
/* InfixType = head:CompoundType tails:(id __ CompoundType)* { */
InfixType = head:CompoundType tails:(id nl? CompoundType)* {
      var ids = [], cts = [];
	for (var i = 0; i < tails.length; i++) {
        ids.push(tails[i][0]);
        cts.push(tails[i][2]);
	  }	  return {type:"InfixType", compoundType:head, ids:ids, compoundTypes:cts};
    }

/* CompoundType ::= AnnotType {‘with’ AnnotType} [Refinement] */
/* | Refinement */
CompoundType	= at:AnnotType wat:(WITH AnnotType)? ref:Refinement? {return {type:"CompoundType", annotType:[at, ftr(wat)], ref:ftr(ref)};}
/ Refinement

/* AnnotType ::= SimpleType {Annotation} */
AnnotType = st:SimpleType annotation:Annotation* {return {type:"AnnotType", st:st, annotation:annotation}; }

/* SimpleType ::= SimpleType TypeArgs */
/* | SimpleType ‘#’ id */
/* | StableId */
/* | Path ‘.’ ‘type’ */
/* | ‘(’ Types ’)’ */
SimpleType =
path:Path dot:DOT tp:TYPE  tails:(TypeArgs / withId)* {return {type:"SimpleType", id:[path, dot, tp], postfix:tails}; }
/ si:StableId tails:(TypeArgs / withId)* {return {type:"SimpleType", id:[si], postfix:tails}; }
/ op:OPPAREN tps:Types cl:CLPAREN  tails:(TypeArgs / withId)* {return {type:"SimpleType", id:[op, tps, cl], postfix:tails}; }
withId = '#' __ id:id {return {type:"withId", id:id};}


/* SimpleType = StableId _SimpleType */
/* / Path DOT TYPE _SimpleType */
/* / OPPAREN Types CLPAREN _SimpleType */
/* _SimpleType = TypeArgs */
			/* / '#' __ id */
			/* / Empty */

/* TypeArgs ::= ‘[’ Types ‘]’ */
TypeArgs = OPBRACKET types:Types CLBRACKET {return {type:"TypeArgs", types:types}; }


/* Types ::= Type {‘,’ Type} */
Types = tp:Type tps:(COMMA Type)* {
      var result = [tp];
	  for (var i = 0; i < tps.length; i++) {
        result.push(tps[i][1]);
	  }
	  return {type:"Types", contents:result};
}

/* Refinement ::= [nl] ‘{’ RefineStat {semi RefineStat} ‘}’ */
Refinement = nl? OPBRACE ref:RefineStat refs:(semi RefineStat)* CLBRACE {
      var result = [ref];
	  for (var i = 0; i < refs.length; i++) {
        result.push(refs[i][1]);
	  }
	  return {type:"Refinement", contents:result};
    }

/* RefineStat ::= Dcl */
/* | ‘type’ TypeDef */
/* | */
RefineStat = Dcl
/ TYPE td:TypeDef {return {type:"RefineStat", typedef:td}; }
/ Empty

/* TypePat ::= Type */
TypePat = Type

/* Ascription ::= ‘:’ InfixType */
/* | ‘:’ Annotation {Annotation} */
/* | ‘:’ ‘_’ ‘*’ */
Ascription = COLON infix:InfixType {return {type:"Ascription", contents:[infix]}; }
/ COLON as:Annotation+ {return {type:"Ascription", contents:as}; }
/ COLON ud:UNDER st:STAR {return {type:"Ascription", contents:[us,st]}; }

/* Expr ::= (Bindings | [‘implicit’] id | ‘_’) ‘=>’ Expr */
/* | Expr1 */
Expr = left:(Bindings / IMPLICIT? id / UNDER) ARROW right:Expr {return {type:"AnonymousFunction", left:left, right:right}; }
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
Expr1 = IF OPPAREN condition:Expr CLPAREN nl* ifStatement:Expr elseStatement:(semi? 'else' __ Expr)? {
      return {
        type:          "IfStatement",
        condition:     condition,
        ifStatement:   ifStatement,
        elseStatement: elseStatement !== "" ? elseStatement[3] : null
      };
    }
/ WHILE OPPAREN condition:Expr CLPAREN nl* statement:Expr {
      return {
        type: "WhileStatement",
        condition: condition,
        statement: statement
      };
    }
/ 'try' __ OPBRACE block:Block CLBRACE catch_:('catch' __ OPBRACE CaseClauses CLBRACE)? finally_:('finally' __ Expr)?{
      return {
        type:      "TryStatement",
        block:     block,
        "catch":   ftr(catch_, 3),
        "finally": ftr(finally_, 2)
      };
    }
/ 'do' __ statement:Expr semi? WHILE OPPAREN condition:Expr CLPAREN {
      return {
        type: "DoWhileStatement",
        condition: condition,
        statement: statement
      };
    }
/ 'for' __ enums:(OPPAREN Enumerators CLPAREN / OPBRACE Enumerators CLBRACE) nl* yield:('yield' __)? statement:Expr {
      return {
        type:        "ForStatement",
        enumrator: enums[1],
        yield:     yield !== "" ? yield[0] : null,
        statement:   statement
      };
    }
/ 'throw' __ exception:Expr {
      return {
        type:      "ThrowStatement",
        exception: exception
      };
    }
/ 'return' __ value:Expr? {
      return {
        type:  "ReturnStatement",
        value: value !== "" ? value : null
      };
    }
/ se1:SimpleExpr1 ae:ArgumentExprs EQUAL exp:Expr {return {type:"AssignmentFunction", left:[se1, ae], right:exp}; }
/ pe:PostfixExpr as:Ascription {return {type:"ExpressionWithAscription", postfix:pe, ascription:as}; }
/ pe:PostfixExpr 'match' __ OPBRACE cases:CaseClauses CLBRACE {return {type:"PatternMatchingExpression", postfix:pe, cases:cc}; }
/ se:(SimpleExpr DOT)? id:id EQUAL exp:Expr {return{type:"AssignmentExpression", prefix:ftr(se), id:toVariable(id), right:exp}; }
/ PostfixExpr

/* PostfixExpr ::= InfixExpr [id [nl]] */
PostfixExpr = infix:InfixExpr id:(id nl?)? {return {type:"PostfixExpression", infix:infix, id: ftr(id, 0)};}

/* InfixExpr ::= PrefixExpr */
/* | InfixExpr id [nl] InfixExpr */
InfixExpr = head:PrefixExpr tails:(id nl? InfixExpr)* {
      var ids = [], exps = [];
	for (var i = 0; i < tails.length; i++) {
        ids.push(tails[i][0]);
        exps.push(tails[i][2]);
	  }
	return {type:"InfixExpression", left:head, ops:ids, rights:exps};
    }
/* _InfixExpr = id nl? InfixExpr _InfixExpr */
/* / Empty */

/* PrefixExpr ::= [‘-’ | ‘+’ | ‘~’ | ‘!’] SimpleExpr */
PrefixExpr = op:(HYPHEN / PLUS / '~' __ / '!' __)? expr:SimpleExpr {
	return {type:"PrefixExpression", op:ftr(op), expr:expr};
}

/* SimpleExpr ::= ‘new’ (ClassTemplate | TemplateBody) */
/* | BlockExpr */
/* | SimpleExpr1 [‘_’] */
SimpleExpr =
NEW arg:(ClassTemplate / TemplateBody) DOT id:id se1:_SimpleExpr1 {return {type:"InstanceCreationExpressionWithId", arg:arg, id:id, suffix:se1}; }
/ NEW arg:(ClassTemplate / TemplateBody) ta:TypeArgs se1:_SimpleExpr1 {return {type:"InstanceCreationExpressionWithTypes", arg:arg, types:ta, suffix:se1}; }
/ NEW arg:(ClassTemplate / TemplateBody) {
	return {type:"InstanceCreationExpression", arg:arg};
}
/ expr:SimpleExpr1 ud:UNDER? {
	return {type:"SimpleExpression", expr:expr, under:ftr(ud)};
}
/ BlockExpr



/* SimpleExpr1 ::= Literal */
/* | Path */
/* | ‘_’ */
/* | ‘(’ [Exprs] ‘)’ */
/* | SimpleExpr ‘.’ id */
/* | SimpleExpr TypeArgs */
/* | SimpleExpr1 ArgumentExprs */
/* | XmlExpr */
SimpleExpr1 = OPPAREN exp:Exprs? CLPAREN se1:_SimpleExpr1 {return {type:"TupleExpression", expr:exp, suffix:se1}; }
/* / SimpleExpr DOT id */
/ NEW arg:(ClassTemplate / TemplateBody) DOT id:id se1:_SimpleExpr1 {return {type:"InstanceCreationExpressionWithId", arg:arg, id:id, suffix:se1}; }
/ NEW arg:(ClassTemplate / TemplateBody) ta:TypeArgs se1:_SimpleExpr1 {return {type:"InstanceCreationExpressionWithTypes", arg:arg, types:ta, suffix:se1}; }
/ bk:BlockExpr DOT id:id se1:_SimpleExpr1 {return {type:"blockExpressionWithId", block:bk, id:id, suffix:se1}; }
/ bk:BlockExpr ta:TypeArgs se1:_SimpleExpr1 {return {type:"blockExpressionWithTypes", block:bk, types:ta, suffix:se1}; }
/ xml:XmlExpr se1:_SimpleExpr1 {return {type:"XmlSimpleExpression", xml:xml, suffix:se1}; }
/* / path:Path se1:_SimpleExpr1 {return {type:"SimpleExpression", expr:path, suffix:se1}; } */
/* / path:id !EQUAL se1:_SimpleExpr1 {return {type:"idSeqSimpleExpression", ids:path, suffix:se1}; } */
/ path:id !EQUAL se1:_SimpleExpr1 {/*console.log("%j", toVariable(path));*/ return {type:"idSeqSimpleExpression", ids:toVariable(path), suffix:se1}; }
/ lt:Literal se1:_SimpleExpr1 {return {type:"literalSimpleExpression", literal:lt, suffix:se1}; }
_SimpleExpr1 = ud:UNDER? !(DOT id EQUAL) DOT id:id se1:_SimpleExpr1 {return {type:"DesignatorPostfix", under:ftr(ud), id:id, postfix:se1}; }
/ ud:UNDER? ta:TypeArgs se1:_SimpleExpr1 {return {type:"TypeApplicationPostfix", under:ftr(ud), typeArgument:ta, postfix:se1}; }
/ ud:UNDER se1:_SimpleExpr1 {return {type:"suffixSimpleExpression", expr:ud, suffix:se1}; }
/ ae:ArgumentExprs !EQUAL se1:_SimpleExpr1 {return {type:"FunctionApplicationPostfix", argument:ae, postfix:se1}; }
/ Empty



/* Exprs ::= Expr {‘,’ Expr} */
Exprs = expr:Expr exprs:(COMMA Expr)* {
      var result = [expr];
	  for (var i = 0; i < exprs.length; i++) {
        result.push(exprs[i][1]);
	  }
	  return {type:"Exprs", contents:result};
    }

/* ArgumentExprs ::= ‘(’ [Exprs] ‘)’ */
/* | ‘(’ [Exprs ‘,’] PostfixExpr ‘:’ ‘_’ ‘*’ ’)’ */
/* | [nl] BlockExpr */
ArgumentExprs = OPPAREN exprs:Exprs? CLPAREN {return {type:"ArgumentExpression", exprs:ftr(exprs)}; }
/ OPPAREN exprs:(Exprs COMMA)? pfe:PostfixExpr COLON UNDER STAR CLPAREN {return {type:"ArgumentExprsWithRepeated", exprs:ftr(exprs, 0), postfixExpr:pfe}; }
/ nl? block:BlockExpr {return block; }

/* BlockExpr ::= ‘{’ CaseClauses ‘}’ */
/* | ‘{’ Block ‘}’ */
BlockExpr = OPBRACE block:CaseClauses CLBRACE {return {type: "PatternMatchingAnonymousFunction", block:block};}
/ OPBRACE block:Block CLBRACE {return {type: "BlockExpression", block:block}; }

/* Block ::= {BlockStat semi} [ResultExpr] */
Block = blocks:(BlockStat semi)* res:ResultExpr? {
      var result = [];
	  for (var i = 0; i < blocks.length; i++) {
        result.push(blocks[i][0]);
	  }
	  return {type:"Block", states:result,res:ftr(res)};
    }

/* BlockStat ::= Import */
/* | {Annotation} [‘implicit’ | ‘lazy’] Def */
/* | {Annotation} {LocalModifier} TmplDef */
/* | Expr1 */
/* | */
BlockStat = Import
/ an:Annotation* md:(IMPLICIT / LAZY)? def:Def {return {type:"BlockStat", annotations:an, modifier:ftr(md), def:def}; }
/ an:Annotation* lm:LocalModifier* td:TmplDef {return {type:"BlockStat", annotations:an, modifier:lm, def:td}; }
/ Expr1
/ Empty

/* ResultExpr ::= Expr1 */
/* | (Bindings | ([‘implicit’] id | ‘_’) ‘:’ CompoundType) ‘=>’ Block */
ResultExpr =
left:(Bindings / (IMPLICIT? id / UNDER) COLON CompoundType) ARROW right:Block
{return {type:"AnonymousFunctionWithCompound", left:left, right:right}; }
/ Expr1

/* Enumerators ::= Generator {semi Enumerator} */
Enumerators = gen:Generator enums:(semi Enumerator)* {
      var result = [];
	  for (var i = 0; i < enums.length; i++) {
        result.push(enums[i][1]);
	  }
	  return {type:"Enumerators", gen:gen, enums:result};
}

/* Enumerator ::= Generator */
/* | Guard */
/* | ‘val’ Pattern1 ‘=’ Expr */
//保留
Enumerator = Generator
/ Guard
/ VAL pt1:Pattern1 EQUAL exp:Expr {return {type:"Enumerator", left:pt1, right:exp}; }

/* Generator ::= Pattern1 ‘<-’ Expr [Guard] */
Generator = pt1:Pattern1 '<-' __ expr:Expr guard:Guard? {return {type: "Generator", pt1:pt1, expr:expr, guard:guard}; }

/* CaseClauses ::= CaseClause { CaseClause } */
CaseClauses = cls:CaseClause+ {return {type: "CaseClauses", cls:cls};}

/* CaseClause ::= ‘case’ Pattern [Guard] ‘=>’ Block */
CaseClause = CASE pt:Pattern guard:Guard? ARROW block:Block {return {type: "Generator", pt:pt, guard:ftr(guard), block:block}; }

/* Guard ::= ‘if’ PostfixExpr */
Guard = IF postfix:PostfixExpr {return {type: "Guard", postfix:postfix};}

/* Pattern ::= Pattern1 { ‘|’ Pattern1 } */
Pattern = pt1:Pattern1 pt1s:( '|' __ Pattern1 )* {
      var result = [pt1];
	  for (var i = 0; i < pt1s.length; i++) {
        result.push(pt1s[i][2]);
	  }
	  return {type:"PatternAlternatives", pts:result};
}

/* Pattern1 ::= varid ‘:’ TypePat */
/* | ‘_’ ‘:’ TypePat */
/* | Pattern2 */
Pattern1 = id:varid COLON tp:TypePat {return {type: "TypedPattern", id:id, tp:tp};}
/ id:UNDER COLON tp:TypePat {return {type: "TypedPattern", id:id, tp:tp};}
/ Pattern2

/* Pattern2 ::= varid [‘@’ Pattern3] */
/* | Pattern3 */
Pattern2 = id:varid pt:(AT Pattern3)? {return {type: "PatternBinder", id:id, pt:pt!== ""? pt[1] : null};}
/ Pattern3

/* Pattern3 ::= SimplePattern */
/* | SimplePattern { id [nl] SimplePattern } */
Pattern3 =
//SimplePattern
head:SimplePattern tails:( !EQUAL id nl? SimplePattern )* {
      var ids = [], cts = [];
	for (var i = 0; i < tails.length; i++) {
        ids.push(tails[i][0]);
        cts.push(tails[i][2]);
	  }	  return {type:"InfixOperatorPattern", SimplePattern:head, ids:ids, SimplePatterns:cts};
    }

/* SimplePattern ::= ‘_’ */
/* | varid */
/* | Literal */
/* | StableId */
/* | StableId ‘(’ [Patterns ‘)’ */
/* | StableId ‘(’ [Patterns ‘,’] [varid ‘@’] ‘_’ ‘*’ ‘)’ */
/* | ‘(’ [Patterns] ‘)’ */
/* | XmlPattern */
SimplePattern = UNDER
/ varid
/ Literal
/ si:StableId OPPAREN pts:Patterns? CLPAREN {return {type: "ConstructorPattern", id:si, pattern:pts};}
/ id:StableId OPPAREN pts:(Patterns COMMA)? vi:(varid AT)? UNDER STAR CLPAREN {return {type: "PatternSequences", id:si, pattern:ftr(pts, 0), varid:ftr(vi, 0)};}
/ StableId
/ OPPAREN pts:Patterns? CLPAREN {return {type: "TuplePattern", id:null, pattern:ftr(pts)};}
/ XmlPattern

/* Patterns ::= Pattern [‘,’ Patterns] */
/* | ‘_’ * */
Patterns = head:Pattern tail:(COMMA Patterns)? {return {type: "Patterns", pattern:[head, tail]};}
/ ud:UNDER st:STAR {return {type: "Patterns", pattern:[ud, st]};}

/* TypeParamClause ::= ‘[’ VariantTypeParam {‘,’ VariantTypeParam} ‘]’ */
TypeParamClause = OPBRACKET param:VariantTypeParam params:(COMMA VariantTypeParam)* CLBRACKET {
      var result = [param];
	  for (var i = 0; i < params.length; i++) {
        result.push(params[i][1]);
	  }
	  return {type:"TypeParamClause", params:result};
}

/* FunTypeParamClause::= ‘[’ TypeParam {‘,’ TypeParam} ‘]’ */
FunTypeParamClause = OPBRACKET param:TypeParam params:(COMMA TypeParam)* CLBRACKET {
      var result = [param];
	  for (var i = 0; i < params.length; i++) {
        result.push(params[i][1]);
	  }
	  return {type:"FunTypeParamClause", params:result};
}

/* VariantTypeParam ::= {Annotation} [‘+’ | ‘-’] TypeParam */
VariantTypeParam = ans:Annotation* sign:(PLUS / HYPHEN)? param:TypeParam {return {type: "VariantTypeParam", annotations:ans, sign:ftr(sign), param:param};}

/* TypeParam ::= (id | ‘_’) [TypeParamClause] [‘>:’ Type] [‘<:’ Type]*/
/* {‘<%’ Type} {‘:’ Type} */
TypeParam = id:(id / UNDER) cl:TypeParamClause? lower:(LEFTANGLE Type)? upper:(RIGHTANGLE Type)? view:('<%' __ Type)* context:(COLON Type)*
{
	var views = [];
	for (var i = 0; i < view.length; i++) {
    views.push(view[i][2]);
	}
	var contexts = [];
	for (var i = 0; i < context.length; i++) {
    contexts.push(context[i][1]);
	}


	return {type: "TypeParam",
	id:id,
	 clause: ftr(cl),
	 lower: ftr(lower, 1),
	 upper: ftr(upper, 1),
	 view: views,
	 context: contexts};}

/* ParamClauses ::= {ParamClause} [[nl] ‘(’ ‘implicit’ Params ‘)’] */
ParamClauses = pc:ParamClause* pm:(nl? OPPAREN IMPLICIT Params CLPAREN)? {return {type: "ParamClauses", clauses:pc, params:pm !== ""? pm[3] : null};}

/* ParamClause ::= [nl] ‘(’ [Params] ’)’ */
ParamClause = nl? OPPAREN pm:Params? CLPAREN {return {type: "ParamClause", params:pm !== ""? pm : null};}

/* Params ::= Param {‘,’ Param} */
Params = param:Param params:(COMMA Param)* {
      var result = [param];
	  for (var i = 0; i < params.length; i++) {
        result.push(params[i][1]);
	  }
	  return {type:"Params", params:result};
    }

/* Param ::= {Annotation} id [‘:’ ParamType] [‘=’ Expr] */
Param = an:Annotation* id:id pt:(COLON ParamType)? expr:(EQUAL Expr)? {return {type:"Param", annotations:an, id:id, paramType:ftr(pt, 1), expr:expr}; }

/* ParamType ::= Type */
/* | ‘=>’ Type */
/* | Type ‘*’ */
ParamType = ar:ARROW tp:Type {return {type:"ParamType", allow:ar, tp:tp, star:null}; }
/ tp:Type st:STAR? {return {type:"ParamType", allow:null, tp:tp, star:ftr(st)}; }


/* ClassParamClauses ::= {ClassParamClause} */
/* [[nl] ‘(’ ‘implicit’ ClassParams ‘)’] */
ClassParamClauses = cls:ClassParamClause* params:(nl? OPPAREN IMPLICIT ClassParams CLPAREN)? {return {type:"ClassParamClauses", cls:cls, params:params !== ""? params[3] : null}; }

/* ClassParamClause ::= [nl] ‘(’ [ClassParams] ’)’ */
ClassParamClause = nl? OPPAREN cp:ClassParams? CLPAREN {return {type:"ClassParamClause", params:ftr(cp)}; }

/* ClassParams ::= ClassParam {‘’ ClassParam} */
ClassParams = param:ClassParam params:(' ' ClassParam)*
{
      var result = [param];
	  for (var i = 0; i < params.length; i++) {
        result.push(params[i][1]);
	  }
	  return {type:"ClassParams", params:result};
}

/* ClassParam ::= {Annotation} [{Modifier} (‘val’ | ‘var’)] */
/* id ‘:’ ParamType [‘=’ Expr] */
ClassParam = an:Annotation* md:(Modifier* (VAL / VAR))? id:id COLON pt:ParamType exp:(EQUAL Expr)? {return {type:"ClassParam", annotations:an, modifier:ftr(md, 0), vax:ftr(md, 1), id:id, paramType:pt, exp:ftr(exp, 1)}; }

/* Bindings ::= ‘(’ Binding {‘,’ Binding ‘)’ */
//多分'(' Binding (',' Binding ')')*ってこと？？
//'(' Binding (',' Binding )* ')'ってことっぽい
Bindings = OPPAREN bd:Binding bds:(COMMA Binding)* CLPAREN {
      var result = [bd];
	  for (var i = 0; i < bds.length; i++) {
        result.push(bds[i][1]);
	  }
	  return {type:"Bindings", bindings:result};
    }

/* Binding ::= (id | ‘_’) [‘:’ Type] */
Binding = UNDER tp:(COLON Type)? {return {type:"BindingAny", tp:ftr(tp, 1)}; }
/ id:id tp:(COLON Type)? {return {type:"Binding", id:toVariable(id), tp:ftr(tp, 1)}; }

/* Modifier ::= LocalModifier */
/* | AccessModifier */
/* | ‘override’ */
Modifier = LocalModifier
/ AccessModifier
/ 'override' __ {return makeKeyword("override");}

/* LocalModifier ::= ‘abstract’ */
/* | ‘final’ */
/* | ‘sealed’ */
/* | ‘implicit’ */
/* | ‘lazy’ */
LocalModifier = 'abstract' __ {return makeKeyword("abstract");}
/ 'final' __ {return makeKeyword("final");}
/ 'sealed' __ {return makeKeyword("sealed");}
/ IMPLICIT
/ LAZY

/* AccessModifier ::= (‘private’ | ‘protected’) [AccessQualifier] */
AccessModifier = md:('private' / 'protected') __ qual:AccessQualifier? {return {type:"AccessModifier", modifier:makeKeyword(md), qualifier:ftr(qual)};}

/* AccessQualifier ::= ‘[’ (id | ‘this’) ‘]’ */
AccessQualifier = OPBRACKET id:(id / THIS) CLBRACKET {return {type:"AccessQualifier", id:id};}

/* Annotation ::= ‘@’ SimpleType {ArgumentExprs} */
Annotation = AT stype:SimpleType exprs:ArgumentExprs* {return {type:"Annotation", stype:tp, exprs:exprs};}

/* ConstrAnnotation ::= ‘@’ SimpleType ArgumentExprs */
ConstrAnnotation = AT tp:SimpleType exprs:ArgumentExprs {return {type:"ConstrAnnotation", stype:tp, exprs:exprs};}


/* NameValuePair ::= ‘val’ id ‘=’ PrefixExpr */
NameValuePair = VAL id:id EQUAL prefix:PrefixExpr {return {type:"NameValuePair", id:id, prefix:prefix};}


/* TemplateBody ::= [nl] ‘{’ [SelfType] TemplateStat {semi TemplateStat} ‘}’ */
TemplateBody = nl? OPBRACE tp:SelfType? nl? ts:TemplateStat tss:(semi TemplateStat)* nl? CLBRACE {
      var result = [ts];
	  for (var i = 0; i < tss.length; i++) {
        result.push(tss[i][1]);
	  }
	  return {type:"TemplateBody", selftype:ftr(tp), states:result};
}

/* TemplateStat ::= Import */
/* | {Annotation [nl]} {Modifier} Def */
/* | {Annotation [nl]} {Modifier} Dcl */
/* | Expr */
/* | */
TemplateStat = Import
/ ats:(Annotation nl?)* modifier:Modifier* def:(Def / Dcl) {
      var result = [];
	  for (var i = 0; i < ats.length; i++) {
        result.push(ats[i][0]);
	  }
	  return {type:"TemplateStatement", annotation:result, modifier:modifier, definition:def};
    }
/ Expr
/ Empty

/* SelfType ::= id [‘:’ Type] ‘=>’ */
/* | ‘this’ ‘:’ Type ‘=>’ */
SelfType = id:id tp:(COLON Type)? ARROW {return {type:"SelfType", id:id, tp:ftr(tp,1)};}
/ id:THIS COLON tp:Type ARROW {return {type:"SelfType", id:id, tp:tp};}

/* Import ::= ‘import’ ImportExpr {‘,’ ImportExpr} */
Import = 'import' __ head:ImportExpr tail:(COMMA ImportExpr)* {
	var result = [head];
	for (var i = 0; i < tail.length; i++) {
		result.push(tail[i][1]);
	}
	return {type:"ImportStatement", exprs:result};
}

/* ImportExpr ::= StableId ‘.’ (id | ‘_’ | ImportSelectors) */
ImportExpr = id:StableId sel:(DOT (UNDER / ImportSelectors))? {return {type:"ImportExpr", id:id, selector:ftr(sel,1)};}

/* ImportSelectors ::= ‘{’ {ImportSelector ‘,’} (ImportSelector | ‘_’) ‘}’ */
ImportSelectors = OPBRACE heads:(ImportSelector COMMA)* tail:(ImportSelector / UNDER) CLBRACE {
	var result = [];
	for (var i = 0; i < heads.length; i++) {
		result.push(heads[i][0]);
	}
	result.push(tail);
	return {type:"ImportSelectors", selectors:result};
}

/* ImportSelector ::= id [‘=>’ id | ‘=>’ ‘_’] */
ImportSelector = head:id tail:(ARROW id / ARROW UNDER)? {return {type:"ImportSelector", src:head, dest:ftr(tail,1)};}

/* Dcl ::= ‘val’ ValDcl */
/* | ‘var’ VarDcl */
/* | ‘def’ FunDcl */
/* | ‘type’ {nl} TypeDcl */
Dcl = dcl:VAL body:ValDcl {return {type:"Declaration", dcl:dcl, body:body};}
/ dcl:VAR body:VarDcl {return {type:"Declaration", dcl:dcl, body:body};}
/ dcl:DEF body:FunDcl {return {type:"Declaration", dcl:dcl, body:body};}
/ dcl:TYPE nl* body:TypeDcl {return {type:"Declaration", dcl:dcl, body:body};}

/* ValDcl ::= ids ‘:’ Type */
ValDcl = id:ids COLON tp:Type {return {type:"ValueDeclaration", id:id, tp:tp};}

/* VarDcl ::= ids ‘:’ Type */
VarDcl = id:ids COLON tp:Type {return {type:"VariableDeclaration", id:id, tp:tp};}

/* FunDcl ::= FunSig [‘:’ Type] */
FunDcl = sig:FunSig tp:(COLON Type)? {return {type:"FunctionDeclaration", signature:sig, tp:ftr(tp, 1)};}

/* FunSig ::= id [FunTypeParamClause] ParamClauses */
FunSig = id:id funtype:FunTypeParamClause? param:ParamClauses {return {type:"FunctionSignature", id:id, funtype:ftr(funtype), param:param};}

/* TypeDcl ::= id [TypeParamClause] [‘>:’ Type] [‘<:’ Type] */
TypeDcl = id:id tpc:TypeParamClause? t1:(LEFTANGLE Type)? t2:(RIGHTANGLE Type)? {return {type:"TypeDeclaration", id:id, typeparam:ftr(tpc), type1:ftr(t1), type2:ftr(t2)};}

/* PatVarDef ::= ‘val’ PatDef */
/* | ‘var’ VarDef */
PatVarDef = dcl:VAL body:PatDef {return {type:"PatValDef", body:body};}
/ dcl:VAR body:VarDef {return {type:"PatVarDef", body:body};}

/* Def ::= PatVarDef */
/* | ‘def’ FunDef */
/* | ‘type’ {nl} TypeDef */
/* | TmplDef */
Def = PatVarDef
/ DEF body:FunDef {return {type:"Definition", body:body};}
/ TYPE nl* body:TypeDef {return {type:"TypeDefinition", body:body};}
/ TmplDef

/* PatDef ::= Pattern2 {‘,’ Pattern2} [‘:’ Type] ‘=’ Expr */
PatDef = ptn:Pattern2 ptns:(COMMA Pattern2)* tp:(COLON Type)? EQUAL expr:Expr{
	var result = [ptn];
	for (var i = 0; i < ptns.length; i++) {
		result.push(ptns[i][1]);
	}
	return {type:"PatDef", patterns:result, tp:ftr(tp, 1), expr:expr};
}

/* VarDef ::= PatDef */
/* | ids ‘:’ Type ‘=’ ‘_’ */
VarDef = PatDef
/ id:ids COLON tp:Type EQUAL UNDER {return {type:"VarDef", ids:id, tp:tp};}

/* FunDef ::= FunSig [‘:’ Type] ‘=’ Expr */
/* | FunSig [nl] ‘{’ Block ‘}’ */
/* | ‘this’ ParamClause ParamClauses */
/* (‘=’ ConstrExpr | [nl] ConstrBlock) */
FunDef = fs:FunSig tp:(COLON Type)? EQUAL exp:Expr {return {type:"FunctionDefinition", signature:fs, tp:ftr(tp, 1), expr:exp}; }
/ fs:FunSig nl? OPBRACE bk:Block CLBRACE {return {type:"Procedure", signature:fs, block:bk}; }
/ THIS pc:ParamClause pcs:ParamClauses body:(EQUAL ConstrExpr / nl? ConstrBlock) {return {type:"ConstructorDefinition", param:pc, params:pcs, body:body}; }

/* TypeDef ::= id [TypeParamClause] ‘=’ Type */
TypeDef = id:id pm:TypeParamClause? EQUAL tp:Type {return {type:"TypeDef", id:id, param:ftr(pm), tp:tp}; }

/* TmplDef ::= [‘case’] ‘class’ ClassDef */
/* | [‘case’] ‘object’ ObjectDef */
/* | ‘trait’ TraitDef */
TmplDef = cs:CASE? 'class' __ def:ClassDef {return {type:"ClassTemplateDefinition", prefix:ftr(cs), def:def}; }
/ cs:CASE? OBJECT def:ObjectDef {return {type:"ObjectTemplateDefinition", prefix:ftr(cs), def:def}; }
/ 'trait' __ def:TraitDef {return {type:"TraitTemplateDefinition", def:def}; }

/* ClassDef ::= id [TypeParamClause] {ConstrAnnotation} [AccessModifier] */
/* ClassParamClauses ClassTemplateOpt */
ClassDef = id:id tpc:TypeParamClause? ca:ConstrAnnotation* am:AccessModifier? cpc:ClassParamClauses cto:ClassTemplateOpt {return {type:"ClassDef", id:id, typeParam:ftr(tpc), annotation:ca, modifier:ftr(am), classParam:cpc, classTemplate:cto}; }

/* TraitDef ::= id [TypeParamClause] TraitTemplateOpt */
TraitDef = id:id tpc:TypeParamClause? tto:TraitTemplateOpt {return {type:"TraitDef", id:id, typeParam:tpc, traitTemplate:tto}; }

/* ObjectDef ::= id ClassTemplateOpt */
ObjectDef = id:id cto:ClassTemplateOpt {return {type:"ObjectDefinition", id:id, classTemplate:cto}; }

/* ClassTemplateOpt ::= ‘extends’ ClassTemplate | [[‘extends’] TemplateBody] */
ClassTemplateOpt = ext:EXTENDS ct:ClassTemplate {return {type:"ClassTemplateOpt", extend:ext, body:ct}; }
/ tmpl:(EXTENDS? TemplateBody)? {return {type:"ClassTemplateOpt", extend:ftr(ftr(tmpl, 0)), body:ftr(tmpl, 1)}; }

/* TraitTemplateOpt ::= ‘extends’ TraitTemplate | [[‘extends’] TemplateBody] */
TraitTemplateOpt = ext:EXTENDS tt:TraitTemplate {return {type:"TraitTemplateOpt", extend:ext, body:tt}; }
/ tmpl:(EXTENDS? TemplateBody)? {return {type:"TraitTemplateOpt", extend:ftr(ftr(tmpl, 0)), body:ftr(tmpl, 1)}; }

/* ClassTemplate ::= [EarlyDefs] ClassParents [TemplateBody] */
ClassTemplate = ed:EarlyDefs? cp:ClassParents tb:TemplateBody? {return {type:"ClassTemplate", def:ftr(ed), classParent:cp, body:ftr(tb)}; }

/* TraitTemplate ::= [EarlyDefs] TraitParents [TemplateBody] */
TraitTemplate = ed:EarlyDefs? tp:TraitParents tb:TemplateBody? {return {type:"TraitTemplate", def:ftr(ed), traitParent:tp, body:ftr(tb)}; }

/* ClassParents ::= Constr {‘with’ AnnotType} */
ClassParents = cst:Constr ats:(WITH AnnotType)* {return {type:"ClassParents", constr:cst, annotType:ats}; }

/* TraitParents ::= AnnotType {‘with’ AnnotType} */
TraitParents = at:AnnotType ats:(WITH AnnotType)* {return {type:"TraitParents", annotType:at, annotType:ats}; }

/* Constr ::= AnnotType {ArgumentExprs} */
Constr = at:AnnotType ae:ArgumentExprs* {return {type:"Constr", annotType:at, exprs:ae}; }

/* EarlyDefs ::= ‘{’ [EarlyDef {semi EarlyDef}] ‘}’ ‘with’ */
EarlyDefs = OPBRACE eds:(EarlyDef (semi EarlyDef)*)? CLBRACE WITH {
      var result = ftr(eds);
	  if(eds !== null){
		  for (var i = 0; i < eds[1].length; i++) {
			  result.push(eds[1][i][1]);
		  }
	  }
	  return {type:"EarlyDefs", earlyDefs:result};
    }

/* EarlyDef ::= {Annotation [nl]} {Modifier} PatVarDef */
EarlyDef = an:(Annotation nl?)* md:Modifier* pvd:PatVarDef {
      var result = [];
	  for (var i = 0; i < an.length; i++) {
        result.push(an[i][0]);
	  }
	  return {type:"EarlyDef", annotation:an, modifier:md, def:pvd};
    }

/* ConstrExpr ::= SelfInvocation */
/* | ConstrBlock */
ConstrExpr = SelfInvocation
/ ConstrBlock

/* ConstrBlock ::= ‘{’ SelfInvocation {semi BlockStat} ‘}’ */
ConstrBlock = OPBRACE si:SelfInvocation bss:(semi BlockStat)* CLBRACE{
      var result = [];
	  for (var i = 0; i < bss.length; i++) {
        result.push(bss[i][1]);
	  }
	  return {type:"TypeParamClause", params:result};
    }

/* SelfInvocation ::= ‘this’ ArgumentExprs {ArgumentExprs} */
SelfInvocation = THIS ae:ArgumentExprs+ {return {type:"SelfInvocation", exprs:ae}; }

/* TopStatSeq ::= TopStat {semi TopStat} */
TopStatSeq = tp:TopStat tps:(semi TopStat)*{
      var result = [tp];
	  for (var i = 0; i < tps.length; i++) {
        result.push(tps[i][1]);
	  }
	  return {type:"TopStatSeq", topstat:result};
    }

/* TopStat ::= {Annotation [nl]} {Modifier} TmplDef */
/* | Import */
/* | Packaging */
/* | PackageObject */
/* | */
TopStat = an:(Annotation nl?)* md:Modifier* td:TmplDef{
      var result = [];
	  for (var i = 0; i < an.length; i++) {
        result.push(an[i][0]);
	  }
	  return {type:"TopStat", annotation:an, modifier:md, def:td};
    }
/ Import
/ Packaging
/ PackageObject
/ Empty
/* Packaging ::= ‘package’ QualId [nl] ‘{’ TopStatSeq ‘}’ */
Packaging = PACKAGE qi:QualId nl? OPBRACE tss:TopStatSeq CLBRACE {return {type:"Packaging", qualId:qi, topStatseq:tss}; }

/* PackageObject ::= ‘package’ ‘object’ ObjectDef */
PackageObject = PACKAGE OBJECT od:ObjectDef {return {type:"PackageObject", def:od}; }




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
printableChar = !charEscapeSeq chr:. {return chr;}

printableCharNoDoubleQuote = !'"' chr:printableChar {return chr;}

charNoDoubleQuote = !'"' chr:. {return chr;}

/* Empty = & {return true;} __ */
Empty = & {return true;} {return {type:"Empty"};}
/* Empty = (&. / !.) {return {type:"Empty", value:null};} */

PACKAGE = 'package' __ {return {type:"Keyword", word:"package"}}
SEMICOLON = ';' __ {return {type:"Keyword", word:";"}}
HYPHEN = '-' __ {return {type:"Keyword", word:"-"}}
DOT = '.' __ {return {type:"Keyword", word:"."}}
COMMA = ',' __ {return {type:"Keyword", word:","}}
THIS = 'this' __ {return {type:"Keyword", word:"this"}}
OPBRACKET = '[' ___ {return {type:"Keyword", word:"["}}
CLBRACKET = ']' __ {return {type:"Keyword", word:"]"}}
ARROW = '=>' __ {return {type:"Keyword", word:"=>"}}
OPPAREN = '(' ___ {return {type:"Keyword", word:"("}}
CLPAREN = ')' __ {return {type:"Keyword", word:")"}}
OPBRACE = '{' ___ {return {type:"Keyword", word:String.fromCharCode(123)}} //'{'だとバグるので文字コードで回避
CLBRACE = '}' __ {return {type:"Keyword", word:String.fromCharCode(125)}}
TYPE = 'type' __ {return {type:"Keyword", word:"type"}}
VAL = 'val' __ {return {type:"Keyword", word:"val"}}

WITH = 'with' __ {return {type:"Keyword", word:"with"}}
COLON = ':' __ {return {type:"Keyword", word:":"}}
UNDER = '_' __ {return {type:"Keyword", word:"_"}}
STAR = '*' __ {return {type:"Keyword", word:"*"}}
IMPLICIT = 'implicit' __ {return {type:"Keyword", word:"implicit"}}
IF = 'if' __ {return {type:"Keyword", word:"if"}}
WHILE = 'while' __ {return {type:"Keyword", word:"while"}}
EQUAL = '=' !opchar ___ {return {type:"Keyword", word:"="}} //==などはEQUALではないとして弾く
PLUS = '+' !opchar __ {return {type:"Keyword", word:"+"}}
NEW = 'new' __ {return {type:"Keyword", word:"new"}}
LAZY = 'lazy' __ {return {type:"Keyword", word:"lazy"}}
CASE = 'case' __ {return {type:"Keyword", word:"case"}}
AT = '@' __ {return {type:"Keyword", word:"@"}}
LEFTANGLE = '>:' __ {return {type:"Keyword", word:">:"}}
RIGHTANGLE = '<:' __ {return {type:"Keyword", word:"<:"}}
VAR = 'var' __ {return {type:"Keyword", word:"var"}}
DEF = 'def' __ {return {type:"Keyword", word:"def"}}
OBJECT = 'object' __ {return {type:"Keyword", word:"object"}}
EXTENDS = 'extends' __ {return {type:"Keyword", word:"extends"}}

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

XmlExpr = XmlContent Element* {return {type:"XmlExpr"};}
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
CharData = !(CharNoRef* OPBRACE CharB CharNoRef*) !(CharNoRef* ']]>' CharNoRef*) CharNoRef*
Char1 = !('<' / '&') Char
CharQ = !'"' Char1
CharA = !"'" Char1
CharB = !'{' Char1
Name = XNameStart NameChar*
// (as in W3C XML, but without ':'
XNameStart = !':' (UNDER / BaseChar / Ideographic)

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
Eq = S? EQUAL S?

// not used
// CombiningChar = [\u0300-\u0345] / [\u0360-\u0361] / [\u0483-\u0486] / [\u0591-\u05A1] / [\u05A3-\u05B9] / [\u05BB-\u05BD] / '\u05BF' / [\u05C1-\u05C2] / '\u05C4' / [\u064B-\u0652] / '\u0670' / [\u06D6-\u06DC] / [\u06DD-\u06DF] / [\u06E0-\u06E4] / [\u06E7-\u06E8] / [\u06EA-\u06ED] / [\u0901-\u0903] / '\u093C' / [\u093E-\u094C] / '\u094D' / [\u0951-\u0954] / [\u0962-\u0963] / [\u0981-\u0983] / '\u09BC' / '\u09BE' / '\u09BF' / [\u09C0-\u09C4] / [\u09C7-\u09C8] / [\u09CB-\u09CD] / '\u09D7' / [\u09E2-\u09E3] / '\u0A02' / '\u0A3C' / '\u0A3E' / '\u0A3F' / [\u0A40-\u0A42] / [\u0A47-\u0A48] / [\u0A4B-\u0A4D] / [\u0A70-\u0A71] / [\u0A81-\u0A83] / '\u0ABC' / [\u0ABE-\u0AC5] / [\u0AC7-\u0AC9] / [\u0ACB-\u0ACD] / [\u0B01-\u0B03] / '\u0B3C' / [\u0B3E-\u0B43] / [\u0B47-\u0B48] / [\u0B4B-\u0B4D] / [\u0B56-\u0B57] / [\u0B82-\u0B83] / [\u0BBE-\u0BC2] / [\u0BC6-\u0BC8] / [\u0BCA-\u0BCD] / '\u0BD7' / [\u0C01-\u0C03] / [\u0C3E-\u0C44] / [\u0C46-\u0C48] / [\u0C4A-\u0C4D] / [\u0C55-\u0C56] / [\u0C82-\u0C83] / [\u0CBE-\u0CC4] / [\u0CC6-\u0CC8] / [\u0CCA-\u0CCD] / [\u0CD5-\u0CD6] / [\u0D02-\u0D03] / [\u0D3E-\u0D43] / [\u0D46-\u0D48] / [\u0D4A-\u0D4D] / '\u0D57' / '\u0E31' / [\u0E34-\u0E3A] / [\u0E47-\u0E4E] / '\u0EB1' / [\u0EB4-\u0EB9] / [\u0EBB-\u0EBC] / [\u0EC8-\u0ECD] / [\u0F18-\u0F19] / '\u0F35' / '\u0F37' / '\u0F39' / '\u0F3E' / '\u0F3F' / [\u0F71-\u0F84] / [\u0F86-\u0F8B] / [\u0F90-\u0F95] / '\u0F97' / [\u0F99-\u0FAD] / [\u0FB1-\u0FB7] / '\u0FB9' / [\u20D0-\u20DC] / '\u20E1' / [\u302A-\u302F] / '\u3099' / '\u309A'

// http://www.w3.org/TR/xml/#NT-Ideographic
Ideographic	= [\u4E00-\u9FA5] / '\u3007' / [\u3021-\u3029]

NameChar = NameStartChar / "-" / "." / [0-9] / '\u00B7' / [\u0300-\u036F] / [\u203F-\u2040]
NameStartChar = ":" / [A-Z] / "_" / [a-z] / [\u00C0-\u00D6] / [\u00D8-\u00F6] / [\u00F8-\u02FF] / [\u0370-\u037D] / [\u037F-\u1FFF] / [\u200C-\u200D] / [\u2070-\u218F] / [\u2C00-\u2FEF] / [\u3001-\uD7FF] / [\uF900-\uFDCF] / [\uFDF0-\uFFFD] / [\u10000-\uEFFFF]

// http://www.w3.org/TR/xml/#NT-Reference
Reference = EntityRef / CharRef
EntityRef = '&' Name SEMICOLON
CharRef = '&#' [0-9]+ SEMICOLON
		/ '&#x' [0-9a-fA-F]+ SEMICOLON

// http://www.w3.org/TR/xml/#NT-BaseChar
BaseChar = [\u0041-\u005A] / [\u0061-\u007A] / [\u00C0-\u00D6] / [\u00D8-\u00F6] / [\u00F8-\u00FF] / [\u0100-\u0131] / [\u0134-\u013E] / [\u0141-\u0148] / [\u014A-\u017E] / [\u0180-\u01C3] / [\u01CD-\u01F0] / [\u01F4-\u01F5] / [\u01FA-\u0217] / [\u0250-\u02A8] / [\u02BB-\u02C1] / '\u0386' / [\u0388-\u038A] / '\u038C' / [\u038E-\u03A1] / [\u03A3-\u03CE] / [\u03D0-\u03D6] / '\u03DA' / '\u03DC' / '\u03DE' / '\u03E0' / [\u03E2-\u03F3] / [\u0401-\u040C] / [\u040E-\u044F] / [\u0451-\u045C] / [\u045E-\u0481] / [\u0490-\u04C4] / [\u04C7-\u04C8] / [\u04CB-\u04CC] / [\u04D0-\u04EB] / [\u04EE-\u04F5] / [\u04F8-\u04F9] / [\u0531-\u0556] / '\u0559' / [\u0561-\u0586] / [\u05D0-\u05EA] / [\u05F0-\u05F2] / [\u0621-\u063A] / [\u0641-\u064A] / [\u0671-\u06B7] / [\u06BA-\u06BE] / [\u06C0-\u06CE] / [\u06D0-\u06D3] / '\u06D5' / [\u06E5-\u06E6] / [\u0905-\u0939] / '\u093D' / [\u0958-\u0961] / [\u0985-\u098C] / [\u098F-\u0990] / [\u0993-\u09A8] / [\u09AA-\u09B0] / '\u09B2' / [\u09B6-\u09B9] / [\u09DC-\u09DD] / [\u09DF-\u09E1] / [\u09F0-\u09F1] / [\u0A05-\u0A0A] / [\u0A0F-\u0A10] / [\u0A13-\u0A28] / [\u0A2A-\u0A30] / [\u0A32-\u0A33] / [\u0A35-\u0A36] / [\u0A38-\u0A39] / [\u0A59-\u0A5C] / '\u0A5E' / [\u0A72-\u0A74] / [\u0A85-\u0A8B] / '\u0A8D' / [\u0A8F-\u0A91] / [\u0A93-\u0AA8] / [\u0AAA-\u0AB0] / [\u0AB2-\u0AB3] / [\u0AB5-\u0AB9] / '\u0ABD' / '\u0AE0' / [\u0B05-\u0B0C] / [\u0B0F-\u0B10] / [\u0B13-\u0B28] / [\u0B2A-\u0B30] / [\u0B32-\u0B33] / [\u0B36-\u0B39] / '\u0B3D' / [\u0B5C-\u0B5D] / [\u0B5F-\u0B61] / [\u0B85-\u0B8A] / [\u0B8E-\u0B90] / [\u0B92-\u0B95] / [\u0B99-\u0B9A] / '\u0B9C' / [\u0B9E-\u0B9F] / [\u0BA3-\u0BA4] / [\u0BA8-\u0BAA] / [\u0BAE-\u0BB5] / [\u0BB7-\u0BB9] / [\u0C05-\u0C0C] / [\u0C0E-\u0C10] / [\u0C12-\u0C28] / [\u0C2A-\u0C33] / [\u0C35-\u0C39] / [\u0C60-\u0C61] / [\u0C85-\u0C8C] / [\u0C8E-\u0C90] / [\u0C92-\u0CA8] / [\u0CAA-\u0CB3] / [\u0CB5-\u0CB9] / '\u0CDE' / [\u0CE0-\u0CE1] / [\u0D05-\u0D0C] / [\u0D0E-\u0D10] / [\u0D12-\u0D28] / [\u0D2A-\u0D39] / [\u0D60-\u0D61] / [\u0E01-\u0E2E] / '\u0E30' / [\u0E32-\u0E33] / [\u0E40-\u0E45] / [\u0E81-\u0E82] / '\u0E84' / [\u0E87-\u0E88] / '\u0E8A' / '\u0E8D' / [\u0E94-\u0E97] / [\u0E99-\u0E9F] / [\u0EA1-\u0EA3] / '\u0EA5' / '\u0EA7' / [\u0EAA-\u0EAB] / [\u0EAD-\u0EAE] / '\u0EB0' / [\u0EB2-\u0EB3] / '\u0EBD' / [\u0EC0-\u0EC4] / [\u0F40-\u0F47] / [\u0F49-\u0F69] / [\u10A0-\u10C5] / [\u10D0-\u10F6] / '\u1100' / [\u1102-\u1103] / [\u1105-\u1107] /'\u1109' / [\u110B-\u110C] / [\u110E-\u1112] / '\u113C' / '\u113E' / '\u1140' / '\u114C' / '\u114E' / '\u1150' / [\u1154-\u1155] / '\u1159' / [\u115F-\u1161] / '\u1163' / '\u1165' / '\u1167' / '\u1169' / [\u116D-\u116E] / [\u1172-\u1173] / '\u1175' / '\u119E' / '\u11A8' / '\u11AB' / [\u11AE-\u11AF] / [\u11B7-\u11B8] / '\u11BA' / [\u11BC-\u11C2] / '\u11EB' / '\u11F0' / '\u11F9' / [\u1E00-\u1E9B] / [\u1EA0-\u1EF9] / [\u1F00-\u1F15] / [\u1F18-\u1F1D] / [\u1F20-\u1F45] / [\u1F48-\u1F4D] / [\u1F50-\u1F57] / '\u1F59' / '\u1F5B' / '\u1F5D' / [\u1F5F-\u1F7D] / [\u1F80-\u1FB4] / [\u1FB6-\u1FBC] / '\u1FBE' / [\u1FC2-\u1FC4] / [\u1FC6-\u1FCC] / [\u1FD0-\u1FD3] / [\u1FD6-\u1FDB] / [\u1FE0-\u1FEC] / [\u1FF2-\u1FF4] / [\u1FF6-\u1FFC] / '\u2126' / [\u212A-\u212B] / '\u212E' / [\u2180-\u2182] / [\u3041-\u3094] / [\u30A1-\u30FA] / [\u3105-\u312C] / [\uAC00-\uD8A3]

/* http://www.w3.org/TR/xml/#NT-S
   S (white space) consists of one or more space (#x20) characters, carriage returns, line feeds, or tabs.
   S	   ::=   	(#x20 | #x9 | #xD | #xA)+
 */
S = ('\x20' / '\x09' / '\x0d' / '\x0a')+


//とりあえず保留・・・
XmlPattern = ElemPattern {return {type:"XmlPattern"};}
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

ScalaPatterns = OPBRACE Patterns CLBRACE

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

