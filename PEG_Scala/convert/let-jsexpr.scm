#hasheq((type . "Program")
        (elements
         .
         (#hasheq((type . "ExpressionMacroDefinition")
                  (macroName . "Let")
                  (literals . ("="))
                  (syntaxRules
                   .
                   (#hasheq((pattern
                             .
                             (#hasheq((type . "Paren")
                                      (elements
                                       .
                                       (#hasheq((type . "Repetition")
                                                (elements
                                                 .
                                                 #hasheq((type . "RepBlock")
                                                         (elements
                                                          .
                                                          (#hasheq((name
                                                                    .
                                                                    "id")
                                                                   (type
                                                                    .
                                                                    "IdentifierVariable"))
                                                           #hasheq((name . "=")
                                                                   (type
                                                                    .
                                                                    "LiteralKeyword"))
                                                           #hasheq((name . "e")
                                                                   (type
                                                                    .
                                                                    "ExpressionVariable"))))))
                                                (punctuationMark . (",")))
                                        #hasheq((type . "Ellipsis")))))
                              #hasheq((type . "Brace")
                                      (elements
                                       .
                                       (#hasheq((name . "body")
                                                (type
                                                 .
                                                 "ExpressionVariable")))))))
                            (type . "SyntaxRule")
                            (template
                             .
                             #hasheq((type . "ArrayLiteral")
                                     (elements
                                      .
                                      (#hasheq((type . "ArrayLiteral")
                                               (elements
                                                .
                                                (#hasheq((name . "id")
                                                         (type . "Variable"))
                                                 #hasheq((name . "e")
                                                         (type
                                                          .
                                                          "Variable")))))
                                       #hasheq((type . "Ellipsis"))))))))))
          #hasheq((type . "VariableStatement")
                  (declarations
                   .
                   (#hasheq((name . "a")
                            (type . "VariableDeclaration")
                            (value
                             .
                             #hasheq((type . "MacroForm")
                                     (inputForm
                                      .
                                      (#hasheq((name . "Let")
                                               (type . "MacroName"))
                                       #hasheq((type . "Paren")
                                               (elements
                                                .
                                                (#hasheq((type . "Repeat")
                                                         (elements
                                                          .
                                                          (#hasheq((type
                                                                    .
                                                                    "RepBlock")
                                                                   (elements
                                                                    .
                                                                    (#hasheq((name
                                                                              .
                                                                              "x")
                                                                             (type
                                                                              .
                                                                              "Variable"))
                                                                     #hasheq((name
                                                                              .
                                                                              "=")
                                                                             (type
                                                                              .
                                                                              "LiteralKeyword"))
                                                                     #hasheq((type
                                                                              .
                                                                              "NumericLiteral")
                                                                             (value
                                                                              .
                                                                              "3")))))
                                                           #hasheq((type
                                                                    .
                                                                    "RepBlock")
                                                                   (elements
                                                                    .
                                                                    (#hasheq((name
                                                                              .
                                                                              "y")
                                                                             (type
                                                                              .
                                                                              "Variable"))
                                                                     #hasheq((name
                                                                              .
                                                                              "=")
                                                                             (type
                                                                              .
                                                                              "LiteralKeyword"))
                                                                     #hasheq((type
                                                                              .
                                                                              "NumericLiteral")
                                                                             (value
                                                                              .
                                                                              "4")))))))))))
                                       #hasheq((type . "Brace")
                                               (elements
                                                .
                                                (#hasheq((type
                                                          .
                                                          "BinaryExpression")
                                                         (operator . "*")
                                                         (left
                                                          .
                                                          #hasheq((name . "x")
                                                                  (type
                                                                   .
                                                                   "Variable")))
                                                         (right
                                                          .
                                                          #hasheq((name . "y")
                                                                  (type
                                                                   .
                                                                   "Variable"))))))))))))))))))
