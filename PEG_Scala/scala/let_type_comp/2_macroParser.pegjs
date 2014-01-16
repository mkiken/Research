CheckOuterMacro
 = { return outerMacro; }

CharacterStatement
 = &{}

OneLine
 = &{}

start
 = CompilationUnit

ExpressionMacro
 = (&{ return macroType; } form:(t0:("Let" !IdentifierPart
{ return { type: "MacroName", name:"Let" }; }) __ t1:("(" __ t0:(t0:(v:MacroKeyword &{ return v.name === "="; }
{ return v; }) __ t1:Expr __ t2:(","
{ return { type: "PunctuationMark", value: "," }; }) __ t3:MacroIdentifier __ t4:(","
{ return { type: "PunctuationMark", value: "," }; }) __ t5:MacroIdentifier __ t6:(v:MacroKeyword &{ return v.name === "="; }
{ return v; }) __ t7:Expr __ t8:(","
{ return { type: "PunctuationMark", value: "," }; }) __ t9:Type { return [t0, t1, t2, t3, t4, t5, t6, t7, t8, t9]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) __ t2:("{" __ t0:(t0:Expr { return [t0]; }) __ "}"
{ return { type: "Brace", elements: t0 }; }) { return [t0, t1, t2]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / (&{ return macroType; } form:(t0:("Let" !IdentifierPart
{ return { type: "MacroName", name:"Let" }; }) __ t1:("(" __ t0:(t0:Expr __ t1:(","
{ return { type: "PunctuationMark", value: "," }; }) __ t2:MacroIdentifier __ t3:(","
{ return { type: "PunctuationMark", value: "," }; }) __ t4:MacroIdentifier __ t5:(v:MacroKeyword &{ return v.name === "="; }
{ return v; }) __ t6:Expr __ t7:(","
{ return { type: "PunctuationMark", value: "," }; }) __ t8:Type { return [t0, t1, t2, t3, t4, t5, t6, t7, t8]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) __ t2:("{" __ t0:(t0:Expr { return [t0]; }) __ "}"
{ return { type: "Brace", elements: t0 }; }) { return [t0, t1, t2]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / (&{ return macroType; } form:(t0:("Let" !IdentifierPart
{ return { type: "MacroName", name:"Let" }; }) __ t1:("(" __ t0:(t0:(","
{ return { type: "PunctuationMark", value: "," }; }) __ t1:MacroIdentifier __ t2:(","
{ return { type: "PunctuationMark", value: "," }; }) __ t3:MacroIdentifier __ t4:(v:MacroKeyword &{ return v.name === "="; }
{ return v; }) __ t5:Expr __ t6:(","
{ return { type: "PunctuationMark", value: "," }; }) __ t7:Type { return [t0, t1, t2, t3, t4, t5, t6, t7]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) __ t2:("{" __ t0:(t0:Expr { return [t0]; }) __ "}"
{ return { type: "Brace", elements: t0 }; }) { return [t0, t1, t2]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / (&{ return macroType; } form:(t0:("Let" !IdentifierPart
{ return { type: "MacroName", name:"Let" }; }) __ t1:("(" __ t0:(t0:MacroIdentifier __ t1:(","
{ return { type: "PunctuationMark", value: "," }; }) __ t2:MacroIdentifier __ t3:(v:MacroKeyword &{ return v.name === "="; }
{ return v; }) __ t4:Expr __ t5:(","
{ return { type: "PunctuationMark", value: "," }; }) __ t6:Type { return [t0, t1, t2, t3, t4, t5, t6]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) __ t2:("{" __ t0:(t0:Expr { return [t0]; }) __ "}"
{ return { type: "Brace", elements: t0 }; }) { return [t0, t1, t2]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / (&{ return macroType; } form:(t0:("Let" !IdentifierPart
{ return { type: "MacroName", name:"Let" }; }) __ t1:("(" __ t0:(t0:(","
{ return { type: "PunctuationMark", value: "," }; }) __ t1:MacroIdentifier __ t2:(v:MacroKeyword &{ return v.name === "="; }
{ return v; }) __ t3:Expr __ t4:(","
{ return { type: "PunctuationMark", value: "," }; }) __ t5:Type { return [t0, t1, t2, t3, t4, t5]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) __ t2:("{" __ t0:(t0:Expr { return [t0]; }) __ "}"
{ return { type: "Brace", elements: t0 }; }) { return [t0, t1, t2]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / (&{ return macroType; } form:(t0:("Let" !IdentifierPart
{ return { type: "MacroName", name:"Let" }; }) __ t1:("(" __ t0:(t0:MacroIdentifier __ t1:(v:MacroKeyword &{ return v.name === "="; }
{ return v; }) __ t2:Expr __ t3:(","
{ return { type: "PunctuationMark", value: "," }; }) __ t4:Type { return [t0, t1, t2, t3, t4]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) __ t2:("{" __ t0:(t0:Expr { return [t0]; }) __ "}"
{ return { type: "Brace", elements: t0 }; }) { return [t0, t1, t2]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / (&{ return macroType; } form:(t0:("Let" !IdentifierPart
{ return { type: "MacroName", name:"Let" }; }) __ t1:("(" __ t0:(t0:(v:MacroKeyword &{ return v.name === "="; }
{ return v; }) __ t1:Expr __ t2:(","
{ return { type: "PunctuationMark", value: "," }; }) __ t3:Type { return [t0, t1, t2, t3]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) __ t2:("{" __ t0:(t0:Expr { return [t0]; }) __ "}"
{ return { type: "Brace", elements: t0 }; }) { return [t0, t1, t2]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / (&{ return macroType; } form:(t0:("Let" !IdentifierPart
{ return { type: "MacroName", name:"Let" }; }) __ t1:("(" __ t0:(t0:Expr __ t1:(","
{ return { type: "PunctuationMark", value: "," }; }) __ t2:Type { return [t0, t1, t2]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) __ t2:("{" __ t0:(t0:Expr { return [t0]; }) __ "}"
{ return { type: "Brace", elements: t0 }; }) { return [t0, t1, t2]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / (&{ return macroType; } form:(t0:("Let" !IdentifierPart
{ return { type: "MacroName", name:"Let" }; }) __ t1:("(" __ t0:(t0:(","
{ return { type: "PunctuationMark", value: "," }; }) __ t1:Type { return [t0, t1]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) __ t2:("{" __ t0:(t0:Expr { return [t0]; }) __ "}"
{ return { type: "Brace", elements: t0 }; }) { return [t0, t1, t2]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / (&{ return macroType; } form:(t0:("Let" !IdentifierPart
{ return { type: "MacroName", name:"Let" }; }) __ t1:("(" __ t0:(t0:Type { return [t0]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) __ t2:("{" __ t0:(t0:Expr { return [t0]; }) __ "}"
{ return { type: "Brace", elements: t0 }; }) { return [t0, t1, t2]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / (&{ return macroType; } form:(t0:("Let" !IdentifierPart
{ return { type: "MacroName", name:"Let" }; }) __ t1:("(" __ ")"
{ return { type: "Paren", elements: [] }; }) __ t2:("{" __ t0:(t0:Expr { return [t0]; }) __ "}"
{ return { type: "Brace", elements: t0 }; }) { return [t0, t1, t2]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / (&{ return macroType; } form:(t0:("Let" !IdentifierPart
{ return { type: "MacroName", name:"Let" }; }) __ t1:("{" __ t0:(t0:Expr { return [t0]; }) __ "}"
{ return { type: "Brace", elements: t0 }; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / (&{ return macroType; } form:(t0:("Let" !IdentifierPart
{ return { type: "MacroName", name:"Let" }; }) __ t1:("{" __ "}"
{ return { type: "Brace", elements: [] }; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / form:(t0:("Let" !IdentifierPart
{ return { type: "MacroName", name:"Let" }; }) __ t1:("(" __ t0:(t0:MacroIdentifier __ t1:(v:MacroKeyword &{ return v.name === "="; }
{ return v; }) __ t2:Expr __ t3:(","
{ return { type: "PunctuationMark", value: "," }; }) __ t4:MacroIdentifier __ t5:(","
{ return { type: "PunctuationMark", value: "," }; }) __ t6:MacroIdentifier __ t7:(v:MacroKeyword &{ return v.name === "="; }
{ return v; }) __ t8:Expr __ t9:(","
{ return { type: "PunctuationMark", value: "," }; }) __ t10:Type { return [t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) __ t2:("{" __ t0:(t0:Expr { return [t0]; }) __ "}"
{ return { type: "Brace", elements: t0 }; }) { return [t0, t1, t2]; })
{ return { type: "MacroForm", inputForm: form }; }

RejectWords
 = "," 
 / "="


