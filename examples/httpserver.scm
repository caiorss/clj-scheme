;;; File: "simple-http-server.scm"

(define http-server-address "0.0.0.0:8000") ;; "*:80" is standard

(define (http-server-start)
  (let ((accept-port
         (open-tcp-server (list server-address: http-server-address
                                eol-encoding: 'cr-lf))))
    (let loop ()
      (let ((connection (read accept-port)))
        (if (not (eof-object? connection))
            (begin
              (http-serve connection)
              (loop)))))))

(define (http-serve connection)
  (let ((request (read-line connection)))
    (if (string? request)
        (let* ((r
                (call-with-input-string
                 request
                 (lambda (p)
                   (read-all p (lambda (p)
                                 (read-line p #\space))))))
               (method
                (car r)))
          (cond ((string-ci=? method "GET")
                 (http-get connection (cadr r)))
                (else
                 (println "unhandled request: " request)))))
    (close-port connection)))

(define (http-get connection document)
  (print port: connection
         "HTTP/1.0 200 OK\n"
         "Content-Type: text/html; charset=ISO-8859-1\n"
         "Connection: close\n"
         "\n"
         "<pre>\n"
         "document requested: " document "\n"
         "</pre>\n"))

(http-server-start)
