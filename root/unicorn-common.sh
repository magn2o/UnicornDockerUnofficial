#!/bin/bash

CONT_CONF_FILE="/unicorn_version.txt"

function addVarToConf {
  local variable="$1"
  local value="$2"
  if [ ! -z "${variable}" ]; then
    echo ${variable}=${value} >> ${CONT_CONF_FILE}
  fi
}

function readVarFromConf {
  local variable="$1"
  declare -n value=$2
  if [ ! -z "${variable}" ]; then
    value="$(grep -w ${variable} ${CONT_CONF_FILE} | cut -d'=' -f2 | tail -n 1)"
  else
    value=NULL
  fi
}

function getVersionInfo {
  local repo="$1"
  declare -n remoteVersion=$2
  declare -n remoteFile=$3

  local versionInfo=$(git ls-remote --tags https://github.com/UnicornTranscoder/${repo}.git | sed -nE 's#.*refs/tags/(v?[0-9]+(\.[0-9]+)*)$#\1#p' | sort -Vr | head -n 1)

  remoteVersion="${versionInfo}"
  remoteFile="${repo}/archive/${versionInfo}.tar.gz"
}


function installFromUrl {
  installFromRawUrl "https://github.com/UnicornTranscoder/${1}"
}

function installFromRawUrl {
  local remoteFile="$1"
  local repo=$(echo "${remoteFile}" | cut -d'/' -f5)
  curl -J -L -o "/tmp/${repo}.tgz" "${remoteFile}"
  local last=$?

  # test if deb file size is ok, or if download failed
  if [[ "$last" -gt "0" ]] || [[ $(stat -c %s "/tmp/${repo}.tgz") -lt 9 ]]; then
    echo "Failed to fetch update"
    exit 1
  fi

  mkdir -p "/opt/${repo}" && tar xzf "/tmp/${repo}.tgz" --strip-components 1 -C "/opt/${repo}"
  rm -f "/tmp/${repo}.tgz"

  npm install --prefix="/opt/${repo}" 
  addVarToConf "${repo}_version" "${remoteVersion}"
}
