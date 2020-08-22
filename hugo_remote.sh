#!/bin/bash

trap ctrl_c INT
function ctrl_c() {
    kill $(ps aux | grep ssh | grep 1313 | awk '{ print $2 }') 2>/dev/null
}

if [ ! -f "hugo" ]; then
    echo "Hugo found, cloning from docker! :)"
    ./copy_hugo_elf.sh
fi

/bin/rm -rf resources
kill $(ps aux | grep ssh | grep 1313 | awk '{ print $2 }') 2>/dev/null
ssh -fNR 1313:0.0.0.0:1313 root@vps.thinkloveshare.com
echo "Verify GatewayPorts yes in /etc/ssh/sshd_config"
./hugo --bind 0.0.0.0 -b http://vps.thinkloveshare.com/ serve
