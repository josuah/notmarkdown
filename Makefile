NAME = notwiki
VERSION = 1.0
DESTDIR =
PREFIX = /usr/local
MANPREFIX = ${PREFIX}/share/man

BIN = notmarkdown notmarkdown-gph notmarkdown-html notmarkdown-gph notmarkdown-html
MAN1 = notmarkdown-gph.1 notmarkdown-html.1
MAN5 = notmarkdown.5

all: ${BIN}

clean:
	rm -f index.* *.tgz

install:
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -rf ${BIN} ${DESTDIR}${PREFIX}/bin
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	cp -rf ${MAN1} ${DESTDIR}${MANPREFIX}/man1
	mkdir -p ${DESTDIR}${MANPREFIX}/man5
	cp -rf ${MAN5} ${DESTDIR}${MANPREFIX}/man5

dist:
	git archive v${VERSION} --prefix=notmarkdown-${VERSION}/ \
	| gzip >notmarkdown-${VERSION}.tgz

site: dist
	notmarkdown README.md | notmarkdown-html | cat .head.html - >index.html
	notmarkdown README.md | notmarkdown-gph | cat .head.gph - >index.gph
	sed -i "s/VERSION/${VERSION}/g" index.*
