# !/bin/bash

FILE=/root/log/ip.log
DENY=/root/log/hosts.deny
BACKUP=/root/log/backup/secure-$(date +%Y%m%d-%H%M%S)

cat /var/log/secure | sed -n -e 's/.*Failed password for \(.*\) from \(.*\) port.*/\2/gp' > $FILE
mv /var/log/secure $BACKUP
/bin/kill -HUP `cat /var/run/syslogd.pid 2> /dev/null` 2> /dev/null
sort $FILE | uniq -c > $DENY
