#!/bin/bash
<<INFO
PROJECT: 智能补丁使用和管理
Author: wangguangge
Date: 2023-09-14
EC_S: TaiShan-200 | openEuler-22.03-LTS aarch64
INFO

wget $file_system/openEuler.repo
cp openEuler.repo /etc/yum.repos.d/ -y

# 客户端服务部署
# 部署aops-ceres
yum install aops-ceres -y
# 部署dnf-hotpatch-plugin
dnf install dnf-hotpatch-plugin -y
# 部署syscare
dnf install syscare-build -y
dnf install syscare -y

# clean 
echo > /root/.bash_history
history -c
