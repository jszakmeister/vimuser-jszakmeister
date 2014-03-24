#!/usr/bin/env python
# vim:set fileencoding=utf8:

import os
import sys
import re
import setpypath

from sniputil import put

from sniputil import snip, bsnip, wsnip
from sniputil import abbr, babbr, wabbr


bsnip("com", "/* comment */", r"""
/* $1 */
""", flags="b!")


# Templates

bsnip("template_c.c", ".c template", r"""
#ifndef INCLUDED_`!p import re; res = re.sub('[-/]', '_', t[1].rsplit('.')[0]).upper()`
#include "${1:`!v expand('%:t:r')`.h}"
#endif

$0
""", flags="!")

bsnip("template_c.h", ".h template", r"""
#ifndef INCLUDED_${1:`!p import re; res = re.sub('[-/]', '_', vim.eval("expand('%:t:r')")).upper()`}
#define INCLUDED_$1

#ifdef __cplusplus
extern "C" {
#endif

$0

#ifdef __cplusplus
}
#endif

#endif /* INCLUDED_$1 */
""", flags="!")
