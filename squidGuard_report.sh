#!/bin/bash
set -e

if [ `id -u` -ne "0" ];then
  echo "Sorry,Not Permit User!"
  exit 2
fi

TEMP="/var/log/squid/squidGuard_block_report.log"

sudo -u proxy echo -e "`LANG=C date`\n# SquidGuard block Report" > ${TEMP}
for bar in `seq 1 80`;do echo "#";done | xargs echo -n | \
  sudo -u proxy sed s/" "//g >> ${TEMP}
echo "" >> ${TEMP}
sudo -u proxy find /var/log/squid/block -mtime -1 -print | \
  grep -v "block\$" | \
  for list in `xargs`;do
    TITLE=`echo "$list" | sed s%"/var/log/squid/block/"%%g | sed s/"\.log"//g`
    echo "[ ${TITLE} ]"
    test -f "$list" && sudo -u proxy cat "${list}" 
  done >> ${TEMP}
cat ${TEMP} | mail -s "squidGuard Block Report" root
unset TEMP bar TITLE list
exit 0
