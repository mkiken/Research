
(define (my-counter)
 (let ((counter 0))
  (lambda ()
   (set! counter (+ counter 1))
   counter)))

(define mc1 (my-counter))
(define mc2 (my-counter))
(display (mc1))
(newline)
(display (mc1))
(newline)
(newline)
(display (mc2))
(newline)
(display (mc2))
(newline)
