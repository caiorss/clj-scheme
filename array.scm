(include "utils.scm")
(include "core.scm")
(include "ffi-tools.scm")

(c-declare "#include <stdlib.h>")

(c-define-type int* (pointer int #f))

(define malloc-int-array
   (c-lambda (int) int* " ___result_voidstar =  malloc (___arg1 * sizeof (int)) ; "))

; pure but slow version:
;
;(define int-array-ref
;  (c-lambda (int* int) int "int_array_ref"))
;
;(define int-array-set!
;  (c-lambda (int* int int) void "int_array_set"))

; faster version:


;; (make-carray-getter double)
;; (make-carray-setter double)

;; (make-carray-getter unsigned-int8)
;; (make-carray-setter unsigned-int8)

;; (make-carray-getter int)
;; (make-carray-setter int)




;; (define s 
;;   (apply-macros
;;    '(make-carray-getter make-carray-getter)
;;    '(int unsigned-int8 unsigned-int16 double char)))




;; define int-array-ref
;; (c-lambda (int* int) int "___result = ___arg1[___arg2];"))

;; (define int-array-set!
;;   (c-lambda (int* int int) void
;;             "___arg1[___arg2] = ___arg3;"))





(define (carray->size c-array)
  (vector-ref c-array 2))

(define (carray->type c-array)
  (vector-ref c-array 1))

(define (carray->ref c-array)
  (vector-ref c-array 3))


;; (define (__collect-times n f z acc)
;;   (if (= n z)
;;       (reverse acc)
;;       (__collect-times
;;        n
;;        f
;;        (+ z 1)
;;        (cons (f z) acc)
;;        )
;;       ))

;; (define (collect-times n f)
;;   (__collect-times n f 0 '()))

;; (define (__run-times n f z)
;;   (if (not  (= n z))
;;       (begin
;;         (f z)
;;         (__run-times n f (+ z 1) ))))

;; (define (run-times n f)
;;   (__run-times n f 0))


;; (define (get-int-array array)
;;   (let
;;       ((ref   (c-array->ref  array))
;;        (n     (c-array->size array))
;;        )      
;;     (collect-times n
;;                    (lambda (i)
;;                      (int-array-ref ref i) ))         
;;       ))


;; (define (set-int-array array values)
;;     (let
;;       ((ref   (c-array->ref  array))
;;        (n     (c-array->size array))
;;        )      

;;       (exec-times
;;        n
;;        (lambda (i)
;;          (int-array-set! ref i
;;                          (list-ref values i))
;;          )
;;        )
;;       ))


  




