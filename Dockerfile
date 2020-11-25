FROM        python:alpine

LABEL       org.opencontainers.image.source="https://github.com/ksurl/docker-flexget"

LABEL       maintainer="ksurl"

WORKDIR     /config

VOLUME      /config /downloads /media

EXPOSE      5050

ENV         APK_PKGS="" \
            LOG_FILE=/config/flexget.log \
            LOG_LEVEL=info \
            PIP_PKGS="" \
            PUID=1000 \
            PGID=1000 \
            TZ=UTC \
            VERSION=""

COPY        init /init

RUN         chmod +x /init && \
            apk add --no-cache --virtual .build-deps \
                gcc \
                make \
                libffi-dev \
                musl-dev && \
            apk add --no-cache --virtual .run-deps \
                dumb-init \
                libressl-dev \
                su-exec \
                tzdata && \
            pip install --no-cache-dir \
                flexget \
                transmissionrpc && \
            apk del --purge --no-cache .build-deps && \
            rm -rf /tmp/* /var/cache/apk/* /root/.cache

HEALTHCHECK --interval=60s --timeout=15s --start-period=5s --retries=3 \
            CMD [ "/bin/sh", "-c", "/usr/local/bin/flexget -l /dev/null daemon status | /bin/grep -q 'Daemon running'" ]

ENTRYPOINT  [ "/usr/bin/dumb-init", "--" ]
CMD         [ "/init" ]
