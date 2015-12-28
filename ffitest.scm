;(include "utils.scm")
(include "core.scm")
(include "ffi-tools.scm")

(define-macro (comment  sexp) 
  `(values))

;
;; Get string from pointer. 
;;


(define-macro (with-ref ref type value . body)
  `(let
       (
        (,ref     (malloc (size-of ,type)))
        )
     ,(cond
       ((equal? type 'int)    `(ptr-int-set ,ref ,value))
       ((equal? type 'float)  `(ptr-float-set ,ref ,value))
       ((equal? type 'double) `(ptr-double-get ,ref ,value))
       ((equal? type 'time_t) `(ptr-time_t-get ,ref ,value))
       )
     (let
         ((out (begin  ,@body)))
       (free ,ref)
       out
       )))

(define (bind-ref type value  func)
  (let
      ((ref     (malloc (size-of type))))
    
     (cond
          ((equal? type 'int)    (ptr-int-set    ref value))
          ((equal? type 'float)  (ptr-float-set  ref value))
          ((equal? type 'double) (ptr-double-set ref value))
          ((equal? type 'time_t) (ptr-time_t-set ref value))
          )
    (let
      ((out (func ref)))
      (free ref)
      out
      )))




(def-Cstruct  tm
              (tm_sec  int)
              (tm_min  int)
              (tm_hour int)
              (tm_mday int)
              (tm_mon  int)
              (tm_year int)
              (tm_wday int)
              (tm_yday int)
              (tm_isdst int)
              )


(define (test-struct)
  (tm-fields-tags
   (doto (tm-new)
         (tm->tm_sec! 0)
         (tm->tm_min! 0)
         (tm->tm_hour! 0)
         
         (tm->tm_year! 100)
         (tm->tm_mday! 0)
         (tm->tm_mon! 3)
         )))


(def-Cfunc-code tm-new
                ()
                (pointer (struct "tm"))

                "
                ___result_voidstar = malloc (sizeof (struct tm)) ;
                ")

(define (tm-make tm fields)
  (bind-values

   (sec min hour mday mon year wday yday isdst)

   fields
   
   (doto (tm-new)
         (tm->tm_sec! sec)
         (tm->tm_min!  min)
         (tm->tm_hour! hour)
         (tm->tm_mday! mday)
         (tm->tm_mon!  mon)
         (tm->tm_year! year)
         (tm->tm_wday! wday)
         (tm->tm_yday! yday)
         (tm->tm_isdst! isdst)
        )
   ))



;; (def-Cfunc-code tm->tm_year!
;;   ((pointer (struct "tm")) int)
;;   void
;;   "___arg1->tm_year = ___arg2 ;"
;;   )





;; (make-field-setter tm tm_year int)
;; (make-field-setter tm tm_mday int)
;; (make-field-setter tm tm_mon int)
  

(def-Cfunc-cast ptr->string
                void*
                char-string)

(def-Cfunc-cast time_t->int
                 time_t
                 unsigned-int)

(def-Cfunc-cast time_t->double
                 time_t
                 double)

;;;  int gethostname(char *name, size_t len);
;;
(def-Cfunc c_gmtime
            "gmtime"
            ((pointer time_t))
            (pointer (struct "tm"))            
            )

(def-Cfunc c_time
            "time"
            ((pointer time_t))
             time_t            
             )

(def-Cfunc c_mktime
            "mktime"
            ((pointer (struct "tm")))
            time_t            
           )



(define (gmtime t)
  (with-ref ptr 'time_t t
            (c_gmtime ptr)))


(comment
 (define (gmtime-wr x) 
    (let*
        (
         (ref     (malloc (size-of 'int)))
         ;;(ref          (ptr-void->time_t ref))
         )
      (ptr-int-set ref x)
      (let

          ((out (gmtime ref)))
        (free ref)
        out
        ))))

