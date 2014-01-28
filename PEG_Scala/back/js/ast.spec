// Literals
NumericalLiteral: value
StringLiteral: value
NullLiteral:
BooleanLiteral: value
RegularExpressionLiteral: body, flags
This:
Variable: name
ArrayLiteral: elements
ObjectLiteral: properties

// Properties
PropertyAssignment: name, value
GetterDefinition: name, body
SetterDefinition: name, param, body

// Expressions
NewOperator: constructor, arguments
PropertyAccess: base, name
PropertyAccessProperty: name
FunctionCallArguments: arguments
PostfixExpression: operator, expression
UnaryExpression: operator, expression
BinaryExpression: operator, left, right
ConditionalExpression: condition, trueExpression, falseExpression
AssignmentExpression: operator, left, right

// Statements
Block: statements
VariableStatement: declarations
VariableDeclaration: name, value
EmptyStatement:
IfStatement: condition, ifStatement, elseStatement
DoWhileStatement: condition, statement
WhileStatement: condition, statement
ForStatement: initializer, test, counter, statement
ForInStatement: iterator, collection, statement
ContinueStatement: label
BreakStatement: label
ReturnStatement: value
WithStatement: environment, statement
SwitchStatement: expression, clauses
CaseClause: selector, statements
DefaultClause: statements
LabeledStatement: label, statements
ThrowStatement: exception
TryStatement: block, catch, finally
Catch: identifier, block
Finally: block

// Others
DebbugerStatement:
Program: elements

// Macro
MacroForm: inputForm
MacroName: name
Repetition: elements
RepBlock: elements
IdentifierVariable: name
LiteralKeyword: name
ExpressionVariable: name
Repeat: elements

