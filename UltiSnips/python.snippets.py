#!/usr/bin/env python3
# vim:set fileencoding=utf8:

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
""")


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

bsnip("gc", "gc debug", r"""
import gc; gc.set_debug(gc.DEBUG_LEAK)
""")

wsnip("fr", "from", "from ")

bsnip("cli-sub", "subcommand cli template", r"""
import argparse
import logging
import sys

from pathlib import Path

from . import __version__ as VERSION


log = logging.getLogger("")


def add_common_options(parser):
    parser.add_argument(
        "--debug",
        help="Turn on verbose logging.",
        default=False,
        action="store_true")
    parser.add_argument(
        "--traceback",
        default=False,
        action="store_true",
        help="Print traceback of error.")
    parser.add_argument(
        "--version",
        action="version",
        version=VERSION)


def command_dummy(args):
    print("Temporary dummy command.")


def main():
    parser = argparse.ArgumentParser()

    add_common_options(parser)
    parser.set_defaults(command=lambda args: parser.print_help())

    subparsers = parser.add_subparsers()

    cmd = subparsers.add_parser(
        "dummy",
        help="Temporary dummy command.")

    add_common_options(cmd)

    cmd.set_defaults(command=command_dummy)

    args = parser.parse_args()

    logging.basicConfig(stream=sys.stdout,
                        level=logging.DEBUG if args.debug else logging.ERROR,
                        format="%(levelname)s: %(message)s")

    try:
        args.command(args)
    except KeyboardInterrupt:
        pass
    except Exception as e:
        if args.traceback:
            raise

        print(f"ERROR: {e!s}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
""")

bsnip("add-hexdump", "add my handy hexdump impl.", r"""
def hexdump(data):
    if isinstance(data, str):
        data = data.encode("utf-8")

    for i in range(0, len(data), 16):
        block = data[i:i+16]

        line_data_hex = (" ".join("%02x" % (x,) for x in block[0:8]) + "  " +
                         " ".join("%02x" % (x,) for x in block[8:]))
        line_data_ascii = "".join(chr(x) if 32 <= x < 127 else "." for x in block)

        if len(block) < 16:
            line_data_hex += " " * (48 - len(line_data_hex))

        print(f"{i:10d} ({i:8x}h):  {line_data_hex}    {line_data_ascii}")


$0
""")

bsnip("cli-simple", "simple cli template for standalone scripts", r"""
#!/usr/bin/env python3
import argparse
import logging
import shutil
import subprocess
import sys

from glob import glob
from pathlib import Path
from pprint import pprint


COLORS = {
    "yellow": "",
    "reset": "",
}


def setup_say():
    tput_path = shutil.which("tput")
    if tput_path and sys.stdout.isatty():
        COLORS["yellow"] = "".join(
            [
                run(tput_path, "bold"),
                run(tput_path, "setaf", "3"),
             ]
        )
        COLORS["reset"] = run(tput_path, "sgr0")


def say(msg):
    print(f"{COLORS['yellow']}{msg}{COLORS['reset']}")


def run(*args, **kwargs):
    show_cmd = kwargs.get('show_cmd', False)
    shell = kwargs.get('shell', False)
    encoding = kwargs.get('encoding', 'utf-8')

    if shell:
        command = ' '.join([shlex.quote(x) for x in args])
    else:
        command = args

    if show_cmd:
        print(' '.join(args))

    check_ret = kwargs.get('check_ret', True)

    p = subprocess.Popen(
        command, shell=shell, encoding=encoding,
        stdout=subprocess.PIPE, stderr=subprocess.STDOUT)

    output = p.communicate()
    retcode = p.poll()
    if check_ret and retcode:
        raise ScriptError("Error executing: %r (%d, %s)" % (command, retcode, output))

    return output[0]


def run_git(*args, **kwargs):
    path = kwargs.pop('path', None)

    if path is not None:
        path = str(path)

        if path.endswith('.git'):
            args = ['--git-dir=%s' % path] + list(args)
        else:
            args = ['--git-dir=%s/.git' % path, '--work-tree=%s' % path] + list(args)

    command = ['git'] + list(args)
    return run(*command, **kwargs).strip()


def do_the_thing(args):
    say("Do real work here.")


def main():
    parser = argparse.ArgumentParser()

    parser.add_argument(
        "--traceback",
        default=False,
        action="store_true",
        help="Print traceback of error.")

    args = parser.parse_args()

    setup_say()

    try:
        do_the_thing(args)
    except KeyboardInterrupt:
        pass
    except Exception as e:
        if args.traceback:
            raise

        print(f"ERROR: {e!s}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
""")
