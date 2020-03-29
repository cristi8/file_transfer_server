#!/bin/bash

set -e

iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

iptables -A INPUT -s ${ALLOWED_SRC} -p tcp --dport 22 -j ACCEPT
iptables -A OUTPUT -d ${ALLOWED_SRC} -p tcp --sport 22 -m state --state ESTABLISHED,RELATED -j ACCEPT

/usr/sbin/sshd

cd /home/user
watch -n 1 $(cat <<EOF
    netstat -plant;

    /bin/echo -e '\nBash History:';
    cat /home/user/.bash_history;

    /bin/echo -e '\n\nUser directory content:';
    du -abh --max-depth=1 .

EOF)
