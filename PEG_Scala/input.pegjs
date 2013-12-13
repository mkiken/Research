Template
 = StatementInTemplate

CheckOuterMacro
 = { return outerMacro; }

Errors
 = ForbiddenInStatement

CharacterStatement
 = &{}

MacroExpression
 = form:(t0:("Let" !IdentifierPart
{ return { type: "MacroName", name:"Let" }; }) __ t1:("(" __ t0:(t0:MacroIdentifier __ t1:("="
{ return { type: "PunctuationMark", value: "=" }; }) __ t2:AssignmentExpression { return [t0, t1, t2]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) __ t2:("{" __ t0:(t0:AssignmentExpression { return [t0]; }) __ "}"
{ return { type: "Brace", elements: t0 }; }) { return [t0, t1, t2]; })
{ return { type: "MacroForm", inputForm: form }; } 
 / (&{ return macroType; } form:(t0:("Let" !IdentifierPart
{ return { type: "MacroName", name:"Let" }; }) __ t1:("(" __ t0:(t0:("="
{ return { type: "PunctuationMark", value: "=" }; }) __ t1:AssignmentExpression { return [t0, t1]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) __ t2:("{" __ t0:(t0:AssignmentExpression { return [t0]; }) __ "}"
{ return { type: "Brace", elements: t0 }; }) { return [t0, t1, t2]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / (&{ return macroType; } form:(t0:("Let" !IdentifierPart
{ return { type: "MacroName", name:"Let" }; }) __ t1:("(" __ t0:(t0:AssignmentExpression { return [t0]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) __ t2:("{" __ t0:(t0:AssignmentExpression { return [t0]; }) __ "}"
{ return { type: "Brace", elements: t0 }; }) { return [t0, t1, t2]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / (&{ return macroType; } form:(t0:("Let" !IdentifierPart
{ return { type: "MacroName", name:"Let" }; }) __ t1:("(" __ ")"
{ return { type: "Paren", elements: [] }; }) __ t2:("{" __ t0:(t0:AssignmentExpression { return [t0]; }) __ "}"
{ return { type: "Brace", elements: t0 }; }) { return [t0, t1, t2]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / (&{ return macroType; } form:(t0:("Let" !IdentifierPart
{ return { type: "MacroName", name:"Let" }; }) __ t1:("{" __ t0:(t0:AssignmentExpression { return [t0]; }) __ "}"
{ return { type: "Brace", elements: t0 }; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / (&{ return macroType; } form:(t0:("Let" !IdentifierPart
{ return { type: "MacroName", name:"Let" }; }) __ t1:("{" __ "}"
{ return { type: "Brace", elements: [] }; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; })


