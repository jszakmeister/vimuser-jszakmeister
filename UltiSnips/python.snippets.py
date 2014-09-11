#!/usr/bin/env python
# vim:set fileencoding=utf8:

import os
import sys
import re
import setpypath

from sniputil import put

from sniputil import snip, bsnip, wsnip
from sniputil import abbr, babbr, wabbr


# Templates

bsnip("template_python.snippets.py", "new snippet template", r"""
#!/usr/bin/env python
# vim:set fileencoding=utf8:

import os
import sys
import re
import setpypath

from sniputil import put

from sniputil import snip, bsnip, wsnip
from sniputil import abbr, babbr, wabbr

$0
""", flags="!")


bsnip("screrr", "ScriptError", r"""
class ScriptError(Exception):
    pass

$0
""", aliases=['se'])

wsnip("xrange", "xrange", r"""
xrange($1)$0
""", aliases = ['xr'])

bsnip("rre", "raise RuntimeError()", r"""
raise RuntimeError($1)$0
""")

bsnip("pst", "print stack trace", r"""
import sys, traceback; traceback.print_stack(file=sys.stderr)
""")

bsnip("nose", "from nose.tools import *", r"""
from nose.tools import *
""")
