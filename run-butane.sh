#!/usr/bin/env bash
#set -x
declare -a merge=("butane/common/merge.bu" "butane/common/merge_no_packages.bu" "butane/ucore/merge-ucore.bu" "butane/nvidia/merge-nvidia.bu")
declare -a hosts=("apps" "books" "db" "downloads" "lead1" "lead2" "misc" "network" "network2" "plex" "secure" "web")
declare -a mounts=("3d_models" "anime" "anime_movies" "audiobooks" "audiobooks_unsorted" "calibre" "cartoons" "comics" "documentary_films" "documentary_series" "downloads" "kids_tv" "live_media" "movies_4k" "movies" "music" "plex_meta" "sabnzbd" "tv_4k" "tv")

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
process_file() {
  find_end
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
  do_merge
  do_mounts
  do_hosts
}
FILE=$1
if [ ${FILE} == "all" ]; then {
  process_all
}
else {
  process_file
}
fi
