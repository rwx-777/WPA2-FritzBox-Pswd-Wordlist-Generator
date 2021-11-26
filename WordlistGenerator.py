import re
for i in range(1000000000000,9999000000000000):
    num = ('%0.16d' % i)
    if re.search(r"([1-9])\1\1", num) == None:
        print(num)
