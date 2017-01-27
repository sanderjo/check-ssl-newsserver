#!/usr/bin/env python

import fileinput

for line in fileinput.input():
	if line.find("NOK") >= 0:
		line = line.replace("NOK", '<span style="color:red">NOK</span>')
	else:
		line = line.replace("OK", '<span style="color:green">OK</span>')
	print line,
