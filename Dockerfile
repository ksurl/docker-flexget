FROM        ghcr.io/linuxserver/baseimage-alpine:3.12

LABEL       org.opencontainers.image.source="https://github.com/ksurl/docker-flexget"

LABEL       maintainer="ksurl"

ARG         FLEXGET_VERSION

ENV         LOG_FILE=/config/flexget.log \
            LOG_LEVEL=info \
            VERSION=""

RUN         echo "**** install build packages ****" && \
            apk add --no-cache --virtual=build-dependencies \
                curl \
                gcc \
                libffi-dev \
                make \
                musl-dev && \
            echo "**** install packages ****" && \
            apk add --no-cache \
                libressl-dev \
                py3-pip \
                python3 && \
            echo "**** install flexget ****" && \
            if [ -z ${FLEXGET_VERSION} ]; then \
                FLEXGET_VERSION=$(curl -sX GET "https://api.github.com/repos/Flexget/Flexget/releases/latest" \
                | grep "tag_name" \
                | sed -e 's/.*v//' -e 's/",//'); \
            fi && \
            pip install --no-cache-dir \
                transmissionrpc \
                flexget==${FLEXGET_VERSION} && \
            echo "**** cleanup ****" && \
            apk del --purge \
                build-dependencies && \
            rm -rf /tmp/* /var/cache/apk/* /root/.cache

COPY        root/ /

HEALTHCHECK --interval=60s --timeout=15s --start-period=5s --retries=3 \
            CMD [ "/bin/sh", "-c", "/bin/ps x | /bin/grep -v grep | /bin/grep -q 'flexget'" ]

EXPOSE      5050
VOLUME      /config /downloads /media
