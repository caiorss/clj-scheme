(include "ffi-tools.scm")

(define-macro (comment  sexp) 
  `(values))

;
;; Get string from pointer. 
;;

(def-Cfunc-cast ptr->string  void* char-string)

;;;  int gethostname(char *name, size_t len);
;;
(def-Cfunc-code  get-hostname
                  () 
                  char-string
                  "
                  char hostname [64];
                  gethostname(hostname, 64);
                  ___result = hostname ;
                  "
                  )

(def-Cfunc gmtime
            "gmtime"
            ((pointer time_t))
            (pointer (struct "tm"))            
            )

(def-Cfunc-cast time_t->int
                 time_t
                 unsigned-int)

(def-Cfunc time-now
            "time"
            ((pointer time_t))
             time_t            
             )


(def-Cfunc-code  pointer-int-set 
                  ((pointer int #f) int)
                  void
                  "* ___arg1 = ___arg2 ;"
                  )

(def-Cfunc-code pointer-int-get
                 ((pointer int #f))
                 int
                 "___result = * ___arg1 ;"
                 )

(let
    (
     (ref     (malloc (size-of 'int)))
     ()
     )

  )

(comment
 (with-ref (ref int 0)
           (gmtime ref)
           ))


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

(define (get-hostname2)
  (with-malloc (s 64)               
               (gethostname s 64)
               (ptr->string s)
               ))
