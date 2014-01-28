#!/usr/bin/env ypsilon
;; ファイル書き込み
(define (write-file file contents pretty-output)
  (if (not (null? file))
      (let ((out (open-output-port file)))
        (pretty-output contents out)
        (close-output-port out))
      '())
  (if debug
      (begin (pretty-output contents) (newline) (newline))
      '()))


; (define debug #t) ;; 結果を表示するかどうか
(define debug #f) ;; 結果を表示するかどうか
(define (open-output-port output )
  (transcoded-port (open-file-output-port output (file-options no-fail))
                   (make-transcoder (utf-8-codec))))

;; JSタグ付きS式をマクロ展開し，JavaScriptに変換
(define (expand-scm sform-file-path output2) ;; 引数のファイル名は -sform.scm で終わる
  (let* ((in (transcoded-port (open-file-input-port sform-file-path)
                              (make-transcoder (utf-8-codec))))
         (expanded (parameterize ((coreform-optimize #f))(macro-expand (read in))))
		 )
		; (write-file "A-expanded.scm" expanded pretty-print)
		(write-file output2 expanded pretty-print)
    ; (write-file (change-suffix sform-file-path "-expanded.js") js display)
    (close-input-port in)
    ))

(define (main args)
  (begin
	 (expand-scm (cadr args) (caddr args))
	))

(main (command-line))

