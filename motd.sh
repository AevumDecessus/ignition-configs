#!/usr/bin/env bash
#set -x
SOURCE_DIR="$(dirname "$(readlink -f "$0")")"
echo $SOURCE_DIR
source ${SOURCE_DIR}/arrays.sh
source ${SOURCE_DIR}/colors.sh

make_dirs() {
  mkdir -p ${SOURCE_DIR}/motd
  mkdir -p ${SOURCE_DIR}/butane/motd
  mkdir -p ${SOURCE_DIR}/ignition/motd
}
do_hosts() {
  for HOST in "${hosts[@]}"
  do
    OUT=${SOURCE_DIR}/motd/${HOST}
    #echo ${RED} > ${OUT}
    figlet ${HOST} > ${OUT}
    #echo ${NONE} >> ${OUT}
    output_butane
  done
}

output_butane() {
  cat << EOF > ${SOURCE_DIR}/butane/motd/${HOST}.bu
variant: fcos
version: 1.5.0
storage:
  files:
    - path: /etc/motd.d/00-figlet.conf
      contents:
        source: https://raw.githubusercontent.com/AevumDecessus/ignition-configs/main/motd/$HOST
      mode: 0644
    - path: /etc/issue.d/00_figlet.issue
      contents:
        source: https://raw.githubusercontent.com/AevumDecessus/ignition-configs/main/motd/$HOST
      mode: 0644
EOF
}

make_dirs
do_hosts
