#!/bin/bash

nassign="[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}:/"
cfsserver=`mount -l |grep -E ${nassign} | awk '{print $1}'`
cfsserver1=$(echo ${cfsserver} | sed 's/\//\\\//g')
localdir=`mount -l |grep -E ${nassign} |awk '{print $3}'`

if [ x == x${cfsserver} ] || [ x == x${localdir} ];then
   echo 'nas is not mounting'
   exit 1
fi 

echo "remote nas server is "${cfsserver}, "mounting localdir is "${localdir}
# echo "mount -t nfs -o vers=3,nolock,proto=tcp,noresvport ${cfsserver} ${localdir}"
# exit 0

timestamp=`date +"%Y%m%d%H%M%S"`
grep ${cfsserver1} /etc/profile >> /dev/null
if [ x0 == x$? ];then
  cp /etc/profile /etc/profile_bak${timestamp}
  sed -i "/${cfsserver1}/"d /etc/profile
fi

grep ${cfsserver1} /etc/fstab >> /dev/null
if [ x0 == x$? ];then
  cp /etc/fstab /etc/fstab_bak${timestamp}
  sed -i "/${cfsserver1}/"d /etc/fstab
fi

### mounting
chmod +x /etc/rc.d/rc.local

cp /etc/rc.d/rc.local /etc/rc.d/rc.local_bak${timestamp}
mount -l | grep -E ${nassign} | grep "mountvers=3" > /dev/null
if [ x0 == x$? ];then
  sed -i "/${cfsserver1}/"d /etc/rc.d/rc.local
  mount -t nfs -o vers=3,nolock,proto=tcp,noresvport ${cfsserver} ${localdir}
  echo "mount -t nfs -o vers=3,nolock,proto=tcp,noresvport ${cfsserver} ${localdir}" >> /etc/rc.d/rc.local
else
  sed -i "/${cfsserver1}/"d /etc/rc.d/rc.local
  mount -t nfs -o vers=4.0,noresvport ${cfsserver} ${localdir}
  echo "mount -t nfs -o vers=4.0,noresvport ${cfsserver} ${localdir}" >> /etc/rc.d/rc.local
fi


