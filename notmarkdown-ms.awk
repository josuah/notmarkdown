
## notmarkdown-html.awk ## html front-end

function init()
{
	for(i in unesc) unesc[i] = troffescape(unesc[i])
	hook("", "")
}

function troffescape(s)
{
	gsub("\"", "\\\\e", s)
	return s
}

function getlink(s, url)
{
	return s"\n" ".FS\n" url"\n" ".FE\n"
}

function getbold(s)
{
	return s
}

function getitalics(s)
{
	return s
}

function getliteral(s)
{
	return s
}

function hook(m)
{
	if(macro) print "."macro
	macro = m
}

function printquote(s)
{
	hook("")
	print ".QP"
	print s
}

function printcode(s)
{
	hook("ED")
	print ".BD"
	print troffescape(s)
}

function printulist(s)
{
	hook("")
	print ".IP -"
	print s
}

function printolist(s)
{
	hook("")
	print ".IP 0."
	print s
}

function printhead(s, lv)
{
	hook("")
	print ".SH "lv
	print s
}

function printpar(s)
{
	hook("")
	print ".PP"
	print s
}
