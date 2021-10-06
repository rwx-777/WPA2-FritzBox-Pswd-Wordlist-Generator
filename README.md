# WPA2-FritzBox-Pswd-Wordlist-Generator
This Script will produce all of the WPA2 Passwords used by various Router companies aswell as Fritzbox. All of these Passwords will be 16 Numbers in length. So it could get a bit large. If anybody has got some extra SSDs feel free to send them over. 

### Usage:
```
$ ./WordlistGenerator.perl > All16Nums-Wordlist.txt
```

## Update 2021
thanks to my good friend f4n0 we have a new script in python which now also checks for three consecutive numbers in the wordlist.
~~~
$ python WordlistGenerator.py > Router-pswds.txt

### DONE:
- FritzBox never have Passwords with three same Numbers after each other so we could reduce this

### To-do:
- compression ?

Please feel free to help improve and lets try to get these Wordlists together. 

Enjoy,

rwx-777
