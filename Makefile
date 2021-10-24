PREFIX = /usr/local
MANPREFIX = ${PREFIX}/man

BIN = notmarkdown-gph notmarkdown-html notmarkdown-gmi \
  notmarkdown-txt notmarkdown-ms

all: ${BIN}

${BIN}: ${BIN:=.awk} notmarkdown.awk

.SUFFIXES: .awk

.awk:
	echo '#!/usr/bin/awk -f' | cat - $< notmarkdown.awk >$@
	chmod +x $@

clean:
	rm ${BIN}

install: ${BIN}
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp ${BIN} ${DESTDIR}${PREFIX}/bin
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	cp notmarkdown.man ${DESTDIR}${MANPREFIX}/man1
