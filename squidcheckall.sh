#!/bin/bash
# for squid and squidGuard
# DEBUG or 1st Only

if [ "`id -u`" -ne "0" ];then
  echo "Sorry,Not Permit User!"
  exit 1
fi
ALLLOG="/var/log/squidcheckall_`date '+%Y%m%d'`.log.gz"
FLAG=0

dpkg -l squidclient | grep ^ii > /dev/null || FLAG=1
test -f "$ALLLOG" && chmod 600 "$ALLLOG"
touch "$ALLLOG" || FLAG=2

if [ "$FLAG" -ne "0" ];then
  echo "squidclient : Error Status $FLAG"
  exit 1
fi

squidclient mgr:menu | grep "public" | awk '{print $1}' | \
  for list in `xargs`;do
    echo -e "\n[${list}]\n"
    for n in `seq 1 80`;do echo -n "-" ;done
    echo ""
    squidclient mgr:${list}
  done | gzip > "$ALLLOG"
chmod 400 "$ALLLOG"

echo "See Log : `zcat ${ALLLOG} | wc -l` lines"
echo "lv -s ${ALLLOG}"
unset ALLLOG FLAG
exit 0
