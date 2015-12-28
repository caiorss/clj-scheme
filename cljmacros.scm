;; Author: Caior Rodrigues
;; Description: Set of functions and macros to emulate Clojure.
;;
;;


;;(include "utils.scm")

(define table-functions (make-table))

(define-macro (inc! x)
  `(set! ,x (+ ,x 1)))

(define-macro (dec! x)
  `(set! ,x (- ,x 1)))


(define-macro (-> . s-exps)
  (let  ((sym (gensym)))

    `(let*
         ,(map
           (lambda (s) `(,sym ,@s-exps))
           s-exps
           )
       ,sym

       )
    ))











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



(define-macro (bind-values bindings value-list . body)

  (let
      (
       (sym  (gensym))
       )

      `(let*
           (
             (,sym ,value-list)

            ,@(map-index
               (lambda (n b)
                 `(,b (list-ref ,sym ,n))

                 )
               bindings
               )

            )

         ,@body
         )))

(define-macro (bind-cons pair form . body)
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


(define-macro (letc params . body)
  (define (plist->assoc plist)
    (if (null? plist)
        '()
        (cons
         (list (car plist) (cadr plist))
         (plist->assoc (cddr plist)))))

  `(let*
       ,(plist->assoc params)
     ,@body
     ))




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









;;
;; Debug Injection Macro
;;






(define-macro (bind-form form param  sepxp)
  (cond

   ;; ((list? form)
   ;;  `(let*

   ;;       (($ ,param)
   ;;        ()
   ;;        )


   ;;       ))
   ((pair? form)
    `(let*
         (
          ($ ,param)
          (,(car form) (car $))
          (,(cdr form) (cdr $))
          )
       ,sepxp
       ))
   ))





;;
;; Function Composition Macro
;;
;;
;; (define-macro (comp . fs )
;;   (let
;;       ((var (gensym)))

;;    `(lambda (,var)
;;       ,(reduce
;;          (lambda (acc f)
;;            `(,f ,acc)
;;            )
;;          fs
;;          var
;;          ))))
