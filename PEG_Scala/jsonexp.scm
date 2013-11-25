
(use rfc.json)

(define input-file-path "json_example.txt")
(define infile (open-input-file input-file-path))
;(define jsonstring "{\"precision\": \"zip\"}")
(define jsonstring (parse-json infile))
(define (jsexpr2json js)
  (lambda ()
	(begin
	  ; (print js)
	  ; (print "")
	  (construct-json jsonstring)
	  ; (print "")
	  )))

(define (main args)
  (begin
	(print (list-ref args 1))
	(print (jsexpr2json jsonstring))
	(print "done.")
	)
  )




