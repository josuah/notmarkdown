NAME = notwiki
VERSION = 0.6
DESTDIR =
PREFIX = /usr/local
MANPREFIX = ${PREFIX}/share/man

BIN = notmarkdown notmarkdown-gph notmarkdown-html notwiki-gph notwiki-html notwiki-mandoc
MAN1 = notwiki-gph.1 notwiki-html.1
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
	git archive v${VERSION} --prefix=notwiki-${VERSION}/ \
	  | gzip >notwiki-${VERSION}.tgz

site: dist
	notmarkdown README.md | notmarkdown-html | cat .head.html - >index.html
	notmarkdown README.md | notmarkdown-gph | cat .head.gph - >index.gph
	sed -i "s/VERSION/${VERSION}/g" index.*
