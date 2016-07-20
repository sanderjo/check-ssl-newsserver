#!/usr/bin/env python

import socket, ssl, sys
import traceback

# Manual stuff:
# openssl s_client -connect news.eweka.nl:563
# openssl s_client -connect news.giganews.com:563

def check_NNTPS_server(servername,serverport,strict):
	'''
	strict:
	0 : not strict
	1 : create context, with certificate check: context.verify_mode = ssl.CERT_REQUIRED
	2 : create context, with certificate and hostname check: context.check_hostname = True
	'''

	sslversion = welcomeline = mytraceback = error = "" 
	#print "Check:", servername, serverport, strict, ":",

	try:
		# Context is everything:
		# NB https://docs.python.org/2/library/ssl.html#ssl.SSLContext was introduced with Python 2.7.9
		context = ssl.SSLContext(ssl.PROTOCOL_SSLv23)
		if strict >= 1:
			#context.options |= ssl.OP_NO_SSLv2
			#context.options |= ssl.OP_NO_SSLv3
			# The SSL context created by the two lines above will only allow TLSv1 and later (if supported by your system) connections.
			context.verify_mode = ssl.CERT_REQUIRED
			if strict >= 2:
				context.check_hostname = True
			context.load_default_certs()

		s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		s.settimeout(3)
	except:
		print "you need python 2.7.9 or higher!"
		print traceback.format_exc()
		

	try:
		ssl_sock = context.wrap_socket(s, server_hostname=servername)
		ssl_sock.connect((servername, serverport))
		sslversion = ssl_sock.version()
		#print "Version: ", sslversion,

		welcomeline = ssl_sock.recv().rstrip()
		#print "Welcome is", welcomeline, 

		#ssl_sock.send("HELP\r\n")
		#print ssl_sock.recv()

		ssl_sock.send("QUIT\r\n")
		closingline = ssl_sock.recv()
	except:
		e = sys.exc_info()[0]
		# print "Not good", e,
		error = str(e).split("'")[1]
		#print "traceback:",traceback.format_exc().split("\n")[-2]
		mytraceback = traceback.format_exc().split("\n")[-2]
		#raise

	try:
		ssl_sock.close()
	except:
		pass

	#print ""
	return (sslversion, welcomeline, error, mytraceback)



############################
###### MAIN ################


try:
#if True:
	output = []

	# Newsserver we want to checK
	newsserver = sys.argv[1]
	#print newsserver,
	output.append(newsserver)

	sslfound = ""
	firsterror = ""
	firsttraceback = ""

	# We do 3 levels of Strictness


	# Strict 0
	(sslversion, welcomeline, error, mytraceback) = check_NNTPS_server(newsserver, 563,0)
	output.append(sslversion)
	output.append(welcomeline)
	if error <> "":
		output.append("NOK")
		firsterror = error
		firsttraceback = mytraceback
	else:
		output.append("OK")


	# Strict 1
	(sslversion, welcomeline, error, mytraceback) = check_NNTPS_server(newsserver, 563,1)
	if error <> "":
		output.append("NOK")
		firsterror = error
		firsttraceback = mytraceback
	else:
		output.append("OK")

	# Strict 2
	(sslversion, welcomeline, error, mytraceback) = check_NNTPS_server(newsserver, 563,2)
	if error <> "":
		output.append("NOK")
		firsterror = error
		firsttraceback = mytraceback
	else:
		output.append("OK")


	# Collect results:

	if firsterror <> "":
		output.append(firsterror)
	else:
		output.append("-")

	if firsttraceback <> "":
		output.append(firsttraceback)
	else:
		output.append("-")

	#print output
	# ... and print results in CSV format:
	print '"' + '","'.join(output) + '"'


	
except:
	print "No input, or other error"


