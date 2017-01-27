# check-ssl-newsserver
Check the SSL/TLS of a newsserver, in other words check the NNTPS.

Output: result in CSV format, including the level of security

## Usage 1:

Check just one newsserver, like newsreader.eweka.nl
```
./check_ssl_newsserver---to-csv.py newsreader.eweka.nl
"newsreader.eweka.nl","IPv4-only","TLSv1.2","OK","OK","OK","-","-"
```

## Usage 2:

Find and check all newsservers you can find:

```
./run-opt-python.sh
```
