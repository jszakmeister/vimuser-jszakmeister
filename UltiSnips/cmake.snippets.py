#!/usr/bin/env python
# vim:set fileencoding=utf8:

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
bsnip("msf", "message(FATAL_ERROR ...)", r"message(FATAL_ERROR $0)",
      aliases=["err"])
bsnip("set", "set(...)", r"set($0)")

bsnip("gfc", "get_filename_component(...)", r"""
get_filename_component(${1:VAR} ${2:FROM} ${0:PATH|ABSOLUTE|NAME|EXT|NAME_WE|REALPATH})
""")

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

bsnip("macro", "macro(...)", r"""
macro(${1:name and args})
$0
endmacro()""")

bsnip("dump-variables", "dump all variables", r"""
get_cmake_property(_variableNames VARIABLES)
foreach (_variableName ${_variableNames})
    message(STATUS "${_variableName}=${${_variableName}}")
endforeach()""", aliases=["dv"])

bsnip("option", "option(...)", r"""
option(${1:VAR} "${2:help string}" ${3:ON|OFF})
""", aliases=['opt'])

bsnip("sdp", "set_directory_properties()", r"""
set_directory_properties(PROPERTIES
       ${1:ADDITIONAL_MAKE_CLEAN_FILES} ${2:value})
""")

wsnip("cmd", "COMMAND", r"COMMAND $0")
wsnip("wd", "WORKING_DIRECTORY", r"WORKING_DIRECTORY $0")
