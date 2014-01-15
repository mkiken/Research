CheckOuterMacro
 = { return outerMacro; }

CharacterStatement
 = &{}

OneLine
 = &{}

start
 = CompilationUnit

ExpressionMacro
 = (&{ return macroType; } form:(t0:("Or" !IdentifierPart
{ return { type: "MacroName", name:"Or" }; }) __ t1:("(" __ ")"
{ return { type: "Paren", elements: [] }; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / form:(t0:("Or" !IdentifierPart
{ return { type: "MacroName", name:"Or" }; }) __ t1:("(" __ t0:(t0:MacroIdentifier { return [t0]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; }


