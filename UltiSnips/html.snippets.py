#!/usr/bin/env python
# vim:set fileencoding=utf8:

import setpypath

from sniputil import put

from sniputil import snip, bsnip, wsnip
from sniputil import abbr, babbr, wabbr

bsnip("pre", "pre", r"""
<pre>
$0
</pre>
""")

wsnip("code", "code", r"""
<code>$1</code>$0
""")

wsnip("dd", "dd", "<dd>$0</dd>")

bsnip("template_html", "skeleton html doc", r"""
<!DOCTYPE html>
<html>
	<head lang="en">
		<meta charset="UTF-8">
		<title>${1:Title}</title>
	</head>
	<body>
		$0
	</body>
</html>
""")
