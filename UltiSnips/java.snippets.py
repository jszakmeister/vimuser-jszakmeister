#!/usr/bin/env python
# vim:set fileencoding=utf8:

import setpypath

from sniputil import put

from sniputil import snip, bsnip, wsnip
from sniputil import abbr, babbr, wabbr

put(r"""
global !p
from sniputil import betterVisual
endglobal
""")

bsnip("docstring", "docstring for func or type", r"""
/**
 *  ${1:Brief description.}
 *
 *  ${0:Full description.}
 */
""", flags="b", aliases=["doc", "/**"])

# Javadoc.
wabbr("@param",     "@param ${1:inParam}  ${0:@todo Description of $1.}",
        aliases=["@p", "@pi", "@po", "@pio"])
wabbr("@return",    "@return ", aliases=["@re", "@ret", "@retval", "@rv"])
wabbr("todo",  "/** @todo ${1:Description of what's TO DO.} */")
wabbr("bug",   "/** @bug ${1:Description of BUG.} */")

bsnip("pl", "System.out.println()", r"""
System.out.println($1);
""", flags="b")

put(r"""
snippet printf "printf('...', ...);" w
System.out.printf("${1:%s}\n"${1/([^%]|%%)*(%.)?.*/(?2:, :\);)/}$2${1/([^%]|%%)*(%.)?.*/(?2:\);)/}
endsnippet

snippet pf "printf('...', ...);" w
System.out.printf("${1:%s}\n"${1/([^%]|%%)*(%.)?.*/(?2:, :\);)/}$2${1/([^%]|%%)*(%.)?.*/(?2:\);)/}
endsnippet

snippet err "printf('...', ...);" w
System.err.printf("${1:%s}\n"${1/([^%]|%%)*(%.)?.*/(?2:, :\);)/}$2${1/([^%]|%%)*(%.)?.*/(?2:\);)/}
endsnippet

""")

# 'if' snippets.
bsnip("if", "if (...) {...}", r"""
if ($1) {
    `!p betterVisual(snip)`$0
}
""")

wsnip("else", "else {...}", r"""
else {
    `!p betterVisual(snip)`$0
}
""", aliases=["el"])

wsnip("elif", "else if (...) {...}", r"""
else if ($1) {
    `!p betterVisual(snip)`$0
}
""", aliases = ["ei"])

bsnip("for", "for (i = 0; i < N; i++) {...}", (
r"""for (${1:i}""" +
r"""${1/(.*;.*)|(.*=.*)|(.+)|.*/(?1::(?2:;:(?3: = 0;:;)))/} """ +
r"""${1/\s*[=;].*//}""" +
r"""${2/(.*;.*)|(^[<>!=].*)|.*/(?1::(?2: : < ))/}""" +
r"""${2:N}""" +
r"""${2/(.*;.*)|.*/(?1::;)/} """ +
r"""${1/\s*[=;].*//}""" +
r"""${3:${2/(^>.*)|.*/(?1:--:++)/}}""" +
r""") {
    `!p betterVisual(snip)`$0
}
"""))

bsnip("fore", "for (each)", r"""
for ($1 : $2) {
    $0
}""")

bsnip("template_java", "template for a new java file", r"""
package ${1:name};

${2:public} class ${3:Name} {
    $0
}
""")
