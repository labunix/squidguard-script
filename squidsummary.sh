#!/bin/bash

if [ "`id -u`" -ne "0" ];then
  echo "Sorry,Not Permit User"
  exit 1
fi

TODAY="`date '+%Y-%m-%d'`"
SQUIDSTAT="/var/log/squidsummary_$TODAY"
squidclient mgr:info > $SQUIDSTAT
squidclient mgr:60min >> $SQUIDSTAT
grep -v "0\.00000" "$SQUIDSTAT" | \
  mail -s "Squid Summary Report $TODAY" root
unset TODAY SQUIDSTAT
exit 0

