echo "BEGIN"
echo $1
../testssl.sh/testssl.sh --ip one $1:snntp | grep -i -e "not ok" 
echo "END"

