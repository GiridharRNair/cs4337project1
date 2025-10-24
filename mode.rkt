#lang racket

(define prompt?
  (let ([args (current-command-line-arguments)])
    (cond
      [(= (vector-length args) 0) #t]
      [(string=? (vector-ref args 0) "-b") #f]
      [(string=? (vector-ref args 0) "--batch") #f]
      [else #t])))

(define history (make-hash))
(define history-counter 0)

(define (format-input expr)
  (define trimmed (string-trim expr))
  (if (string=? trimmed "")
      (error "Invalid input")
      ;; Insert spaces around operators and $ references
      (let* ([with-spaces (regexp-replace* #rx"([+*/\\-]|\\$[0-9]+)" trimmed " \\1 ")]
             [normalized (regexp-replace* #rx"\\s+" with-spaces " ")]
             [final (string-trim normalized)])
        (if (string=? final "")
            (error "Invalid input")
            final))))

(define (add-to-history! value)
  (set! history-counter (+ history-counter 1))
  (hash-set! history history-counter value)
  history-counter)

(define (get-from-history index)
  (hash-ref history index (lambda () (error (format "History reference $~a not found" index)))))

(define (eval-prefix expr [save-to-history? #t])
  (define tokens (string-split expr))
  (define (helper tokens)
    (define token (car tokens))
    (define rest (cdr tokens))
    (cond
      [(and (> (string-length token) 1)
            (char=? (string-ref token 0) #\$)
            (string->number (substring token 1)))
       (define index (string->number (substring token 1)))
       (values (get-from-history index) rest)]
      [(member token '("+" "-" "*" "/"))
       (define-values (left-value rest-after-left) (helper rest))
       (define-values (right-value rest-after-right) (helper rest-after-left))
       (values (case token
                 [("+") (+ left-value right-value)]
                 [("-") (- left-value right-value)]
                 [("*") (* left-value right-value)]
                 [("/") (/ left-value right-value)])
               rest-after-right)]
      [else (values (string->number token) rest)]))
  (define-values (result _) (helper tokens))
  (when save-to-history?
    (add-to-history! result))
  result)

(format-input "+3*45")
(format-input "+3*45")       ; => "+ 3 * 4 5"
(format-input "  + 3  * 4 5  ") ; => "+ 3 * 4 5"
(format-input "+$1*45")    
; (eval-prefix "+3*45")
; (eval-prefix "* $1 2")
; (eval-prefix "+ $1 $2")
