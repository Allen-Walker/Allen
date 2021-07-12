#!/bin/bash

yum -y install nfs-utils
### 挂载NAS
mkdir -p /home/ap/nas;
chmod 777 /home/ap/nas;
### 下面配置信息根据实际修改，开机自动挂载nas只能写入 /etc/rc.d/rc.local
mount -t nfs -o vers=3,nolock,proto=tcp 192.168.12.14:/vyjyimm5 /home/ap/nas
chmod +x /etc/rc.d/rc.local
echo "mount -t nfs -o vers=3,nolock,proto=tcp 192.168.12.14:/vyjyimm5 /home/ap/nas" >> /etc/rc.d/rc.local


### NAS是NFS服务器，我们需要有能访问这个NFS服务器的网络环境，需要在对应子网中添加这个服务器的出入站规则，设置安全组。网络环境的验证使用 ** telnet ** 工具，默认端口号是2049。具体可以查看共有云上的帮助文档。
### 除了网络环境，我还需要在机器上挂载NAS，并设置NAS重启自动挂载，即向 ** rc.local文件 ** 中写入自动挂载NAS命令，同时 rc.local必须要有 ** 可执行的权限 ** ，否则机子重启也不会自动挂载。
### !! 注：挂载之前需要安装nfs-utils，执行命令：yum -y install nfs-utils
