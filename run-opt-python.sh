#!/bin/sh


# Collect potential newsservers from various sources:
# The base: SSL newsservers that were found earlier and stored in the .csv file:
if [ -f "newsservers-with-SSL.csv" ];
then
    cat newsservers-with-SSL.csv  | awk -F\, '{ print $1 }' | tr -d '"' > potential-ssl-newsservers.txt
fi
# Generate from reddit:
./generate-potential-newsservers.sh  >> potential-ssl-newsservers.txt
# Add what was manually added:
cat manual-added-newsservers.txt >> potential-ssl-newsservers.txt
# Check apache-log for cgi-bin lines:
# "GET /cgi-bin/check_newsserver.py?server=newsreader.eweka.nl HTTP/1.1"
if [ -f "/var/log/apache2/access.log" ];
then
    cat /var/log/apache2/access.log | grep check_newsserver  | grep -o -P '(?<=server=)[a-zA-Z0-9_\-\.]*(?= )' | sort -u | grep "[a-zA-Z]" >> potential-ssl-newsservers.txt
    # PS: 'grep "[a-zA-Z]" ' is needed to filter out IP-addresses.
fi

# List complete. Now convert to small letters, and do a unique sort:
cat potential-ssl-newsservers.txt | tr "[A-Z]" "[a-z]" | sort -u > temp-newsservers-combined.txt



# Now the actual SSL probing of all the (potential) newsservers in the list
# We need a python 2.7.9+ for that, so we need a opt-python on old Ubuntu 14.04:
# If there is a "/opt/python2711/bin/python", use that. Otherwise use plain python 

if [ -f "/opt/python2711/bin/python" ];
then
   cat temp-newsservers-combined.txt | awk '{ print "/opt/python2711/bin/python check_ssl_newsserver---to-csv.py " $1 }' | /bin/sh | grep OK > newsservers-with-SSL.csv
else
   cat temp-newsservers-combined.txt | awk '{ print "python check_ssl_newsserver---to-csv.py " $1 }' | /bin/sh | grep OK > newsservers-with-SSL.csv
fi

# OK, done with searching

# Convert the CSV to HTML
cat header.csv newsservers-with-SSL.csv | csv2html  > newsservers-with-SSL-noncolor.html

# Add title, and colorize:
python color-OK-and-NOK.py < newsservers-with-SSL-noncolor.html > newsservers-with-SSL.html

if [ -d "/var/www/newsservers/" ]; then
  cp newsservers-with-SSL* /var/www/newsservers/
fi





