#!/bin/bash

devuser=devuser

tstamp=`date '+%Y%m%d%H%M%S'`

work_base_dir="/home/${devuser}/backup_work"
work_dir="${work_base_dir}/${tstamp}"

backup_dev_dir="/home/${devuser}/backup/dev"
backup_db_dir="/home/${devuser}/backup/db"

archive_file="${tstamp}.tar.gz"
archive_num=30

script_failed() {
  echo "ERROR : Script failed."
  exit 1
}

dump_git() {
  echo "START : dump_git $1 $2"
  repository=$1
  file_name=$2
  git clone --bare ${repository}
  pushd ${file_name}
  git bundle create ../${file_name}.backup --all || script_failed
  popd
  rm -rf ${file_name}
  echo "END : dump_git"
  return 0
}

dump_dir() {
  echo "START : dump_dir $1 $2"
  file_name=$1
  backup_file_name=$2
  cp -pr ${file_name} ./${backup_file_name} || script_failed
  echo "END : dump_dir"
  return 0
}

dump_mysql() {
  echo "START : dump_mysql $1"
  file_name=$1
  user=$2
  mysqldump --opt --all-databases --default-character-set=binary -u ${user} > ${file_name} || script_failed
  echo "END : dump_mysql"
  return 0
}

truncate_archive() {
  echo "START : truncate_archive $1"
  backup_dir=$1
  archive_count=`ls -trF1 ${backup_dir} | grep -v / | grep -v '_' | wc -l`
  if [ ${archive_count} -gt ${archive_num} ]; then
    del_num=`expr ${archive_count} - ${archive_num}`
    archives=`ls -trF1 ${backup_dir} | grep -v / | grep -v '_' | head -n ${del_num}`
    for del_archive in ${archives}
    do
      rm -rf ${backup_dir}/${del_archive}
    done
  fi
  echo "END : truncate_archive"
  return 0
}

rsync_backup() {
  echo "START : rsync_backup $1 $2 $3"
  remote_port=$1
  src_dir=$2
  dest_dir=$3
  /usr/bin/rsync -auz --delete -e "ssh -p ${remote_port}" ${src_dir} ${dest_dir} || script_failed
  echo "END : rsync_backup"
  return 0
}

