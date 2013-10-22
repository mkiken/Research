(define mc '(let ((x (foo n)) (y (bar n))) (- x y (/ x y))))

(define mc2 '(let* ((x (foo n)) (y (bar n))) (- x y (/ x y))))

(define mc3 '(let ((counter 0))
  (lambda ()
   (set! counter (+ counter 1))
   counter)))

;same name
(define mc4 '(let ((e x)) (let ((e (+ e y))) (+ e 1000))))

;nest of let
(define mc5 '(let ((v1 e1)) (let ((v2 e2)) (+ v1 v2))))

; v1 = let...
(define mc6 '(let ((v1 (let ((v2 e2)) (+ 2 v2)))) (- (+ v1 1000) v2)))

;(let ((e 2)) e)

;(define mc2 '(let ))

(import (debug))
;(debug-expand '(let ((x (foo n)) (y (bar n))) (- x y (/ x y))))
;(newline)
(debug-expand mc6)
(newline)
