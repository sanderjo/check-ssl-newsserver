time cat lijssie-2017-01-17.txt | tr "[A-Z]" "[a-z]" | sort -u | awk '{ print "python check_ssl_newsserver---to-csv.py " $1 }' | /bin/sh | grep OK > superlijst-2017-01-17b.csv

