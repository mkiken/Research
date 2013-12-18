CheckOuterMacro
 = { return outerMacro; }

Errors
 = ForbiddenInStatement

CharacterStatement
 = &{}

MacroExpression
 = form:(t0:("Let" !IdentifierPart
{ return { type: "MacroName", name:"Let" }; }) __ t1:("(" __ t0:(t0:MacroIdentifier __ t1:(v:MacroKeyword &{ return v.name === "="; }
{ return v; }) __ t2:Expr __ t3:(","
{ return { type: "PunctuationMark", value: "," }; }) __ t4:MacroIdentifier __ t5:(v:MacroKeyword &{ return v.name === "="; }
{ return v; }) __ t6:Expr { return [t0, t1, t2, t3, t4, t5, t6]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) __ t2:("{" __ t0:(t0:Expr { return [t0]; }) __ "}"
{ return { type: "Brace", elements: t0 }; }) { return [t0, t1, t2]; })
{ return { type: "MacroForm", inputForm: form }; }


