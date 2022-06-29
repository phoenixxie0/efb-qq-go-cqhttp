FROM alpine:latest
MAINTAINER Phoenix <hkxseven007@gmail.com>

ENV LANG C.UTF-8
ENV TZ 'Asia/Shanghai'

RUN set -ex \
        && apk add --no-cache --virtual .build-deps sed build-base libffi-dev openssl-dev python3-dev git \
        && apk add --no-cache tzdata ca-certificates ffmpeg libmagic openjpeg zlib-dev libwebp \
                python3 py3-olefile py3-numpy py3-pillow py3-pip py3-cryptography py3-decorator \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone

RUN set -ex \
        && pip3 install --upgrade pip \
        && pip3 install --upgrade setuptools \
        #&& pip3 install ehforwarderbot \
        && pip3 install git+https://github.com/ehForwarderBot/ehForwarderBot \
        && pip3 install git+https://github.com/ehForwarderBot/efb-telegram-master \
        && pip3 install -U git+https://github.com/milkice233/efb-qq-slave \
        && pip3 install lottie \
        && pip3 install cairosvg \
        && sed -i "s/{self.chat_type_emoji}/丨/g" /usr/local/lib/python3.*/site-packages/efb_telegram_master/chat.py \
        && pip3 install python-telegram-bot[socks] \
        && apk del .build-deps \
        && rm -rf ~/.cache

CMD ["ehforwarderbot"]
