#!/usr/bin/env python3
# vim:set fileencoding=utf8:

import setpypath

from sniputil import put

from sniputil import snip, bsnip, wsnip
from sniputil import abbr, babbr, wabbr


# Section heading
bsnip("sect", "Section", r"""
------------------------------------------------------------------------------
${1:NAME}`!p snip.rv = (57-len(t[1]))*' '+'*notes_'+t[1].lower()+'*'`
  ${2:Short description}`!p snip.rv = (55-len(t[2]))*' '`|${3:doc-ref}|

${0:Information goes here.}

Version ${4:version} from ${5:url}

Installation:
- Follow bundle installation instructions (|bundle_installation|).

""")
