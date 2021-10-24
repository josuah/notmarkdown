v = 1.0

bin = notmarkdown-gph notmarkdown-html notmarkdown-gmi \
  notmarkdown-txt notmarkdown-ms

all:V: $bin

clean:V:
	rm -fr $bin *.tgz

install:V: $bin
	cp $bin /rc/bin
	cp notmarkdown.man /sys/man/1/notmarkdown

dist:V:
	mkdir -p notmarkdown-$v
	cp *file *.awk *.md *.man notmarkdown-$v
	tar c notmarkdown-$v | gzip >notmarkdown-$v.tgz
	rm -r notmarkdown-$v

notmarkdown-%: notmarkdown-%.awk notmarkdown.awk
	echo '#!/bin/awk -f' | cat /fd/0 $prereq >$target
	chmod +x $target
