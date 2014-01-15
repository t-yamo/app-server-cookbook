#!/bin/bash

. ./backup_function.sh

rm -rf ${work_base_dir}
mkdir -p ${work_dir}

if [ ! -d ${backup_dev_dir} ]; then
  mkdir -p ${backup_dev_dir}
fi

pushd ${work_dir}

### PREASE ADD SOME REPOSITORIES HERE. ###
dump_git gitolite@localhost:gitolite-admin.git gitolite-admin.git || script_failed
dump_mysql all_databases.sql root || script_failed

pushd ${work_base_dir}
tar cvfz ${backup_dev_dir}/${archive_file} ${tstamp} || script_failed
popd

truncate_archive ${backup_dev_dir} || script_failed
rsync_backup 22 ${backup_dev_dir} db01:${backup_dev_dir} || script_failed

popd

