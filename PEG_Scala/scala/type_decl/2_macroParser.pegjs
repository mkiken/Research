CheckOuterMacro
 = { return outerMacro; }

CharacterStatement
 = &{}

OneLine
 = &{}

start
 = CompilationUnit

ExpressionMacro
 = (&{ return macroType; } form:(t0:("Decl" !IdentifierPart
{ return { type: "MacroName", name:"Decl" }; }) __ t1:("(" __ t0:(t0:(","
{ return { type: "PunctuationMark", value: "," }; }) __ t1:MacroIdentifier __ t2:(","
{ return { type: "PunctuationMark", value: "," }; }) __ t3:Type { return [t0, t1, t2, t3]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / (&{ return macroType; } form:(t0:("Decl" !IdentifierPart
{ return { type: "MacroName", name:"Decl" }; }) __ t1:("(" __ t0:(t0:MacroIdentifier __ t1:(","
{ return { type: "PunctuationMark", value: "," }; }) __ t2:Type { return [t0, t1, t2]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / (&{ return macroType; } form:(t0:("Decl" !IdentifierPart
{ return { type: "MacroName", name:"Decl" }; }) __ t1:("(" __ t0:(t0:(","
{ return { type: "PunctuationMark", value: "," }; }) __ t1:Type { return [t0, t1]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / (&{ return macroType; } form:(t0:("Decl" !IdentifierPart
{ return { type: "MacroName", name:"Decl" }; }) __ t1:("(" __ t0:(t0:Type { return [t0]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / (&{ return macroType; } form:(t0:("Decl" !IdentifierPart
{ return { type: "MacroName", name:"Decl" }; }) __ t1:("(" __ ")"
{ return { type: "Paren", elements: [] }; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / form:(t0:("Decl" !IdentifierPart
{ return { type: "MacroName", name:"Decl" }; }) __ t1:("(" __ t0:(t0:Expr __ t1:(","
{ return { type: "PunctuationMark", value: "," }; }) __ t2:MacroIdentifier __ t3:(","
{ return { type: "PunctuationMark", value: "," }; }) __ t4:Type { return [t0, t1, t2, t3, t4]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; }

RejectWords
 = ","

