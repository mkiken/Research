CheckOuterMacro
 = { return outerMacro; }

CharacterStatement
 = &{}

OneLine
 = &{}

start
 = CompilationUnit

ExpressionMacro
 = form:(t0:(">>" !IdentifierPart
{ return { type: "MacroName", name:">>" }; }) __ t1:MacroSymbol __ t2:MacroSymbol { return [t0, t1, t2]; })
{ return { type: "MacroForm", inputForm: form }; } 
 / form:(t0:(">>" !IdentifierPart
{ return { type: "MacroName", name:">>" }; }) __ t1:MacroSymbol { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; }


