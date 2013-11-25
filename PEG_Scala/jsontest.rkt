#lang racket

	(require json)
(define checkJsexpr
 (lambda ()
 (let ((a (read)))
 (begin
  (if (jsexpr? a)
   (print a)
   (print "input is not jsexpr.")
  )
  (write "end\n")
 )
 )
 ))

(define json2jsexprWithIO
 (lambda ()
 (let ((s (read)))
 (begin
  (displayln (string->jsexpr s))
   )
 )
 )
 )
(define json2jsexpr2
 (lambda ()
 (begin
  (displayln (string->jsexpr jsonstring))
  (write-json (string->jsexpr jsonstring)))))

(define input-file-path "json_example.txt")
(define infile (open-input-file input-file-path))
;(define jsonstring "{\"precision\": \"zip\"}")
(define jsonstring (read-json infile))
(define json2jsexpr
 (lambda ()
 (begin
  (displayln jsonstring)
  (displayln "")
  (write-json jsonstring))))

(json2jsexpr)
(displayln "done.")

