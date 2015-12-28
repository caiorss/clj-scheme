
(define-macro (comment .  sexp)
  `(values)
  )


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
      (lambda (pair) (bind-cons (h . t) pair (* h t)))
      '((1 . 2) (3 . 4) (5 . 6))
    )

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


(define nil 'nil)
(define true #t)
(define false #f)

(define (false? x) (not (and x #t)))
(define (true? x) (and x #t))

(define (identity x) x)
(define (constantly c) (lambda (x) x))

(define (eof? x)  (equal? x #!eof))
(define (void? x) (equal? x #!void))

(define (even? x) (= 0 (remainder x 2)))
(define (odd? x) (= 1 (remainder x 2)))

(define concat append)

(define (println x)
  (display x)
  (newline))


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
(define (plist->alist plist)
  (if (null? plist)
      '()
      (cons
       (list (car plist) (cadr plist))
       (plist->alist (cddr plist)))))

;;; Convert association list to plist
(define (alist->plist assocl)
(if (null? assocl)
      '()
      (let
          ((hd (car assocl))
           (tl (cdr assocl)))
        (cons (car hd)
           (cons (cadr hd)
                 (alist->plist tl))))))


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
      (f var-err)
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


(define (inc x)
  "Increment a number, add 1"
  (+ x 1) )

(define (dec x)
  "Decrement a number, subract 1"
  (- x 1))


(define (list-get lst n)
  (if  (or (>= n (length lst)) (< n 0))
       nil
       (list-ref lst n)
       ))


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


(define (zipv . xss)
  (apply map vector xss))

(define (zip . xss)
  (apply map list xss))


(define (plist->assoc plist)
  (if (null? plist)
      '()
      (cons
       (list (car plist) (cadr plist))
       (plist->assoc (cddr plist)))))

;;
;; Oly returns true if all arguments are true
;;
(define (all? . args)
  (reduce (lambda (acc x) (and acc x)) args true))

(define (any? . args)
  (reduce (lambda (acc x) (or acc x)) args false))

(define (for-all? pred xs)
  (apply all? (map pred xs)))

(define (for-any? pred xs)
  (apply any? (map pred xs)))

;;
;; Invert predicate function
;;
(define (compl pred)
  (lambda (x) (not (pred x))))

;;
;; Join predicate functions
;;
(define (pred-or . preds)
  (lambda (x)
    (reduce
     (lambda (acc f) (or (f x) acc)  )
     preds
     #f
     )))

(define (pred-and . preds)
  (lambda (x)
    (reduce
     (lambda (acc f) (and (f x) acc))
     preds
     #t
     )))

(define (pred-nor . preds)
  (lambda (x)
    (not (reduce
       (lambda (acc f) (or (f x) acc)  )
       preds
       #f
       ))))

(define (pred-nand . preds)
  (lambda (x)
    (not
     (reduce
       (lambda (acc f) (and (f x) acc))
       preds
       #t
       ))))

(define (pred-false x)  #f)
(define (pred-true  x)  #t)




(define (__take-while f xs acc)

  (if (null? xs)
      '()
      (bind-cons (hd . tl) xs
                 (if (f hd)
                     (reverse acc )
                     (__take-while f tl (cons hd acc))) )
      ))

(define (take-while f xs)
  (__take-while f xs '()))


(define (__take n xs acc)
  (if (or (null? xs) (zero? n))
      (reverse acc)
      (__take (- n 1) (cdr xs) (cons (car xs) acc))
      ))

(define (take n xs)
  (__take n xs '()))

(define (drop n xs)
  (if (or (null? xs) (zero? n))
      xs
      (drop (- n 1) (cdr xs))))

(define (__drop-while f xs acc)

  (if (null? xs)
      acc
      (bind-cons (hd . tl) xs
                 (if (not  (f hd))
                     (__drop-while f tl (cons hd acc))
                     (reverse acc)
                  ))))

(define (drop-while f xs)
  (__drop-while f xs '()))

;;
;; Function Composition
;;
(define (__compose funcs x)
  (if (null? funcs)
      x
      (__compose (cdr funcs) ((car funcs) x))))

(define (fcomp . funcs)
  (lambda (x) (__compose funcs x)))


(define (juxt . funcs)
  (lambda (x)
    (map
     (lambda (f) (f x))
     funcs
     )))

(define (juxtp . params)
  (let*

      (
       (alist (plist->alist params))
       (tags  (map car  alist))
       (funcs (map cadr alist))
       )
    (lambda (x)
      (zip tags ((apply juxt funcs) x)))))



(define (__map-index-m f xs acc index)
  (if (for-all null? xs)
      (reverse acc)

      (__map-index-m
       f
       (map cdr xs)
       (cons    (apply f index (map car xs)) acc)
       (+ 1 index))))


(define (map-index f . xs)
  (__map-index-m f xs '() 0 ))


(define (__collect-until pred func acc)
  (let
      (
       (x (func))
       )
    (if (pred x)
        (reverse acc)
        (__collect-until
         pred
         func
         (cons x acc)
         )
        )))

(define (collect-until pred func)
  (__collect-until pred func '()))

(define (__collect-times n f z acc)
  (if (= n z)
      (reverse acc)
      (__collect-times
       n
       f
       (+ z 1)
       (cons (f z) acc)
       )
      ))

(define (collect-times n f)
  (__collect-times n f 0 '()))

(define (__exec-times n f z)
  (if (not  (= n z))
      (begin
        (f z)
        (__exec-times n f (+ z 1) ))))

(define (exec-times n f)
  (__exec-times n f 0))


(comment


"
Example:
>
(
 (group-by-pred
  (list \"pdf\"     (file/ends-with \".pdf\"))
  (list \"tar.gz\"  (file/ends-with \".tar.gz\"))
  (list \"tar.bz2\" (file/ends-with \".tar.bz2\"))
  (list \"tgz\"     (file/ends-with \".tgz\"))
  )

  (dir/list \"~/Downloads\") )
"
  ) ;;; End of comment

(define  (group-by-pred . pred-list)
  (lambda (xs)
    (map
     (lambda (row)

       (let
           ((tag (car  row))
            (fun (cadr row))
            )

         (list
          tag
          (filter fun xs)
          )
         ))
     pred-list
     )))



;;
(comment "Function Transformations:")

(define (t-map f)
  (lambda (list xs) (apply map f xs)))

(define (t-filter)
  (partial filter f))

(define (t-reduce f #!optional (acc nil))
  (lambda (xs) (reduce f xs acc)))

(define (t-curry f)
  "A function of many arguments is turned into
   a function of one argument that takes a list
   of original function."
  (lambda (list xs) (apply f xs)))

(define sum  (t-reduce + 0))
(define prod (t-reduce * 1))


(define (vector-map f vec)
  (let*

      ((n  (vector-length vec))
       (v-new (make-vector n))
       )

    (dotimes i n
             (vector-set! v-new i (f (vector-ref vec i))))
    v-new
   ))


;; (def f
;;      (juxtp
;;       name: identity
;;       type: (comp file-info file-info-type)
;;       size: (comp file-info file-info-size)
;;       ))


(define (str s)
  "
  Example:

  > (str (vector (list 1 2 3 4) (vector '+ 3 4 6) 12 \"hello world\"))
  \"[(1 2 3 4) [+ 3 4 6] 12 \\\"hello world\\\"]\"
  >

  > (vector (list 1 2 3 4) (vector '+ 3 4 6) 12 \"hello world\")
  #((1 2 3 4) #(+ 3 4 6) 12 \"hello world\")
  >
  "
  (cond

   ((string? s) (string-append "\"" s "\""))
   ((number? s) (number->string s))
   ((symbol? s) (symbol->string s))
   ((list? s)   (string-append "(" (string/join " "
                                                (map str s)) ")"))
   ((pair? s)   (string-append "(" (str (car s)) " . " (str (cdr s))  ")"))

   ((vector? s) (string-append "["
                               (string/join " "
                                (map str (vector->list s))) "]"))

   ))


(define-macro ($dbg f . args)
  "
  Debug Injection Macro:

  > (def a 10)
  > (+ 10 40 ($dbg - 10 ($dbg a)))
  > a = 10
  > (- 10 ($dbg a)) = 0
  50
  >
  "
  (let

      ((result (gensym)))

    `(let
         ((,result ,(if (null? args) f `(,f ,@args) )))

       (display " > ")
       (display (str ,(if (null? args) `(quote ,f) `(quote (,f ,@args)))))
       (display " = ")
       (display (str ,result))
       (newline)

       ,result ;;; Return value

       )))
