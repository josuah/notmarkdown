
## notmarkdown-txt.awk ## plain text front-end

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
	return "`"s"`"
}

function getbold(s)
{
	return "**"s"**"
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

function printlink(url, line)
{
	print line
}

function blankline(after)
{
	if(blankprev) print ""
	blankprev = after
}

function printhead(s, lv,
	hr)
{
	blankline(0)
	if(lv == 1){
		hr = s
		gsub(".", "━", hr)
		print hr
		printblock("", "", s, 80)
		print hr
	}else if(lv == 2){
		printblock("", "", s, 80)
		gsub(".", "─", s)
		print s
	}else if(lv == 3){
		printblock("═══ ", "", s " ═══", 80)
	}else if(lv == 4){
		printblock("─── ", "", s " ───", 80)
	}else{
		printblock("┈┈┈ ", "", s " ┈┈┈", 80)
	}
}

function printcode(s)
{
	blankline(1)
	gsub("\n", "\n ┊ ", s)
	print " ┊ " s
}

function printulist(s)
{
	blankline(1)
	printblock(" • ", "   ", s, 80)
}

function printolist(s)
{
	blankline(1)
	printblock("#. ", "   ", s, 80)
}

function printquote(s)
{
	blankline(1)
	printblock(" ┊ ", " ┊ ", s, 80)
}

function printpar(s)
{
	blankline(1)
	printblock(" ", " ", s, 80)
}
