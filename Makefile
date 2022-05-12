V = 1.2
PREFIX = /usr/local
MANPREFIX = ${PREFIX}/man

BIN =	notmarkdown-gph notmarkdown-html notmarkdown-gmi \
	notmarkdown-txt notmarkdown-ms

all: ${BIN}

${BIN}: ${BIN:=.awk} notmarkdown.awk

.SUFFIXES: .awk

.awk:
	echo '#!/usr/bin/awk -f' | cat - $< notmarkdown.awk >$@
	chmod +x $@

clean:
	rm -f ${BIN}

dist:
	mkdir -p notmarkdown-$V
	cp *file *.awk *.md *.man notmarkdown-$V
	tar cf - notmarkdown-$V | gzip >notmarkdown-$V.tgz
	rm -r notmarkdown-$V

install: ${BIN}
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp ${BIN} ${DESTDIR}${PREFIX}/bin
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	cp notmarkdown.man ${DESTDIR}${MANPREFIX}/man1/notmarkdown.1
