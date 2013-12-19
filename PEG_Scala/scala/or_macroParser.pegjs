CheckOuterMacro
 = { return outerMacro; }

Errors
 = ForbiddenInStatement

CharacterStatement
 = &{}

MacroExpression
 = form:(t0:("Or" !IdentifierPart
{ return { type: "MacroName", name:"Or" }; }) __ t1:("(" __ t0:(t0:Expr __ t1:(","
{ return { type: "PunctuationMark", value: "," }; }) __ t2:MacroIdentifier { return [t0, t1, t2]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; }


