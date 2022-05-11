
## notmarkdown.awk ## parser backend

function dolink(t, beg, len, text, link)
{
	linknum++
	linktxt[linknum] = escape(text)
	linkurl[linknum] = escape(link)
	t["head"] = t["head"] substr(t["tail"], 1, beg-1)"["linknum"]"
	t["tail"] = substr(t["tail"], beg+len)
}

# <txtref>

function linkliteral(s,
	t)
{
	t["tail"] = s
	while (match(t["tail"], /<[^ >]+>/)) {
		dolink(t, RSTART, RLENGTH,
		  substr(t["tail"], RSTART+1, RLENGTH-2),
		  substr(t["tail"], RSTART+1, RLENGTH-2))
	}
	return t["head"] t["tail"]
}

# [text][ref]

function linkrefer(s,
	t, i, ref)
{
	t["tail"] = s
	while (match(t["tail"], /\[[^\]]+\]\[[^ \]]+\]/)) {
		i = index(t["tail"], "][")
		ref = substr(t["tail"], i+2, RSTART+RLENGTH-i-3)
		dolink(t, RSTART, RLENGTH,
		  substr(t["tail"], RSTART+1, i-RSTART-1),
		  linkref[ref])
	}
	return t["head"] t["tail"]
}

# [text](link)

function linkinline(s,
	t, i)
{
	t["tail"] = s
	while (match(t["tail"], /\[[^\]]+\]\([^ \)]+\)/)) {
		i = index(t["tail"], "](")
		dolink(t, RSTART, RLENGTH,
		  substr(t["tail"], RSTART+1, i-RSTART-1),
		  substr(t["tail"], i+2, RSTART+RLENGTH-i-3))
	}
	return t["head"] t["tail"]
}

# [1] after conversion by link*()

function convertlink(s,
	head, tail, ref)
{
	tail = s
	while (match(tail, /\[[0-9]+\]/)) {
		head = head substr(tail, 1, RSTART-1)
		ref = substr(tail, RSTART+1, RLENGTH-2)
		head = head getlink(ref)f
		tail = substr(tail, RSTART+RLENGTH)
	}
	return head tail
}

# ![1] after conversion by links*()

function convertmedia(s,
	head, tail, ref)
{
	tail = s
	while (match(tail, /!\[[0-9]+\]/)) {
		head = head substr(tail, 1, RSTART-1)
		ref = substr(tail, RSTART+2, RLENGTH-3)
		head = head getmedia(ref)
		tail = substr(tail, RSTART+RLENGTH)
	}
	return head tail
}

# `quoted`

function convertquoted(s,
	head, tail)
{
	tail = s
	while (match(tail, /`[^`]*`/)) {
		head = head substr(tail, 1, RSTART-1)
		head = head getliteral(substr(tail, RSTART+1, RLENGTH-2))
		tail = substr(tail, RSTART+RLENGTH)
	}
	return head tail
}

# **bold**

function convertbold(s,
	head, tail)
{
	tail = s
	while (match(tail, "[*][*][^ *][^*]*[^ *][*][*]")) {
		head = head substr(tail, 1, RSTART-1)
		head = head getbold(substr(tail, RSTART+2, RLENGTH-4))
		tail = substr(tail, RSTART+RLENGTH)
	}
	return head tail
}

# *italic*

function convertitalic(s,
	head, tail)
{
	tail = s
	while (match(tail, "[*][^ *][^*]*[^ *][*]")) {
		head = head substr(tail, 1, RSTART-1)
		head = head getitalic(substr(tail, RSTART+1, RLENGTH-2))
		tail = substr(tail, RSTART+RLENGTH)
	}
	return head tail
}

function getfold(line, len,
	head, i)
{
	head = substr(line, 1, len+1)
	if (length(line) >= len)
		sub(" *[^ ]*$", "", head)
	if (length(head) > 0)
		return head
	i = index(line, " ")
	return (i > 0) ? substr(line, 1, i) : line
}

function printline(prefix, s, len,
	head, tail, fold, ref, lnk, n, i)
{
	len -= length(prefix)
	tail = s
	for (;;) {
		fold = getfold(tail, len - length(head))
		if (!match(fold, /\[[0-9]+\]/))
			break
		ref = substr(tail, RSTART+1, RLENGTH-2)
		lnk[n++] = ref
		head = head substr(tail, 1, RSTART-1) linktxt[ref]
		tail = substr(tail, RSTART+RLENGTH)
	}
	fold = getfold(tail, len - length(head))
	head = head fold
	tail = substr(tail, length(fold) + 2)

	if (n == 1) printlink(linkurl[ref], prefix head)
	if (n != 1) print prefix head
	if (n >= 2) for (i=0; i<n; i++)
		printlink(linkurl[lnk[i]], " • "linktxt[lnk[i]])
	return tail
}

function printblock(prefix1, prefix2, s, len,
	prefix)
{
	for (prefix = prefix1; length(s) > 0; prefix = prefix2)
		s = printline(prefix, s, len)
}

function backslash(s,
	i)
{
	gsub(/\\\\/, "\\e", s)
	for (i in bs)
		gsub("\\\\["bs[i]"]", "\\"i, s)
	return s
}

function debackslash(s,
	i)
{
	for (i in dbs)
		gsub("\\\\"i, dbs[i], s)
	gsub(/\\e/, "\\", s)
	return s
}

function convert(s)
{
	s = backslash(s)
	s = linkliteral(s)
	s = linkrefer(s)
	s = linkinline(s)
	s = escape(s)
	s = convertmedia(s)
	s = convertlink(s)
	s = convertbold(s)
	s = convertitalic(s)
	s = convertquoted(s)
	s = debackslash(s)
	return s
}

function fatal(msg)
{
	print "error: "msg
	exit(1)
}

BEGIN {
	new = 1

	bs["S"] = "["; bs["s"] = "]"; bs["w"] = "*"; bs["d"] = "\""
	bs["R"] = "("; bs["r"] = ")"; bs["u"] = "_"; bs["q"] = "`"
	bs["A"] = "<"; bs["a"] = ">"

	for (i in bs) dbs[i] = escape(bs[i])

	reg["#1"] = "^# +"
	reg["#2"] = "^## +"
	reg["#3"] = "^### +"
	reg["#4"] = "^#### +"
	reg["#5"] = "^##### +"
	reg["#6"] = "^###### +"
	reg["#o"] = "^[0-9]+\\. +"
	reg["#u"] = "^[-+*] +"

	def["#t"] = "^: +"
}

/^(\t|    )/ {
	new = 1
	block[++N] = "#c"
	while (sub("^    ", "\t") || /^\t/) {
		block[N] = block[N] substr($0, 2) "\n"
		if (getline <= 0)
			break
	}
	sub(/\n$/, "", block[N])
}

sub("^> +", "") {
	new = 1
	block[++N] = "#q"$0
	while (getline > 0 && sub("^> +", "", $0))
		block[N] = block[N]" "$0
	next
}

/^```/ {
	new = 1
	block[++N] = "#c"
	while (getline && $0 !~ /^```/)
		block[N] = block[N] $0 "\n"
	sub(/\n$/, "", block[N])
	next
}

!new && /^=+$/ {
	new = 1
	block[N] = "#1"substr(block[N], 3)
	next
}

!new && /^-+$/ {
	new = 1
	block[N] = "#2"substr(block[N], 3)
	next
}

match($0, /^\[[^\] ]+\]:/) {
	new = 1
	linkref[tolower(substr($0, RSTART+1, RLENGTH-3))] = $2
	next
}

/^$/ {
	new = 1
	next
}

{
	sub("^ *", "")
	sub(" *$", "")
	for (i in reg) {
		if (sub(reg[i], i, $0) > 0) {
			new = 0
			block[++N] = $0
			next
		}
	}	

	for (i in def) {
		if (sub(def[i], "", $0) > 0) {
			new = 0
			def[++N] = $0
			getline
			block[N] = i $0
			next
		}
	}	
}

new {
	new = 0
	block[++N] = "#p"$0
	next
}

!new {
	block[N] = block[N]" "$0
	next
}

END {
	init()
	for (i = 1; i in block; i++) {
		s = convert(block[i])
		t = convert(def[i])
		if (sub(/^#c/, "", s)) { printcode(escape(s)); continue }
		if (sub(/^#1/, "", s)) { printhead(s, 1); continue }
		if (sub(/^#2/, "", s)) { printhead(s, 2); continue }
		if (sub(/^#3/, "", s)) { printhead(s, 3); continue }
		if (sub(/^#4/, "", s)) { printhead(s, 4); continue }
		if (sub(/^#5/, "", s)) { printhead(s, 5); continue }
		if (sub(/^#6/, "", s)) { printhead(s, 6); continue }
		if (sub(/^#o/, "", s)) { printolist(s); continue }
		if (sub(/^#u/, "", s)) { printulist(s); continue }
		if (sub(/^#q/, "", s)) { printquote(s); continue }
		if (sub(/^#t/, "", s)) { printdef(s, t); continue }
		if (sub(/^#p/, "", s)) { printpar(s); continue }
		fatal("unknown block type: "s)
	}
}
