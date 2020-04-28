#!/bin/bash

. /unicorn-common.sh

getVersionInfo "UnicornFFMPEG" remoteVersion remoteFile

if [ -z "${remoteVersion}" ] || [ -z "${remoteFile}" ]; then
  echo "Could not get install version"
  exit 1
fi

echo "Attempting to install: ${remoteVersion}"
installFromUrl "${remoteFile}"
npm start --prefix=/opt/UnicornFFMPEG

[ -f "/usr/lib/plexmediaserver/Plex Transcoder" ] && rm -f "/usr/lib/plexmediaserver/Plex Transcoder"
cp -f "/opt/UnicornFFMPEG/bin/Plex Transcoder-linux" "/usr/lib/plexmediaserver/Plex Transcoder"
