#!/bin/bash
/usr/bin/expect <<-EOF
set time 30
spawn fdisk /dev/vdb
expect "*#"
expect -exact "Command (m for help):"
send -- "n\r"
expect -exact "Select (default p):"
send -- "p\r"
expect -exact "Partition number (1-4, default 1):"
send -- "1\r"
expect -exact "First sector"
send -- "\r"
expect -exact "Last sector, +sectors or +size{K,M,G}"
send -- "\r"
expect -exact "Command (m for help):"
send -- "wq\r"
expect "*#"
interact
expect eof
EOF