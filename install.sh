#! /bin/bash
ELASTICSEARCH_PATH=elasticsearch-7.16.2-linux-x86_64.tar.gz
LOGSTASH_PATH=logstash-7.16.2-linux-x86_64.tar.gz
KIBANA_PATH=kibana-7.16.2-linux-x86_64.tar.gz
PATCH_XPACK_PATH=patch/x-pack-core-7.16.2.jar

ELASTICSEARCH_NAME=elasticsearch-7.16.2
LOGSTASH_NAME=logstash-7.16.2
KIBANA_NAME=kibana-7.16.2
XPACK_NAME=x-pack-core-7.16.2.jar

LICENSE_DATA='{"license": { "uid":"537c5c48-c1dd-43ea-ab69-68d209d80c32", "type":"platinum", "issue_date_in_millis":1558051200000, "expiry_date_in_millis":2524579200999, "max_nodes":1000, "issued_to":"pyker", "issuer":"Web Form", "signature":"AAAAAwAAAA3fIq7NLN3Blk2olVjbAAABmC9ZN0hjZDBGYnVyRXpCOW5Bb3FjZDAxOWpSbTVoMVZwUzRxVk1PSmkxaktJRVl5MUYvUWh3bHZVUTllbXNPbzBUemtnbWpBbmlWRmRZb25KNFlBR2x0TXc2K2p1Y1VtMG1UQU9TRGZVSGRwaEJGUjE3bXd3LzRqZ05iLzRteWFNekdxRGpIYlFwYkJiNUs0U1hTVlJKNVlXekMrSlVUdFIvV0FNeWdOYnlESDc3MWhlY3hSQmdKSjJ2ZTcvYlBFOHhPQlV3ZHdDQ0tHcG5uOElCaDJ4K1hob29xSG85N0kvTWV3THhlQk9NL01VMFRjNDZpZEVXeUtUMXIyMlIveFpJUkk2WUdveEZaME9XWitGUi9WNTZVQW1FMG1DenhZU0ZmeXlZakVEMjZFT2NvOWxpZGlqVmlHNC8rWVVUYzMwRGVySHpIdURzKzFiRDl4TmM1TUp2VTBOUlJZUlAyV0ZVL2kvVk10L0NsbXNFYVZwT3NSU082dFNNa2prQ0ZsclZ4NTltbU1CVE5lR09Bck93V2J1Y3c9PQAAAQCjNd8mwy8B1sm9rGrgTmN2Gjm/lxqfnTEpTc+HOEmAgwQ7Q1Ye/FSGVNIU/enZ5cqSzWS2mY8oZ7FM/7UPKVQ4hkarWn2qye964MW+cux54h7dqxlSB19fG0ZJOJZxxwVxxi8iyJPUSQBa+QN8m7TFkK2kVmP+HnhU7mGUrqXt3zTk5d3pZw3QBQ/Rr3wmSYC5pxV6/o2UHFgu1OPDcX+kEb+UZtMrVNneR+cEwyx7o5Bg3rbKC014T+lMtt69Y080JDI5KfHa7e9Ul0c3rozIL975fP45dU175D4PKZy98cvHJgtsCJF3K8XUZKo2lOcbsWzhK2mZ5kFp0BMXF3Hs", "start_date_in_millis":1558051200000 } }'

# 检查文件是否存在
checkFile(){
  file=$1
  if [ ! -f "${file}" ];then
    echo "开始下载${file}"
    return 0
  else
    return 1
  fi
}

echo -e "开始检查文件是否齐全......\c"
# 检查文件
checkFile ${ELASTICSEARCH_PATH}
if [ $? == 0 ];then
  wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.16.2-linux-x86_64.tar.gz
fi
checkFile ${LOGSTASH_PATH}
if [ $? == 0 ];then
  wget https://artifacts.elastic.co/downloads/logstash/logstash-7.16.2-linux-x86_64.tar.gz
fi
checkFile ${KIBANA_PATH}
if [ $? == 0 ];then
  wget https://artifacts.elastic.co/downloads/kibana/kibana-7.16.2-linux-x86_64.tar.gz
fi
checkFile ${PATCH_XPACK_PATH}
if [ $? == 0 ];then
  exit 1
fi
echo "完成"

# 检查当前用户是否为非root
echo -e "检查当前用户类型......\c"
user=$(env | grep USER | cut -d "=" -f 2)
if [ "${user}" == "root" ];then
  echo "请使用非root用户安装"
  exit 1
fi
echo "完成"

# 检查打开文件数
echo -e "检查最大打开文件数......\c"
ulimit=$(ulimit -Hn)
if [ $ulimit -lt 65536 ];then
  echo "异常"
  echo "当前用户的打开文件数小于65536[${ulimit}]，请使用root修改 /etc/security/limits.conf 文件，并重新登录"
  exit 1
fi
ulimit=$(ulimit -Sn)
if [ $ulimit -lt 65536 ];then
  echo "异常"
  echo "当前用户的打开文件数小于65536[${ulimit}]，请使用root修改 /etc/security/limits.conf 文件，并重新登录"
  exit 1
fi
echo "完成"

# 检查线程个数
echo -e "检查最大线程个数......\c"
ulimit=$(ulimit -Hu)
if [ $ulimit -lt 4096 ];then
  echo "异常"
  echo "当前用户的最大线程个数小于4096[${ulimit}]，请使用root修改 /etc/security/limits.conf 文件，并重新登录"
  exit 1
fi
ulimit=$(ulimit -Su)
if [ $ulimit -lt 4096 ];then
  echo "异常"
  echo "当前用户的最大线程个数小于4096[${ulimit}]，请使用root修改 /etc/security/limits.conf 文件，并重新登录"
  exit 1
fi
echo "完成"

# 检查最大虚拟内存
echo -e "检查最大虚拟内存......\c"
vmmax=$(sysctl -n vm.max_map_count)
if [ $vmmax -lt 262144 ];then
  echo "异常"
  echo "当前用户的最大虚拟内存小于262144[${vmmax}]，请使用root修改 /etc/sysctl.conf 文件，并执行命令sysctl -p生效"
  exit 1
fi
echo "完成"

# 输入安装目录
enterInstallPath(){
  read -p "请输入安装目录:" install_path
  if [ "${install_path}" == "" ] ;then
    enterInstallPath
  else
    echo "${install_path}"
  fi
}

INSTALL_PATH=$(enterInstallPath)
echo "执行安装目录${INSTALL_PATH}"

# 创建目录
mkdir -p ${INSTALL_PATH}

# 复制和解压
echo -e "复制文件......"
cp ${ELASTICSEARCH_PATH} ${INSTALL_PATH}/${ELASTICSEARCH_NAME}.tar.gz
cp ${LOGSTASH_PATH} ${INSTALL_PATH}/${LOGSTASH_NAME}.tar.gz
cp ${KIBANA_PATH} ${INSTALL_PATH}/${KIBANA_NAME}.tar.gz

cp -rf config ${INSTALL_PATH}/config
cp -rf script ${INSTALL_PATH}/script
cp -rf patch ${INSTALL_PATH}/patch
echo "完成"

# 进入安装目录
cd ${INSTALL_PATH}

# 解压
echo "解压${ELASTICSEARCH_NAME}.tar.gz..."
tar -zxvf ${ELASTICSEARCH_NAME}.tar.gz
rm -rf ${ELASTICSEARCH_NAME}.tar.gz

echo "解压${LOGSTASH_NAME}.tar.gz..."
tar -zxvf ${LOGSTASH_NAME}.tar.gz
rm -rf ${LOGSTASH_NAME}.tar.gz

echo "解压${KIBANA_NAME}.tar.gz..."
tar -zxvf ${KIBANA_NAME}.tar.gz
rm -rf ${KIBANA_NAME}.tar.gz
# 注：kibana的命名需要重写修改
mv ${KIBANA_NAME}-* ${KIBANA_NAME}

echo "解压文件......完成"

# 写入配置
echo -e "写入配置......\c"
mv config/${ELASTICSEARCH_NAME}/* ${ELASTICSEARCH_NAME}/config/
mv config/${LOGSTASH_NAME}/* ${LOGSTASH_NAME}/config/
mv config/${KIBANA_NAME}/* ${KIBANA_NAME}/config/

mv script/elasticsearch_startup.sh ${ELASTICSEARCH_NAME}/bin/startup.sh
mv script/logstash_startup.sh ${LOGSTASH_NAME}/bin/startup.sh
mv script/kibana_startup.sh ${KIBANA_NAME}/bin/startup.sh

mv patch/x-pack-core-7.16.2.jar ${ELASTICSEARCH_NAME}/modules/x-pack-core/x-pack-core-7.16.2.jar

rm -rf config/
rm -rf script/
rm -rf patch/

chmod 755 ${ELASTICSEARCH_NAME}/bin/startup.sh
chmod 755 ${LOGSTASH_NAME}/bin/startup.sh
chmod 755 ${KIBANA_NAME}/bin/startup.sh

echo "完成"

# 开始启动服务
echo "启动elasticsearch..."
cd ${INSTALL_PATH}/${ELASTICSEARCH_NAME}/bin
./startup.sh

echo "启动logstash..."
cd ${INSTALL_PATH}/${LOGSTASH_NAME}/bin
./startup.sh

echo "启动kibana..."
cd ${INSTALL_PATH}/${KIBANA_NAME}/bin
./startup.sh

# 监听elasticsearch启动
echo "等待elasticsearch启动..."
CONSOLE_LOG=${INSTALL_PATH}/${ELASTICSEARCH_NAME}/logs/my-es.log
COUNT_LOG=`sed -n '$=' ${CONSOLE_LOG}`
i=1
while [ ${i} -le 500 ]  # 小于500等于时候才执行 
do
  i=`expr ${i} + 1`
  sleep 1  # 休眠1秒再执行检测
  # 判断程序是否已经启动完了
  if [[ $(curl -m 5 -s -o /dev/null -w %{http_code} http://127.0.0.1:9200/info) = 000 ]]
  then
    # 检查日志
    NEW_COUNT_LOG=`sed -n '$=' ${CONSOLE_LOG}`
    if [[ $NEW_COUNT_LOG -gt $COUNT_LOG ]]
    then
      # 打印启动日志
      NEW_ADD_COUNT_LOG=$[NEW_COUNT_LOG-COUNT_LOG]
      tail -n $NEW_ADD_COUNT_LOG ${CONSOLE_LOG}
      # 查找是否有错误
      NEW_LOG=$(tail -n $NEW_ADD_COUNT_LOG ${CONSOLE_LOG})
      FIND_ERROR=$(echo $NEW_LOG | grep "ERROR")
      if [[ "$FIND_ERROR" != "" ]]
      then
        echo "出现异常，请检查！"
  exit 1 
      fi
      COUNT_LOG=$NEW_COUNT_LOG
    fi
  else
    echo "程序已正常运行"
    i=`expr ${i} + 500`  
  fi
done

# 开始进行导入license
cd ${INSTALL_PATH}
echo $LICENSE_DATA > license.json

echo -e "开始导入license......"
curl -XPUT 'http://127.0.0.1:9200/_xpack/license' -H "Content-Type: application/json" -d @license.json
echo "导入完成"
echo "ELK 7.16.2 安装完毕"
