FROM python:alpine
MAINTAINER Phoenix <hkxseven007@gmail.com>

ENV LANG C.UTF-8
ENV TZ 'Asia/Shanghai'

RUN set -ex \
        && apk add --no-cache udns \
        && apk add --no-cache --virtual .run-deps sed build-base libffi-dev openssl-dev git \
        && apk add --no-cache tzdata openjpeg zlib-dev libmagic libwebp-dev ffmpeg cairo \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone

RUN set -ex \
        && pip3 install --upgrade pip \
        && pip3 install --upgrade setuptools \
        #&& pip3 install ehforwarderbot \
        && pip3 install git+https://github.com/ehForwarderBot/ehForwarderBot \
        && pip3 install git+https://github.com/ehForwarderBot/efb-telegram-master \
        && pip3 install -U git+https://github.com/tedrolin/python-wechatPc \
        #&& pip install -U https://github.com/Tedrolin/efb-wechat-pc-slave \
        && pip3 install -U git+https://github.com/tom-snow/efb-wechat-pc-slave \
        && pip3 install lottie \
        && pip3 install cairosvg \
        && sed -i 's/channel_emoji: str = "💬🖥️"/channel_emoji: str = "𝙒𝙚𝙘𝙝𝙖𝙩"/g' /usr/local/lib/python3.*/site-packages/efb_wechat_pc_slave/__init__.py \
        && sed -i "s/{self.chat_type_emoji}/丨/g" /usr/local/lib/python3.*/site-packages/efb_telegram_master/chat.py \
        && pip3 install git+https://github.com/ehForwarderBot/efb-mp-instantview-middleware \
        #&& pip3 install git+https://github.com/ehForwarderBot/efb-link_preview-middleware \
        #&& pip3 install git+https://github.com/ehForwarderBot/efb-voice_recog-middleware \
        && pip3 install git+https://github.com/ehForwarderBot/efb-msg_blocker-middleware \
        #&& pip3 install git+https://github.com/ehForwarderBot/efb-patch-middleware \
        && pip3 install git+https://github.com/ahxxm/efb-filter-middleware \
        && pip3 install python-telegram-bot[socks] \
        && rm -rf ~/.cache \
        && apk del .run-deps

CMD ["ehforwarderbot"]
