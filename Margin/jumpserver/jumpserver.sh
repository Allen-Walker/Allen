#!/bin/bash

## 获取脚本执行路径
function get_ss_exec_dir(){
  SOURCE="${BASH_SOURCE[0]}"
  while [ -h "$SOURCE" ]; do
    DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
  done
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null && pwd )"
  echo ${DIR}
}


### 判断输入是否在iplist中
function get_server_in_list(){
  server=$1
  for item in `cat ${IP_LIST} | awk -F, '{print $1","$2}' | grep ${server}`
  # for item in `cat ${IP_LIST} | grep ${server}`
  do
    id=`echo ${item} | awk -F, '{print $1}'`
    ip=`echo ${item} | awk -F, '{print $2}'`
    if [[ ${server} == ${id} || ${server} == ${ip} ]]
    then
      echo ${ip}
      return
    fi
  done
  echo "None"
}


function sshlogin(){
  pwd='123456'
  user=$1
  srv=$2
  ./autossh.exp ${pwd} ${user} ${srv}
}


BASE_DIR=`get_ss_exec_dir`
IP_LIST="$BASE_DIR/iplist.csv"

### 打印IP列表
function print_list(){
  cat ${IP_LIST} | awk -F, '{print "|"$1"\t|"$2"\t|"$3"\t|"$4}'
}


### 用户交互
#限制用户登录次数
int=1
while(($int<=5))
do
  let "int++"
  
  print_list
  
  read -p "请输入机器id或者ip，默认登录root，或者第二参数指定登录用户" server user
  
  srv=`get_server_in_list ${server}`
  
  echo $srv
  
  if [[ ${srv} == "None" ]]
  then
    echo "输入目标机器不存在"
    sleep 2
  else
    if [[ ${user} == '' ]]
    then
      sshlogin root ${srv}
    else
      sshlogin ${user} ${srv}
    fi
  fi
done








