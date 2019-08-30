FROM python:3.7-slim

LABEL maintainer "ksurl"

ARG UID=1000
ARG GID=1000

WORKDIR /config

RUN apt-get update && apt-get install -y python3-dev gcc && \
    pip install --no-cache-dir -U pip setuptools && \
    pip install --no-cache-dir -U flexget deluge-client pysftp==0.2.8

VOLUME /config /downloads

USER ${UID}:${GID}

CMD [ "rm", "-f", "/config/.config-lock", "2>", "/dev/null", "&&", "flexget", "daemon", "start", "--autoreload-config" ]