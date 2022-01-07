#lang racket

(provide string-to-list)

(define (string-to-list s)
  (read
   (open-input-string
    (list->string (map (lambda (x)
                         (case x
                           [(#\() #\(]
                           [(#\)) #\)]
                           [(#\') #\"]
                           [else x]))
                       (remove* '(#\,)
                                (string->list s)))))))

