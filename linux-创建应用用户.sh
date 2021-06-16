#!/bin/bash
user_name=ifsp
mkdir /home/ap
useradd -d /home/ap/${user_name} ${user_name}
### 为$user_name修改密码
echo "ifsp@yqd0907" | passwd --stdin ${user_name}
chmod 755 /home/ap/${user_name}
### 使用chage保持账户不过期
chage -M 99999 ${user_name}

