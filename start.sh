#!/bin/sh 
if [ ! -f "/root/go-cqhttp/go-cqhttp" ]; then
  mkdir -p /root/go-cqhttp
  cd /root/go-cqhttp 
  wget https://github.com/Mrs4s/go-cqhttp/releases/download/v1.0.1/go-cqhttp_linux_amd64.tar.gz
  tar -xvf go-cqhttp_linux_amd64.tar.gz 
  chmod +x go-cqhttp 
  echo -e "go-cqhttp安装完成...\n"
fi

cd /root/go-cqhttp 
nohup ./go-cqhttp &>/dev/null &
echo -e "go-cqhttp启动完成...\n"
sleep 20
ehforwarderbot &
sh
