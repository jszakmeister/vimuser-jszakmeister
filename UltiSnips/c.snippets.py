#!/usr/bin/env python
# vim:set fileencoding=utf8:

import setpypath

from sniputil import put

from sniputil import snip, bsnip, wsnip
from sniputil import abbr, babbr, wabbr


bsnip("com", "/* comment */", r"""
/* $1 */
""", flags="b")

bsnip("cb", "compiler barrier (gcc)", r"""
asm volatile("": : :"memory")
""")

bsnip("docstring", "docstring for func or type", r"""
/**
    ${1:Brief description.}

    ${0:Full description.}
*/
""", flags="b", aliases=["doc"])

bsnip("ig", "(void) ...;", r"""
(void) $1;$0
""")

bsnip("ts", "typedef struct name { ... }", r"""
typedef struct ${1:name}
{
    $0
} $1;
""")

bsnip("vmain", "main(void)", r"""
/** @brief Main program entry point.
    @retval 0
        Success.
*/
int
main(void)
{
    $0
    return 0;
}
""")


# Attributes

wsnip("depr", "__attribute__ ((deprecated))", r"""
__attribute__ ((deprecated))$0
""")

wsnip("unused", "__attribute__ ((unused))", r"""
__attribute__ ((unused))$0
""")


# Templates

bsnip("template_c.c", ".c template", r"""
#ifndef INCLUDED_`!p import re; res = re.sub('[-/]', '_', t[1].rsplit('.')[0]).upper()`
#include "${1:`!v expand('%:t:r')`.h}"
#endif

$0
""")

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
""")
