NAME = notwiki
PREFIX = /usr/local
MANPREFIX = ${PREFIX}/man

BIN = notmarkdown-gph notmarkdown-html notmarkdown-gmi \
  notmarkdown-txt notmarkdown-ms

.SUFFIXES: .awk

.awk:
	echo '#!/usr/bin/awk -f' | cat - $< notmarkdown.awk >$@
	chmod +x $@

all: ${BIN}

clean:
	rm -rf ${BIN}

install: ${BIN}
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp ${BIN} ${DESTDIR}${PREFIX}/bin
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	cp notmarkdown.1 ${DESTDIR}${MANPREFIX}/man1
	mkdir -p ${DESTDIR}${MANPREFIX}/man5
	cp notmarkdown.5 ${DESTDIR}${MANPREFIX}/man5
