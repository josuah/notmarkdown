PREFIX = /usr/local
MANPREFIX = ${PREFIX}/share/man
 
bin = notmarkdown-gph notmarkdown-html notwiki-atom notwiki-doc
man1 = notwiki-doc.1
man5 = notmarkdown.5

all:
install:
	mkdir -p "${PREFIX}/bin" "${MANPREFIX}/man1"
	cp ${bin} "${PREFIX}/bin"
	cp "${man1}" "${MANPREFIX}/man1"
