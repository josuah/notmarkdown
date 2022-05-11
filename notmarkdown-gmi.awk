
## notmarkdown-gmi.awk ## gemini backend

function init()
{
	# nothing
}

function escape(s)
{
	return s
}

function getliteral(s)
{
	return "'"s"'"
}

function getbold(s)
{
	return "*"s"*"
}

function getitalic(s)
{
	return "*"s"*"
}

function getlink(ref)
{
	linktxt[ref] = "{"linktxt[ref]"}"
	return "["ref"]"
}

function getmedia(ref)
{
	return getlink(ref)
}

function printlink(line, url)
{
	print "=> "url" "line
}

function printhead(s, lv,
	i)
{
	for(i = 0; i < lv; i++) printf "#"
	print " "s
}

function printcode(s)
{
	gsub("\n", "\n\t", s)
	print "\t"s
}

function printulist(s)
{
	print "*", s
}

function printolist(s)
{
	print "*", s
}

function printquote(s)
{
	print ">", s
}

function printpar(s)
{
	print s
}
