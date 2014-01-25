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
{ return { type: "MacroName", name:"makeArray" }; }) __ t1:("[" __ t0:(t0:(v:MacroKeyword &{ return v.name === ".."; }
{ return v; }) __ t1:Expr { return [t0, t1]; }) __ "]"
{ return { type: "Bracket", elements: t0 }; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / (&{ return macroType; } form:(t0:("makeArray" !IdentifierPart
{ return { type: "MacroName", name:"makeArray" }; }) __ t1:("[" __ t0:(t0:Expr { return [t0]; }) __ "]"
{ return { type: "Bracket", elements: t0 }; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / (&{ return macroType; } form:(t0:("makeArray" !IdentifierPart
{ return { type: "MacroName", name:"makeArray" }; }) __ t1:("[" __ "]"
{ return { type: "Bracket", elements: [] }; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / form:(t0:("makeArray" !IdentifierPart
{ return { type: "MacroName", name:"makeArray" }; }) __ t1:("[" __ t0:(t0:Expr __ t1:(v:MacroKeyword &{ return v.name === ".."; }
{ return v; }) __ t2:Expr { return [t0, t1, t2]; }) __ "]"
{ return { type: "Bracket", elements: t0 }; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; }

RejectWords
 = ".."


