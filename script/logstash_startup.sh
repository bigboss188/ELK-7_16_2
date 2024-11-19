#!/bin/bash
dir_base=$(cd `dirname $0`; pwd)
cd ${dir_base}
bin_name=$(ls logstash)
if [ $(pgrep -f ${bin_name} | wc -l) -gt 0 ]; then
  pkill -9 -f ${dir_base}/${bin_name}
  echo "kill ${dir_base}/${bin_name}"
fi
echo ${dir_base}/${bin_name}
nohup ${dir_base}/${bin_name} -f ${dir_base}/../config/log-client.conf >/dev/null 2>&1 &
sleep 2
echo "ok!"
