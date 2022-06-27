![Logo](https://i.imgur.com/PyKLAe7.png)

[![License](https://img.shields.io/badge/license-The_Unlicense-red.svg)](https://unlicense.org/)

About
----

**IPsum** is a threat intelligence feed based on 30+ different publicly available [lists](https://github.com/stamparm/maltrail) of suspicious and/or malicious IP addresses. All lists are automatically retrieved and parsed on a daily (24h) basis and the final result is pushed to this repository. List is made of IP addresses together with a total number of (black)list occurrence (for each). Greater the number, lesser the chance of false positive detection and/or dropping in (inbound) monitored traffic. Also, list is sorted from most (problematic) to least occurent IP addresses.

As an example, to get a fresh and ready-to-deploy auto-ban list of "bad IPs" that appear on at least 3 (black)lists you can run:

```
curl --compressed https://raw.githubusercontent.com/stamparm/ipsum/master/ipsum.txt 2>/dev/null | grep -v "#" | grep -v -E "\s[1-2]$" | cut -f 1
```

If you want to try it with `ipset`, you can do the following:

```
sudo su
apt-get -qq install iptables ipset
ipset -q flush ipsum
ipset -q create ipsum hash:net
for ip in $(curl --compressed https://raw.githubusercontent.com/stamparm/ipsum/master/ipsum.txt 2>/dev/null | grep -v "#" | grep -v -E "\s[1-2]$" | cut -f 1); do ipset add ipsum $ip; done
iptables -D INPUT -m set --match-set ipsum src -j DROP 2>/dev/null
iptables -I INPUT -m set --match-set ipsum src -j DROP
```

In directory [levels](levels) you can find preprocessed raw IP lists based on number of blacklist occurrences (e.g. [levels/3.txt](levels/3.txt) holds IP addresses that can be found on 3 or more blacklists).

Wall of Shame (2022-06-27)
----

|IP|DNS lookup|Number of (black)lists|
|---|---|--:|
103.251.167.21|tor-exit-at-the.quesadilla.party|9
171.25.193.77|tor-exit1-readme.dfri.se|9
171.25.193.78|tor-exit4-readme.dfri.se|9
185.130.44.108|tor-exit-se1.privex.cc|8
185.196.220.81|-|8
107.152.217.2|ip263.njohjeonline.net|8
179.60.147.74|-|8
45.61.188.110|-|7
162.247.74.74|-|7
62.197.136.10|-|7
192.42.116.16|tor-exit.hartvoorinternetvrijheid.nl|7
185.220.102.4|communityexit.torservers.net|7
185.220.102.8|185-220-102-8.torservers.net|7
185.220.101.16|berlin01.tor-exit.artikel10.org|7
193.106.191.80|-|7
185.220.102.6|185-220-102-6.torservers.net|7
185.129.62.63|tor02.zencurity.com|7
185.129.62.62|tor01.zencurity.com|7
222.186.19.205|-|7
198.98.51.189|tor.teitel.net|7
