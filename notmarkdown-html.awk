
## notmarkdown-html.awk ## html front-end

function init()
{
	TYPE["jpg"] = TYPE["jpeg"] = TYPE["png"] = TYPE["gif"] = "picture"
	TYPE["mkv"] = TYPE["webm"] = TYPE["avi"] = TYPE["mp4"] = "video"
	TYPE["mka"] = TYPE["opus"] = TYPE["wav"] = TYPE["mp3"] = "audio"
	TYPE["flac"] = TYPE["ogg"] = "audio"
	hook("")
}

function escape(s)
{
	gsub("&", "\\&amp;", s)
	gsub("\"", "\\&quot;", s)
	gsub("<", "\\&lt;", s)
	gsub(">", "\\&gt;", s)
	return s
}

function getmedia(link, alt,
	ext, type)
{
	ext = link
	sub(/.*\./, "", ext)
	if ((type = TYPE[ext]) == "" || type == "picture")
		return sprintf("<img src=\"%s\" alt=\"%s\"/>", link, alt)
	return sprintf("<%s controls> <source src=\"%s\"/> %s </%s>",
	  type, link, alt, type)
}

function getlink(s, url)
{
	return sprintf("<a href=\"%s\">%s</a>", url, s)
}

function getbold(s)
{
	return "<b>"s"</b>"
}

function getitalic(s)
{
	return "<i>"s"</i>"
}

function getliteral(s)
{
	return "<code>"s"</code>"
}

function hook(t)
{
	if (tag != t) {
		if (tag) print("</"tag">")
		if (t) print("<"t">")
	}
	tag = t
}

function printquote(s)
{
	hook("")
	print s
}

function printcode(s)
{
	hook("")
	print "<pre>"
	print s
	print "</pre>"
}

function printulist(s)
{
	hook("ul")
	print "<li>"s"</li>"
}

function printolist(s)
{
	hook("ol")
	print "<li>"s"</li>"
}

function printhead(s, lv)
{
	hook("")
	print ""
	print sprintf("<h%d>%s</h%d>", lv, s, lv)
	print ""
}

function printpar(s)
{
	hook("")
	print "<p>" s "</p>"
}
