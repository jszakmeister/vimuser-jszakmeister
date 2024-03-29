#!/usr/bin/env python3
# vim:set fileencoding=utf8:

import setpypath

from sniputil import put

from sniputil import snip, bsnip, wsnip
from sniputil import abbr, babbr, wabbr

put("extends markdown\n")

bsnip("ab", "Acked-by: ...", r"""
Acked-by: John Szakmeister <john@szakmeister.net>
""")

bsnip("sob", "Signed-off-by: ...", r"""
Signed-off-by: John Szakmeister <john@szakmeister.net>
""")

bsnip("rb", "Reviewed-by: ...", r"""
Reviewed-by: John Szakmeister <john@szakmeister.net>
""")
