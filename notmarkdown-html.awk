
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

function getlink(ref)
{
	return sprintf("<a href=\"%s\">%s</a>", linkurl[ref], linktxt[ref])
}

function getmedia(ref,
	ext, src, alt, type)
{
	ext = linkurl[ref]
	src = linkurl[ref]
	alt = linktxt[ref]
	sub(/.*\./, "", ext)
	type = TYPE[ext]
	if (type == "" || type == "picture")
		return sprintf("<img src=\"%s\" alt=\"%s\"/>", src, alt)
	return sprintf("<%s controls> <source src=\"%s\"/> %s </%s>",
	  type, src, alt, type)
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
	print "<blockquote>"s"</blockquote>"
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

function getid(s)
{
	s = tolower(s)
	gsub(/[^a-z0-9]+/, "-", s)
	if (ID[s]++)
		s = s "-" ID[s]
	return s
}

function printhead(s, lv,
	id)
{
	hook("")
	print ""
	id = getid(s)
	printf("<h%d id=\"%s\">%s <a href=\"#%s\" class=\"permalink\">¶</a></h%d>\n",
	  lv, id, s, id, lv)
	print ""
}

function printdef(s, d)
{
	hook("")
	print "<dl><dt>" d "</dt><dd>" s "</dd></dl>"
}

function printpar(s)
{
	hook("")
	print "<p>" s "</p>"
}
