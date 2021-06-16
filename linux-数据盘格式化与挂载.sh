#!/bin/bash

mkfs.ext3 /dev/vdb;
mkdir -p /home/ap;
mount /dev/vdb /home/ap;
echo '/dev/vdb /home/ap ext3 defaults 0 0' >> /etc/fstab;