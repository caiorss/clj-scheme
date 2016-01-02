(c-declare
"
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

extern char ** environ;

"
)

(define  (ignore func . args)
  (begin
    (apply func args)
    (values)))

(define print-environ
  (c-lambda

   ()
   void
   "
int i = 0;
while(environ[i]) {
  printf(\"%s\\n\", environ[i++]);
}
  "

   ))



;;
;;  getenv, secure_getenv - get an environment variable
;;
;; signature: char *getenv(const char *name);
;;
(define gentenv
  (c-lambda
   (char-string)
   char-string
   "getenv"
   ))

;;
;;
;; signature:
;;  int setenv(const char *name,
;;             const char *value,
;;             int overwrite)
;;
(define (setenv var val)
  (define ___setenv
    (c-lambda
     (char-string char-string int)
     int
     "setenv"
     ))
  (ignore ___setenv var val 1)
  )




(define (env-vars)

  (define get-environ-variable
    (c-lambda
     (int)
     char-string

#<<end-c-code
     if ( environ[___arg1] != NULL ){
       ___result = environ [___arg1] ;
      }else {
       ___result = NULL ;
                 }
end-c-code
   ))


  (define (__environ idx acc)
  (let
      (
       (out (get-environ-variable idx))
       )
    (if (not out)
        (reverse acc)
        (__environ (+ 1 idx) (cons out acc))
        )))

  (__environ 0 '()))
