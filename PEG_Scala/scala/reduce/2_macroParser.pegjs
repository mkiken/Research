CheckOuterMacro
 = { return outerMacro; }

CharacterStatement
 = &{}

OneLine
 = &{}

start
 = CompilationUnit

ExpressionMacro
 = (&{ return macroType; } form:(t0:("Reduce" !IdentifierPart
{ return { type: "MacroName", name:"Reduce" }; }) __ t1:("[" __ t0:(t0:Expr __ t1:(","
{ return { type: "PunctuationMark", value: "," }; }) __ t2:(head:Expr
 tail:(__ "," __ Expr)*
ellipsis:(__ "," __ "...")
{ var elements = [head];
  for (var i=0; i<tail.length; i++) {
    elements.push(tail[i][3]);
  }
  if (ellipsis) elements.push({ type: "Ellipsis" });
  return { type: "Repeat", elements: elements };
})
 { return [t0, t1, t2]; }) __ "]"
{ return { type: "Bracket", elements: t0 }; }) __ t2:("(" __ t0:(t0:MacroIdentifier { return [t0]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) __ t3:Expr { return [t0, t1, t2, t3]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / (&{ return macroType; } form:(t0:("Reduce" !IdentifierPart
{ return { type: "MacroName", name:"Reduce" }; }) __ t1:("[" __ t0:(t0:(","
{ return { type: "PunctuationMark", value: "," }; }) __ t1:(head:Expr
 tail:(__ "," __ Expr)*
ellipsis:(__ "," __ "...")
{ var elements = [head];
  for (var i=0; i<tail.length; i++) {
    elements.push(tail[i][3]);
  }
  if (ellipsis) elements.push({ type: "Ellipsis" });
  return { type: "Repeat", elements: elements };
})
 { return [t0, t1]; }) __ "]"
{ return { type: "Bracket", elements: t0 }; }) __ t2:("(" __ t0:(t0:MacroIdentifier { return [t0]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) __ t3:Expr { return [t0, t1, t2, t3]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / (&{ return macroType; } form:(t0:("Reduce" !IdentifierPart
{ return { type: "MacroName", name:"Reduce" }; }) __ t1:("[" __ t0:(t0:(head:Expr
 tail:(__ "," __ Expr)*
ellipsis:(__ "," __ "...")
{ var elements = [head];
  for (var i=0; i<tail.length; i++) {
    elements.push(tail[i][3]);
  }
  if (ellipsis) elements.push({ type: "Ellipsis" });
  return { type: "Repeat", elements: elements };
})
 { return [t0]; }) __ "]"
{ return { type: "Bracket", elements: t0 }; }) __ t2:("(" __ t0:(t0:MacroIdentifier { return [t0]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) __ t3:Expr { return [t0, t1, t2, t3]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / (&{ return macroType; } form:(t0:("Reduce" !IdentifierPart
{ return { type: "MacroName", name:"Reduce" }; }) __ t1:("(" __ t0:(t0:MacroIdentifier { return [t0]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) __ t2:Expr { return [t0, t1, t2]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / (&{ return macroType; } form:(t0:("Reduce" !IdentifierPart
{ return { type: "MacroName", name:"Reduce" }; }) __ t1:("(" __ ")"
{ return { type: "Paren", elements: [] }; }) __ t2:Expr { return [t0, t1, t2]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / (&{ return macroType; } form:(t0:("Reduce" !IdentifierPart
{ return { type: "MacroName", name:"Reduce" }; }) __ t1:Expr { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / form:(t0:("Reduce" !IdentifierPart
{ return { type: "MacroName", name:"Reduce" }; }) __ t1:("[" __ t0:(t0:Expr __ t1:(","
{ return { type: "PunctuationMark", value: "," }; }) __ t2:(head:Expr
 tail:(__ "," __ Expr)*
{ var elements = [head];
  for (var i=0; i<tail.length; i++) {
    elements.push(tail[i][3]);
  }
  return { type: "Repeat", elements: elements };
})
 { return [t0, t1, t2]; }) __ "]"
{ return { type: "Bracket", elements: t0 }; }) __ t2:("(" __ t0:(t0:MacroIdentifier { return [t0]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) __ t3:Expr { return [t0, t1, t2, t3]; })
{ return { type: "MacroForm", inputForm: form }; } 
 / form:(t0:("Reduce" !IdentifierPart
{ return { type: "MacroName", name:"Reduce" }; }) __ t1:("[" __ t0:(t0:Expr { return [t0]; }) __ "]"
{ return { type: "Bracket", elements: t0 }; }) __ t2:("(" __ t0:(t0:MacroIdentifier { return [t0]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) __ t3:Expr { return [t0, t1, t2, t3]; })
{ return { type: "MacroForm", inputForm: form }; } 
 / form:(t0:("Reduce" !IdentifierPart
{ return { type: "MacroName", name:"Reduce" }; }) __ t1:("[" __ "]"
{ return { type: "Bracket", elements: [] }; }) __ t2:("(" __ t0:(t0:MacroIdentifier { return [t0]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) __ t3:Expr { return [t0, t1, t2, t3]; })
{ return { type: "MacroForm", inputForm: form }; }

RejectWords
 = ","


