FROM python:3.8.13-alpine3.14
MAINTAINER Phoenix <hkxseven007@gmail.com>

ENV LANG C.UTF-8
ENV TZ 'Asia/Shanghai'

RUN set -ex \
        && apk add --no-cache --virtual .build-deps sed build-base libffi-dev openssl-dev git \
        && apk add --no-cache tzdata ca-certificates ffmpeg libmagic openjpeg zlib-dev libwebp openjdk11-jre \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone

RUN set -ex \
        && pip3 install --upgrade setuptools \
        && pip3 install git+https://github.com/ehForwarderBot/ehForwarderBot \
        && pip3 install git+https://github.com/ehForwarderBot/efb-telegram-master \
        && pip3 install -U git+https://github.com/milkice233/efb-qq-slave \
        && pip3 install git+https://github.com/milkice233/efb-qq-plugin-mirai \
        && pip3 install python-telegram-bot[socks] 

RUN set -ex \
        && mkdir -p ~/mcl \
        && cd ~/mcl \
        && wget https://github.com/iTXTech/mirai-console-loader/releases/download/v2.1.0/mcl-2.1.0.zip \
        && unzip mcl-2.1.0.zip \
        && chmod +x mcl \
        && ./mcl --update-package net.mamoe:mirai-api-http --channel stable-v2 --type plugin \
        && apk del .build-deps \
        && rm -rf ~/.cache

CMD ["ehforwarderbot"]
