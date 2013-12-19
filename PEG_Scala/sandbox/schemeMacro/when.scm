; ((let-syntax ((when (syntax-rules ()
                         ; ((when test stmt1 stmt2 ...)
                          ; (if test
                              ; (begin stmt1
                                     ; stmt2 ...))))))

(define-syntax when
  (syntax-rules ()
    ((_ pred b1 ...)
     (if pred (begin b1 ...)))))
(when #t (display 2) (display 10))
