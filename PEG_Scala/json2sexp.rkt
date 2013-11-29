
#lang racket/load

(require (planet dherman/json:4:=0))
(require racket/pretty)

; (json2sexpr)
; (displayln "done.")
(define (json2sexpr tree-file-path) ;; 引数のファイル名は .tree で終わる
  (let* ((in (open-input-file tree-file-path))
         (jsexpr (read-json in))
         ; (sform (racket-jsexpr->sexp jsexpr))
		 )
    (pretty-print jsexpr)
    ; (pretty-print (write-json jsexpr))
    ; (write-file (change-suffix tree-file-path "-sform.scm") sform pretty-write)
    (close-input-port in)))

(define (main args)
  ; (printf "Converting JSON ...~%")
  (let ((start (current-milliseconds)))
    (json2sexpr (vector-ref args 0))
	; (displayln (vector-ref args 0))
    ; (printf "Done.~%Time: ~as.~%" (/ (- (current-milliseconds) start) 1000.0))
	))

(main (current-command-line-arguments))
