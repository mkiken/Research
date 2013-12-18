CheckOuterMacro
 = { return outerMacro; }

Errors
 = ForbiddenInStatement

CharacterStatement
 = &{}

MacroExpression
 = form:(t0:("Let" !IdentifierPart
{ return { type: "MacroName", name:"Let" }; }) __ t1:("(" __ t0:(t0:(head:(t0:(t0:MacroIdentifier __ t1:(v:MacroKeyword &{ return v.name === "="; }
{ return v; }) __ t2:Expr { return [t0, t1, t2]; }) __ 
{ return { type: "RepBlock", elements: t0 }; })
 tail:(__ "," __ (t0:(t0:MacroIdentifier __ t1:(v:MacroKeyword &{ return v.name === "="; }
{ return v; }) __ t2:Expr { return [t0, t1, t2]; }) __ 
{ return { type: "RepBlock", elements: t0 }; }))*
{ var elements = [head];
  for (var i=0; i<tail.length; i++) {
    elements.push(tail[i][3]);
  }
  return { type: "Repeat", elements: elements };
})?
 { return [t0]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) __ t2:("{" __ t0:(t0:Expr { return [t0]; }) __ "}"
{ return { type: "Brace", elements: t0 }; }) { return [t0, t1, t2]; })
{ return { type: "MacroForm", inputForm: form }; } 
 / (&{ return macroType; } form:(t0:("Let" !IdentifierPart
{ return { type: "MacroName", name:"Let" }; }) __ t1:("(" __ t0:(t0:(head:(t0:(t0:MacroIdentifier __ t1:(v:MacroKeyword &{ return v.name === "="; }
{ return v; }) __ t2:Expr { return [t0, t1, t2]; }) __ 
{ return { type: "RepBlock", elements: t0 }; })
 tail:(__ "," __ (t0:(t0:MacroIdentifier __ t1:(v:MacroKeyword &{ return v.name === "="; }
{ return v; }) __ t2:Expr { return [t0, t1, t2]; }) __ 
{ return { type: "RepBlock", elements: t0 }; }))*
ellipsis:(__ "," __ "...")?
{ var elements = [head];
  for (var i=0; i<tail.length; i++) {
    elements.push(tail[i][3]);
  }
  if (ellipsis) elements.push({ type: "Ellipsis" });
  return { type: "Repeat", elements: elements };
})?
 { return [t0]; }) __ ")"
{ return { type: "Paren", elements: t0 }; }) __ t2:("{" __ t0:(t0:Expr { return [t0]; }) __ "}"
{ return { type: "Brace", elements: t0 }; }) { return [t0, t1, t2]; })
{ return { type: "MacroForm", inputForm: form }; })


