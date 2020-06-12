FROM python:3.8-slim

LABEL maintainer "ksurl"

ARG UID=1000
ARG GID=1000

WORKDIR /config

RUN apt-get update && apt-get install -y --no-install-recommends gcc python3-dev && \
    pip install --no-cache-dir flexget==3.1.56 pysftp==0.2.8 transmissionrpc && \
    apt-get remove -y gcc python3-dev && apt autoremove -y && rm -rf /var/lib/apt/lists/*

VOLUME /config /downloads /media

USER ${UID}:${GID}

EXPOSE 5050

CMD [ "sh", "-c","rm -f /config/.config-lock 2> /dev/null && flexget daemon start --autoreload-config" ]