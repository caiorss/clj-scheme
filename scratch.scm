

;;;; Create the function map-index






(define-macro (match x . patterns)
  (let*
      (
       (sym (gensym))

       (list-match? (lambda  (s1 s2)
                             (and
                              (and (list? s1)  (list? s2))
                              (= (length s1) (length s2))
                              )))



       (f_match    (lambda (s)

                     (let ((pattern (car s))
                           (rule    (cadr s))
                           )

                       (println (list "pattern = " (str pattern)))
                       (println (list "rule = "    (str rule)))

                       (cond

                        ((null? pattern) `((null? ,sym) ,rule))

                        ((pair? pattern) `((pair? ,sym)
                                           (let
                                               ((,(car pattern) (car ,sym))
                                                (,(cdr pattern) (cdr ,sym))
                                                )
                                             ,rule
                                             )
                                           ))

                        ((symbol? pattern) `((equal? (quote ,pattern) ,sym) ,rule))

                        ((keyword? pattern) `((equal? ,pattern ,sym) ,rule))


                        ((list? pattern) (begin
                                          (println "list ")
                                         `((list-match? ,pattern ,sym)

                                           (let
                                               ,(map-index
                                                 (lambda (idx pt sy)

                                                   `(,(list-ref
                                                       (quote ,pt) ,idx)
                                                     ,(list-ref ,sy ,idx)))
                                                 pattern
                                                 sym
                                                 )

                                             ,rule

                                             )))
                         )


                        ))))
       ) ;; End of let*


    `(let ((,sym ,x))
       (cond
         ,@(map f_match patterns)

         ))

    ))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;(define (matcht x . patterns)
(define-macro (match x . patterns)
  (let*
      (
       (sym (gensym))

       (list-match? (lambda  (s1 s2)
                             (and
                              (and (list? s1)  (list? s2))
                              (= (length s1) (length s2))
                              )))


       (all-empty? (lambda  (xs)
                    (= 0  (apply + (map length xs)))))

       (map-index     (lambda (ff . xsss)
                        (letrec

                            ((__map-index
                              (lambda  (f  xss acc idx)
                                (if (all-empty? xss)

                                    (reverse  acc)

                                    (__map-index
                                     f
                                     (map cdr xss)
                                     (cons (apply f  idx (map car xss)) acc)
                                     (+ 1 idx)
                                     )))))
                          (__map-index ff xsss '() 0)
                          )))

;
       ;; (map-index  (lambda (f . xss)
       ;;               (__map-index f xss '() 0)))


       (f_match    (lambda (s)

                     (let ((pattern (car s))
                           (rule    (cadr s))
                           )

                       (println (list "pattern = " (str pattern)))
                       (println (list "rule = "    (str rule)))

                       (cond

                        ((null? pattern) `((null? ,sym) ,rule))



                        ((symbol? pattern) `((equal? (quote ,pattern) ,sym) ,rule))

                        ((keyword? pattern) `((equal? ,pattern ,sym) ,rule))


                        ((list? pattern) (begin
                                           (println "pattern = list")

                                           `((list-match? (quote ,pattern) ,sym)

                                             (let
                                                 ,(map-index
                                                   (lambda (idx pt)
                                                     `(,pt (list-ref ,sym ,idx)))
                                                   pattern
                                                   )

                                               ,rule

                                               )))
                         )

                        ((pair? pattern) `((pair? ,sym)
                                           (let
                                               ((,(car pattern) (car ,sym))
                                                (,(cdr pattern) (cdr ,sym))
                                                )
                                             ,rule
                                             )
                                           ))


                        ))))
       ) ;; End of let*

    ;;($dbv map-index list '(1 2 3 4) '(a b c d) '(a: b: c: d:))

    `(let ((,sym ,x))
       (cond
         ,@(map f_match patterns)

         ))

    )) ;;; end of matchit


(match '(10 20)
       (()       0)
       ((a b)    (+ a b))
       ((a b c)  (* a b c))
       )


(matcht '(10 20)
       '(()       0)
       '((a b)    (+ a b))
       '((a b c)  (* a b c))
       )




(let

    ((g126 '(10 20))

     (cond ((null? g126) 0)

           ((list-match? (a b) g126)
             (let ((a (list-ref g126 0)) (b (list-ref g126 1))) (+ a b)))

            ((list-match? (a b c) g126)
             (let ((a (list-ref g126 0))
                   (b (list-ref g126 1))
                   (c (list-ref g126 2)))
               (* a b c))))))

(define (run-op operation)
  (match operation
         (()       0)
         ((a b)    (+ a b))
         ((a b c)  (* a b c))
         ))
