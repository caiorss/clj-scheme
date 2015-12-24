




(define nil 'nil)
(define true #t)
(define false #f)


(define-macro (wrap-nil sexp)
  `(with-exception-catcher
   (lambda (e) nil)
   (lambda () ,sexp)
   ))

(define (nil? x)
  (or  (equal? x 'nil)
       (null? x)))

(define (not-nil? x)
  (not (nil? x)))

(define (first xs)
  (if (nil? xs)
      nil
      (car xs)
      ))

(define (second xs)
  (if (nil? xs)
      nil
      (cdar xs)
      ))

(define (rest xs)
  (if (nil? xs)
      nil
      (cdr xs)
      ))

(define (last xs)
  (if (nil? xs)
      nil
      (if (nil? (rest xs))
          (first xs)
          (last (rest xs))
          )))

(define (consc hd tl)
  (if (nil? tl)
      (cons hd '())
      (cons hd tl)
      ))

(define  (partial f . args)
  (lambda (args-rest)
    (apply f (append
              args
              (if (list?  args-rest)
                  args-rest
                  (list args-rest)
                  )))))


;;; Convert plist to association list
(define (plist->assoc plist)
  (if (null? plist)
      '()
      (cons
       (list (car plist) (cadr plist))
       (plist->assoc (cddr plist)))))

;;; Convert association list to plist
(define (assoc->plist assocl)
(if (null? assocl)
      '()
      (let
          ((hd (car assocl))
           (tl (cdr assocl)))
        (cons (car hd)
           (cons (cadr hd)
                 (assoc->plist tl))))))

(define-macro (comment  sexp)
  `(values)
  )

(define (plist-get key params)

  (if ( nil? params)
      nil
      (let
          ((hd1 ( car params))
           (hd2 ( cadr params))
           (tl2 ( cddr params))

           )
        (if (equal? hd1 key)
            hd2
            (if (nil? (cdr tl2))
                nil
                (plist-get key tl2)
                )))))


(define (apply-or-nil f arg)
  (if (not (nil? arg))
      (f arg)
      nil
      ))

;;
;; Based on: https://adambard.com/blog/acceptable-error-handling-in-clojure/
;;
(define (bind-error f var-err)
  (if (nil? (car var-err))
      (f var)
      (list nil (cadr var-err))
      ))

(define (apnil f)
  (lambda (arg)
    (if (nil? arg)
        nil
        (f arg)
        )))

(define (fnil f arg-list nil-return)
  (let ((result
         (if (null? arg-list)
             nil
             (apply f arg-list)
             )))
    (if (nil? result)
        nil-return
        result
        )))

(define (list-get lst n)
  (if  (or (>= n (length lst)) (< n 0))
       nil
       (list-ref lst n)
       ))

(define (inc x)
  (+ x 1) )

(define (dec x)
  (- x 1))

(define-macro (inc! x)
  `(set! ,x (+ ,x 1)))

(define-macro (dec! x)
  `(set! ,x (- ,x 1)))

(define empty? null?)

(define  (__reduce f xs acc)
  (if (null? xs)
      acc
      (__reduce f (cdr xs) (f acc (car xs)))
      ))

(define (reduce f xs #!optional (acc nil))
  (if (nil? acc)
      (__reduce f (cdr xs) (car xs))
      (__reduce f xs acc)
   ))



(define (__filter f xs acc)
  (if (null? xs)
      (reverse acc)
      (let ((hd (car xs))
            (tl (cdr xs))
            )
        (__filter f tl  (if (f hd)
                            (cons hd acc)
                            acc
                            )))))

(define (filter f xs)
  (__filter f xs '()))


;; (define (map-index f . xs)
;;   (reduce
;;    (lambda (acc x)
;;      (let*
;;          ((elem  (car acc))
;;           (num   (car elem))
;;           )
;;        (cons (apply f (+ 1 num) x) acc)
;;        ))
;;    xs
;;    '()
;;    )
;;   )

(define (zipv . xss)
  (apply map vector xss))

(define (zip . xss)
  (apply map list xss))

;; (define map-index (f . xss)
;;   ())



(define-macro (defn name params body)
  `(define (,name ,@params) ,body))


(define-macro (def name value)
  `(define ,name ,value))

(define-macro (fn params body)
  `(lambda ,params ,body))


(define (plist->assoc plist)
  (if (null? plist)
      '()
      (cons
       (list (car plist) (cadr plist))
       (plist->assoc (cddr plist)))))


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


(define-macro ($-> x0 . sexps)
  (reduce
   (lambda (acc sp)
     `(let (($ ,acc))
        ,(let ((r sp))
           (if (symbol? r)
               `(,r $)
                r
               ))))
   sexps
   x0
   ))

;; ($-> 500
;;      (/ $ 20)
;;      (- 40 $)
;;      (expt $ 2)
;;      log
;;      exp
;;      sqrt
;;      )


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

(define-macro (when cond . sexps)
  `(if ,cond
      (begin ,@sexps)
      ))

(define-macro (unless cond . sexps)
  `(if (not ,cond)
      (begin ,@sexps)
      ))



(define-macro (do . sexps)
  `(begin
    ,@sexps
    ))

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


;;
;; Debug Injection Macro
;;
(define-macro ($dbg f . args)
  (let ((sym (gensym)))
    `(let
         ((,sym (,f ,@args)))
       ;;(println (quote (,f ,@args)))
       (println ,sym)
       ,sym
       )
    ))

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


(defn string/join (sep strings)
  (reduce
   (fn (acc x) (string-append acc sep x ))
   strings
   ))

(defn char->string (c)
  (list->string (list c)))

(defn string/butlast (str)
  (substring str 0 (- (string-length str) 1)))

(defn string/last (str)
  (char->string
   (string-ref str (- (string-length str) 1))))

(defn path/sep (platform)
  (case platform
    ((unix) "/")
    ((win)  "\\")

    ))

(defn string/rest (s)
  (substring s 1 (- (string-length s) 1)))

(defn string/ends-with (suffix s)
  (letc
   (n1  (string-length s)
    n2  (string-length suffix))
   (if (< n1 n2)
       #f
       (equal? suffix (substring s (- n1 n2) n1))
       )))

(defn string/starts-with (prefix s)
  (letc
   (n1  (string-length s)
    n2  (string-length prefix))
   (if (< n1 n2)
       #f
       (equal? prefix (substring s 0 n2))
       )))

(defn path/join (p . paths )
  (string/join "/"
               (append
                (if (equal? p "/")
                    '("")
                    (list p)
                    )
                paths)))


(defn path/remove-sep (path)
  (if (equal? (string/last path) "/")
      (string/butlast path)
      path
      ))


(def cwd current-directory)

(defn dir/list (path)
  (map
   (fn (p) (path/join path p))
   (directory-files path))  )
