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

(define (add-to-history! value)
  (set! history-counter (+ history-counter 1))
  (hash-set! history history-counter value)
  history-counter)

(define (get-from-history index)
  (hash-ref history index (lambda () (error (format "History reference $~a not found" index)))))

(define (clear-history!)
  (set! history (make-hash))
  (set! history-counter 0))

(define (show-history)
  (if (= history-counter 0)
      (displayln "No history yet.")
      (for ([i (in-range 1 (+ history-counter 1))])
        (printf "$~a = ~a~n" i (hash-ref history i)))))

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

(eval-prefix "+ 3 * 4 5")
(eval-prefix "* $1 2")
(eval-prefix "+ $1 $2")
