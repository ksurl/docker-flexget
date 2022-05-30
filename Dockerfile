FROM        python:3.10.4-alpine3.16

ENV         PYTHONUNBUFFERED=1

ARG         FLEXGET_VERSION

RUN         set -x; \
            echo "**** install build packages ****" && \
            apk add --no-cache --upgrade \
                build-base \
                ca-certificates \
                curl \
                git \
                jq \
                libffi-dev \
                openssl-dev \
                unzip && \
            rm -rf /var/cache/apk/*

WORKDIR     /wheels

RUN         set -x; \
            echo "**** build flexget wheels ****" && \
            if [ -z ${FLEXGET_VERSION} ]; then \
                FLEXGET_VERSION=$(curl -sX GET "https://api.github.com/repos/Flexget/Flexget/releases/latest" \
                | jq -r '.tag_name'); \
            fi && \
            git clone --depth 1 --branch ${FLEXGET_VERSION} https://github.com/flexget/flexget /flexget

RUN         set -x; \
            pip install -U pip && \
            pip wheel -e /flexget && \
            pip wheel pysocks && \
            pip wheel transmission-rpc

WORKDIR     /flexget-ui-v2
RUN         set -x; \
            echo "**** download flexget web ui****" && \
            wget https://github.com/Flexget/webui/releases/latest/download/dist.zip && \
            unzip dist.zip && \
            rm dist.zip

FROM        python:3.10.4-alpine3.16

LABEL       org.opencontainers.image.source="https://github.com/ksurl/docker-flexget"

LABEL       maintainer="ksurl"

WORKDIR     /config

ENV         PYTHONUNBUFFERED=1 \
            LOG_FILE=/config/flexget.log \
            LOG_LEVEL=info \
            S6_CMD_WAIT_FOR_SERVICES_MAXTIME=30000 \
            TERM=xterm-256color \
            TZ=UTC \
            VERSION=docker

RUN         set -x; \
            echo "**** install packages ****" && \
            apk add --no-cache --upgrade \
                bash \
                ca-certificates \
                curl \
                libstdc++ \
                libressl-dev \
                s6-overlay \
                shadow \
                tzdata && \
            echo "**** create user ****" && \
            groupmod -g 1000 users && \
            useradd -u 911 -U -d /config -s /bin/false abc && \
            usermod -G users abc && \
            mkdir -p /config && \
            echo "**** disable root login ****" && \
            sed -i -e 's/^root::/root:!:/' /etc/shadow

COPY        --from=0 /wheels /wheels

RUN         set -x; \
            echo "**** install flexget ****" && \
            pip install -U pip && \
            pip install --no-cache-dir --no-index \
                -f /wheels \
                FlexGet \
                pysocks \
                transmission-rpc && \
            rm -rf /wheels

COPY        --from=0 /flexget-ui-v2 /usr/local/lib/python3.10/site-packages/flexget/ui/v2/

RUN         set -x; \
            echo "**** cleanup ****" && \
            rm -rf /tmp/* /var/cache/apk/* /root/.cache

COPY        root/ /

HEALTHCHECK --interval=60s --timeout=15s --start-period=5s --retries=3 \
            CMD [ "/bin/sh", "-c", "/bin/netstat -an | /bin/grep -q 5050" ]

EXPOSE      5050
VOLUME      /config /data

ENTRYPOINT [ "/init" ]
