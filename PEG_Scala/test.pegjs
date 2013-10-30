
and = [&]

op = ([*/%] / [+\-] / ':' / [=!~] / [<>] / '&' / '^' / '|')



/* seqNt = nt+ */
/* nt = !'a' . */
/* seq = notDQ+ */
/* notDQ = ![\\\\"] [a-z] */

stringLiteral = ('"' stringElement* '"') __
//stringLiteral = ('"' stringElement* '"' / '"""' multiLineChars '"""') __

stringElement	= printableCharNoDoubleQuote
				/ charEscapeSeq
multiLineChars = ('"'? '"'? charNoDoubleQuote)* '"'*
charNoDoubleQuote = !'"' .

charEscapeSeq	= '\\b' / '\\u0008'
				/ '\\t' / '\\u0009'
				/ '\\n' / '\\u000a'
				/ '\\f' / '\\u000c'
				/ '\\r' / '\\u000d'
				/ '\\"' / '\\u0022'
				/ "\\'" / '\\u0027'
				/ '\\' / '\\u005c'
printableChar = !charEscapeSeq .

printableCharNoDoubleQuote = !'"' printableChar

B = '\t'

A = 'a'+

semi = (SEMICOLON / nl+)
nl = "\r\n" / "\n" / "\r"
SEMICOLON = ';' __
__
  = (whitespace / comment)*
whitespace = [\u0020\u0009\u000D\u000A]
comment = singleLineComment / multiLineComment

singleLineComment = '//' (!'\n' . )* '\n'
multiLineComment = [/][*] ((&"/*" multiLineComment) / (!"*/" . ))* [*][/]
//Empty = &. / !.



//comment = SingleLineComment / MultiLineComment
//SingleLineComment = '//' (!'\n' . )* '\n'
//MultiLineComment = [/][*] ((&"/*" MultiLineComment) / (!"*/" . ))* [*][/]
//’iii’



/* chr = '\t' */
/* range = [\u0020-\u0021] */
/* start = "Scala!" */
