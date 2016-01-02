(define table-functions (make-table))

(define (list-match? s1 s2)
  (and
   (and (list? s1)  (list? s2))
   (= (length s1) (length s2))
   ))



(define-macro (letc params . body)
  (let

      (
       (plist->alist (lambda (plst)
                       (letrec

                           ((_plist->alist

                             (lambda  (plist)
                               (if (null? plist)
                                   '()
                                   (cons
                                    (list (car plist) (cadr plist))
                                    (_plist->alist (cddr plist)))))
                             ))

                         (_plist->alist plst)

                         )))
       )
    `(let*
         ,(plist->alist params)
       ,@body
       )))


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




(define-macro (comment .  sexp)
  `(values)
  )


(define-macro (inc! x)
  `(set! ,x (+ ,x 1)))

(define-macro (dec! x)
  `(set! ,x (- ,x 1)))


(define-macro (dotimes var value body)
  `(letrec
       ((loop
         (lambda (,var)
           (if  (< ,var ,value)
                (begin
                  ,body
                  (loop (+ ,var 1))))
           )))
     (loop 0)
     ))


(define-macro (dolist var alist body)
  `(letrec
       ((loop (lambda (xs)
                (if (not  (null? xs))
                    (let ((,var (car xs)))
                      (begin
                        ,body
                        (loop (cdr xs))
                        ))
                    ))))
     (loop ,alist)
       ))


(define-macro (when cond . sexps)
  `(if ,cond
      (begin ,@sexps)
      ))

(define-macro (unless cond . sexps)
  `(if (not ,cond)
      (begin ,@sexps)
      ))


(define-macro (if-not
               cond
               f-statement
               #!optional (t-statement nil))

  (if (nil? t-statement)
      `(if (not ,cond)
          ,f-statement
          )
      `(if (not ,cond)
           ,f-statement
           ,t-statement
           )
      ))


(define-macro (doto obj . s-exps)
  (let
      ((sym (gensym)))

    `(let
         ((,sym ,obj))

         (begin
           ,@(map (lambda (s)
                    `(,(car s) ,sym ,@(cdr s)))
                  s-exps
                  )
           ,sym
           ))))




(define-macro (-> . s-exps)
  "
  Clojure thread first macro

  "
  (let  ((sym (gensym)))

    `(let*

         (
          (,sym ,(car s-exps))

         ,@(map
            (lambda (s) `(,sym (,(car s) ,sym  ,@(cdr s))))
            (cdr s-exps)
           )

          )
       ,sym
       )
    )
  )

(define-macro (->> . s-exps)
  "
  Clojure thread last macro

  "
  (let  ((sym (gensym)))

    `(let*

         (
          (,sym ,(car s-exps))

         ,@(map
            (lambda (s) `(,sym (,(car s) ,@(cdr s) ,sym)))
            (cdr s-exps)
           )

          )
       ,sym
       )
    )
  )

(define-macro ($-> s0 . s-exps)
"
Example:

($-> 500
     (/ $ 20)
     (- 40 $)
     (expt $ 2)
     log
     exp
     sqrt
     )

Expansion:

(sqrt
   (exp
     (log
        (expt
           (- 40 (/ 500 20)) 2))))

Expected output: 15.0
"
  `(let*

       (
        ($  ,s0)

        ,@(map
           (lambda (s) (if (symbol? s)
                           `($   (,s $))
                           `($  ,s))
                   )
           s-exps
           )

        )
     $
     )
  )

(define-macro (bind-cons pair form . body)
  "
  Destructure a cons-pair

  Example:

  > (bind-cons (x . y) '(9 . 8) (* x y))
  72

  > (map
      (lambda (pair)
            (bind-cons (h . t) pair (* h t)))
      '((1 . 2) (3 . 4) (5 . 6)))


   (2 12 30)
   >

  "
  (let
      ((sym1 (car pair))
       (sym2 (cdr pair))
       (s    (gensym))
       )

    `(let*

         (
          (,s     ,form)
          (,sym1 (car ,s))
          (,sym2 (cdr ,s))
          )

          ,@body
         )))


(define-macro ($thunk func . args )
   " Thunk Macro, turns the s-expression into a thunk:

     Example:

    > (define t ($thunk display 10))
    > t
    #<procedure #3 t>
    > (t)
   10>

   This macro will expand to:

   ($thunk display 10)) -> (lambda () (display 10))
   "
  `(lambda () (,func ,@args)))



(define-macro (fn params body)
  `(lambda ,params ,body))

(define-macro (do . sexps)
  `(begin
    ,@sexps
    ))

(define-macro (defn name params p1 #!optional (p2 'nil))
  (if (equal? p2 'nil)

      `(define (,name ,@params) ,p1)


      (begin
        ;;(println p1)
        ;;(println p2)
       `(begin
          ;;(println "Begin ")
          (define (,name ,@params) ,p2)

          (table-set! table-functions
                      (quote ,name)
                      (vector
                        ,p1
                       (quote ,params)
                       (quote (defn ,name ,params ,p1 ,p2))
                       )
                      )
          ;;(println "Created ")
          ))
      ))

(defn func/doc (function-name)
  "Find function documentation"
  (println
   (vector-ref
    (table-ref table-functions function-name) 0)))

(defn func/code (function-name)
  "Find the code of a function"
  (pretty-print
   (vector-ref
    (table-ref table-functions function-name) 2)))

(defn func/get-doc (function-name)
  "Get the function doc"
  (vector-ref
   (table-ref table-functions function-name) 0))

(defn func/get-code (function-name)
  "Get the function source code"
  (vector-ref
    (table-ref table-functions function-name) 2))

(defn func/show ()
  "Show all functions in the function database"
  (for-each println (map car (table->list table-functions))))

(defn func/list ()
  "Return a list with all functions"
  (map car (table->list table-functions)))

(defn func/apropos (prefix)
  "Show all functions matching the prefix"
  (for-each println
   (filter
    (fcomp symbol->string
           (partial string/starts-with prefix))

    (func/list))))

(defn func/apropos-doc (prefix)
  "Search the function and shows the docs"

  (for-each
   (fn [c]
       (do
        (println "")
        (println c)
        (println "")
        (func/doc c) ;; Print documentation
        (println "---------------")

        ))

   (filter
    (fcomp symbol->string
           (partial string/starts-with prefix))

    (func/list))))


(define-macro (def name value)
  `(define ,name ,value))
