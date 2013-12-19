(begin
(define-syntax my-or
      (syntax-rules ()
                ((my-or) #f)
                ((my-or e) e)
                ((my-or e1 e2 ...)
                 (let ((temp e1))
                   (if temp
                       temp
                       (my-or e2 ...))))))
(display 2)
 (display (let ((x #f)
						(temp 1)
)
				(my-or x
							 temp))))
