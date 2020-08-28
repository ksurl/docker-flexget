# Docker image for [FlexGet](https://flexget.com)

* Based on python:alpine
* transmissionrpc
* pysftp

Defaults to 1000 for UID

# Usage

## docker cli

    docker run -d \
        --name=CONTAINER_NAME \
        -v HOST_DOWNLOADS:/downloads \
        -v HOST_MEDIA:/media \
        -v HOST_CONFIG:/config \
        -v /etc/timezone:/etc/timezone:ro
        -p 5050:5050
        ksurl/flexget:latest

## docker-compose 

    version: "2"
    services:
      flexget:
        image: ksurl/flexget:latest
        container_name: flexget
        hostname: flexget
        command: ["sh","-c","rm -f /config/.config-lock 2> /dev/null && flexget daemon start --autoreload-config" ]
        networks:
          local:
            ipv4_address: 172.20.0.2 # set your own IP here if not using this subnet
        ports:
          - 5050:5050
        volumes:
          - <HOST>/config:/config
          - <HOST_MNT>/downloads/flexget:/downloads
          - <HOST_MNT>/media:/media
          - /etc/timezone:/etc/timezone:ro
        labels:
          com.centurylinklabs.watchtower.enable: "false" # no autoupdate from watchtower
        restart: unless-stopped
        
      tunnel:
        image: jossec101/sshtunneller:latest
        container_name: tunnel
        networks:
          local:
            ipv4_address: 172.20.0.3 # set your own IP here if not using this subnet
        environment:
          - ssh_host=<REMOTE_SERVER_IP>
          - ssh_port=22 # change if not default port
          - ssh_username=<REMOTE_USERNAME>
          - ssh_private_key_password=<SSH_PRIVATE_KEY_PASSWORD>
          - remote_bind_addresses=[("127.0.0.1",9091)] # change port, add additional with comma separation
          - local_bind_addresses=[("172.20.0.3",9091)] # change port, add additional with comma separation
        volumes:
          - <HOST>/key:/private.key
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

The tunnel is primarily used for transmission access (no reverse proxy needed)

Local port forward requires binding to docker network IP, not localhost/127.0.0.1 so use a static IP in your compose file
