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
ssh -fNR 1313:127.0.0.1:1313 root@vps.thinkloveshare.com
./hugo -b http://vps.thinkloveshare.com/ serve
