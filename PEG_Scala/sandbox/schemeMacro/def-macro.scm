;; hygiene
(let ((x 1))
  (let-syntax ((boo (syntax-rules ()
                      ((_ expr ...)
                       (let ((x x))
                         (set! x (+ x 1))
                         expr ...)))))
    (boo (display x) (newline))))

;; non hygiene
(let ((x 1))
  (define-macro (boo . args)
    `(let ((x x))
       (set! x (+ x 1))
       ,@args))
  (boo (display x) (newline)))


