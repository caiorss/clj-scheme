;;;; Create the function map-index
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(define (list-match? s1 s2)
  (and
   (and (list? s1)  (list? s2))
   (= (length s1) (length s2))
   ))

;;(define (matcht x . patterns)
(define-macro (match x . patterns)
  (let*
      (
       (sym (gensym))

       (predicate?     (lambda (s) (and (list? s)
                                        (not (null? s))
                                        (equal? '? (car s)))))

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

                       ;;(println (list "pattern = " (str pattern)))
                      ;; (println (list "rule = "    (str rule)))

                       (cond

                        ((equal? #t pattern) `((equla? #t ,sym) ,rule))
                        ((equal? #f pattern) `((equal? #f ,sym) ,rule))

                        ((predicate? pattern) `((,(cadr pattern) ,sym) ,rule))

                        ((or (string? pattern) (number? pattern))
                         `((equal? ,pattern ,sym) ,rule))



                        ((null? pattern) `((null? ,sym) ,rule))



                        ((symbol? pattern) `((equal? (quote ,pattern) ,sym) ,rule))

                        ((keyword? pattern) `((equal? ,pattern ,sym) ,rule))


                        ((list? pattern) (begin
                                           ;;(println "pattern = list")

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


                        ))))) ;; End of let*

    ;;($dbv map-index list '(1 2 3 4) '(a b c d) '(a: b: c: d:))

    `(let ((,sym ,x))
       (cond
         ,@(map f_match patterns)

         ))

    )) ;;; end of matchit




(match '(2 3)
       (()       0)
       ((a b)    (+ a b))
       ((a b c)  (* a b c))

       ;;('sum a b c)
       )


(matcht '(10 20)
       '(()       0)
       '((a b)    (+ a b))
       '((a b c)  (* a b c))


       )




(match 200
       ((? zero?)  "zero")
       ((? odd?)   "odd")
       ((? even?)  "even")
       )

(define (run-op operation)
  (match operation
         (()       0)
         ((a b)    (+ a b))
         ((a b c)  (* a b c))
         ))



(define (list-match? s1 s2)
  (and
   (and (list? s1)  (list? s2))
   (= (length s1) (length s2))
   ))

(define (map2 f xs)
  (match xs
         ((hd . tl)    (cons (f hd ) (map2 f tl)))
         (()          '())
   ))

(map2 inc (list 1 2 3 4 5 ))

(define (run op a b)
  (match op
         (add  (+ a b))
         (sub  (- a b))
         (mul  (* a b))
         (div  (/ a b))

         (add: (+ a b))
         (sub: (- a b))

         ))

(run  add: 10 20)
(run 'mul  20 30)



(define-macro (test x)
  `(quote ,x)
  )

(comment

 "Dream Pattern Matching "

 (defn map2 (f xs)
   (match xs
          (hd . tl)  '(cons (f hd) (map2 f tl))
          ()         '()
          ))

 (match form

        ()          (error "Cannot be empty")
        (x: x y:)   (list x y)
        (add: x y)  (+ x y)
        (a b c d)   (+ a b c d)

        ("--command1" x1 x2 x3)  dosemething

        ("--command2" . args)

        "--command3"

        )

 )
