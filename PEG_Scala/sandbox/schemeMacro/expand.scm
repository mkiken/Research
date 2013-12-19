#!/usr/bin/env ypsilon

;; JSタグ付きS式をマクロ展開し，JavaScriptコードに変換するプログラム．
;; 引数のscmファイルが存在するフォルダと同じフォルダに以下の2ファイルを生成する．
;; XXX-expanded.scm: JSタグ付きS式をマクロ展開したS式
;; XXX-expanded.js : マクロ展開後のS式をJavaScriptに変換したもの

(import (pregexp))
(import (time))
; (load "common.scm")
; (load "scheme-to-js-simple.scm")


;; ファイル名の最後を変更
; (define (change-suffix file-path suffix)
  ; (regexp-replace "(\\.tree|-sform\\.scm)$" file-path suffix))

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



(define debug #t) ;; 結果を表示するかどうか
; (define regexp-replace pregexp-replace) ;; racketとの互換性をもたせる
(define (open-output-port output )
  (transcoded-port (open-file-output-port output (file-options no-fail))
                   (make-transcoder (utf-8-codec))))

;; JSタグ付きS式をマクロ展開し，JavaScriptに変換
(define (expand-scm sform-file-path output2) ;; 引数のファイル名は -sform.scm で終わる
  (let* ((in (transcoded-port (open-file-input-port sform-file-path)
                              (make-transcoder (utf-8-codec))))
         ; (expanded (time (parameterize ((coreform-optimize #f))(macro-expand (read in)))))
         (expanded (parameterize ((coreform-optimize #f))(macro-expand (read in))))
         ; (js (time (scheme-to-javascript expanded)))
		 )
		; (write-file "A-expanded.scm" expanded pretty-print)
		(write-file output2 expanded pretty-print)
    ; (write-file (change-suffix sform-file-path "-expanded.js") js display)
    (close-input-port in)
    ))

(define (main args)
  ; (time (begin (expand-scm (cadr args)) (display "MacroExpand...")))
  (begin
	 ; (time (expand-scm (cadr args)))
	 (expand-scm (cadr args) (caddr args))
	 ; (display (macro-expand (read (cadr args))))
	 ; (time (parameterize ((coreform-optimize #f)) (expand-scm (cadr args)))))
	))

(main (command-line))



