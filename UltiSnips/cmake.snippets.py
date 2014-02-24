#!/usr/bin/env python
# vim:set fileencoding=utf8:

import os
import sys
import re
import setpypath

from sniputil import put

from sniputil import snip, bsnip, wsnip
from sniputil import abbr, babbr, wabbr

bsnip("foreach", "foreach", r"""
foreach(${1:SRC} ${${2:SRCS}})
    $0
endforeach($1)""", aliases=["fore"])

bsnip("mss", "message(STATUS ...)", r"message(STATUS $0)""")

wsnip("var", "${...}", r"${$0}")
