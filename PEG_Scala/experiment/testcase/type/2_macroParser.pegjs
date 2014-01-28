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
{ return { type: "MacroName", name:"T" }; }) __ t1:(v:Literal &{ return v.type === "floatingPointLiteral" && String(v.value) == "1.1"; }
										{ return v; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; } 
 / form:(t0:("T" !IdentifierPart
{ return { type: "MacroName", name:"T" }; }) __ t1:(v:Literal &{ return v.type === "floatingPointLiteral" && String(v.value) == "1.2"; }
										{ return v; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; } 
 / form:(t0:("L" !IdentifierPart
{ return { type: "MacroName", name:"L" }; }) __ t1:(v:Literal &{ return v.type === "symbolLiteral" && String(v.value) == "str"; }
										{ return v; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; } 
 / form:(t0:("F" !IdentifierPart
{ return { type: "MacroName", name:"F" }; }) __ t1:("(" __ t0:(t0:MacroIdentifier { return [t0]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; } 
 / (&{ return macroType; } form:(t0:("F" !IdentifierPart
{ return { type: "MacroName", name:"F" }; }) __ t1:("(" __ ")"
{ return { type: "Paren", elements: [] }; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; })

RejectWords
 = "1.1" 
 / "1.2" 
 / "str"


