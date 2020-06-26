# Docker image for [FlexGet](https://flexget.com)

* Based on python:3.8-slim
* transmissionrpc
* pysftp
* openssh-client

Defaults to current user for UID

# Usage

## docker cli

    docker run -d \
        --name=CONTAINER_NAME \
        -v HOST_DOWNLOADS:/downloads \
        -v HOST_MEDIA:/media \
        -v HOST_CONFIG:/config \
        -v HOST_SSH_DOCKER:/home/flexget/.ssh \
        -v /etc/localtime:/etc/localtime:ro
        -p 5050:5050
        -e UID=HOST_UID \
        -e GID=HOST_UID \
        ksurl/flexget

## docker-compose 

    version: "2"
    services:
      flexget:
        image: ksurl/flexget:latest
        container_name: flexget
        hostname: flexget
        command: ["sh","-c","ssh -f -N host && rm -f /config/.config-lock 2> /dev/null && flexget daemon start --autoreload-config" ]
        networks:
          local:
            ipv4_address: 172.20.0.2 # set your own IP here if not using this subnet
        ports:
          - 5050:5050
        environment:
          - UID=1000
          - GID=1000
        volumes:
          - <HOST>/config:/config
          - <HOST>/ssh:/home/flexget/.ssh # optional if not using ssh/local portforward
          - <HOST_MNT>/downloads/flexget:/downloads
          - <HOST_MNT>/media:/media
          - /etc/localtime:/etc/localtime:ro
        labels:
          com.centurylinklabs.watchtower.enable: "false" # no autoupdate from watchtower
        restart: unless-stopped
        
    networks:
      local:
        driver: bridge
        ipam:
          config:
            - subnet: 172.20.0.0/16 # pick your own subnet and fill in gateway/range accordingly
              gateway: 172.20.0.1
              ip_range: 172.20.1.0/24 # pick a range outside of what you plan to use for static IP's


# Notes

Add custom log location with custom CMD e.g. `flexget -l /path/flexget.log daemon start --autoreload-config`

The ssh folder expects a config file with a Host named tunnel and a known_hosts file (create by connecting to remote host on docker host and moving to docker ssh folder location)

Use separate a Host for ssh commands in tasks

The tunnel is primarily used for transmission access (no reverse proxy needed)

Local port forward requires binding to docker network IP, not localhost/127.0.0.1 so use a static IP in your compose file
