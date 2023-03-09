import re
import os
chunk_size = 100000
filename = ""
startRange = 1000000000000
if not os.path.exists("wlist"):
    os.makedirs("wlist")
try:    
    lastwlist = os.listdir("wlist")[-1]
    with open("wlist/"+lastwlist, 'r') as f:
        startRange = int(f.readlines()[-1])    
    with open("wlist/"+lastwlist, 'a') as f:
        f.write("\n")
except:
    startRange = 1000000000000

for i in range(startRange, 9999000000000000):
    num = "%0.16d" % i
    if re.search(r"([1-9])\1\1", num) == None:
        tmp = "wlist/fritz%d.txt" % (i/chunk_size)
        if filename != tmp:
            try:
                if f.closed == False:
                    f.close()
            except: 
                pass
            filename = tmp
            f = open(filename, "a")
        else:
            f.write("\n")        
        f.write(num)

