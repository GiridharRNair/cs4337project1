#lang racket

(define prompt?
  (let [(args (current-command-line-arguments))]
    (cond
      [(= (vector-length args) 0) #t]
      [(string=? (vector-ref args 0) "-b") #f]
      [(string=? (vector-ref args 0) "--batch") #f]
      [else #t])))

;; Evaluate a prefix expression
;; Usage example: (eval-prefix "+ 3 * 4 5") => 23
(define (eval-prefix expr)
  (define tokens (string-split expr))
  (define (helper tokens)
    (define token (car tokens))
    (define rest (cdr tokens))
    (cond
      [(member token '("+" "-" "*" "/"))
       (define-values (left-value rest-after-left) (helper rest))
       (define-values (right-value rest-after-right) (helper rest-after-left))
       (values
        (case token
          [("+") (+ left-value right-value)]
          [("-") (- left-value right-value)]
          [("*") (* left-value right-value)]
          [("/") (/ left-value right-value)])
        rest-after-right)]
      [else
       (values (string->number token) rest)]))
  (define-values (result _) (helper tokens))
  result)

;; Example
(eval-prefix "+ 3 * 4 5")
