#!/usr/bin/env python3
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
bsnip("msw", "message(WARNING ...)", r"message(WARNING $0)", aliases=["warn"])
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

bsnip("acc", "add_custom_command()", r"""
add_custom_command(
    OUTPUT_FILE ${1:output_file}
    COMMAND ${3:command}
    DEPENDS ${2:input_file})
""")

bsnip("cmr", "cmake_minimum_required()", r"""
cmake_minimum_required(VERSION ${1:3.13})$0
""")

bsnip("proj", "project()", r"""
project(${1:name} ${2:C CXX})$0
""")

bsnip("sub", "add_subdirectory()", r"""
add_subdirectory($1)$0
""")

bsnip("exe", "add_executable()", r"""
add_executable(${0:name and sources})
""")

wsnip("cmd", "COMMAND", r"COMMAND $0")
wsnip("wd", "WORKING_DIRECTORY", r"WORKING_DIRECTORY $0")

bsnip("template_cmake.txt", "template for new CMake file", r"""
cmake_minimum_required(VERSION ${1:3.13})

project(${2:name} ${3:C CXX})

$0
""")
