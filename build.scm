

(define (build)
  (compile-file "ffitest.scm" ld-options: "-lm"))

(define (make-reload)
  (build)
  (load "ffitest"))
