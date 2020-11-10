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
        -e VERSION=""
        -p 5050:5050 \
        ksurl/flexget

## docker-compose 

    version: "2"
    services:
      flexget:
        image: ksurl/flexget
        container_name: flexget
        environment:
          - LOG_FILE=/config/flexget.log
          - LOG_LEVEL=info
          - PUID=1000
          - PGID=1000
          - TZ=UTC
          - VERSION=""
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
| `-e VERSION=""` | Specify a version to use. Valid input: `<blank>` (defaults to version installed since last build), "latest", `<specific version>` |
| `-v /config` | Default config folder location |
| `-v /downloads` | Downloads go here |
| `-v /media` | Media goes here |