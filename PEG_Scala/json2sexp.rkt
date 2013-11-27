
#lang racket/load

	(define (json2sexpr input-file-path)
 (begin
  ; (displayln jsonstring)
  ; (displayln "")
  (write-json (read-json (open-input-file input-file-path)))))

; (json2sexpr)
; (displayln "done.")

(define (main args)
  ; (printf "Converting JSON ...~%")
  (let ((start (current-milliseconds)))
    (display (json2sexpr (vector-ref args 0)))
	; (displayln (vector-ref args 0))
    ; (printf "Done.~%Time: ~as.~%" (/ (- (current-milliseconds) start) 1000.0))
	))

(main (current-command-line-arguments))
