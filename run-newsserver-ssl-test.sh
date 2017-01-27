#!/bin/sh

./generate-potential-newsservers.sh  > potential-ssl-newsservers.txt
cat manual-added-newsservers.txt >> potential-ssl-newsservers.txt
cat potential-ssl-newsservers.txt | tr "[A-Z]" "[a-z]" | sort -u | awk '{ print "python check_ssl_newsserver---to-csv.py " $1 }' | /bin/sh | grep OK > newsservers-with-SSL.csv

# csv2html must be installed. See https://github.com/maxogden/csv2html
cat header.csv newsservers-with-SSL.csv | csv2html > newsservers-with-SSL.html

