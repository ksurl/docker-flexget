# Docker image for [FlexGet](https://flexget.com)

* Based on python:alpine
* transmissionrpc
* pysftp

# Usage

## docker cli

    docker run -d \
        --name=CONTAINER_NAME \
        -v HOST_DOWNLOADS:/downloads \
        -v HOST_MEDIA:/media \
        -v HOST_CONFIG:/config \
        -e LOG_FILE=/config/flexget.log
        -e LOG_LEVEL=info \
        -e PUID=1000
        -e PGID=1000
        -e TZ=UTC \
        -p 5050:5050 \
        ksurl/flexget:latest

## docker-compose 

    version: "2"
    services:
      flexget:
        image: ksurl/flexget:latest
        container_name: flexget
        hostname: flexget
        environment:
          - LOG_FILE=/config/flexget.log
          - LOG_LEVEL=info
          - PUID=1000
          - PGID=1000
          - TZ=UTC
        ports:
          - 5050:5050
        volumes:
          - <HOST>/config:/config
          - <HOST_MNT>/downloads/flexget:/downloads
          - <HOST_MNT>/media:/media
        labels:
          com.centurylinklabs.watchtower.enable: "false" # no autoupdate from watchtower
        restart: unless-stopped

## Parameters

| Parameter | Function |
| :----: | --- |
| `-e LOG_FILE=/config/flexget.log` | Set log file location |
| `-e LOG_LEVEL=info` | Set log level |
| `-e PUID=1000` | Set uid |
| `-e PGID=1000` | Set gid |
| `-e TZ=UTC` | Specify a timezone to use |
| `-v /config` | Default config folder location |
| `-v /downloads` | Downloads go here |
| `-v /media` | Media goes here |