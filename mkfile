name = notwiki
v = 1.0

bin = notmarkdown-gph notmarkdown-html notmarkdown-gmi \
  notmarkdown-txt notmarkdown-ms

notmarkdown-%: notmarkdown-%.awk notmarkdown.awk
	echo '#!/bin/awk -f' | cat /fd/0 $prereq >$target
	chmod +x $target

all:V: $bin

clean:V:
	rm -fr $bin *.tgz

install:V: $bin
	cp $bin /rc/bin
	cp notmarkdown.1 /sys/man/1/notmarkdown
	cp notmarkdown.5 /sys/man/5/notmarkdown

dist:V:
	mkdir -p $name-$v
	cp *file *.awk *.md notmarkdown.[0-9] $name-$v
	tar c $name-$v | gzip >$name-$v.tgz
	rm -r $name-$v
