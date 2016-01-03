

(defn sexp/read-string (s)
  "Parse a string to s-expression, lisp parsed code
   but not evaluated. Note: It only reads one s-expression.

   Example:

   > (sexp/read-string \"(+ 1 2 3 4) (sin 10) (cos 20)\")
   (+ 1 2 3 4)
   >

   > (eval (sexp/read-string \"(+ 1 2 3 4) (sin 10) (cos 20)\"))
   10
   "

  (call-with-input-string   s read))


(defn sexp/read-string-all (s)
  "Pase all s-expressions in a string.

  Example:

  > (sexp/read-string-all \"(+ 1 2 3 4) (sin 10) (cos 20)\")
  ((+ 1 2 3 4) (sin 10) (cos 20))
  >
  "

   (call-with-input-string s read-all))

(defn sexp/load-string (s)
  "Eval a s expression from a string"
  (eval (read-string)))





(defn string/join (sep strings)
  "
  (string/join <sep> <list of strings>) -> string

  Join a list of string

  Example:

  (string/join \"-\" '(\"a\" \"b\" \"c\"))
  \"a-b-c\"


  "
  (reduce
   (fn (acc x) (string-append acc sep x ))
   strings
   ))

(defn char->string (c)

  "Convert a char to string"
  (list->string (list c)))

(defn string/butlast (str)

  "Return a string removing the last character"
  (substring str 0 (- (string-length str) 1)))

(defn string/last (str)
  "Return the last character of a string"

  (char->string
   (string-ref str (- (string-length str) 1))))

(defn path/sep (platform)
  "Return the path separator for a given
   platform
  "
  (case platform
    ((unix) "/")
    ((win)  "\\")

    ))

(defn string/rest (s)
  (substring s 1 (- (string-length s) 1)))

(defn string/ends-with (suffix s)
  "
   (string/ends-with <suffix> <s>) -> bool

   Test if string <s> ends with suffix <suffix>

   Example:

  > (string/ends-with  \".pdf\" \"dummy.pdf\")
  #t
  > (string/ends-with  \".doc\" \"dummy.pdf\")
  #f
  >
  "
  (letc
   (n1  (string-length s)
    n2  (string-length suffix))
   (if (< n1 n2)
       #f
       (equal? suffix (substring s (- n1 n2) n1))
       )))

(defn string/starts-with (prefix s)
  "
  (string/starts-with <prefix> <s>) -> bool

  Test if a string starts with a prefix

  "
  (letc
   (n1  (string-length s)
    n2  (string-length prefix))
   (if (< n1 n2)
       #f
       (equal? prefix (substring s 0 n2))
       )))

(defn path/join (p . paths )
  (string/join "/"
               (append
                (if (equal? p "/")
                    '("")
                    (list p)
                    )
                paths)))


(defn path/remove-sep (path)
  (if (equal? (string/last path) "/")
      (string/butlast path)
      path
      ))


(defn file/read (file-name)
  "Read a text file"

  (letc [
         p   (open-input-file file-name)
         out   (string/join "\n"
                            (collect-until
                             eof?
                             ($thunk read-line p)))
         ]

        (close-input-port p)
        out
        ))


(defn file/ends-with (suffix)
  "
   (file/ends-with <string) -> ((<string>) -> bool)

   Test if file ends with suffix.

   Example:

   > (def is_pdf (file/ends-with \".pdf\"))

   > (filter is_pdf (list \"f1.pdf\" \"f2.doc\" \"d4.pdf\"))
   (\"f1.pdf\" \"d4.pdf\")
   >
   "
  (fn (f)
      (string/ends-with suffix f)))

(defn dir/cwd ()
  "Show current directory"
  (current-directory))

(defn dir/list (path)
  "List all directories and files in a given path"
  (map
   (fn (p) (path/join path p))
   (directory-files path))  )

(defn dir/list-files (path)
  "List only files in a given path"
  (filter
   (fn (x) (equal? 'regular (file-info-type (file-info x))))
   (dir/list path)))

(defn dir/list-dirs (path)
  "List only directories the path"
  (filter
   (fn (x) (equal? 'directory (file-info-type (file-info x))))
   (dir/list path)))

(defn dir/filter-files (path . suffix)
  "Filter all files ending in a given extension."
  (filter
   (fn (x)
       (and  (equal? 'regular (file-info-type (file-info x)))
             ((apply pred-or (map file/ends-with suffix)) x)
             ))
   (dir/list path)))


(defn read-process (command . arguments)
  "
   Read a output from process

  (read-process <command> . <arguments>)

   Arguments:
    - command:   commmand to be executed
    - arguments: Arguments to be passed to the process
  "
  (letc
   (p       (open-process  `(path: ,command
                             arguments:  ,arguments))
    )

   (string/join "\n"
      (collect-until eof? (fn [] (read-line p))))

   ))

(defn run-process (command . arguments)
  "Run a process and return a process object"
  (open-process `(path: ,command arguments: ,arguments)))


(defn file/read-sexps [file-name]
  "
   Read all s-expressions in a file, but it checks if the
   file starts with #! shebang that means that is a
   script file.

  "

  (letc
   [p           (open-input-file file-name)

    first-line (string/starts-with
                  "#!"
                  (call-with-input-file file-name read-line))
    ]

         ;; Test if file is a script
     (if first-line
         (read-line p)
         )

     (letc  [out (collect-until eof? ($thunk read p))]
            (close-input-port p)
            out
            )))



(comment
 (defn tools/repl []

    (do
        (print ">> ")

        (letc

         [s (read)]

         (cond

          ((equal? s '/pwd) (println (current-directory)))
          ((pred-true s)    (println (eval s)))

          )
         )
      )))

(defn ignore (list xs)
  "Ignore input and returns nothing"
  (values))

(defn browse-url (url)
  (ignore
   (run-process
    "firefox"
    "-no-remote"
    "-new-tab"
    "-P"
    "dev"
    url
    )))


(defn nohup (list commands)
  "Turn a command into a daemon."
  (apply run-process "nohup" commands ))

(defn curl (list commands)
  (apply read-process "curl" "-s" commands))

(defn curl-download (url)
  "Download file. "
  (run-process
   "curl"
   "-s"
   "-L"
   "-O"
   url
   ))


(defn xclip ()
  "Paste from clipboard in  Linux/Unix"
  (read-process
   "xclip"  "-o"  "-selection" "clipboard"))


;; (defn next-arg (arglist0
;;   (bind-cons (hd . tl) arglist

;;              (if (string/starts-with "-" hd)


;;                  )))

;; (defn dir/tree (paths acc)
;;   (let
;;       ((files (dir/list-files path))
;;        (dirs  (dir/list-dirs  path))
;;        )
;;     (dir/tree

;;      )))



(comment
 (def p
      (thread-start!
       (make-thread
        ($thunk run-process
                "nohup"
                "ruby"
                "/home/tux/PycharmProjects/clojure/tools/maven.rb"
                "-run-repl")))))




(comment
 (run-process
  "nohup"
  "ruby"
  "/home/tux/PycharmProjects/clojure/tools/maven.rb"
  "-run-repl"))





;; (defn flat [list . xs] (reduce append xs '()))

(defn string/quote [s]
  (string-append "\"" s  "\""))

(defn gsc-build ()
  "Execute the buiild script in current directory 
   namely: \"build.ss\"
  
  "
  (do
      (shell-command "gsi \"build.ss\"")
      (println "Compiled Ok.")
    ))


(defn gsc-compile (filename . plist)
  "
  Compile a file 

  "
  (letc
   [
    params      (plist->alist plist)
                
    prelude     (alist-get params prelude:)
    ld-options  (alist-get params ld-options:)      
    output      (alist-get params output:)
    ]

   (apply  run-process
           (reject nil?
            `("gsc"
              
              ,@(if (not-nil? output)     (list "-o" output) '(nil))
              ,@(if (not-nil? prelude)    (list "-prelude"  prelude) '(nil))
              ,@(if (not-nil? ld-options) (list "-ld-options"  ld-options) '(nil))

              ,filename           
              )))))

(reject nil?
 `("gsc"
   
   ,@(if #f     '("-o" output))
   ,@(if #t    '( "-prelude"  prelude)    '(nil))
   ,@(if #f '( "-ld-options"  ld-options) '(nil))

   ))


(defn symbol/append (s . syms)
  (string->symbol
   (apply  string-append (symbol->string s)
           (map symbol->string syms)  )))





