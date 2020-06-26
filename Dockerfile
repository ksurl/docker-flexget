FROM python:3.8-slim

LABEL maintainer "ksurl"

ARG UID=1000
ARG GID=1000

WORKDIR /config

RUN apt-get update && apt-get install -y --no-install-recommends gcc python3-dev openssh-client netcat && \
    pip install --no-cache-dir flexget pysftp==0.2.8 transmissionrpc && \
    apt-get remove -y gcc python3-dev && apt autoremove -y && rm -rf /var/lib/apt/lists/*

RUN useradd -m -u ${UID} flexget

VOLUME /config /downloads /media /home/flexget/.ssh /etc/localtime

USER flexget

EXPOSE 5050

CMD [ "sh", "-c","ssh -f -N host -f && rm -f /config/.config-lock 2> /dev/null && flexget daemon start --autoreload-config" ]
