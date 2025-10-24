#lang racket

(define interactive?
  (let ([args (current-command-line-arguments)])
    (cond
      [(= (vector-length args) 0) #t]
      [(string=? (vector-ref args 0) "-b") #f]
      [(string=? (vector-ref args 0) "--batch") #f]
      [else #t])))

(define (get-from-history history index)
  (define reversed-history (reverse history))
  (if (and (> index 0) (<= index (length history)))
      (list-ref reversed-history (- index 1))
      (error (format "History reference $~a not found" index))))

(define (tokenize expr)
  (define trimmed (string-trim expr))
  (when (string=? trimmed "")
    (error "Invalid input: empty expression"))
  (regexp-match* #rx"\\$[0-9]+|[0-9]+|[+*/~-]" trimmed))

(define (eval-prefix expr history)
  (define tokens (tokenize expr))

  (when (null? tokens)
    (error "Invalid input-No tokens to evaluate"))

  (define (helper tokens)
    (when (null? tokens)
      (error "Invalid expression-Unexpected end of input"))

    (define token (car tokens))
    (define rest (cdr tokens))

    (cond
      ;; History reference
      [(and (> (string-length token) 1) (char=? (string-ref token 0) #\$))
       (define index (string->number (substring token 1)))
       (if index
           (values (get-from-history history index) rest)
           (error (format "Invalid history reference: ~a" token)))]

      ;; Unary negation operator
      [(string=? token "-")
       (when (null? rest)
         (error "Unary negation missing operand"))
       (define-values (operand rest-after-operand) (helper rest))
       (values (- operand) rest-after-operand)]

      ;; Binary operators
      [(member token '("+" "*" "/"))
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

  result)

(define (repl history)
  (when interactive?
    (display "> ")
    (flush-output))

  (define input (read-line))

  (cond
    [(eof-object? input) (void)]
    [(string=? input "quit") (void)]
    [else
     (with-handlers ([exn:fail? (lambda (e)
                                  (displayln (format "Error: ~a" (exn-message e)))
                                  (when interactive?
                                    (repl history)))])
       (define result (eval-prefix input history))
       (define new-history (cons result history))
       (define history-id (length new-history))

       (when interactive?
         (display history-id)
         (display ": "))
       (display (real->double-flonum result))
       (newline)

       (if interactive?
           (repl new-history)
           (void)))]))

(repl '())