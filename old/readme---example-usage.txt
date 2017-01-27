Check one newsserver:

python check_ssl_newsserver---to-csv.py newsreader.eweka.nl
"newsreader.eweka.nl","IPv4-only","TLSv1.2","200 Welcome to Eweka (fx18.am4)","OK","OK","OK","-","-"

Bulk:


/bin/bash ./generate-potential-newsservers.sh > lijssie-10sept2016.txt
cat lijssie-10sept2016.txt | awk '{ print "python check_ssl_newsserver---to-csv.py " $1 }' | /bin/sh > superlijst-10sept2016.csv

