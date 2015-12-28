#! /usr/bin/env gsi



(defn map-apply (f xss)
  (map (fn (xs) (apply f xs)) xss))

(def opts '("--coomand1" "a" "b" "c" "d"
            "--command2" "y" "z"
            "--command3"
            "--command4"
            ))


(defn bind-nil (f x #!optional (val #f))
  (if (null? x)
      val
      (f x)
      ))

(def opt-param?
     (partial string/starts-with "--"))

(defn opt-get (opts)

  (if (null? opts)

      '()

      (letc
       (
        hd        (car opts)
        tl        (cdr opts)
        res       (take-while-rest opt-param? tl)
        args      (bind-nil car res '())
        rest-args (bind-nil cadr res '())
        )

       (list (list hd args) rest-args)
       )))

(defn __opt-parse (opts acc)
  (if  (null? opts)

       (reverse acc)

       (letc

        [
         params-restp   (opt-get opts)
         params         (car  params-restp)
         restp          (cadr params-restp)
        ]

        (__opt-parse  restp
                    (cons params acc))
        )))

(defn opt-parse (opts)
  (__opt-parse opts '()))



(opt-run

 name: "Make file automation tool"

 help: "Build the file "

 option: any, one-of

 (list
  opt: "--start"
  arg: 'none
  fun:  start-daemon
  )
 (list
  opt: "--stop"
  arg: 'none
  func: stop-daemon
  )
 (list
  "--restart"
  arg: 'none
  func: stop-daemon
  ))


(-> (doto (make-table)
          (table-set! 'x 10)
          (table-set! "--command1" inc)
          (table-set! "--command2" dec)
          )

    (table->list)
    )


(defn next-st (xs)
  (list
   out:   (car xs)
   state: (cdr xs)))


(defn  split-opts (xs acc1 acc2 flag)
  (if (null? xs)
      '()
      (bind-cons (hd . tl)
                 (if (string/starts-with "--" hd)


                     ))))


(define (__split-when f xs acc)
  (if (null? xs)
      '()
      (bind-cons (hd . tl) xs
                 (if (not (f hd))
                     (list (reverse acc) tl)
                     (__split-when f tl (cons hd acc))
                     ))))

(define (split-when f xs)
  (__split-when f xs '()))

(define (__take-while-rest f xs acc1 acc2)

  (if (null? xs)
      '()
      (bind-cons (hd . tl) xs
                 (if (f hd)
                     (list (reverse acc1 ) acc2)
                     (__take-while
                      f
                      tl
                      (cons hd acc1)

                      )
                     ))
      ))


(define-macro ($dbv f . args)
  (let

      ((result (gensym)))

    `(let
         ((,result (,f ,@args)))

       (display " > ")
       (display (str (quote (,f ,@args))))
       (display " = ")
       (display (str ,result))
       (newline)

       ,result ;;; Return value

       )))

(define (__take-while-rest f xs acc)

  (if (null? xs)
      '()
      (bind-cons (hd . tl) xs
                 (if (f hd)
                     (list (reverse acc ) (cons hd tl))
                     (__take-while-rest f tl (cons hd acc))) )
      ))


(define (take-while-rest f xs)
  (__take-while-rest f xs '()))



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


(define (main . args)
  (println args))

(println "Dummy")
