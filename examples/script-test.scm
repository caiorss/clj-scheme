#! /usr/bin/env gsc-script
;;
;;
;;
;;----------------------------------------------

(defn gsc/compile (filename . options)
  (apply read-process "gsc" filename options))

(defn clean-files ()
  (do
      (println "Clean files")
      (for-each delete-file
                (filter
                 (partial pregexp-match ".o\\d+$")
                 (dir/list "."))
                )))

;; ($dbg filter
;;  (pred-or
;;   (partial pregexp-match ".o\\d+$")
;;   (partial pregexp-match ".out$")
;;   (partial pregexp-match ".bin$")
;;   )

(defn run-tests ()
  (println "Run all tests"))

(defn build ()

  (match (second (command-line))

         (nil        (println "Options [clean|test|run]"))
         ("clean"    (clean-files)  )
         ("test"     (run-tests)    )
         ("environ"  (gsc/compile "environ.scm"))

         ;; ("curl"     (println  (gsc/compile "curl.ss"
         ;;                                    "-L/usr/lib/i386-linux-gnu"
         ;;                                    "-lcurl"

         ;;                                    )))

         ))


(build)
;;(println "Testing the function")
