#!/bin/sh
#
# Install Resilio Sync, set config path. This script can also be run to update
# rslsync.
#
# Also available in a convenient Google Doc:
# https://docs.google.com/document/d/1LSr3J6hdnCDQHfiH45K3HMvEqzbug7GeUeDa_6b_Hhc
#
# Jacob McDonald
# Revision 171023a-yottabit
#
# Licensed under BSD-3-Clause, the Modified BSD License

configDir=$(dialog --no-lines --stdout --inputbox "Persistent storage is:" 0 0 \
"/config") || exit

if [ -d "$configDir" ] ; then
  echo "$configDir exists, like a boss!"
else
  echo "$configDir does not exist, so exiting (you might want to link a dataset)."
  exit
fi

/usr/sbin/pkg update || exit
/usr/sbin/pkg upgrade --yes || exit
/usr/sbin/pkg install --yes wget || exit
/usr/sbin/pkg clean --yes || exit

echo "Killing rslsync in case it is running."
/usr/bin/killall -d rslsync && sleep 10
/usr/bin/killall -d -9 rslsync

/usr/local/bin/wget "https://download-cdn.resilio.com/stable/FreeBSD-x64/resilio-sync_freebsd_x64.tar.gz" \
|| exit
/usr/bin/tar xvzf resilio-sync_freebsd_x64.tar.gz || exit

[ ! -d "$configDir/.sync" ] && mkdir -p "$configDir/.sync"

echo "Checking for $configDir/sync.conf."
if [ ! -f "$configDir/sync.conf" ] ; then
  echo "$configDir/sync.conf does not exist, so creating."
  "$configDir/rslsync" --dump-sample-config > "$configDir/sync.conf" || exit
  sed -i "" -e "s~// \"storage_path\" : \"/home/user/.sync\",~\"storage_path\" : \"$configDir/.sync\"~" \
"$configDir/sync.conf" || exit
else
  echo "$configDir/sync.conf found."
fi

echo "Checking suitability of /etc/rc.local."
[ ! -f "/etc/rc.local" ] && touch "/etc/rc.local" && chmod 755 "/etc/rc.local"

echo "Adding to /etc/rc.local."
if grep rslsync "/etc/rc.local"; then
  true
else
  echo "\"$configDir/rslsync\" --config \"$configDir/sync.conf\"" \
  >> "/etc/rc.local" || exit
fi

echo "Starting /etc/rc.local."
/etc/rc.local
