#!/bin/sh

cat potential-ssl-newsservers.txt | tr "[A-Z]" "[a-z]" | sort -u > temp-newsservers-combined.txt

# If there is a "/opt/python2711/bin/python", use that (Hello, Ubuntu 14.04). Otherwise the plain python 

if [ -f "/opt/python2711/bin/python" ];
then
   cat temp-newsservers-combined.txt | awk '{ print "/opt/python2711/bin/python check_ssl_newsserver---to-csv.py " $1 }' | /bin/sh | grep OK > newsservers-with-SSL.csv
else
   cat temp-newsservers-combined.txt | awk '{ print "python check_ssl_newsserver---to-csv.py " $1 }' | /bin/sh | grep OK > newsservers-with-SSL.csv
fi


cat header.csv newsservers-with-SSL.csv | csv2html > newsservers-with-SSL-noncolor.html
python color-OK-and-NOK.py < newsservers-with-SSL-noncolor.html > newsservers-with-SSL.html
