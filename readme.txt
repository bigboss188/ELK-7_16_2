最新ELK 7.16.2 一键安装的破解白金版本

#解压
unzip elk-7.16.2.zip

#进入目录，执行安装程序
cd elk-7.16.2
chmod 755 install.sh
./install.sh 


注：
1.需要使用非root账号安装
2.需要先修改最大打开文件数、进程数、虚拟内存数，参考文章：
https://www.cnblogs.com/zhi-leaf/p/8484337.html

A.修改/etc/security/limits.conf文件
* soft nofile 65536
* hard nofile 65536
* soft nproc 4096
* hard nproc 4096
重新登录后生效

B.修改/etc/sysctl.conf文件，增加配置vm.max_map_count=262144
执行命令sysctl -p生效