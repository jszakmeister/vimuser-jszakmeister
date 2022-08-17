#!/usr/bin/env python3
# vim:set fileencoding=utf8:

import setpypath

from sniputil import put

from sniputil import snip, bsnip, wsnip
from sniputil import abbr, babbr, wabbr

bsnip("ifeq", "ifeq (...) / endif", r"""
ifeq ($1,$2)
    $0
endif
""")

bsnip("ifneq", "ifneq (...) / endif", r"""
ifneq ($1,$2)
    $0
endif
""")

bsnip("ifdef", "ifdef var / endif", r"""
ifdef $1
    $0
endif
""")

bsnip("ifndef", "ifndef var / endif", r"""
ifndef $1
    $0
endif
""")

bsnip("ifempty", "ifeq ($(VAR),) / endif", r"""
ifeq ($($1),)
    $0
endif
""", aliases=["ifem"])

bsnip("info", "$(info ...)", r"""
$(info $1)
""")

bsnip("warn", "$(warning ...)", r"""
$(warning $1)
""")

bsnip("err", "$(error ...)", r"""
$(error $1)
""")
