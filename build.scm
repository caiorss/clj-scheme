;;(include "cljutils.scm")
;;(include "cljcore.scm")

(define (main . args)
  (println (str args))
  (case (list-ref args 2)
    (("utils")   (compile-file "cljutils.scm"))
    (("ffitest") (compile-file "ffitest.scm" ld-options: "-lm"))
    (("format")  (compile-file "format"))
    )
  )

;; (define (main)
;;   (build)
;;   )

;ç(build)


