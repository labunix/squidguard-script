#!/bin/bash

# Chenge user name and group name.

LOCALUSER=root
LOCALGROUP=root

TARGETDB=/var/lib/squidguard/db
MYHOME=`su $LOCALUSER -c 'echo $HOME'`
OUTFILE="${MYHOME}/squidguard_mydb_`date '+%Y%m%d_%H%M'`.tar"

if [ "`id -u`" -ne "0" ] ;then
  echo "Sorry, Not Permit User!"
  exit 1
fi

find "$TARGETDB" -type d \( -name "whitelist" -o -name "personal" \) -print | \
  tar cvf "$OUTFILE" `xargs`
test -f ${MYHOME}/squid_blacklists_updates.sh && tar rvf "$OUTFILE" ${MYHOME}/squid_blacklists_updates.sh
test -f "$OUTFILE" && gzip "$OUTFILE"
test -f "${OUTFILE}.gz" && chown $LOCALUSER:$LOCALGROUP "${OUTFILE}.gz"

unset OUTFILE MYHOME LOCALGROUP LOCALUSER TARGETDB
