
## notmarkdown-gph.awk ## geomyidae's gph frontend

function init()
{
	ext["gif"] = "g"
	ext["jpg"] = ext["jpeg"] = ext["png"] = "I"
	ext["cgi"] = ext["dcgi"] = ext["gph"] = "1"
	ext["mkv"] = ext["webm"] = ext["avi"] = ext["mp4"] = "9"
	ext["mka"] = ext["opus"] = ext["wav"] = ext["mp3"] = "9"
	ext["pdf"] = ext["ps"] = ext["epub"] = "9"
}

function extension(s,
	x)
{
	if (s ~ "/$")
		return "1"
	for (x in ext)
		if (tolower(s) ~ "\\."x"$")
			return ext[x]
	return "0"
}

function parseuri(s, link,
	i)
{
	if (i = index(s, "://")) {
		link["proto"] = substr(s, 1, i - 1)
		s = substr(s, i + 3)
	}

	if (i = index(s, "/")) {
		link["host"] = substr(s, 1, i - 1)
		s = substr(s, i + 1)
	} else {
		link["host"] = s
		s = ""
	}

	if (i = index(link["host"], ":")) {
		link["port"] = substr(link["host"], i + 1)
		link["host"] = substr(link["host"], 1, i - 1)
	}

	link["path"] = "/" s
}

function striptype(link)
{
	if (link["path"] == "/") {
		link["type"] = "1"
	} else {
		link["type"] = substr(link["path"], 2, 1)
		link["path"] = substr(link["path"], 3)
	}
}

function expand(link,
	s)
{
	if ("SERVER" in ENVIRON && link["host"] == "")
		link["host"] = ENVIRON["SERVER"]
	if ("PREFIX" in ENVIRON)
		link["path"] = "/" ENVIRON["PREFIX"] link["path"]
}

function parselink(s, link)
{
	link["host"] = "server"
	link["port"] = "port"
	link["desc"] = s

	if (s ~ "^//") {
		parseuri(substr(s, 3), link)
		link["type"] = extension(link["path"])
		expand(link)
		return
	}

	if (s ~ "^/") {
		link["path"] = s
		link["type"] = extension(link["path"])
		expand(link)
		return
	}

	parseuri(s, link)
	if (link["proto"] == "telnet") {
		link["type"] = "8"
	} else if (link["proto"] == "gopher") {
		striptype(link)
	} else {
		link["type"] = "h"
		link["path"] = "URL:" s
	}
}

function printlinkline(link, line,
	item)
{
	parselink(link, item)
	item["line"] = line
	for (i in item)
		gsub(/\|/, "\\|", item[i])

	print sprintf("[%s|%s|%s|%s|%s]", item["type"], item["line"],
	  item["path"], item["host"], item["port"])
}

function getliteral(s)
{
	return "`"s"`"
}

function getbold(s)
{
	return "**"s"**"
}

function getitalics(s)
{
	return "*"s"*"
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
		printblock("", "", s)
		print hr
	}else if(lv == 2){
		printblock("", "", s)
		gsub(".", "─", s)
		print s
	}else if(lv == 3){
		printblock("═══ ", "", s " ═══")
	}else if(lv == 4){
		printblock("─── ", "", s " ───")
	}else{
		printblock("┈┈┈ ", "", s " ┈┈┈")
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
	printblock(" • ", "   ", s)
}

function printolist(s)
{
	blankline(1)
	printblock("#. ", "   ", s)
}

function printquote(s)
{
	blankline(1)
	printblock(" ┊ ", " ┊ ", s)
}

function printpar(s)
{
	blankline(1)
	printblock(" ", " ", s)
}
