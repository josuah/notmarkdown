
## notmarkdown-gmi.awk ## gemini backend

function init()
{
	# nothing
}

function getliteral(s)
{
	return "`"s"`"
}

function printlink(link, descr)
{
	print unescape(sprintf("=> %s %s", link, line))
}

function printhead(s, lv,
	i)
{
	for(i = 0; i < lv; i++) printf "#"
	print " " s
}

function printcode(s)
{
	gsub("\n", "\n\t", s)
	print "\t"s
}

function printulist(s)
{
	print "•", s
}

function printolist(s)
{
	print "#.", s
}

function printquote(s)
{
	print ">", s
}

function printpar(s)
{
	printline(s)
}
