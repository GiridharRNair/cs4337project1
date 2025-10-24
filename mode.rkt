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
      (error "Invalid Expression")))

(define (skip-whitespace chars)
  (cond
    [(null? chars) '()]
    [(char-whitespace? (car chars)) (skip-whitespace (cdr chars))]
    [else chars]))

(define (parse-number chars)
  (define (collect-digits chars acc)
    (cond
      [(null? chars) (list acc '())]
      [(char-numeric? (car chars)) (collect-digits (cdr chars) (cons (car chars) acc))]
      [else (list acc chars)]))

  (define result (collect-digits chars '()))
  (define digits (reverse (car result)))
  (define remaining (cadr result))

  (if (null? digits)
      #f
      (list (string->number (list->string digits)) remaining)))

(define (parse-history chars)
  (cond
    [(null? chars) #f]
    [(not (char=? (car chars) #\$)) #f]
    [else
     (define num-result (parse-number (cdr chars)))
     (if num-result
         (list (car num-result) (cadr num-result))
         #f)]))

(define (is-operator? c)
  (or (char=? c #\+) (char=? c #\*) (char=? c #\/) (char=? c #\-)))

(define (eval-prefix expr history)
  (define chars (string->list expr))

  (define (eval-helper chars)
    (define trimmed (skip-whitespace chars))

    (when (null? trimmed)
      (error "Invalid Expression"))

    (define first-char (car trimmed))
    (define rest-chars (cdr trimmed))

    (cond
      [(char=? first-char #\$)
       (define hist-result (parse-history trimmed))
       (if hist-result
           (let ([index (car hist-result)]
                 [remaining (cadr hist-result)])
             (cons (get-from-history history index) remaining))
           (error "Invalid Expression"))]

      [(char=? first-char #\-)
       (define operand-result (eval-helper rest-chars))
       (cons (- (car operand-result)) (cdr operand-result))]

      [(char=? first-char #\+)
       (define left-result (eval-helper rest-chars))
       (define right-result (eval-helper (cdr left-result)))
       (cons (+ (car left-result) (car right-result)) (cdr right-result))]

      [(char=? first-char #\*)
       (define left-result (eval-helper rest-chars))
       (define right-result (eval-helper (cdr left-result)))
       (cons (* (car left-result) (car right-result)) (cdr right-result))]

      [(char=? first-char #\/)
       (define left-result (eval-helper rest-chars))
       (define right-result (eval-helper (cdr left-result)))
       (when (= (car right-result) 0)
         (error "Invalid Expression"))
       (cons (quotient (car left-result) (car right-result)) (cdr right-result))]

      [(char-numeric? first-char)
       (define num-result (parse-number trimmed))
       (if num-result
           (cons (car num-result) (cadr num-result))
           (error "Invalid Expression"))]

      [else (error "Invalid Expression")]))

  (define result (eval-helper chars))
  (define remaining (skip-whitespace (cdr result)))

  (when (not (null? remaining))
    (error "Invalid Expression"))

  (car result))

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
