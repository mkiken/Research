CheckOuterMacro
 = { return outerMacro; }

CharacterStatement
 = &{}

OneLine
 = &{}

start
 = CompilationUnit

ExpressionMacro
 = (&{ return macroType; } form:(t0:("ルート" !IdentifierPart
{ return { type: "MacroName", name:"ルート" }; }) __ t1:("(" __ t0:(t0:(v:MacroKeyword &{ return v.name === "から"; }
{ return v; }) __ t1:MacroSymbol __ t2:(v:MacroKeyword &{ return v.name === "まで"; }
{ return v; }) __ t3:MacroSymbol __ t4:(v:MacroKeyword &{ return v.name === "で"; }
{ return v; }) { return [t0, t1, t2, t3, t4]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / (&{ return macroType; } form:(t0:("ルート" !IdentifierPart
{ return { type: "MacroName", name:"ルート" }; }) __ t1:("(" __ t0:(t0:MacroSymbol __ t1:(v:MacroKeyword &{ return v.name === "まで"; }
{ return v; }) __ t2:MacroSymbol __ t3:(v:MacroKeyword &{ return v.name === "で"; }
{ return v; }) { return [t0, t1, t2, t3]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / (&{ return macroType; } form:(t0:("ルート" !IdentifierPart
{ return { type: "MacroName", name:"ルート" }; }) __ t1:("(" __ t0:(t0:(v:MacroKeyword &{ return v.name === "まで"; }
{ return v; }) __ t1:MacroSymbol __ t2:(v:MacroKeyword &{ return v.name === "で"; }
{ return v; }) { return [t0, t1, t2]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / (&{ return macroType; } form:(t0:("ルート" !IdentifierPart
{ return { type: "MacroName", name:"ルート" }; }) __ t1:("(" __ t0:(t0:MacroSymbol __ t1:(v:MacroKeyword &{ return v.name === "で"; }
{ return v; }) { return [t0, t1]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / (&{ return macroType; } form:(t0:("ルート" !IdentifierPart
{ return { type: "MacroName", name:"ルート" }; }) __ t1:("(" __ t0:(t0:(v:MacroKeyword &{ return v.name === "で"; }
{ return v; }) { return [t0]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / (&{ return macroType; } form:(t0:("ルート" !IdentifierPart
{ return { type: "MacroName", name:"ルート" }; }) __ t1:("(" __ ")"
{ return { type: "Paren", elements: [] }; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / form:(t0:("ルート" !IdentifierPart
{ return { type: "MacroName", name:"ルート" }; }) __ t1:("(" __ t0:(t0:MacroSymbol __ t1:(v:MacroKeyword &{ return v.name === "から"; }
{ return v; }) __ t2:MacroSymbol __ t3:(v:MacroKeyword &{ return v.name === "まで"; }
{ return v; }) __ t4:MacroSymbol __ t5:(v:MacroKeyword &{ return v.name === "で"; }
{ return v; }) { return [t0, t1, t2, t3, t4, t5]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; }

RejectWords
 = "から" 
 / "まで" 
 / "で"


