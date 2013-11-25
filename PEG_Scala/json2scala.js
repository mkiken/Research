/*
 * Unparser for JavaScript
 * This program takes a JSON tree that represents an abstract syntax
 * tree for JavaScript code and converts it to a textual program.
 */

var fs = require('fs');

var buf = [], indentLevel = 0, whitespaces = '    ', bol = true;
function newline() { B.push('\n'); bol = true; }

var B = { // Buffer
	push: function (/* args */) {
		for (var i = 0; i < arguments.length; i++) {
			this.indent();
			buf.push(arguments[i]);
		}
	},
	params: function (names) {
		if (names.length > 0) B.push(ident(names[0]));
		for (var i = 1; i < names.length; i++)
			this.format(', ', ident(names[i]));
	},
	Tjoin: function (arr, separator) {
		if (arr.length === 0) return;
		T(arr[0]);
		for (var i = 1; i < arr.length; i++) { this.push(separator); T(arr[i]); }
	},
	separating: function (arr) {
		B.Tjoin(arr, ', ');
	},
	terminating: function (arr) {
		arr.forEach(function (a) { B.format(a, ';', newline); });
	},
	format: function (/* args */) {
		this.indent();
		for (var i = 0; i < arguments.length; i++) {
			var a = arguments[i];
			if (a == null) ;
			else if (Array.isArray(a)) {
				var sep = arguments[i+1]; i++;
				if (sep === ',') this.separating(a, sep);
				else if (sep === ';') this.terminating(a, sep);
			} else if (typeof a === 'object' && a.type) T(a);
			else if (typeof a === 'string') this.push(a);
			else if (typeof a === 'number') indentLevel += a;
			else if (typeof a === 'function') a();
			else console.error('I do not know what to do with: ', a);
		}
	},
	indent: function () {
		if (!bol) return;
		while (whitespaces.length < indentLevel)
			whitespaces += whitespaces;
		buf.push(whitespaces.substr(0, indentLevel));
		bol = false;
	},
	flush: function (fd) {
		if (fd) {
			newline();
			// console.log("|buf| = " + buf.length);
			buf.forEach(function (line) { fs.writeSync(fd, line); });
			this.reset();
		} else {
			var result = buf.join('');
			this.reset();
			return result;
		}
	},
	reset: function () { buf = []; indentLevel = 0; }
};

var unwanted_characters = '`.*';
function ident(identifier) {
	var chars = identifier.split('');
	for (var i = 0; i < chars.length; i++)
		if (unwanted_characters.indexOf(chars[i]) >= 0) chars[i] = '_';
	return chars.join('');
}

// my unparser
var unparser = {
	CompilationUnit: function(t){
		t.packages.forEach(function (v) {
			B.format('package ', v, newline);
		});
		T(t.topStatseq);
	},
	Identifier: function (t) { B.push(t.name); },
	/*
	   integerLiteral = ilit:(decimalNumeral / hexNumeral / octalNumeral) ll:('L' / 'l')? __ {
	   decimalNumeral	= '0'
	   hexNumeral = '0' 'x' parts:hexDigit+ __ {return "0x" + parts.join("");}
	   octalNumeral = '0' parts:octalDigit+ __ {return '0' + parts.join("");}
	   nonZeroDigit = [1-9]
	   octalDigit = [0-7]
	   floatingPointLiteral= dp:digit+ '.' ds:digit* exp:exponentPart? type:floatType? __ {return dp.join("") + '.' + ds.join("") + exp + type;}
	   exponentPart = exp:('E' / 'e') sign:('+' / '-')? dt:digit+ {return exp + sign + dt.join("");}
	   floatType = 'F' / 'f' / 'D' / 'd'
	   booleanLiteral = ret:('true' / 'false') __ {return {type: "booleanLiteral", value: chrs};}
	   characterLiteral = ['] chr:( printableChar / charEscapeSeq ) ['] __ {return chr;}*/
	stringLiteral : function(t){
		B.push('"', t.value, '"');
	},
	/*stringElement	= printableCharNoDoubleQuote
	  multiLineChars	= eles:multiLineCharsElements* ('"""""' / '""""' / '"""') {return eles.join("");}
	  multiLineCharsElements = chrs:('"'? '"'? charNoDoubleQuote) {return chrs.join("");}
	  symbolLiteral = "'" pi:plainid __ {return "'" + pi;}
	  comment = singleLineComment / multiLineComment
	  singleLineComment = '//' (!nl . )* nl+
	  multiLineComment = [/][*] ((&"/*" multiLineComment) / (!"/" . ))* [*][/]
	  __ = (whitespace / comment)*
	  nl = ("\r\n" / "\n" / "\r") __
	  semi = (SEMICOLON nl* / nl+)
	  whitespace = [\u0020\u0009]
	  Literal =
	  QualId = head:id tail:(DOT id)* {*/
	QualId: function (t) { B.Tjoin(t.contents, ', '); },
	/*
	   ids = head:id tail:(COMMA id)* {
	   Path	= StableId*/
	StableId: function (t) { B.Tjoin(t.contents, '.'); },
	/*
	 * ClassQualifier = OPBRACKET qual:id CLBRACKET {return {type: "ClassQualifier", id:qual};}
	 Type	= funcarg:FunctionArgTypes ARROW tp:Type {return {type:"FunctionType", left:funcarg, right:tp};}
	 FunctionArgTypes	= InfixType
	 ExistentialClause = 'forSome' __ OPBRACE ex:ExistentialDcl exs:(semi ExistentialDcl)* CLBRACE {
	 ExistentialDcl	= tp:TYPE dcl:TypeDcl {return {type:"ExistentialDcl", pre:tp, dcl:dcl}}
	 InfixType = head:CompoundType tails:(id nl? CompoundType)* {
	 CompoundType	= at:AnnotType wat:(WITH AnnotType)? ref:Refinement? {return {type:"CompoundType", annotType:[at, ftr(wat)], ref:ftr(ref)};}
	 AnnotType = st:SimpleType annotation:Annotation* {return {type:"AnnotType", st:st, annotation:annotation}; }
	 SimpleType =
	 withId = '#' __ id:id {return {type:"withId", id:id};}
	 TypeArgs = OPBRACKET types:Types CLBRACKET {return {type:"TypeArgs", types:types}; }
	 Types = tp:Type tps:(COMMA Type)* {
	 Refinement = nl? OPBRACE ref:RefineStat refs:(semi RefineStat)* CLBRACE {
	 RefineStat = Dcl
	 TypePat = Type
	 Ascription = COLON infix:InfixType {return {type:"Ascription", contents:[infix]}; }
	 Expr = left:(Bindings / IMPLICIT? id / UNDER) ARROW right:Expr {return {type:"AnonymousFunction", left:left, right:right}; }
	 Expr1 = IF OPPAREN condition:Expr CLPAREN nl* ifStatement:Expr elseStatement:(semi? 'else' __ Expr)? {*/
	PostfixExpression : function(t){
		B.format(t.infix, t.id);
	},
	InfixExpression: function(t){
		B.format(t.left);
		for(var i = 0; i < t.ops.length; i++){
			B.format(' ', t.ops[i], ' ', t.rights[i]);
		}
	},
	PrefixExpression : function(t){
		B.format(t.op, t.expr);
	},
	SimpleExpression : function(t){
		B.format(t.expr, t.under);
	},
	// SimpleExpr1 = OPPAREN exp:Exprs? CLPAREN se1:_SimpleExpr1 {return {type:"TupleExpression", expr:exp, suffix:se1}; }
	idSeqSimpleExpression : function(t){
		B.format(t.ids, t.suffix);
	},
	FunctionApplicationPostfix : function(t){
		B.format(t.argument, t.postfix);
	},

	/*_SimpleExpr1 = ud:UNDER? !(DOT id EQUAL) DOT id:id se1:_SimpleExpr1 {return {type:"DesignatorPostfix", under:ftr(ud), id:id, postfix:se1}; }*/
	Exprs : function(t){
		B.Tjoin(t.contents, ', ');
	},
	ArgumentExpression : function(t){
		B.format('( ', t.exprs, ' )');
	},
	literalSimpleExpression : function(t){
		B.format(t.literal, t.suffix);
	},
	/*BlockExpr = OPBRACE block:CaseClauses CLBRACE {return {type: "PatternMatchingAnonymousFunction", block:block};}*/
	Block : function(t){
		t.states.forEach(function (v) {
			if(v.type != "Empty") B.format(v, ';', newline);
			else B.format(newline);
		});
			if(t.res) B.format(t.res, ';', newline);
		// B.format(t.res, newline);
	},
	/*BlockStat = Import
	  ResultExpr =
	  Enumerators = gen:Generator enums:(semi Enumerator)* {
	  Enumerator = Generator
	  Generator = pt1:Pattern1 '<-' __ expr:Expr guard:Guard? {return {type: "Generator", pt1:pt1, expr:expr, guard:guard}; }
	  CaseClauses = cls:CaseClause+ {return {type: "CaseClauses", cls:cls};}
	  CaseClause = CASE pt:Pattern guard:Guard? ARROW block:Block {return {type: "Generator", pt:pt, guard:ftr(guard), block:block}; }
	  Guard = IF postfix:PostfixExpr {return {type: "Guard", postfix:postfix};}
	  Pattern = pt1:Pattern1 pt1s:( '|' __ Pattern1 )* {
	  Pattern1 = id:varid COLON tp:TypePat {return {type: "TypedPattern", id:id, tp:tp};}
	  Pattern2 = id:varid pt:(AT Pattern3)? {return {type: "PatternBinder", id:id, pt:pt!== ""? pt[1] : null};}
	  Pattern3 =
	  SimplePattern = UNDER
	  Patterns = head:Pattern tail:(COMMA Patterns)? {return {type: "Patterns", pattern:[head, tail]};}
	  TypeParamClause = OPBRACKET param:VariantTypeParam params:(COMMA VariantTypeParam)* CLBRACKET {
	  FunTypeParamClause = OPBRACKET param:TypeParam params:(COMMA TypeParam)* CLBRACKET {
	  VariantTypeParam = ans:Annotation* sign:(PLUS / HYPHEN)? param:TypeParam {return {type: "VariantTypeParam", annotations:ans, sign:sign, param:param};}
	  TypeParam = id:(id / UNDER) cl:TypeParamClause? tp1:(LEFTANGLE Type)? tp2:(RIGHTANGLE Type)?*/
	ParamClauses : function(t){
		t.clauses.forEach(function (v) {
			B.format(v);
		});
		if(t.params) B.format('(implicit ', t.params, ')');
	},
	ParamClause : function(t){
		B.format('(', t.params, ')');
	},
	/*Params = param:Param params:(COMMA Param)* {
	  Param = an:Annotation* id:id pt:(COLON ParamType)? expr:(EQUAL Expr)? {return {type:"Param", annotations:an, id:id, paramType:ftr(pt, 1), expr:expr}; }
	  ParamType = ar:ARROW tp:Type {return {type:"ParamType", allow:ar, tp:tp, star:null}; }
	  ClassParamClauses = cls:ClassParamClause* params:(nl? OPPAREN IMPLICIT ClassParams CLPAREN)? {return {type:"ClassParamClauses", cls:cls, params:params !== ""? params[3] : null}; }
	  ClassParamClause = nl? OPPAREN cp:ClassParams? CLPAREN {return {type:"ClassParamClause", params:ftr(cp)}; }
	  ClassParams = param:ClassParam params:(' ' ClassParam)*
	  ClassParam = an:Annotation* md:(Modifier* (VAL / VAR))? id:id COLON pt:ParamType exp:(EQUAL Expr)? {return {type:"ClassParam", annotations:an, modifier:ftr(md, 0), vax:ftr(md, 1), id:id, paramType:pt, exp:ftr(exp, 1)}; }
	  Bindings = OPPAREN bd:Binding bds:(COMMA Binding)* CLPAREN {
	  Binding = id:(id / UNDER) tp:(COLON Type)? {return {type:"Bindings", id:id, tp:ftr(tp, 1)}; }
	  Modifier = LocalModifier
	  LocalModifier = 'abstract' __ {return makeKeyword("abstract");}
	  AccessModifier = md:('private' / 'protected') __ qual:AccessQualifier? {return {type:"AccessModifier", modifier:makeKeyword(md), qualifier:ftr(qual)};}
	  AccessQualifier = OPBRACKET id:(id / THIS) CLBRACKET {return {type:"AccessQualifier", id:id};}
	  Annotation = AT stype:SimpleType exprs:ArgumentExprs* {return {type:"Annotation", stype:tp, exprs:exprs};}
	  ConstrAnnotation = AT tp:SimpleType exprs:ArgumentExprs {return {type:"ConstrAnnotation", stype:tp, exprs:exprs};}
	  NameValuePair = VAL id:id EQUAL prefix:PrefixExpr {return {type:"NameValuePair", id:id, prefix:prefix};}*/
	TemplateBody : function(t){
		B.format('{', 1, t.selftype, newline);
		t.states.forEach(function (v) {
			B.format(v);
		});
		B.format(newline, -1, '}');
	},
	/*SelfType = id:id tp:(COLON Type)? ARROW {return {type:"SelfType", id:id, tp:ftr(tp,1)};}*/
	TemplateStatement : function(t){
		t.annotation.forEach(function (v) {
			B.format(v, newline);
		});
		t.modifier.forEach(function (v) {
			B.format(v, ' ');
		});
		T(t.definition);
	},

	ImportStatement : function(t){
		B.push("import ");
		B.Tjoin(t.exprs, ', ');
		B.push(";");
	},
	ImportExpr : function(t){
		T(t.id);
		if(t.selector){
			B.push(".");
			T(t.selector);
		}
	},
	/*ImportSelectors = OPBRACE heads:(ImportSelector COMMA)* tail:(ImportSelector / UNDER) CLBRACE {
	  ImportSelector = head:id tail:(ARROW id / ARROW UNDER)? {return {type:"ImportSelector", src:head, dest:ftr(tail,1)};}
	  Dcl = dcl:VAL body:ValDcl {return {type:"Declaration", dcl:dcl, body:body};}
	  ValDcl = id:ids COLON tp:Type {return {type:"ValueDeclaration", id:id, tp:tp};}
	  VarDcl = id:ids COLON tp:Type {return {type:"VariableDeclaration", id:id, tp:tp};}
	  FunDcl = sig:FunSig tp:(COLON Type)? {return {type:"FunctionDeclaration", signature:sig, tp:ftr(tp, 1)};}*/
	  FunctionSignature : function(t){
		B.format(t.id, t.funtype, t.param);
	},
	  /*TypeDcl = id:id tpc:TypeParamClause? t1:(LEFTANGLE Type)? t2:(RIGHTANGLE Type)? {return {type:"TypeDeclaration", id:id, typeparam:ftr(tpc), type1:ftr(t1), type2:ftr(t2)};}
	  PatVarDef = dcl:VAL body:PatDef {return {type:"PatValDef", body:body};}*/
	Definition: function(t){
		B.format(t.dcl, ' ', t.body);
	},
	/*PatDef = ptn:Pattern2 ptns:(COMMA Pattern2)* tp:(COLON Type)? EQUAL expr:Expr{
	  VarDef = PatDef
	  FunDef = fs:FunSig tp:(COLON Type)? EQUAL exp:Expr {return {type:"FunctionDefinition", signature:fs, tp:ftr(tp), expr:exp}; }*/
	Procedure: function(t){
		B.format(t.signature, ' {', 1, t.block, -1, '}');
	},
	/*TypeDef = id:id pm:TypeParamClause? EQUAL tp:Type {return {type:"TypeDef", id:id, param:ftr(pm), tp:tp}; }*/
	TemplateDefinition : function(t){
		// B.Tjoin(t.prefix, ' ');
		t.prefix.forEach(function (v) {
			if(v) B.format(v, ' ');
		});
		T(t.def);
	},
	/*
	   ClassDef = id:id tpc:TypeParamClause? ca:ConstrAnnotation* am:AccessModifier? cpc:ClassParamClauses cto:ClassTemplateOpt {return {type:"ClassDef", id:id, typeParam:ftr(tpc), annotation:ca, modifier:ftr(am), classParam:cpc, classTemplate:cto}; }
	   TraitDef = id:id tpc:TypeParamClause? tto:TraitTemplateOpt {return {type:"TraitDef", id:id, typeParam:tpc, traitTemplate:tto}; }*/
	ObjectDefinition: function(t){
		B.format(t.id, ' ', t.classTemplate);
	},
	ClassTemplateOpt: function(t){
		if(t.extend) B.format(t.extend, ' ', t.body);
		else if(t.body) B.format(t.body);
	},
	/*TraitTemplateOpt = ext:EXTENDS tt:TraitTemplate {return {type:"TraitTemplateOpt", extend:ext, body:tt}; }
	  ClassTemplate = ed:EarlyDefs? cp:ClassParents tb:TemplateBody? {return {type:"ClassTemplate", def:ftr(ed), classParent:cp, body:ftr(tb)}; }
	  TraitTemplate = ed:EarlyDefs? tp:TraitParents tb:TemplateBody? {return {type:"TraitTemplate", def:ftr(ed), traitParent:tp, body:ftr(tb)}; }
	  ClassParents = cst:Constr ats:(WITH AnnotType)* {return {type:"ClassParents", constr:cst, annotType:ats}; }
	  TraitParents = at:AnnotType ats:(WITH AnnotType)* {return {type:"TraitParents", annotType:at, annotType:ats}; }
	  Constr = at:AnnotType ae:ArgumentExprs* {return {type:"Constr", annotType:at, exprs:ae}; }
	  EarlyDefs = OPBRACE eds:(EarlyDef (semi EarlyDef)*)? CLBRACE WITH {
	  EarlyDef = an:(Annotation nl?)* md:Modifier* pvd:PatVarDef {
	  ConstrExpr = SelfInvocation
	  ConstrBlock = OPBRACE si:SelfInvocation bss:(semi BlockStat)* CLBRACE{
	  SelfInvocation = THIS ae:ArgumentExprs+ {return {type:"SelfInvocation", exprs:ae}; }*/
	TopStatSeq : function(t){
		t.topstat.forEach(function (v) {
			B.format(v, newline);
		});
	},
	TopStat : function(t){
		t.annotation.forEach(function (v) {
			B.format(v, newline);
		});
		t.modifier.forEach(function (v) {
			B.format(v, ' ');
		});
		T(t.def);
	},
	/*Packaging = PACKAGE qi:QualId nl? OPBRACE tss:TopStatSeq CLBRACE {return {type:"Packaging", qualId:qi, topStatseq:tss}; }
	  PackageObject = PACKAGE OBJECT od:ObjectDef {return {type:"PackageObject", def:od}; }
	  charEscapeSeq	= '\\b' / '\\u0008'
	  hexDigit = [0-9A-Fa-f]
	  printableChar = !charEscapeSeq chr:. {return chr;}
	  printableCharNoDoubleQuote = !'"' chr:printableChar {return chr;}
	  charNoDoubleQuote = !'"' chr:. {return chr;}*/
	Empty: function (t) { ; },
	Keyword: function (t) { B.push(t.word); },
	/*OBJECT = 'object' __ {return {type:"Keyword", word:"object"}}
	  EXTENDS = 'extends' __ {return {type:"Keyword", word:"extends"}}
	  XmlExpr = XmlContent Element* {return {type:"XmlExpr"};}
	  Element	= EmptyElemTag
	  EmptyElemTag = '<' Name (S Attribute)* S? '/>'
	  STag = '<' Name (S Attribute)* S? '>'
	  ETag = '</' Name S? '>'
	  Content = CharData? (Content1 CharData?)*
	  Content1	= XmlContent
	  XmlContent	= Element
	  Attribute = Name Eq AttValue
	  AttValue	= '"' (CharQ / CharRef)* '"'
	  ScalaExpr = Block
	  CharData = !(CharNoRef* OPBRACE CharB CharNoRef*) !(CharNoRef* ']]>' CharNoRef*) CharNoRef*
	  Char1 = !('<' / '&') Char
	  CharQ = !'"' Char1
	  CharA = !"'" Char1
	  CharB = !'{' Char1
	  Name = XNameStart NameChar*
	  XNameStart = !':' (UNDER / BaseChar / Ideographic)
	  Char = '\u0009' / '\u000A' / '\u000D' / [\u0020-\uD7FF] / [\uE000-\uFFFD] / [\u10000-\u10FFFF]
	  Comment	= '<!--' ((!'-' Char) / ('-' (!'-' Char)))* '-->'
	  Eq = S? EQUAL S?
	  Ideographic	= [\u4E00-\u9FA5] / '\u3007' / [\u3021-\u3029]
	  NameChar = NameStartChar / "-" / "." / [0-9] / '\u00B7' / [\u0300-\u036F] / [\u203F-\u2040]
	  NameStartChar = ":" / [A-Z] / "_" / [a-z] / [\u00C0-\u00D6] / [\u00D8-\u00F6] / [\u00F8-\u02FF] / [\u0370-\u037D] / [\u037F-\u1FFF] / [\u200C-\u200D] / [\u2070-\u218F] / [\u2C00-\u2FEF] / [\u3001-\uD7FF] / [\uF900-\uFDCF] / [\uFDF0-\uFFFD] / [\u10000-\uEFFFF]
	  Reference = EntityRef / CharRef
	  EntityRef = '&' Name SEMICOLON
	  CharRef = '&#' [0-9]+ SEMICOLON
	  BaseChar
	  S = ('\x20' / '\x09' / '\x0d' / '\x0a')+
	  XmlPattern = ElemPattern {return {type:"XmlPattern"};}
	  ElemPattern	= EmptyElemTagP
	  EmptyElemTagP = '<' Name S? '/>'
	  STagP = '<' Name S? '>'
	  ETagP = '</' Name S?'>'
	  ContentP = CharData? ((ElemPattern / ScalaPatterns) CharData?)*
	  ContentP1 = ElemPattern
	  ScalaPatterns = OPBRACE Patterns CLBRACE
	  CDSect = CDStart CData CDEnd
	  CDStart	= '<![CDATA['
	  CData = !(Char* ']]>' Char*) Char*
	  CDEnd = ']]>'
	  PI = '<?' PITarget (S (!(Char* '?>' Char*) Char*))? '?>'
	  PITarget = !(('X' / 'x') ('M' / 'm') ('L' / 'l')) Name
	  C
	 * */

	}

// homizu's unparser
/*
   var unparser = {
   BooleanLiteral: function (t) { B.push(t.value); },
   NullLiteral: function (t) { B.push('null'); },
   NumericLiteral: function (t) { B.push(t.value); },
   RegularExpressionLiteral: function (t) { B.push(t.body, t.flags); },
   StringLiteral: function (t) { B.push(JSON.stringify(t.value)); },

   ArrayLiteral: function (t) { B.format('[', t.elements, ',', ']'); },
   ObjectLiteral: function (t) { B.format('{', t.properties, ',', '}'); },

   This: function (t) { B.push('this'); },

   Function: function (t) {
   var isBOL = bol;
   if (t.name !== null) B.format('function ', ident(t.name), ' (');
   else B.push('function (');
   B.params(t.params);
   B.format(') {', 2, newline, t.elements, ';', -2, '}');
   if (isBOL) { B.push(';'); newline(); }
   },

   UnaryExpression: function (t) {
   B.format('(', t.operator, ' ', t.expression, ')');
   },
   PostfixExpression: function (t) {
   B.format('(', t.expression, ' ', t.operator, ')');
   },
   AssignmentExpression: function (t) {
   B.format('(', t.left, ' ', t.operator, ' ', t.right, ')');
   },
   BinaryExpression: function (t) {
   B.format('(', t.left, ' ', t.operator, ' ', t.right, ')');
   },
   ConditionalExpression: function (t) {
   B.format('(', t.condition, '?',
   t.trueExpression, ':', t.falseExpression, ')');
   },

   FunctionCall: function (t) {
   B.format('(', t.name, '(', t.arguments, ',', '))');
   },

   GetterDefinition: function (t) {
   B.format('get ', ident(t.name), ' {', 2, t.body, ';', -2, '}');
   },
   NewOperator: function (t) {
   B.format('(new ', t.constructor, '(', t.arguments, ',', '))');
   },
   PropertyAccess: function (t) {
   if (typeof t.name === 'string')
   B.format('(', t.base, '.', ident(t.name), ')');
   else B.format('(', t.base, '[', t.name, ']', ')');
   },
//  PropertyAccessProperty: function (t) { },
PropertyAssignment: function (t) {
B.format(t.name, ': ', t.value);
},
SetterDefinition: function (t) {
B.format('set ', ident(t.name), '(', t.param.map(ident), ',', ')',
t.body, ';');
},

Variable: function (t) { B.push(ident(t.name)); },
VariableDeclaration: function (t) {
if (t.value) B.format(t.name, ' = ', t.value);
else B.format(t.name);
},
VariableStatement: function (t) {
if (bol) B.format('var ', t.declarations, ',', ';', newline);
else B.format('var ', t.declarations, ',');
},

	BreakStatement: function (t) {
		if (t.label) B.format('break ', t.label);
		else B.push('break');
	},
	ContinueStatement: function (t) {
		if (t.label) B.format('continue ', t.label);
		else B.push('continue');
	},
	DebuggerStatement: function (t) { B.push('debugger'); },
	DoWhileStatement: function (t) {
		B.format('do ', t.statement);
		if (t.statement.type !== 'Block') B.format(';', newline);
		B.format('while (', t.condition, ')');
				},
				EmptyStatement: function (t) { B.push(';'); },
				ForInStatement: function (t) {
					B.format('for (var ', t.iterator, ' in ', t.collection, ') ',
						t.statement);
				},
				ForStatement: function (t) {
					B.format('for (', t.initializer, '; ', t.test, '; ', t.counter, ') ',
						t.statement, t.statement.type !== 'Block' ? ';' : '');
				},
				IfStatement: function (t) {
					B.format('if (', t.condition, ') ', t.ifStatement);
					if (t.elseStatement) {
						B.format(newline, 'else ', t.elseStatement);
						if (t.elseStatement !== 'Block') B.push(';');
					}
				},
				LabelledStatement: function (t) { B.format(t.label, ': ', t.statement); },
				ReturnStatement: function (t) {
					B.format('return ', t.value ? t.value : '');
				},
				SwitchStatement: function (t) {
					B.format('switch (', t.expression, ') {', 2, newline);
						t.clauses.forEach(T);
						B.format(-2, '}');
					},
					CaseClause: function (t) {
						B.format('case ', t.selector, ': ', 2, t.statements, ';', -2);
					},
					DefaultClause: function (t) {
						B.format('default: ', 2, t.statements, ';', -2);
					},
					TryStatement: function (t) {
						B.format('try ', t.block, t.catch, t.finally);
					},
					Catch: function (t) {
						B.format(' catch (', ident(t.identifier), ') ', t.block);
					},
					Finally: function (t) {
						B.format(' finally ', t.block);
					},
					ThrowStatement: function (t) { B.format('throw ', t.exception); },
					WhileStatement: function (t) {
						B.format('while (', t.condition, ') ', t.statement);
					},
					WithStatement: function (t) {
						B.format('with (', t.environment, ') ', t.statement);
					},

					Block: function (t) {
						if (t.statements.length === 0) B.format('{}');
						else B.format('{', 2, newline, t.statements, ';', -2, '}');
					},
					Program: function (t) {
						if (t.variables)
							t.variables.forEach(function (v) {
								B.format('var ', v, ';', newline);
							});
						t.elements.map(function (t) { T(t); });
					},
					ExpressionMacroDefinition: function (t) {},
					Characterstmt: function (t) {}
				};
*/

function T(t) {
	if (!t ) return;
	var unparse = unparser[t.type];
	if (unparse) return unparse(t);
	// throw(new Error({ message: 'Unknown type', t: JSON.stringify(t) }));
	throw new Error( 'Unknown type:::' + t.type + ':::' + JSON.stringify(t) );
}

exports.convert = function (t, output) {
	var fd = false;
	if (typeof output === 'number') fd = output;
	if (typeof output === 'string') {
		fd = fs.openSync(output, 'w');
	}
	B.format(B.reset, t);
	// B.format(t);
	var result = B.flush(fd);
	if (fd) fs.closeSync(fd);
	return result;
};
