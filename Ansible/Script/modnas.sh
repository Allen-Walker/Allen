#!/bin/bash

nassign="[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}:/"
naslist=`mount -l |grep -E ${nassign} | awk '{print $1","$3}'`

if [ x == x"${naslist}" ];then
   echo 'nas is not mounting'
   exit 1
fi 

timestamp=`date +"%Y%m%d%H%M%S"`
cp /etc/profile /etc/profile_bak${timestamp}
cp /etc/fstab /etc/fstab_bak${timestamp}
cp /etc/rc.d/rc.local /etc/rc.d/rc.local_bak${timestamp}

for nas in ${naslist}
do
  cfsserver=`echo ${nas} | awk -F"," '{print $1}'`
  cfsserver1=$(echo ${cfsserver} | sed 's/\//\\\//g')
  localdir=`echo ${nas} | awk -F"," '{print $2}'`
 
  echo "remote nas server is "${cfsserver}, "mounting localdir is "${localdir}
  # echo "mount -t nfs -o vers=3,nolock,proto=tcp,noresvport ${cfsserver} ${localdir}"
  # exit 0
  
  grep ${cfsserver1} /etc/profile >> /dev/null
  if [ x0 == x"$?" ];then
    sed -i "/${cfsserver1}/"d /etc/profile
  fi

  grep ${cfsserver1} /etc/fstab >> /dev/null
  if [ x0 == x"$?" ];then
    sed -i "/${cfsserver1}/"d /etc/fstab
  fi

  ### mounting
  chmod +x /etc/rc.d/rc.local

  mount -l | grep ${cfsserver} | grep "mountvers=3" > /dev/null
  if [ x0 == x$? ];then
    sed -i "/${cfsserver1}/"d /etc/rc.d/rc.local
    mount -t nfs -o vers=3,nolock,proto=tcp,noresvport ${cfsserver} ${localdir}
    echo "mount -t nfs -o vers=3,nolock,proto=tcp,noresvport ${cfsserver} ${localdir}" >> /etc/rc.d/rc.local
  else
    sed -i "/${cfsserver1}/"d /etc/rc.d/rc.local
    mount -t nfs -o vers=4.0,noresvport ${cfsserver} ${localdir}
    echo "mount -t nfs -o vers=4.0,noresvport ${cfsserver} ${localdir}" >> /etc/rc.d/rc.local
  fi

done

