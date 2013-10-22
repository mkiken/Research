(define add
  (lambda (a)
	(set! a (+ a 1))
	a
	))

(define testAdd2
  (lambda (c)
	(lambda (b)
	  (lambda (a)
		(+ a b c))
	  )
	)
  )

(define testAdd
  (lambda (a)
	(lambda (b)
	  (+ a b))
	)
  )


(define bind_c_3000 (testAdd2 3000))
(define bind_b_300 (bind_c_3000 300))
(define bind_b_200 (bind_c_3000 200))


(display (bind_b_300 1))
(newline)
(display (bind_b_200 1))
(newline)
(display (bind_b_300 1))
(newline)
(display (bind_b_200 1))
(newline)



#|
(define x 100)
(display (add x))
(newline)
(display x)
(newline)
|#
#|
(define adder (testAdd 10))
(display (adder 1000))
(newline)
|#
