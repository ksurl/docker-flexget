FROM        python:alpine

LABEL       org.opencontainers.image.source="https://github.com/ksurl/docker-flexget"

LABEL       maintainer="ksurl"

WORKDIR     /config

VOLUME      /config /downloads /media

EXPOSE      5050

ENV         LOG_FILE=/config/flexget.log \
            LOG_LEVEL=info \
            PUID=1000 \
            PGID=1000 \
            TZ=UTC \
            VERSION=""

RUN         apk add --no-cache --virtual .build-deps \
                gcc \
                make \
                libffi-dev \
                musl-dev && \
            apk add --no-cache --virtual .run-deps \
                libressl-dev \
                netcat-openbsd \
                su-exec \
                tzdata && \
            pip install --no-cache-dir \
                dumb-init \
                flexget \
                pysftp==0.2.8 \
                transmissionrpc && \
            apk del --purge --no-cache .build-deps && \
            rm -rf /tmp/* /var/cache/apk/* /root/.cache

COPY        init /init
RUN         chmod +x /init

ENTRYPOINT  [ "/usr/local/bin/dumb-init", "/init" ]
