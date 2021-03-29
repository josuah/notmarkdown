NotWiki
=======

[NotWiki](//code.z0.is/notwiki/) is a very simple site generator tool, that
support a simple subset of markdown in which this document is formatted:
NotMarkdown.

It supports publication of the same .md files for both http+html and gopher+gph.

This documentation is maintained in the `./doc/` directory of the git repo, and
on every commit, a [git-hook](//josuah.net/wiki/git-hooks/) regenerates the
documentation using NotWiki.

How to use it?
--------------
The [notwiki-doc(1)][doc] tool will search for `*.md` files in all `$srcdir`
passed as arguments, and each file `$path/file.$ext` found, gets copied to the
matching `$dstdir/$path/file.$ext` directory.

[doc]: /man/notwiki-doc.1/

```
$ cd /home/me/website-document-root/
$ notwiki-doc html /srv/www/htdocs/wiki ./wiki
```

Here, `/home/me/website-document-root/wiki/introdcution/index.md` would be
copied to `/srv/www/htdocs/wiki/introduction/index.html`.

The original .md documents are copied along with the source, permitting the
wiki user to suggest modifications.

The `head.$ext` (`head.html`, `head.gph`) file is added at the top of the
converted document.

How to get it?
--------------
```
$ git clone git://code.z0.is/notwiki
$ cd notwiki
$ make PREFIX=/usr/local MANPREFIX=/usr/local/man install
```

How does it work?
-----------------
It does not support editing files directly through the website: it is one shell
script calling one awk script on every page, generating a site in one of these
formats:

 * html - traditionnal format of the Web, through the notmarkdown-html backend.
 * gph - [geomyidae(1)](gopher://bitreich.org/1/scm/geomyidae/file/README.gph)'s
   format for Gopher, through the notmarkdow-gph backend.

To add a new converter backend, add in $PATH a script called notmarkdown-$ext
that reads NotMarkdown from stdin and sends the targetted format to stdout. For
instance, a notmarkdown-txt backend that print the document unchanged or a
notmarkdown-pdf aiming paper publication.

How to have links for both HTTP and Gopher?
-------------------------------------------
Strip the protocol part (`http:`, `https:`, `gopher:`) from all your own links,
and eventually remove the domain name as well.

`//example.com/wiki/` and `/wiki/` both get mapped to:

 * https://example.com/wiki/index.html (on web browser with HTTPS)
 * http://example.com/wiki/index.html (on web browser with HTTP)
 * gopher://example.com/wiki/index.gph (on gopher browsers)

So instead of /wiki/page-name.md, use /wiki/page-name/index.md, and use links
to `/wiki/page-name/` (with a trailing `/`, important for markdown-gph(1)).

How to handle HTTP vHosts on Gopher?
------------------------------------
No vHosts on Gopher: multiple domains with the same destination point to the
same website, unlike the Web where you can redirect them as you wish.

For instance if `//doc.example.com/` and `//git.example.com/` point to the same
server, geomyidae(1) will pick the same `/index.gph` for both. A solution is to
always use prefixes, like `//doc.example.com/doc/` or `//git.example.com/git/`.

Is NotMarkdown different from Markdown?
---------------------------------------
NotMarkdown is Markdown without nesting and HTML. This avoids all edge cases.

For instance, there is a good support for escaping and `\`backtick\`` quoting.
See [notmarkdown(5)](/man/notmarkdown.5/) for full description.