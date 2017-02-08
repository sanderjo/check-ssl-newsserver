# only check known, working SSL newsservers 
awk -F\" '{ print "python2711 check_ssl_newsserver---to-csv.py " $2 }'  < newsservers-with-SSL.csv | /bin/sh

