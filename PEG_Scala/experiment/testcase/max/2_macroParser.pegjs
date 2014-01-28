CheckOuterMacro
 = { return outerMacro; }

CharacterStatement
 = &{}

OneLine
 = &{}

start
 = CompilationUnit

ExpressionMacro
 = (&{ return macroType; } form:(t0:("Max" !IdentifierPart
{ return { type: "MacroName", name:"Max" }; }) __ t1:("(" __ t0:(t0:(head:Expr
 tail:(__ "," __ Expr)*
ellipsis:(__ "," __ "...")
{ var elements = [head];
  for (var i=0; i<tail.length; i++) {
    elements.push(tail[i][3]);
  }
  if (ellipsis) elements.push({ type: "Ellipsis" });
  return { type: "Repeat", elements: elements };
})
 { return [t0]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / (&{ return macroType; } form:(t0:("Max" !IdentifierPart
{ return { type: "MacroName", name:"Max" }; }) __ t1:("(" __ ")"
{ return { type: "Paren", elements: [] }; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; }) 
 / form:(t0:("Max" !IdentifierPart
{ return { type: "MacroName", name:"Max" }; }) __ t1:("(" __ t0:(t0:(head:Expr
 tail:(__ "," __ Expr)*
{ var elements = [head];
  for (var i=0; i<tail.length; i++) {
    elements.push(tail[i][3]);
  }
  return { type: "Repeat", elements: elements };
})
 { return [t0]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) { return [t0, t1]; })
{ return { type: "MacroForm", inputForm: form }; }

RejectWords
 = ","


