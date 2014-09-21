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
endforeach()""", aliases=["fore"])

bsnip("while", "while", r"""
while(${1:expr})
    $0
endwhile()""")

bsnip("mss", "message(STATUS ...)", r"message(STATUS $0)", aliases=["info"])
bsnip("msf", "message(FATAL_ERROR ...)", r"message(FATAL_ERROR $0)")
bsnip("set", "set(...)", r"set($0)")
bsnip("gfc", "get_filename_component(...)",
        r"get_filename_component(${1:VAR} ${2:FROM} ${0:PATH})")

wsnip("var", "${...}", r"${$0}")

bsnip("inc", "include()", r"include($1)")

bsnip("if", "if(...)", r"""
if($1)
    $0
endif()""")

bsnip("func", "function(...)", r"""
function(${1:name and args})
$0
endfunction()""")

bsnip("dump-variables", "dump all variables", r"""
get_cmake_property(_variableNames VARIABLES)
foreach (_variableName ${_variableNames})
    message(STATUS "${_variableName}=${${_variableName}}")
endforeach()""", aliases=["dv"])
