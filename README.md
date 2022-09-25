<img src="https://user-images.githubusercontent.com/64634630/192131628-a5a8a9ab-a973-498f-817d-01844157969d.png" width="200" height="200">

[![License](https://img.shields.io/badge/license-The_Unlicense-red.svg)](https://unlicense.org/)

Intro
----
Original repository is [here](https://github.com/stamparm/ipsum).

I added a script for `firewall-cmd`

About
----

**IPsum** is a threat intelligence feed based on 30+ different publicly available [lists](https://github.com/stamparm/maltrail) of suspicious and/or malicious IP addresses. All lists are automatically retrieved and parsed on a daily (24h) basis and the final result is pushed to this repository. List is made of IP addresses together with a total number of (black)list occurrence (for each). Greater the number, lesser the chance of false positive detection and/or dropping in (inbound) monitored traffic. Also, list is sorted from most (problematic) to least occurent IP addresses.

As an example, to get a fresh and ready-to-deploy auto-ban list of "bad IPs" that appear on at least 3 (black)lists you can run:

```
curl --compressed https://raw.githubusercontent.com/stamparm/ipsum/master/ipsum.txt 2>/dev/null | grep -v "#" | grep -v -E "\s[1-2]$" | cut -f 1
```

If you want to try it with `firewall-cmd ipset`, you can do the following:

Create `ipsum.sh` script and add this into `crontab`

```
#!/bin/bash

firewall-cmd --permanent --delete-ipset=ipsum-blacklist 
#create new ipset
firewall-cmd --permanent --new-ipset=ipsum-blacklist --type=hash:net
#load and add IPs into ipset 
for ip in $(curl --compressed https://raw.githubusercontent.com/stamparm/ipsum/master/ipsum.txt 2>/dev/null | grep -v "#" | grep -v -E "\s[1-2]$" | cut -f 1); do firewall-cmd --ipset=ipsum-blacklist --add-entry=$ip --permanent; done
#firewall-cmd rules
firewall-cmd --permanent --zone=public --remove-rich-rule='rule family="ipv4" source ipset="ipsum-blacklist" drop'
firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" source ipset="ipsum-blacklist" drop'
#firewall-cmd reload and apply rules
firewall-cmd --reload

```

