
(define-macro (c-include header)
  `(c-declare ,(string-append "#include " header)))

(define-macro (def-Cfunc name c-name params return)
  `(define ,name
     (c-lambda ,params ,return ,c-name)))

(define-macro (def-Cfunc-code name params return code)
  `(define ,name
     (c-lambda ,params ,return ,code)))

(define-macro (def-Cfunc-cast name from-type to-type)
  `(define ,name
     (c-lambda
      (,from-type)
      ,to-type
      "___result = ___arg1 ;"
      )))


(define-macro (def-void-ptr-cast name c-type #!optional (c-type-string #f))
  `(def-Cfunc-code ,name
                 ((pointer void))
                 (pointer ,c-type)
                 ,(string-append
                   "___result_voidstar = ( "
                   (or c-type-string (symbol->string c-type))
                   " * ) ___arg1 ;")
                 ))



(define-macro (def-ptr-setter name type)
  `(def-Cfunc-code ,name
                  ((pointer ,type #f) ,type)
                  void
                  "* ___arg1 = ___arg2 ;"
                  ))

(define-macro (def-ptr-getter name type)
  `(def-Cfunc-code ,name
                 ((pointer ,type #f))
                 ,type
                 "___result = * ___arg1 ;"
                 ))



(define-macro (c-sizeof c-type )
  `((c-lambda
     ()  unsigned-int
     ,(string-append "___result = sizeof ("
                     (if (symbol?  c-type)
                         (symbol->string c-type)
                         c-type
                         ) " );"
                           ))))



;; Null pointer 
;;
(define NULL #f)

(c-define-type FILE "FILE")
(c-define-type FILE* (pointer FILE))
(c-define-type char* (pointer char))
(c-define-type void* (pointer void))
(c-define-type time_t "time_t")

(c-include "<stdlib.h>")
(c-include "<stdio.h>")
(c-include "<unistd.h>")
(c-include "<time.h>")

(def-void-ptr-cast ptr-void->int int)
(def-void-ptr-cast ptr-void->char char)
(def-void-ptr-cast ptr-void->double double)
(def-void-ptr-cast ptr-void->float float)
(def-void-ptr-cast ptr-void->time_t time_t)


(def-ptr-getter ptr-int-get int)
(def-ptr-getter ptr-double-get double)
(def-ptr-getter ptr-float-get float)
(def-ptr-getter ptr-time_t-get time_t)

(def-ptr-setter ptr-int-set int)
(def-ptr-setter ptr-double-set double)
(def-ptr-setter ptr-float-set  float)
(def-ptr-setter ptr-time_t-set time_t)


(define size-of-ctypes
  `(
   (int     ,(c-sizeof int))
   (double  ,(c-sizeof double))
   (float   ,(c-sizeof float))
   (char    ,(c-sizeof char))
   (char*   ,(c-sizeof "char *"))
   (double* ,(c-sizeof "double *"))
   (time_t  ,(c-sizeof "time_t"))
   (size_t  ,(c-sizeof "size_t"))
   ))

(define (size-of type)
  (let
      ((c (assoc type size-of-ctypes)))
    (if c
        (cadr c)
        #f
        )))

(define malloc (c-lambda (int) (pointer void #f) "malloc"))
(define free (c-lambda ((pointer void #f)) void "free"))

(define (make-memory bytes)
  (let ((mem (malloc bytes)))
    (make-will mem (lambda (obj) (display "free function called\n") (free obj)))
    mem))


(define-macro (with-malloc params . body)
  (let
      (
       (var    (car  params))
       (size-t (cadr params))
       (out    (gensym))
       )
   `(let*
        ((,var (malloc ,size-t))
         (,out (begin ,@body))
         )
      (free ,var)
      ,out      
      )))


(define-macro (def-Cstruct-field struct field return-type)
  (let*
      (
       (struct-str ( symbol->string struct))
       (field-str  ( symbol->string field))

       (accessor   ( string->symbol
                   (string-append
                    struct-str "->"  field-str)))       
       )
    
    `(def-Cfunc-code ,accessor
                      ((pointer  (struct ,struct-str)))
                      ,return-type
                      ,(string-append  "___result = ___arg1->" field-str " ;")
                      )))


(define-macro (def-Cstruct-field-setter
               struct
               field
               type 
               )
  (let* (
         (struct-name (symbol->string struct))
         (field-name  (symbol->string field))

         (setter      (string->symbol
                       (string-append
                         struct-name
                         "->"
                         field-name
                         "!"
                         )))
         )
      
    `(def-Cfunc-code ,setter
      ((pointer (struct ,struct-name)) ,type)
       void
       ,(string-append
         "___arg1->" field-name  " = ___arg2 ;")
      )))



(define-macro (def-Cstruct struct . field-return-values)
    
  (let*
      (
       (make-accessor-name (lambda (struct field)
                             (string->symbol
                              (string-append
                               (symbol->string  struct)
                               "->"
                               (symbol->string field)))))
       
       (struct-str    (symbol->string struct))

       (field-names   (map car field-return-values))
       
       (destructor-name     (string->symbol
                             (string-append
                              struct-str
                              "-fields"
                              )))
       
       (destructor-tag-names     (string->symbol
                                  (string-append
                                   struct-str
                                   "-fields-tags"
                                   )))

       
       
       (field-accessors  (map
                          (lambda (c)
                            (make-accessor-name struct (car c)))
                          field-return-values
                          )))

   `(begin
      ,@(map
         (lambda (c) `(def-Cstruct-field ,struct ,(car c) ,(cadr c)))
         field-return-values
         )

      (begin
         ,@(map
            (lambda (c) `(def-Cstruct-field-setter
                           ,struct ,(car c) ,(cadr c)))
            field-return-values           
            ))

      (define (,destructor-name st)
        (list ,@(map
                 (lambda (f) `(,f st))
                 field-accessors
                 )))

      (define (,destructor-tag-names st)
        (list  ,@(map

                  (lambda (f tag)
                    `(list (quote ,tag) (,f st)))
                  
                  field-accessors
                  field-names
                  )))
      )))
