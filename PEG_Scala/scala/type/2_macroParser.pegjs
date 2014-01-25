CheckOuterMacro
 = { return outerMacro; }

CharacterStatement
 = &{}

OneLine
 = &{}

start
 = CompilationUnit

TypeMacro
 = form:(t0:("T" !IdentifierPart
{ return { type: "MacroName", name:"T" }; }) __ t1:(v:MacroKeyword &{ return v.name === "a"; }
{ return v; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; } 
 / form:(t0:("T" !IdentifierPart
{ return { type: "MacroName", name:"T" }; }) __ t1:(v:MacroKeyword &{ return v.name === "f"; }
{ return v; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; } 
 / form:(t0:("L" !IdentifierPart
{ return { type: "MacroName", name:"L" }; }) __ t1:(v:MacroKeyword &{ return v.name === "w"; }
{ return v; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; } 
 / form:(t0:("F" !IdentifierPart
{ return { type: "MacroName", name:"F" }; }) __ t1:(v:MacroKeyword &{ return v.name === "e"; }
{ return v; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; }

RejectWords
 = "a" 
 / "f" 
 / "w" 
 / "e"


