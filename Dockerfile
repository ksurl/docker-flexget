FROM python:alpine

LABEL maintainer "ksurl"

ARG UID=1000
ARG GID=1000

WORKDIR /config

RUN apk add --no-cache --virtual .build-deps gcc make python3-dev libressl-dev libffi-dev musl-dev && \
    pip install --no-cache-dir flexget pysftp==0.2.8 transmissionrpc && \
    apk del .build-deps

VOLUME /config /downloads /media

USER ${UID}:${GID}

EXPOSE 5050

CMD [ "sh", "-c","rm -f /config/.config-lock 2> /dev/null && flexget daemon start --autoreload-config" ]
