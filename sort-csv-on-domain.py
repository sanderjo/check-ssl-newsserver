import fileinput

def domain(regel):
	return regel.split(',')[0].split('.')[-2]



mylist = []

for regel in fileinput.input():
	mylist.append(regel.rstrip())

#print mylist
for regel in sorted(mylist, key=domain):
	print regel

