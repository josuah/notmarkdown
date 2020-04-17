VERSION = 0.3
PREFIX = /usr/local
MANPREFIX = ${PREFIX}/share/man

rel = notwiki-${VERSION}
bin = notmarkdown-gph notmarkdown-html notwiki-doc
man = ${man1} ${man5}
man1 = notwiki-doc.1
man5 = notmarkdown.5

all:

install:
	mkdir -p ${PREFIX}/bin ${MANPREFIX}/man1
	cp ${bin} ${PREFIX}/bin
	cp ${man1} ${MANPREFIX}/man1

clean:
	rm -rf *.tar *.gz notwiki-*/

release: clean
	mkdir -p ${rel}
	cp -r README Makefile doc ${man} ${bin} ${rel}
	tar -cf ${rel}.tar ${rel}
	rm -rf ${rel}
	gzip ${rel}.tar
