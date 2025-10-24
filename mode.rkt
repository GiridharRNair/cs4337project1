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

(define (tokenize expr)
  (define trimmed (string-trim expr))
  (when (string=? trimmed "")
    (error "Invalid input: empty expression"))

  ;; Match: $-references, operators, or single digits (in that order!)
  (regexp-match* #rx"\\$[0-9]+|[+*/-]|[0-9]" trimmed))

(define (eval-prefix expr [save-to-history? #t])
  (define tokens (tokenize expr))

  (when (null? tokens)
    (error "Invalid input: no tokens to evaluate"))

  (define (helper tokens)
    (when (null? tokens)
      (error "Invalid expression: unexpected end of input"))

    (define token (car tokens))
    (define rest (cdr tokens))

    (cond
      ;; History reference
      [(and (> (string-length token) 1) (char=? (string-ref token 0) #\$))
       (define index (string->number (substring token 1)))
       (if index
           (values (get-from-history index) rest)
           (error (format "Invalid history reference: ~a" token)))]

      ;; Operator
      [(member token '("+" "-" "*" "/"))
       (when (null? rest)
         (error (format "Operator ~a missing operands" token)))
       (define-values (left rest-after-left) (helper rest))
       (when (null? rest-after-left)
         (error (format "Operator ~a missing second operand" token)))
       (define-values (right rest-after-right) (helper rest-after-left))
       (when (and (string=? token "/") (= right 0))
         (error "Division by zero"))
       (values (case token
                 [("+") (+ left right)]
                 [("-") (- left right)]
                 [("*") (* left right)]
                 [("/") (/ left right)])
               rest-after-right)]

      ;; Number
      [else
       (define num (string->number token))
       (if num
           (values num rest)
           (error (format "Invalid token: '~a'" token)))]))

  (define-values (result remaining) (helper tokens))

  (when (not (null? remaining))
    (error (format "Unused tokens: ~a" remaining)))

  (when save-to-history?
    (add-to-history! result))
  result)

; ;; Tests
; (tokenize "+3*45") ; => '("+" "3" "*" "4" "5")
; (tokenize "  + 3  * 4 5  ") ; => '("+" "3" "*" "4" "5")
; (tokenize "+$1*45") ; => '("+" "$1" "*" "4" "5")

; (eval-prefix "+3*45") ; => 23
; (eval-prefix "* $1 2") ; => 46
; (eval-prefix "+ $1 $2") ; => 69

(define (repl)
  (display "> ")
  (flush-output)
  (define input (read-line))

  (cond
    [(string=? input "quit") (void)]
    [else
     (with-handlers ([exn:fail? (lambda (e) (displayln (format "Error: ~a" (exn-message e))))])
       (define result (eval-prefix input))
       (displayln result))
     (repl)])) 

(when prompt?
  (repl))
