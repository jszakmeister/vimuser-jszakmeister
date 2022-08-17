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

# Status template
bsnip("status", "status template", r"""
`!v strftime("%d %b")` - `!v strftime("%d %b", localtime()+604800)`
===============


Accomplishments
---------------

* $0


Pending
^^^^^^^


Future
------


Issues
------

* None.


Time Off
--------

* None.
""")

# Backlog template
bsnip("backlog", "backlog template", r"""
Backlog
=======

Priorities
----------

* $0


Recently Finished
-----------------


Under Development
-----------------


Follow-up On
------------


Follow-up On (previously discussed)
-----------------------------------


Future Work
-----------


Not Ready to Act On
-------------------


Not Fully Determined
^^^^^^^^^^^^^^^^^^^^


Other Issues
------------
""")

bsnip("release", "release notes template", r"""
${1:1.0.0} (Released ${2:`!v strftime("%Y-%m-%d")`})
`!p snip.rv = (len(t[1]) + len(t[2]) + 12) * '='`

$3


New Features
------------

* $0


Enhancements
------------

*


Bug Fixes
---------

*
""", aliases=['rel'])


bsnip("brelease", "release notes (with breaking changes)", r"""
${1:1.0.0} (Released ${2:`!v strftime("%Y-%m-%d")`})
`!p snip.rv = (len(t[1]) + len(t[2]) + 12) * '='`

$3


Breaking Changes
----------------

* $0


New Features
------------

*


Enhancements
------------

*


Bug Fixes
---------

*
""", aliases=['brel'])


# Handy helpers (for me).

wsnip("done", "[DONE]", r"""
\`\`[DONE]\`\` $0
""")

wsnip("res", "[RESOLVED]", r"""
\`\`[RESOLVED]\`\` $0
""")

wsnip("start", "started <date>", r"""
\`\`[started ${1:`!v strftime("%Y-%m-%d")`}]\`\` $0
""")
