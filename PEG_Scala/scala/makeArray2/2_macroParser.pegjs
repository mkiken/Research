CheckOuterMacro
 = { return outerMacro; }

CharacterStatement
 = &{}

OneLine
 = &{}

start
 = CompilationUnit

ExpressionMacro
 = (&{ return macroType; } form:(t0:("makeArray" !IdentifierPart
{ return { type: "MacroName", name:"makeArray" }; }) __ t1:Expr { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / form:(t0:("makeArray" !IdentifierPart
{ return { type: "MacroName", name:"makeArray" }; }) __ t1:Expr __ t2:Expr { return [t0, t1, t2]; })
{ return { type: "MacroForm", inputForm: form }; }


