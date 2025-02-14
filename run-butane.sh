#!/usr/bin/env bash
#set -x
SOURCE_DIR="$(dirname "$(readlink -f "$0")")"
echo $SOURCE_DIR
source ${SOURCE_DIR}/arrays.sh

END=""

find_end() {
  if [[ ${FILE} == ./* ]]; then 
  {
    FILE="${FILE:2}"
  }
  fi
    END=`echo ${FILE} | cut -d"/" -f2- | rev | cut -d"." -f2- | rev`
}

do_merge() {
  for m in "${merge[@]}"
  do
    echo "${m}"
    FILE=${m}
    process_file
  done
}

do_hosts() {
  for host in "${hosts[@]}"
  do
    echo "host docker-${host}.home.0n5.us"
    FILE="butane/motd/${host}.bu"
    process_file
    FILE="butane/docker-${host}.home.0n5.us.bu"
    process_file
  done
}

do_mounts() {
  for mount in "${mounts[@]}"
  do
    echo "mount ${mount}"
    FILE="butane/mounts/${mount}.bu"
    process_file
  done
}

do_docker_mounts() {
  for mount in "${docker[@]}"
  do
    echo "docker mount ${mount}"
    FILE="butane/mounts/docker/${mount}.bu"
    process_file
  done
}
process_file() {
  find_end
  if [ ! -f "butane/${END}.bu" ]; then
    echo "butane/${END}.bu does not exist"
    exit 1
  fi
  $(docker run --rm --interactive         \
     --security-opt label=disable          \
     --volume "${PWD}":/config             \
     --workdir /config                     \
     quay.io/coreos/butane:release         \
     --files-dir /config                   \
     --strict --pretty                     \
     butane/${END}.bu > ignition/${END}.ign)
}

process_all() {
  do_mounts
  do_docker_mounts
  do_merge
  do_hosts
}
FILE=$1
if [ ${FILE} == "all" ]; then {
  process_all
}
elif [ ${FILE} == "merge" ]; then {
  do_merge
}
elif [ ${FILE} == "hosts" ]; then {
  do_hosts
}
elif [ ${FILE} == "mounts" ]; then {
  do_mounts
  do_docker_mounts
}
else {
  process_file
}
fi
