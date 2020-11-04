FROM    python:alpine

LABEL   org.opencontainers.image.source="https://github.com/ksurl/docker-flexget"

LABEL   maintainer="ksurl"

WORKDIR /config

VOLUME  /config /downloads /media

EXPOSE  5050

RUN     apk add --no-cache --virtual .build-deps \
            gcc \
            make \
            libffi-dev \
            musl-dev && \
        apk add --no-cache --virtual .run-deps \
            tzdata \
            libressl-dev \
            su-exec \
            netcat-openbsd && \
        pip install --no-cache-dir \
            pysftp==0.2.8 \
            transmissionrpc \
            flexget && \
        apk del --purge --no-cache .build-deps && \
        rm -rf /tmp/* /root/.cache

COPY    init /init
RUN     chmod +x /init

CMD     [ "/init" ]
