#!/usr/bin/env bash
#set -x
SOURCE_DIR="$(dirname "$(readlink -f "$0")")"
echo $SOURCE_DIR
source ${SOURCE_DIR}/arrays.sh
source ${SOURCE_DIR}/colors.sh

do_hosts() {
  for host in "${hosts[@]}"
  do
    OUT=${SOURCE_DIR}/motd/${host}
    echo ${RED} > ${OUT}
    figlet ${host} >> ${OUT}
    echo ${NONE} >> ${OUT}
  done
}

do_hosts
