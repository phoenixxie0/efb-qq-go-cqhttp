#!/bin/sh 
if [ ! -d "/root/mcl" ]; then
  mkdir -p /root/mcl
  cd /root/mcl 
  wget https://github.com/iTXTech/mirai-console-loader/releases/download/v2.1.0/mcl-2.1.0.zip 
  unzip mcl-2.1.0.zip 
  chmod +x mcl 
  ./mcl --update-package net.mamoe:mirai-api-http --channel stable-v2 --type plugin 
  echo -e "mcl安装完成...\n"
fi

cd /root/mcl 
nohup ./mcl &>/dev/null &
echo -e "mcl启动完成...\n"
sleep 20
ehforwarderbot
