FROM python:alpine

LABEL maintainer="ksurl"

ARG UID=1000
ARG GID=1000

WORKDIR /config

EXPOSE 5050

VOLUME /config /downloads /media

RUN apk add --no-cache --virtual=build-deps gcc make python3-dev libressl-dev libffi-dev musl-dev netcat-openbsd && \
    python -m pip install --no-cache-dir -U pip && \
    pip install --no-cache-dir flexget pysftp==0.2.8 transmissionrpc && \
    apk del --purge --no-cache build-deps


USER ${UID}:${GID}

CMD [ "sh", "-c","rm -f /config/.config-lock 2> /dev/null && flexget daemon start --autoreload-config" ]
