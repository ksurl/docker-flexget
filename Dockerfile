FROM python:3.8-slim

LABEL maintainer "ksurl"

ARG UID=1000
ARG GID=1000

WORKDIR /config

RUN apt-get update && apt-get install -y gcc python3-dev && \
    pip3 install --no-cache-dir flexget pysftp==0.2.8 transmissionrpc

VOLUME /config /downloads

USER ${UID}:${GID}

CMD [ "rm", "-f", "/config/.config-lock", "2>", "/dev/null", "&&", "flexget", "daemon", "start", "--autoreload-config" ]