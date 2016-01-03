(c-declare "#include <string.h>")
(c-declare "#include <stdlib.h>")
(c-declare "#include <unistd.h>")
(c-declare "#include <sys/types.h>")
(c-declare "#include <sys/socket.h>")
(c-declare "#include <netinet/in.h>")
(c-declare "#include <sys/un.h>")
(c-declare "#include <errno.h>")

(define-macro (define-c-constant var type . const)
  (let* ((const (if (not (null? const)) (car const) (symbol->string var)))
	 (str (string-append "___result = " const ";")))
    `(define ,var ((c-lambda () ,type ,str)))))

(define-macro (define-int-c-constants . var-list)
  `(begin
     ,@(map (lambda (x) `(define-c-constant ,x int)) var-list)))

; Address families.

(define-c-constant address-family/unspecified int "AF_UNSPEC")
(define-c-constant address-family/unix int "AF_UNIX")
(define-c-constant address-family/internet int "AF_INET")
(define-c-constant address-family/internet6 int "AF_INET6")

; Protocol families.

(define-c-constant protocol-family/unspecified int "PF_UNSPEC")
(define-c-constant protocol-family/unix int "PF_UNIX")
(define-c-constant protocol-family/internet int "PF_INET")
(define-c-constant protocol-family/internet6 int "PF_INET6")

; Socket types.

(define-c-constant socket/stream int "SOCK_STREAM")
(define-c-constant socket/datagram int "SOCK_DGRAM")
(define-c-constant socket/raw int "SOCK_RAW")

; Possible error conditions.

(define-c-constant errno/acces int "EACCES")
(define-c-constant errno/addrinuse int "EADDRINUSE")
(define-c-constant errno/again int "EAGAIN")
(define-c-constant errno/badf int "EBADF")
(define-c-constant errno/inval int "EINVAL")
(define-c-constant errno/notsock int "ENOTSOCK")
(define-c-constant errno/fault int "EFAULT")
(define-c-constant errno/loop int "ELOOP")
(define-c-constant errno/nametoolong int "ENAMETOOLONG")

(define-c-constant errno/noent int "ENOENT")
(define-c-constant errno/nomem int "ENOMEM")
(define-c-constant errno/notdir int "ENOTDIR")
(define-c-constant errno/rofs int "EROFS")
(define-c-constant errno/isconn int "EISCONN")
(define-c-constant errno/inprogress int "EINPROGRESS")
(define-c-constant errno/intr int "EINTR")
(define-c-constant errno/netunreach int "ENETUNREACH")
(define-c-constant errno/timedout int "ETIMEDOUT")
(define-c-constant errno/already int "EALREADY")

(define-c-constant errno/afnosupport int "EAFNOSUPPORT")
(define-c-constant errno/notconn int "ENOTCONN")
(define-c-constant errno/msgsize int "EMSGSIZE")
(define-c-constant errno/connreset int "ECONNRESET")
(define-c-constant errno/destaddrreq int "EDESTADDRREQ")
(define-c-constant errno/wouldblock int "EWOULDBLOCK")
(define-c-constant errno/opnotsupp int "EOPNOTSUPP")
(define-c-constant errno/pipe int "EPIPE")

(define-c-constant errno/protonosupport int "EPROTONOSUPPORT")
(define-c-constant errno/nobufs int "ENOBUFS")
(define-c-constant errno/connrefused int "ECONNREFUSED")
(define-c-constant errno/mfile int "EMFILE")
(define-c-constant errno/nfile int "ENFILE")
(define-c-constant errno/connaborted int "ECONNABORTED")
(define-c-constant errno/perm int "EPERM")


; Send and recv flags.

(define-c-constant message/out-of-band int "MSG_OOB")
(define-c-constant message/peek int "MSG_PEEK")
(define-c-constant message/dont-route int "MSG_DONTROUTE")

; Socket address sizes.

(define-c-constant *sockaddr-un-len* int "sizeof(struct sockaddr_un)")
(define-c-constant *sockaddr-in-len* int "sizeof(struct sockaddr_in)")
(define-c-constant *sockaddr-in6-len* int "sizeof(struct sockaddr_in6)")

(define-type socket
  id: 98e94265-558a-d985-b3fe-e67f32458c35
  type-exhibitor: macro-type-socket
  constructor: macro-make-socket
  implementer: implement-type-socket
  opaque:
  macros:
  prefix: macro-
  predicate: macro-socket?
  (fd unprintable:)
  (will unprintable:))

(implement-type-socket)

(define-type sockaddr
  id: ce56103c-c098-5996-21e1-7d200e7e4e6f
  type-exhibitor: macro-type-sockaddr
  constructor: macro-make-sockaddr
  implementer: implement-type-sockaddr
  opaque:
  macros:
  prefix: macro-
  predicate: macro-sockaddr?
  (family unprintable:)
  (address unprintable:))

(implement-type-sockaddr)

(define-type sockaddr-inet6-info
  id: 74065378-a567-ba71-0047-22b413ad9797
  type-exhibitor: macro-type-sockaddr-inet6-info
  constructor: macro-make-sockaddr-inet6-info
  implementer: implement-type-sockaddr-inet6-info
  opaque:
  macros:
  prefix: macro-
  predicate: macro-sockaddr-inet6-info?
  (host unprintable:)
  (port unprintable:)
  (flowinfo unprintable:)
  (scope-id unprintable:))

(implement-type-sockaddr-inet6-info)

(c-define (make-empty-sockaddr-inet6-info) () scheme-object "make_empty_sockaddr_inet6_info" "static" (let ((i (macro-make-sockaddr-inet6-info #f #f #f #f))) i))

(c-declare #<<c-declare-end

#define ___SOCKADDR_FAM(x) ___UNCHECKEDSTRUCTUREREF(x,___FIX(1),___SUB(0),___FAL)
#define ___SOCKADDR_DATA(x) ___UNCHECKEDSTRUCTUREREF(x,___FIX(2),___SUB(0),___FAL)

#define ___INET6_INFO_HOST(x) ___UNCHECKEDSTRUCTUREREF(x,___FIX(1),___SUB(0),___FAL)
#define ___INET6_INFO_PORT(x) ___UNCHECKEDSTRUCTUREREF(x,___FIX(2),___SUB(0),___FAL)
#define ___INET6_INFO_FLOWINFO(x) ___UNCHECKEDSTRUCTUREREF(x,___FIX(3),___SUB(0),___FAL)
#define ___INET6_INFO_SCOPEID(x) ___UNCHECKEDSTRUCTUREREF(x,___FIX(4),___SUB(0),___FAL)


int build_c_sockaddr(___SCMOBJ theaddr,struct sockaddr *myaddr)
{
  size_t len = ___CAST(size_t,___INT(___U8VECTORLENGTH(___SOCKADDR_DATA(theaddr))));
  myaddr->sa_family = ___CAST(sa_family_t,___INT(___SOCKADDR_FAM(theaddr)));
  switch(myaddr->sa_family) {
    case AF_UNSPEC:
      break;
    case AF_UNIX:
      {
        struct sockaddr_un *su = (struct sockaddr_un *)myaddr;
        ___SCMOBJ thevec = ___SOCKADDR_DATA(theaddr);
        int len = ___INT(___U8VECTORLENGTH(thevec));
        int maxlen = sizeof(su->sun_path);
        len  = (len >= maxlen ? maxlen - 1: len);
        memcpy((void *)su->sun_path,___CAST(void *,___BODY_AS(thevec,___tSUBTYPED)),len);
        su->sun_path[len] = 0;
      }
      break;
    case AF_INET:
      {
        struct sockaddr_in *si = (struct sockaddr_in *)myaddr;
        ___SCMOBJ thepr = ___SOCKADDR_DATA(theaddr);
        si->sin_port = htons(___INT(___PAIR_CAR(thepr)));
        memcpy((void *)&(si->sin_addr),___CAST(void *,___BODY_AS(___PAIR_CDR(thepr),___tSUBTYPED)),4);
      }
      break;
    case AF_INET6:
      {
        struct sockaddr_in6 *si = (struct sockaddr_in6 *)myaddr;
        ___SCMOBJ thedata = ___SOCKADDR_DATA(theaddr);
        unsigned short port = ___INT(___INET6_INFO_PORT(thedata));
        unsigned int ___temp;
        si->sin6_port = htons(port);
        si->sin6_flowinfo = htonl(___INT(___INET6_INFO_FLOWINFO(thedata)));
        si->sin6_scope_id = htonl(___U32UNBOX(___INET6_INFO_SCOPEID(thedata)));
        memcpy((void *)&(si->sin6_addr),___CAST(void *,___BODY_AS(___INET6_INFO_HOST(thedata),___tSUBTYPED)),sizeof(struct in6_addr));
      }
      break; 
  }
  return ___NO_ERR;
}

int c_sockaddr_size(struct sockaddr *myaddr) {
  switch(myaddr->sa_family) {
    case AF_UNSPEC:
      return sizeof(struct sockaddr);
    case AF_UNIX:
      return sizeof(struct sockaddr_un);
    case AF_INET:
      return sizeof(struct sockaddr_in);
    case AF_INET6:
      return sizeof(struct sockaddr_in6);
    default:
      return sizeof(struct sockaddr);
  }
}

int build_scheme_sockaddr(struct sockaddr *myaddr,___SCMOBJ theaddr,int addr_size)
{
  ___SCMOBJ thedata;
  switch(myaddr->sa_family)
  {
    case AF_UNIX:
      {
        struct sockaddr_un *su = (struct sockaddr_un *)myaddr;
        int len = strlen(su->sun_path);
        thedata = ___EXT(___alloc_scmobj)(___sU8VECTOR,len,___STILL);
        if(___FIXNUMP(thedata)) {
          return thedata;
        }
        memcpy(___CAST(unsigned char *,___BODY_AS(thedata,___tSUBTYPED)),myaddr->sa_data,len);
      }
      break;
    case AF_INET:
      {
        struct sockaddr_in *si = (struct sockaddr_in *)myaddr;
        thedata = ___EXT(___make_pair)(___FIX(ntohs(si->sin_port)),___EXT(___alloc_scmobj)(___sU8VECTOR,4,___STILL),___STILL);
        if(___FIXNUMP(thedata)) {
          return thedata;
        }
        memcpy(___CAST(unsigned char *,___BODY_AS(___PAIR_CDR(thedata),___tSUBTYPED)),&(si->sin_addr),4);
      }
      break;
    case AF_INET6:
      {
        struct sockaddr_in6 *si = (struct sockaddr_in6 *)myaddr;
        ___SCMOBJ thevec = ___EXT(___alloc_scmobj)(___sU8VECTOR,sizeof(struct
          in6_addr),___STILL);
        unsigned int ___temp;
         
        thedata = make_empty_sockaddr_inet6_info();
	___UNCHECKEDSTRUCTURESET(thedata,thevec,___FIX(1),___SUB(0),___FAL);
	___UNCHECKEDSTRUCTURESET(thedata,___FIX(ntohs(si->sin6_port)),___FIX(2),___SUB(0),___FAL);
	___UNCHECKEDSTRUCTURESET(thedata,___FIX(ntohl(si->sin6_flowinfo)),___FIX(3),___SUB(0),___FAL);
        ___UNCHECKEDSTRUCTURESET(thedata,___U32BOX(ntohl(si->sin6_scope_id)),___FIX(4),___SUB(0),___FAL);
        memcpy(___CAST(unsigned char *,___BODY_AS(thevec,___tSUBTYPED)),&(si->sin6_addr),sizeof(struct in6_addr));
      }
      break;
    default:
      thedata = ___NUL;
      break;
  }
  ___UNCHECKEDSTRUCTURESET(theaddr,___FIX(myaddr->sa_family),___FIX(1),___SUB(0),___FAL);
  ___UNCHECKEDSTRUCTURESET(theaddr,thedata,___FIX(2),___SUB(0),___FAL);
  return ___NO_ERR;
}

c-declare-end
)



(define-record-type invalid-sockaddr-exception
  (make-invalid-sockaddr-exception n expected-family proc args)
  invalid-sockaddr-exception?
  (n invalid-sockaddr-argument-number)
  (expected-family invalid-sockaddr-exception-expected-family)
  (proc invalid-sockaddr-exception-procedure)
  (args invalid-sockaddr-exception-arguments))

(define (socket-address? obj) (macro-sockaddr? obj))
(define (socket? obj) (macro-socket? obj))

(define (socket-address-family obj) (macro-sockaddr-family obj))

(define (check-sockaddr obj fam n proc args)
  (if (not (socket-address? obj))
      (##raise-type-exception n (macro-type-sockaddr) proc args)
      )
  (if (not (= (macro-sockaddr-family obj) fam))
      (raise (make-invalid-sockaddr-exception n fam proc args))))

(define-macro (define-sockaddr-family-pred name family)
  (define (sym-concat sym1 sym2)
    (string->symbol (string-append (symbol->string sym1) (symbol->string sym2))))
  `(define (,name a)
     (and (socket-address? a)
	  (= (macro-sockaddr-family a) ,family))))

; build_scheme_sockaddr will put the error code in place of the address data vector
; if there is a heap overflow error when allocating the vector.

(define (sockaddr-alloc-error? a)
   (integer? (macro-sockaddr-address a)))

(define (raise-if-sockaddr-alloc-error a)
  (if (sockaddr-alloc-error? a)
      (##raise-heap-overflow-exception)
      a))

; This does not yet work with character encodings except ASCII/Latin-1.

(define (unix-address->socket-address fn)
  (let* (
	 (unix-path-max (- *sockaddr-un-len* 2))
	 (l (min (string-length fn) (- unix-path-max 1)))
	 (v (make-u8vector unix-path-max 0))
	 )
    (let loop ((i 0))
      (cond
       ((>= i l) #f)
       (else (u8vector-set! v i (remainder (char->integer (string-ref fn i)) 255))
	     (loop (+ i 1)))))
    (macro-make-sockaddr address-family/unix v)))

(define (unix-socket-address? a)
  (and
   (socket-address? a)
   (= (macro-sockaddr-family a) address-family/unix)))

(define (socket-address->unix-address a)
  (check-sockaddr a address-family/unix 0 socket-address->unix-address (list a))
  (let* ((v (macro-sockaddr-address a))
	(l (u8vector-length v))
	(s (make-string l #\nul)))
    (let loop ((i 0))
      (if (and (< i l)
	       (not (zero? (u8vector-ref v i))))
	  (begin (string-set! s i (integer->char (u8vector-ref v i)))
		 (loop (+ i 1)))
	  (substring s 0 i)))))

(define (integer->network-order-vector-16 n)
  (u8vector
   (bitwise-and (arithmetic-shift n -8) 255)
   (bitwise-and n 255)))

(define (integer->network-order-vector-32 n)
  (u8vector
   (bitwise-and (arithmetic-shift n -24) 255)
   (bitwise-and (arithmetic-shift n -16) 255)
   (bitwise-and (arithmetic-shift n -8) 255)
   (bitwise-and n 255)))

(define (network-order-vector->integer-16 v)
  (bitwise-ior
   (arithmetic-shift (u8vector-ref v 0) 8)
   (u8vector-ref v 1)))

(define (network-order-vector->integer-32 v)
  (bitwise-ior
   (arithmetic-shift (u8vector-ref v 0) 24)
   (arithmetic-shift (u8vector-ref v 1) 16)
   (arithmetic-shift (u8vector-ref v 2) 8)
   (u8vector-ref v 3)))

(define (raise-not-an-ip-address)
  (error "not an ip address"))

(define (consume-ip4-address-component str ptr)
  (let ((l (string-length str)))
    (let loop
	((p ptr)
	 (s '()))
      (if (>= p l)
	  (values (list->string (reverse s)) #f)
	  (let ((c (string-ref str p)))
	    (cond
	     ((char-numeric? c) (loop (+ p 1) (cons c s)))
	     ((char=? c #\.) (values (list->string (reverse s)) p))
	     (else (raise-not-an-ip-address))))))))

(define (string->ip4-address str)
  (let* ((ccheck
	  (lambda (x)
	    (let* ((r (string->number x)))
	      (if (or (not r) (not (integer? r)) (not (exact? r))
		      (> r 255) (< r 0))
		  (raise-not-an-ip-address)
		  r)))))
    (let loop
	((ptr 0)
	 (parts '())
	 (count 0))
      (call-with-values (lambda () (consume-ip4-address-component str ptr))
	(lambda (next nptr)
	  (cond
	   ((and nptr (or (>= (+ nptr 1) (string-length str)) 
			  (not (char-numeric? (string-ref str (+ nptr 1))))))
	    (raise-not-an-ip-address))
	   ((and (< count 3) nptr)
	    (loop (+ nptr 1) (cons (ccheck next) parts) (+ count 1)))
	   ((and (= count 3) (not nptr))
	    (apply u8vector (reverse (cons (ccheck next) parts))))
	   (else (raise-not-an-ip-address))))))))

(define (check-ip4-address v)
  (let* ((e raise-not-an-ip-address))
    (if (not (and (u8vector? v) (= (u8vector-length v) 4))) (e))))

(define (check-ip6-address v)
  (let* ((e raise-not-an-ip-address))
    (if (not (and (u8vector? v) (= (u8vector-length v) 16))) (e))))

(define ip-address/any (u8vector 0 0 0 0))
(define ip-address/loopback (u8vector 127 0 0 1))
(define ip-address/broadcast (u8vector 255 255 255 255))

(define port/any 0)


(define (internet-address->socket-address host port)
  (let* ((ip4a (cond
		((u8vector? host) host)
		((string? host) (string->ip4-address host))))
	 (pv (integer->network-order-vector-16 port)))
	 
    (check-ip4-address ip4a)
    (macro-make-sockaddr address-family/internet (cons port ip4a))))

(define-sockaddr-family-pred internet-socket-address? address-family/internet)

(define (socket-address->internet-address a)
  (check-sockaddr a address-family/internet 0 socket-address->internet-address (list a))
  (values 
   (cdr (macro-sockaddr-address a))
   (car (macro-sockaddr-address a))))

(define (internet6-address->socket-address host port flowinfo scope-id)
  (check-ip6-address host)
  (macro-make-sockaddr
   address-family/internet6
   (macro-make-sockaddr-inet6-info host port flowinfo scope-id)))

(define (socket-address->internet6-address a)
  (check-sockaddr a address-family/internet6 0 socket-address->internet-address (list a))
  (let* ((b (macro-sockaddr-address a)))
    (values 
     (macro-sockaddr-inet6-info-host b)
     (macro-sockaddr-inet6-info-port b)
     (macro-sockaddr-inet6-info-flowinfo b)
     (macro-sockaddr-inet6-info-scope-id b))))

(define (make-unspecified-socket-address)
  (macro-make-sockaddr address-family/unspecified '()))

(define-sockaddr-family-pred unspecified-socket-address? address-family/unspecified)

(define (close-socket sock)
  (let* ( (c-close (c-lambda (int) int
			    "___result = close(___arg1);")))
    (c-close (macro-socket-fd sock))))

(define errno (c-lambda () int "___result = errno;"))

(define (raise-socket-exception-if-error thunk proc . args)
  (let ((b (thunk)))
    (if (< b 0)
	(let* ((e (errno)))
	  (apply
	   ##raise-os-exception
	   (append
	    (list
	     #f
	     e
	     proc
	     )
	   args
	   )))
	b)))

(define-macro (macro-really-make-socket fd)
  `(let* (
	  (sockobj (macro-make-socket ,fd #f)))
    (macro-socket-will-set! sockobj 
			    (make-will sockobj (lambda (s) (close-socket s))))
    sockobj))

(define (create-socket domain type #!optional (protocol 0))
  (let* (
	 (c-socket (c-lambda (int int int) int
			     "___result = socket(___arg1,___arg2,___arg3);"))
	 (sockobj (macro-really-make-socket (raise-socket-exception-if-error
				      (lambda () (c-socket domain type protocol)) create-socket))))
    sockobj))


(define (bind-socket sock addr)
  (let* ((c-bind (c-lambda (scheme-object scheme-object) int
"
int mysize;
struct sockaddr_storage myaddr;
build_c_sockaddr(___arg2,(struct sockaddr *)&myaddr);
mysize = c_sockaddr_size((struct sockaddr *)&myaddr);
___result = bind(___CAST(int,___INT(___UNCHECKEDSTRUCTUREREF(___arg1,___FIX(1),___SUB(0),___FAL))),(struct sockaddr *)&myaddr,mysize);
"
)))
    (if (not (socket? sock))
	(##raise-type-exception 0 (macro-type-socket) bind-socket (list sock addr))
	(if (not (socket-address? addr))
	    (##raise-type-exception 1 (macro-type-sockaddr) bind-socket (list sock addr))
	    (raise-socket-exception-if-error (lambda () (c-bind sock addr)) bind-socket)))
    (if #f #f)))

(define (connect-socket sock addr)
  (let* ((c-connect (c-lambda (scheme-object scheme-object) int
"
int mysize;
struct sockaddr_storage myaddr;
build_c_sockaddr(___arg2,(struct sockaddr *)&myaddr);
mysize = c_sockaddr_size((struct sockaddr *)&myaddr);
___result = connect(___CAST(int,___INT(___UNCHECKEDSTRUCTUREREF(___arg1,___FIX(1),___SUB(0),___FAL))),(struct sockaddr *)&myaddr,mysize);
"
)))
    (if (not (socket? sock))
	(##raise-type-exception 0 (macro-type-socket) connect-socket (list sock addr))
	(if (not (socket-address? addr))
	    (##raise-type-exception 1 (macro-type-sockaddr) connect-socket (list sock addr))
	    (raise-socket-exception-if-error (lambda () (c-connect sock addr)) connect-socket)))
    (if #f #f)))



(define (send-message sock vec #!optional (start 0) (end #f) (flags 0)
		      (addr #f))
  (let* (
	 (svec (if (and (= start 0) (not end)) vec
		   (subu8vector vec start (if (not end) (u8vector-length vec) end))))
	 (c-send
	  (c-lambda (scheme-object scheme-object int) int
		    "
int soc = ___CAST(int,___INT(___UNCHECKEDSTRUCTUREREF(___arg1,___FIX(1),___SUB(0),___FAL)));
void *buf = ___CAST(void *,___BODY_AS(___arg2,___tSUBTYPED));
size_t bufsiz = ___CAST(size_t,___INT(___U8VECTORLENGTH(___arg2)));
int fl = ___CAST(int,___INT(___arg3));
___result = send(soc,buf,bufsiz,fl);
"))
	 (c-sendto
	  (c-lambda (scheme-object scheme-object int scheme-object) int
		    "
struct sockaddr_storage sa;
int sa_size;
int soc = ___CAST(int,___INT(___UNCHECKEDSTRUCTUREREF(___arg1,___FIX(1),___SUB(0),___FAL)));
void *buf = ___CAST(void *,___BODY_AS(___arg2,___tSUBTYPED));
size_t bufsiz = ___CAST(size_t,___INT(___U8VECTORLENGTH(___arg2)));
int fl = ___CAST(int,___INT(___arg3));
build_c_sockaddr(___arg4,(struct sockaddr *)&sa);
sa_size = c_sockaddr_size((struct sockaddr *)&sa);
___result = sendto(soc,buf,bufsiz,fl,(struct sockaddr *)&sa,sa_size);
")))
    (if (not (socket? sock))
	(##raise-type-exception 0 (macro-type-socket) send-message (list sock vec start end flags addr)))
    (if (not (u8vector? vec))
	(##raise-type-exception 1 'u8vector send-message (list sock vec start end flags addr)))
    (if (not addr)
	(raise-socket-exception-if-error (lambda () (c-send sock svec flags)) send-message)
	(if (not (socket-address? addr))
	    (##raise-type-exception 3 (macro-type-sockaddr) send-message (list sock vec start end flags addr))
	    (raise-socket-exception-if-error (lambda () (c-sendto sock svec flags addr)) send-message)))))


(define (receive-message sock len #!optional (flags 0))
  (let* (
         (addr (make-unspecified-socket-address))
	 (vec (make-u8vector len 0))
	 (c-recvfrom
	  (c-lambda (scheme-object scheme-object int scheme-object) int
		    "
struct sockaddr_storage sa;
int sa_size;
int soc = ___CAST(int,___INT(___UNCHECKEDSTRUCTUREREF(___arg1,___FIX(1),___SUB(0),___FAL)));
void *buf = ___CAST(void *,___BODY_AS(___arg2,___tSUBTYPED));
size_t bufsiz = ___CAST(size_t,___INT(___U8VECTORLENGTH(___arg2)));
int fl = ___CAST(int,___INT(___arg3));
___result = recvfrom(soc,buf,bufsiz,fl,(struct sockaddr *)&sa,&sa_size);
if(sa_size > 0) {
  build_scheme_sockaddr((struct sockaddr *)&sa,___arg4,sa_size);
}
")))
    (if (not (socket? sock))
	(##raise-type-exception 0 (macro-type-socket) receive-message (list sock len flags)))
    (let* ((size-actually-recvd
	    (raise-socket-exception-if-error (lambda () (c-recvfrom sock vec flags addr)) receive-message)))
      (values
       (subu8vector vec 0 size-actually-recvd)
       addr))))

(define (listen-socket sock backlog)
  (let* ((c-listen
	  (c-lambda (scheme-object int) int
		    "
int soc = ___CAST(int,___INT(___UNCHECKEDSTRUCTUREREF(___arg1,___FIX(1),___SUB(0),___FAL)));
___result = listen(soc,___arg2);
")))
    (if (not (socket? sock))
	(##raise-type-exception 0 (macro-type-socket) listen-socket (list sock backlog)))
    (raise-socket-exception-if-error (lambda () (c-listen sock backlog)) listen-socket)
    (if #f #f)
    ))

(define (socket-local-address sock) 
  (let* (
	 (dummy-sockaddr (macro-make-sockaddr 0 #f))
	 (c-getsockname
	  (c-lambda (scheme-object scheme-object) int
		    "
struct sockaddr_storage ss;
int sslen = sizeof(struct sockaddr_storage);
int soc = ___CAST(int,___INT(___UNCHECKEDSTRUCTUREREF(___arg1,___FIX(1),___SUB(0),___FAL)));
int r = getsockname(soc,(struct sockaddr *)&ss,&sslen);
if(r<0) {
   ___result = r;
}
else {
   build_scheme_sockaddr((struct sockaddr *)&ss,___arg2,sslen);
   ___result = r;
}
")))
    (if (not (socket? sock))
	(##raise-type-exception 0 (macro-type-socket) socket-local-address (list sock)))
    (raise-socket-exception-if-error (lambda () 
				       (c-getsockname sock dummy-sockaddr)) socket-local-address)
    (raise-if-sockaddr-alloc-error dummy-sockaddr)))

(define (socket-remote-address sock) 
  (let* (
	 (dummy-sockaddr (macro-make-sockaddr 0 #f))
	 (c-getpeername
	  (c-lambda (scheme-object scheme-object) int
		    "
struct sockaddr_storage ss;
int sslen = sizeof(struct sockaddr_storage);
int soc = ___CAST(int,___INT(___UNCHECKEDSTRUCTUREREF(___arg1,___FIX(1),___SUB(0),___FAL)));
int r = getpeername(soc,(struct sockaddr *)&ss,&sslen);
if(r<0) {
   ___result = r;
}
else {
   build_scheme_sockaddr((struct sockaddr *)&ss,___arg2,sslen);
   ___result = r;
}
")))
    (if (not (socket? sock))
	(##raise-type-exception 0 (macro-type-socket) socket-remote-address (list sock)))
    (raise-socket-exception-if-error (lambda () 
				       (c-getpeername sock dummy-sockaddr)) socket-remote-address)
    (raise-if-sockaddr-alloc-error dummy-sockaddr)))

(define (accept-connection sock) 
  (let* (
	 (dummy-sockaddr (macro-make-sockaddr 0 #f))
	 (c-accept
	  (c-lambda (scheme-object scheme-object) int
		    "
struct sockaddr_storage ss;
int sslen = sizeof(struct sockaddr_storage);
int soc = ___CAST(int,___INT(___UNCHECKEDSTRUCTUREREF(___arg1,___FIX(1),___SUB(0),___FAL)));
int r = accept(soc,(struct sockaddr *)&ss,&sslen);
if(r < 0) {
   ___result = r;
}
else {
   build_scheme_sockaddr((struct sockaddr *)&ss,___arg2,sslen);
   ___result = r;
}
")))
    (if (not (socket? sock))
	(##raise-type-exception 0 (macro-type-socket) accept-connection (list sock)))
    (let* ((s2 
	    (raise-socket-exception-if-error (lambda () (c-accept sock dummy-sockaddr)) accept-connection)))
      (raise-if-sockaddr-alloc-error dummy-sockaddr)
      (values (macro-really-make-socket s2) dummy-sockaddr))))

