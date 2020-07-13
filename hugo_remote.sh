#!/bin/sh

/bin/rm -rf resources
kill -9 $(ps aux | grep 'ssh -fNR' | grep -v grep | awk '{print $2}')
ssh -fNR 1313:127.0.0.1:1313 root@vps.thinkloveshare.com
hugo -b http://vps.thinkloveshare.com/ serve
