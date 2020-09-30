NAME = notwiki
VERSION = 0.6
DESTDIR =
PREFIX = /usr/local
MANPREFIX = ${PREFIX}/share/man

BIN = notmarkdown notmarkdown-gph notmarkdown-html notwiki-doc notwiki-mandoc

all: ${BIN}

dist:
	rm -rf ${NAME}-${VERSION}
	mkdir -p ${NAME}-${VERSION}
	cp -r README Makefile doc ${BIN} ${NAME}-${VERSION}
	tar -cf - ${NAME}-${VERSION} | gzip -c >${NAME}-${VERSION}.tar.gz

clean:
	rm -rf index.* *.[0-9] ${NAME}-${VERSION} *.gz

install:
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -rf ${BIN} ${DESTDIR}${PREFIX}/bin
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	cp -rf doc/*.1 ${DESTDIR}${MANPREFIX}/man1
	mkdir -p ${DESTDIR}${MANPREFIX}/man5
	cp -rf doc/*.5 ${DESTDIR}${MANPREFIX}/man5

deploy: dist
	notwiki-doc html doc .
	notwiki-doc gph doc .
	notwiki-mandoc gph utf8 doc .
	notwiki-mandoc html html doc .
