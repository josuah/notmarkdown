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

${BIN}: notmarkdown.awk

clean:
	rm -rf ${BIN}

install: ${BIN}
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp ${BIN} ${DESTDIR}${PREFIX}/bin
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	cp notmarkdown.man ${DESTDIR}${MANPREFIX}/man1
