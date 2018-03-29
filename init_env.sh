#!/bin/sh
yum install -y wget lrzsz 
#添加bcdigger用户并设置密码
useradd bcdigger
echo bcdigger123 | passwd bcdigger --stdin &>/dev/null

#替换国内yum镜像源
cd /etc/yum.repos.d/
mkdir repo_bak
mv *.repo repo_bak
wget http://mirrors.aliyun.com/repo/Centos-7.repo
wget http://mirrors.163.com/.help/CentOS7-Base-163.repo
yum clean all
yum makecache
#安装epel源，下载阿里开源镜像的epel源文件
yum install -y epel-release
wget -O /etc/yum.repos.d/epel-7.repo http://mirrors.aliyun.com/repo/epel-7.repo
yum clean all
yum makecache

#安装docker-ce
curl -sSL https://get.daocloud.io/docker | sh
usermod -aG docker bcdigger
#启动docker
systemctl start docker.service
#开机启动docker
systemctl enable docker

#docker-compose安装（在github上找docker-compose，release中找）
curl -L https://github.com/docker/compose/releases/download/1.20.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

#安装git，并下载git项目
yum install -y git

#创建软件路径
cd /home/bcdigger
git clone https://github.com/yookien/bcdigger-docker-single-env.git

cd bcdigger-docker-single-env