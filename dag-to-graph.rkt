#lang racket
(define (as-string elm)
  (cond
    ((string? elm) (string-append "\\\"" elm "\\\""))
    ((number? elm) (number->string elm))
    ((symbol? elm) (symbol->string elm))
    ((null? elm) "*empty-list*")
    (else (error "Unrecognized type"))))

(define (node-name-label names labels)
  (apply append (map (lambda (a b)
                       (if (list? a)
                           (node-name-label a b)
                           (list (cons a b))))
                     names labels)))

(define (node-txt names labels)
  (apply string-append (map (lambda (x)
                              (let ((name (car x)) (label (cdr x)))
                                (string-append name " [label=\"" (as-string label) "\"];\n")))
                            (node-name-label names labels))))

(define (graph-txt lst)
  (apply string-append (map (lambda (x)
                              (let ((a (car x)) (b (cdr x)))
                                (string-append a " -- " b ";\n")))
                            (get-relationships lst))))

(define (declare-nodes lst (basename "node"))
  (map (lambda (x n)
         (if (and (list? x) (not (empty? x)))
             (declare-nodes x (string-append basename "_" (number->string n)))
             (string-append basename "_" (number->string n))))
       lst
       (range 0 (length lst))))

(define (get-relationships lst)
  (if (< (length lst) 2)
      null
      (apply append (map (lambda (x)
                           (if (list? x)
                               (cons (cons (car lst) (car x)) (get-relationships x))
                               (list (cons (car lst) x))))
                         (cdr lst)))))

(define (range start end)
  (if (>= start end)
      '()
      (cons start (range (+ 1 start) end))))

(define (get-graph code graph-title)
  (let ((names (declare-nodes code)))
    (string-append
     "graph "
     graph-title
     " {\n"
     (node-txt names code)
     "\n"
     (graph-txt names)
     "}")))

(provide get-graph)
