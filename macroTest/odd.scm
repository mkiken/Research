
(define (make-odd-gen)
 (let ((prev-number -1))
  (lambda ()
   (set! prev-number (+ prev-number 2))
   prev-number)))

#|aaaa|#
(define gen-odd-num1 (make-odd-gen))
(display (gen-odd-num1))
(newline)
(display (gen-odd-num1))
(newline)
(display (gen-odd-num1))
(newline)
(display (gen-odd-num1))
(newline)
(display (gen-odd-num1))
(newline)

;(format #t "~h")
;(display 2)
