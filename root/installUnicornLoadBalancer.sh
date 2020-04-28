#!/bin/bash

. /unicorn-common.sh

getVersionInfo "UnicornLoadBalancer" remoteVersion remoteFile

if [ -z "${remoteVersion}" ] || [ -z "${remoteFile}" ]; then
  echo "Could not get install version"
  exit 1
fi

echo "Attempting to install: ${remoteVersion}"
installFromUrl "${remoteFile}"
