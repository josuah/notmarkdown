
## notmarkdown-html.awk ## html front-end

function init()
{
	# nothing
}

function escape(s)
{
	gsub(/\\/, "\\e", s)
	return s
}

function getlink(s, url)
{
	return s"\n" ".FS\n" url"\n" ".FE\n"
}

function getbold(s)
{
	return "\\fB"s"\\fR"
}

function getitalic(s)
{
	return "\\fI"s"\\fR"
}

function getliteral(s)
{
	return "\\fC"s"\\fR"
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
	hook("DE")
	print ".DS"
	print s
}

function printulist(s)
{
	hook("")
	print ".IP •"
	print s
}

function printolist(s)
{
	hook("")
	print ".IP •"
	print s
}

function printhead(s, lv)
{
	hook("")
	print ".NH "lv
	print s
}

function printpar(s)
{
	hook("")
	print ".PP"
	print s
}
