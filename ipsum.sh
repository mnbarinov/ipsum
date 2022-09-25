#!/bin/bash
###
#Copyright (c) 2022 Mikhail Barinov <dev@mbarinov.ru>
#git: https://github.com/mnbarinov/ipsum
###
firewall-cmd --permanent --delete-ipset=ipsum-blacklist 
#create new ipset
firewall-cmd --permanent --new-ipset=ipsum-blacklist --type=hash:ip
#load and add IPs into ipset 
for ip in $(curl --compressed https://raw.githubusercontent.com/stamparm/ipsum/master/ipsum.txt 2>/dev/null | grep -v "#" | grep -v -E "\s[1-2]$" | cut -f 1); do firewall-cmd --ipset=ipsum-blacklist --add-entry=$ip --permanent; done
#firewall-cmd rules
firewall-cmd --permanent --zone=public --remove-rich-rule='rule family="ipv4" source ipset="ipsum-blacklist" drop'
firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" source ipset="ipsum-blacklist" drop'
#firewall-cmd reload and apply rules
firewall-cmd --reload
