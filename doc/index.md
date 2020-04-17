NotWiki
=======

[[NotWiki]] is a very simple site generator tool, that support a simple subset
of markdown in which this document is formatted: NotMarkdown.

[notwiki]: //code.z0.is/notwiki/


How to generate a website?
--------------------------
The notwiki-doc(1) tool will search for *.md files in all $srcdir passed as
arguments, and for each file $path/file.$ext found, it gets copied to the
matching $dstdir/$path/file.$ext directory.

	$ cd /home/me/website-document-root/
	$ notwiki-doc html /srv/www/htdocs/wiki ./wiki

Here, /home/me/website-document-root/wiki/introdcution/index.md would be
copied to /srv/www/htdocs/wiki/introduction/index.html.

The original .md documents are copied along with the source, permitting for
the users of the wiki to suggest modification

The head.$ext (head.html, head.gph) file is added at the top of the converted
document.


How does NotWiki work?
----------------------
It does not support editing files directly through the website: it is one shell
script calling one awk script on every page for generating a site in various
formats:

 * html - traditionnal format of the Web, through the notmarkdown-html backend.
 * gph - [[geomyidae]](1)'s format for Gopher, through the notmarkdow-gph backend.

To add a new converter backend, add in $PATH a script called notmarkdown-$ext
that reads NotMarkdown from stdin and send the target format to stdout.  For
instance, a notmarkdown-txt backend that print the document unchanged.

[geomyidae]: gopher://bitreich.org/1/scm/geomyidae/file/README.gph


How to keep links compatible between HTTP and Gopher?
-----------------------------------------------------
Strip the protocol (http:, https:, gopher:) from all your own links, and eventually
remove the domain name as well.

//example.com/wiki/ and /wiki/ both get converted to:

 * https://example.com/wiki/index.gph (on web browser with HTTPS)
 * http://example.com/wiki/index.gph (on web browser with HTTP)
 * gopher://example.com/wiki/index.gph (on gopher browsers)

So instead of /wiki/page-name.md, use /wiki/page-name/index.md, and use links
to /wiki/page-name/ (with a trailing '/', important for markdown-gph(1)).


How to handle vHosts on Gopher, like for the Web?
-------------------------------------------------
No vHosts on Gopher: multiple domain with the same destination point to the same
website, unlike in the Web when you can redirect them as you wish.

For instance if //doc.example.com/ and //git.example.com/ point to the same server,
geomyidae(1) will pick the same /index.gph for both.  A solution is to always use prefixes,
like //doc.example.com/doc/ or //git.example.com/git/.


What can I do with it?
----------------------

### A software project wiki

This documentation is maintained in the ./doc/ directory of the git repo, and
on every commit, a [[git-hook]] regenerates the documentation using NotWiki.

This permits to have the documentation bound to the code akin to Github's wikis
but self-hosted.

[git-hook]: //josuah.net/wiki/git-hooks/

### A wiki for an existing website/gopherhole

It is convert pages and copies them to the destination directory, which can
have content generated from multiple source. There is no ./index.html/gph
generated (unless you added a ./index.md file yourself), so it will can be
used alongside with other content.


Can I change the default theme?
-------------------------------
Yes, of course!  In fact, there is no default theme, only an example provided
in the ./doc/ of the git repo of NotMarkdown, but all style, layout, header...
are provided by you in head.html or head.gph.


How does NotMarkdown differ with Markdown?
------------------------------------------
All NotMarkdown documents are normal Markdown documents, except for one of the
two link syntax:

	Add a [[link]] and [another][another].
	
	[link]: https://example.com/
	[another]: https://www.example.com/

Only the second is present in Markdown.

It is a subset of Markdown, which means that there is fewer conversion done:

 * The inline links are ignored (required for Gopher, line-based links), you
   will have to convert them to one of the two syntax above.
 * The _ character is not special in any way,
 * Unnumbered lists are only using the asterisks (*), which is the only
   special character inside the paragraphs.

The NotMarkdown format is further described in the notmarkdown(5) manpage.

