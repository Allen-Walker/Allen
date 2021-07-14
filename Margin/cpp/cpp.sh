#!/bin/bash

### 不同环境需要配置以下变量的路径，配合packages_list文件列表使用。
### 程序根据packages_list，从war_dir,jar_dir,zhfc_dir,subzhfc_dir取
### 对应的包，放置在collect_dir路径。

function get_ss_exec_dir(){
  SOURCE="${BASH_SOURCE[0]}"
  # resolve $SOURCE until the file is no longer a symlink
  while [ -h "$SOURCE" ]; do 
    DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" 
  done
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null && pwd )"
  echo "${DIR}/"
}

function dosomething(){
  collect_dir=$3
  cd $1 > /dev/null
  if [ $? == "0" ]
  then
    echo "fullname: $2"
    echo "拷贝包 $2"
    
    fn=$2
    if [[ ${fn##*.} != "jar" && ${fn##*.} != "war" ]]
    then
      zip -r ${fn}.zip $fn
      if [ $? != "0" ]
      then
        echo "zip error"
        return 1
      fi
      mv ${fn}.zip ${collect_dir}
      return 0
    fi
    
    cp ${fn} ${collect_dir}/${fn}
  else
    echo "$1 目录不存在"
  fi
}

base_dir=`get_ss_exec_dir`
f_filelist="${base_dir}/packages_list"
filelist=`cat ${f_filelist}`
war_dir="${base_dir}/app/war"
jar_dir="${base_dir}/app/jar"
subzhfc_dir="${base_dir}/app/subzhfc"
zhfc_dir="${base_dir}/app/zhfc"
collect_dir=$1

for f in ${filelist}
do
  ### 拷贝前端包
  if [[ ${f%.*} == ${f##*.} && ${f##*.} != "jar" && ${f##*.} != "war" ]]
  then
    echo $f | grep -E "^sub" > /dev/null
    if [ $? == "0" ]
    then
      dosomething ${subzhfc_dir} ${f%.*} ${collect_dir}
    else
      dosomething ${zhfc_dir} ${f%.*} ${collect_dir}
    fi

  elif [ ${f##*.} == "war" ]
  then
    dosomething ${war_dir} ${f%.*}.${f##*.} ${collect_dir}

  elif [ ${f##*.} == "jar" ]
  then
    dosomething ${jar_dir} ${f%.*}.${f##*.} ${collect_dir}

  fi
done
  
