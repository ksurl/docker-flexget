# Docker image for [FlexGet](https://flexget.com)

[![](https://img.shields.io/badge/Docker%20Hub--blue)](https://hub.docker.com/r/ksurl/flexget) [![](https://img.shields.io/badge/GitHub%20Container%20Registry--yellow)](https://github.com/users/ksurl/packages/container/package/flexget)

[![](https://img.shields.io/github/v/tag/ksurl/docker-flexget?label=image%20version&logo=docker)](https://hub.docker.com/r/ksurl/flexget) [![](https://img.shields.io/docker/image-size/ksurl/flexget/latest?color=lightgrey&logo=Docker)]() [![](https://img.shields.io/github/actions/workflow/status/ksurl/docker-flexget/build.yml?label=build&logo=Docker)](https://github.com/ksurl/docker-flexget/actions/workflows/build.yml?query=workflow%3Abuild)

* Based on [python:3.12-alpine3.17](https://hub.docker.com/_/python)
* transmission-rpc

## Usage

### docker cli

    docker run -d \
        --name=CONTAINER_NAME \
        -v HOST_DATA:/data \
        -v HOST_CONFIG:/config \
        -e LOG_FILE=/config/flexget.log
        -e LOG_LEVEL=info \
        -e PUID=1000
        -e PGID=1000
        -e TZ=UTC \
        -e VERSION=docker \
        -p 5050:5050 \
        ghcr.io/ksurl/flexget

### docker-compose

    services:
      flexget:
        image: ghcr.io/ksurl/flexget
        container_name: flexget
        environment:
          - LOG_FILE=/config/flexget.log
          - LOG_LEVEL=info
          - PUID=1000
          - PGID=1000
          - TZ=UTC
          - VERSION=docker
        ports:
          - 5050:5050
        volumes:
          - <HOST>/config:/config
          - <HOST_MNT>/data:/data
        restart: unless-stopped

### Parameters

| Parameter | Function | Default |
| :----: | --- | --- |
| `-e LOG_FILE` | Set log file location | `/config/flexget.log` |
| `-e LOG_LEVEL` | Set log level | `info` |
| `-e PUID` | Set uid | `1000` |
| `-e PGID` | Set gid | `1000` |
| `-e TZ` | Specify a timezone to use | `UTC` |
| `-e VERSION` | Optional: Specify a version to use (defaults to installed version from build time). Valid input: `latest`, `docker`, `<specific version>` | `docker` |
| `-v /config` | Config folder goes here | |
| `-v /data` | Downloads go here | |
