#!/usr/bin/env python3
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

bsnip("chap", "Chapter/Title", r"""
# $0
""")

bsnip("sect", "Section", r"""
## $0
""", aliases=["h1"])

bsnip("subsec", "Subsection", r"""
### $0
""", aliases=["h2"])

bsnip("subsubsec", "Sub-subsection", r"""
#### $0
""", aliases=["h3"])

bsnip("para", "Paragraph", r"""
##### $0
""", aliases=["h4"])

bsnip("code", "code block", r"""
{{{
::${1:python}
$0
}}}
""")

bsnip("ghcode", "github code block", r"""
\`\`\`${1:python}
$0
\`\`\`
""")

bsnip("cimg", "centered image", r"""
<center>
 <img src="${1:/path/to/img.png}" alt="${2:description}" />
</center>
$0
""")

wsnip("lit", "literal (code) markup", r"""
\`${1:`!p betterVisual(snip)`}\`$0
""", aliases=['f', 'cmd'])

wsnip("link", "link markup", r"""
[${1:text}](${2:link})$0
""")

wsnip("ln", "link markup with id", r"""
[${1:text}][${2:id}]$0
""")

bsnip("le", "link entry", r"""
[${1:id}]: ${0:url}
""")

wsnip("fn", "footnote", r"""
[^${1:id}]$0
""")

bsnip("fne", "footnote entry", r"""
[^${1:id}]: ${0:text}
""")

wsnip("cb", "checkbox", r"""
[ ] $0
""")

wsnip("nd", "ndash", r"""
&ndash; $0
""")

wsnip("datetime", "today's date",
      r"""`!v strftime("%Y-%m-%d %H:%M:%S %z")`$0""")


bsnip("post", "post header", r"""
---
layout: post
title: "${1:Title}"
date: ${2:`!v strftime("%Y-%m-%d %H:%M:%S %z")`}
tags:
  - Software Development
---
$0
""")

bsnip("rrbook", "recommended reading book", r"""
  - <a href="${3:url}" rel="nofollow">**${1:title}**</a>
    *by ${2:author}* &ndash; ${0}

""")
