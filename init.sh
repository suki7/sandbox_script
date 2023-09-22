#!/bin/bash
<<INFO
PROJECT: 智能补丁使用和管理
Author: wangguangge
Date: 2023-09-14
EC_S: TaiShan-200 | openEuler-22.03-LTS aarch64
INFO

#parameter: 系统变量
file_system='http://21.21.0.211/sandbox/A230920723'
#file_system=/root/sandbox_files
password=$1
ip1=$3
ip2=$5

# password: 记录服务器密码
echo "password: $password" >> /root/info.txt

mkdir /root/experiment_files -p
cd /root/experiment_files

# init
wget ${file_system}/firewall_config.sh
chmod 755 firewall_config.sh
bash firewall_config.sh

# 实验课程初始化

wget ${file_system}/openEuler.repo
cp openEuler.repo /etc/yum.repos.d/ -f

# 服务端服务配置
# 部署mysql
yum install mysql-server -y
wget ${file_system}/my.cnf
sed -i "s/target_ip/${ip1}/g" my.cnf
cp my.cnf /etc/my.cnf -f
systemctl restart mysqld
mysql<<EOF
show databases;
use mysql;
select user,host from user;
update user set host = '%' where user='root';
flush privileges;
create database aops default character set utf8mb4 collate utf8mb4_unicode_ci;
exit;
EOF
# 部署redis
yum install redis -y
wget ${file_system}/redis.conf
sed -i "s/target_ip/${ip1}/g" redis.conf
cp redis.conf /etc/redis.conf -f
systemctl start redis

# 部署aops-zeus
yum install aops-zeus
wget ${file_system}/zeus.ini
sed -i "s/target_ip/${ip1}/g" zeus.ini
cp zeus.ini /etc/aops/zeus.ini -f
systemctl start aops-zeus

# 部署aops-hermes
yum install aops-hermes
wget ${file_system}/aops-nginx.conf
sed -i "s/target_ip/${ip1}/g" aops-nginx.conf
cp aops-nginx.conf /etc/nginx/aops-nginx.conf -f
systemctl start aops-hermes

# 部署elasticsearch
echo "[aops_elasticsearch]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md" > "/etc/yum.repos.d/aops_elascticsearch.repo"
yum install elasticsearch-7.14.0-1
wget ${file_system}/elasticsearch.yml
sed -i "s/target_ip/${ip1}/g" elasticsearch.yml
cp elasticsearch.yml /etc/elasticsearch/elasticsearch.yml -f
systemctl restart elasticsearch

# 部署aops-apollo
yum install aops-apollo
wget ${file_system}/apollo.ini
sed -i "s/target_ip/${ip1}/g" apollo.ini
cp apollo.ini /etc/aops/apollo.ini -f
systemctl start aops-apollo

# 获取热补丁repo源
wget ${file_system}/local_hotpatch
mkdir /root/tmp/ -p
cp -r local_hotpatch /root/tmp/ -f

# 远程到另一台机器进行初始化
sshpass -f /root/password ssh root@$ip2 -o StrictHostKeyChecking=no wget ${file_system}/ init_sub.sh
sshpass -f /root/password ssh root@$ip2 bash init_sub.sh

# ttylogger：记录用户输入和输出
cd /opt
mkdir -p /root/.sandbox/log
wget $file_system/ttylogger
mv ttylogger /usr/bin/
chmod 755 /usr/bin/ttylogger
echo 'pid=`ps | grep bash | sed -n "1p" | awk' "'{print \$1}'\`" >> /root/.bash_profile
echo '(set -m ttylogger $pid 2>&1 >/root/.sandbox/log/$pid &)' >> /root/.bash_profile

# 安装桌面系统
cd /opt
wget http://21.21.0.211/sandbox/desktop/init.sh 
chmod 755 
bash init.sh 
rm -rf init.sh

# Progress：实验进度脚本
cd /root/.sandbox
wget $file_system/progress.sh
nohup bash progress.sh $ip2 >/dev/null 2>&1 &

# result：返回结果
echo "init success 0"

# clean：清理环境
echo > /root/.bash_history
history -c



