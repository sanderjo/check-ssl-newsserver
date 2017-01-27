#!/bin/sh


# Collect potential newsservers from various sources:
# Generate from website:
./generate-potential-newsservers.sh  > potential-ssl-newsservers.txt
# Add what was manually added:
cat manual-added-newsservers.txt >> potential-ssl-newsservers.txt
# Check apache-log:
if [ -f "/var/log/apache2/access.log" ];
then
    cat /var/log/apache2/access.log | grep check_newsserver  | grep -o -P '(?<=server=)[a-zA-Z0-9_\-\.]*(?= )' | sort -u >> potential-ssl-newsservers.txt
fi

# List complete. Now convert to small letters, and do a unique sort:
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
