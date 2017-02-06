echo -n $1 " "
host $1 | grep "has address"  | head -1  | awk '{ print "whois " $NF }'  | /bin/sh | grep -i netname | head -1 | awk '{ print $NF }'

