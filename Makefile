NAME = notwiki
VERSION = 0.6
DESTDIR =
PREFIX = /usr/local
MANPREFIX = ${PREFIX}/share/man

BIN = notmarkdown notmarkdown-gph notmarkdown-html notwiki-gph notwiki-html notwiki-mandoc
MAN1 = notwiki-gph.1 notwiki-html.1
MAN5 = notmarkdown.5

all: ${BIN}

dist:
	rm -rf ${NAME}-${VERSION}
	mkdir -p tmp/${NAME}-${VERSION}
	cp -r ${MAN1} ${MAN5} README Makefile ${BIN} tmp/${NAME}-${VERSION}
	tar -C tmp -cf - ${NAME}-${VERSION} | gzip -c >${NAME}-${VERSION}.tar.gz
	rm -rf tmp

clean:
	rm -f index.* ${NAME}-${VERSION} *.gz

install:
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -rf ${BIN} ${DESTDIR}${PREFIX}/bin
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	cp -rf ${MAN1} ${DESTDIR}${MANPREFIX}/man1
	mkdir -p ${DESTDIR}${MANPREFIX}/man5
	cp -rf ${MAN5} ${DESTDIR}${MANPREFIX}/man5

site: dist
	notwiki-html .site
	notwiki-gph .site
	cp .site/style.css .
