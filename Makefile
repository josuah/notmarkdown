NAME = notwiki
VERSION = 1.0
PREFIX = /usr/local
MANPREFIX = ${PREFIX}/man

BIN = notmarkdown notmarkdown-gph notmarkdown-html notmarkdown-gph notmarkdown-html
MAN1 = notmarkdown.1
MAN5 = notmarkdown.5

all: ${BIN}

clean:
	rm -fr index.* ${NAME}-${VERSION} *.tgz

install: ${BIN}
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f ${BIN} ${DESTDIR}${PREFIX}/bin
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	cp -f ${MAN1} ${DESTDIR}${MANPREFIX}/man1
	mkdir -p ${DESTDIR}${MANPREFIX}/man5
	cp -f ${MAN5} ${DESTDIR}${MANPREFIX}/man5

dist:
	git archive v${VERSION} --prefix=${NAME}-${VERSION}/ \
	| gzip >${NAME}-${VERSION}.tgz

site:
	notmarkdown README.md | notmarkdown-html | cat .head.html - >index.html
	notmarkdown README.md | notmarkdown-gph | cat .head.gph - >index.gph
	mkdir -p man
	mandoc -Thtml -Ofragment ${MAN1} ${MAN5} | cat .head.html - >man/index.html
	mandoc -Tutf8 ${MAN1} ${MAN5} | ul -t dumb >man/index.gph
	sed -i "s/NAME/${NAME}/g; s/VERSION/${VERSION}/g" index.* man/index.*
