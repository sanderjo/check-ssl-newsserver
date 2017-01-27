#!/bin/sh

# Generate potential newsserver FQDN's

lynx --dump 'http://www.reddit.com/r/usenet/wiki/providers' | grep -i -e " http://" -e " https://" | \
awk -F/ '{ print $3 }' | awk -F. '{ print $(NF-1) "." $NF } ' | sort -u | \
awk '{ print "reader." $1 "\nnews." $1 "\nssl." $1  "\nssl-eu." $1 "\nssl-us." $1  "\neu." $1 "\nus." $1  "\ndownload." $1 "\n" $1 }' 
