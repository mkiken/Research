CheckOuterMacro
 = { return outerMacro; }

CharacterStatement
 = &{}

OneLine
 = &{}

start
 = CompilationUnit

ExpressionMacro
 = form:(t0:("Abs" !IdentifierPart
{ return { type: "MacroName", name:"Abs" }; }) __ t1:MacroIdentifier { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; }


