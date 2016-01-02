# Compíles the 
#
#  xml2-config  --cflags --libs
#

all: lxml.o1

lxml.o1: libxml2.ss
	gsc  -o lxml.o1 \
		-prelude "(include \"../core/ffi-tools.scm\")" \
		-ld-options "-I/usr/include/libxml2 -lxml2" libxml2.ss

clean:
	rm -rf lxml.o1
