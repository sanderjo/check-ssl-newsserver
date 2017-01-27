#!/usr/bin/env python

import fileinput

for line in fileinput.input():
	# in the head, insert title:
	line = line.replace('<head>', '<head><title>Overview of SSL NNTPS newservers, and their level of security</title>')

	# colorize OK and NOK:
	if line.find("NOK") >= 0:
		line = line.replace("NOK", '<span style="color:red">NOK</span>')
	else:
		line = line.replace("OK", '<span style="color:green">OK</span>')

	print line,
