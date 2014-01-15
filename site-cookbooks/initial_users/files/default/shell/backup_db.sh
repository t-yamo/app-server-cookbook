#!/bin/bash

. ./backup_function.sh

rm -rf ${work_base_dir}
mkdir -p ${work_dir}

if [ ! -d ${backup_db_dir} ]; then
  mkdir -p ${backup_db_dir}
fi

pushd ${work_dir}

dump_dir /exports exports || script_failed
dump_mysql all_databases.sql root || script_failed

pushd ${work_base_dir}
tar cvfz ${backup_db_dir}/${archive_file} ${tstamp} || script_failed
popd

truncate_archive ${backup_db_dir} || script_failed
rsync_backup 22 ${backup_db_dir} dev01:${backup_db_dir} || script_failed

popd

