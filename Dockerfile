FROM        ghcr.io/ksurl/baseimage-python-alpine

LABEL       org.opencontainers.image.source="https://github.com/ksurl/docker-flexget"

LABEL       maintainer="ksurl"

ARG         FLEXGET_VERSION

WORKDIR     /config

ENV         LOG_FILE=/config/flexget.log \
            LOG_LEVEL=info \
            TERM=xterm-256color \
            VERSION=docker

RUN         echo "**** install build packages ****" && \
            apk add --no-cache --virtual=build-dependencies \
                gcc \
                jq \
                libffi-dev \
                make \
                musl-dev && \
            echo "**** install packages ****" && \
            apk add --no-cache \
                curl \
                g++ \
                libressl-dev && \
            echo "**** install flexget ****" && \
            if [ -z ${FLEXGET_VERSION} ]; then \
                FLEXGET_VERSION=$(curl -sX GET "https://api.github.com/repos/Flexget/Flexget/releases/latest" \
                | jq -r '.tag_name' \
                | sed -e 's/v//'); \
            fi && \
            pip install --no-cache-dir \
                flexget==${FLEXGET_VERSION} \
                pysocks \
                transmission-rpc && \
            echo "**** cleanup ****" && \
            apk del --purge build-dependencies && \
            rm -rf /tmp/* /var/cache/apk/* /root/.cache

COPY        root/ /

HEALTHCHECK --interval=60s --timeout=15s --start-period=5s --retries=3 \
            CMD [ "/bin/sh", "-c", "/bin/netstat -an | /bin/grep -q 5050" ]

EXPOSE      5050
VOLUME      /config /downloads /media
