#!/usr/bin/env python

import socket
import sys


try:
#if True:
	# Newsserver we want to check
	newsserver = sys.argv[1]
	socket.getaddrinfo(newsserver, 80)

	try:
		socket.getaddrinfo(newsserver, 80, socket.AF_INET)
		IPv4 = True
	except:
		IPv4 = False
	try:
		socket.getaddrinfo(newsserver, 80, socket.AF_INET6)
		IPv6 = True
	except:
		IPv6 = False



	if IPv4 and IPv6: iptext = "IPv4-IPv6"
	if IPv4 and not IPv6: iptext = "IPv4-only"
	if not IPv4 and IPv6: iptext = "IPv6-only"

	if IPv4: 
		s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	elif IPv6:
		s = socket.socket(socket.AF_INET6, socket.SOCK_STREAM)



	

	s.settimeout(3)
	s.connect((newsserver, 119))
	data = s.recv(1024).rstrip()
	s.sendall('QUIT\r\n')
	s.close()
	print newsserver, ';', iptext, '; Received', repr(data)


except:
	False
	#print "Error!"

