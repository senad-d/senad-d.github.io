---
title: Nginx Proxy Manager
date: 2022-03-03 13:00:00
categories: [Software, Open source]
tags: [nginx, proxymanager, docker-compose]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/nginx-banner.png?raw=true){: .shadow }


Expose your private network Web services and get connected anywhere. Built-in Let’s Encrypt support allows you to secure your Web services at no cost to you. Configure other users to either view or manage their own hosts. Full access permissions are available.

![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/nginx-proxy-manager-dash.png?raw=true){: .shadow }

### Default Nginx Proxy Manager login and password:
```shell
Username: admin@example.com
Password: changeme
```
## Create docker-compose.yml for Nginx
docker-compose.yml
```shell
version: "3.4"
services:
  nginx:
    image: jc21/nginx-proxy-manager:latest
    container_name: nginx-proxymanager
    restart: unless-stopped
    env_file: .env
    ports:
      - 80:80
      - 81:81
      - 443:443
    volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt
    environment:
      TZ: '${TIMEZONE}'
      DB_MYSQL_HOST: "mariadb-nginx"
      DB_MYSQL_PORT: 3306
      DB_MYSQL_USER: "${MYSQL_USER}"
      DB_MYSQL_PASSWORD: "${MYSQL_PASSWORD}"
      DB_MYSQL_NAME: "${MYSQL_DATABASE}"
      DISABLE_IPV6: 'true'
    depends_on:
      - mariadb-nginx
    networks:
      - proxy
  mariadb-nginx:
    image: jc21/mariadb-aria:latest
    container_name: mariadb-nginx
    restart: unless-stopped
    env_file: .env
    environment:
      TZ: '${TIMEZONE}'
      MYSQL_ROOT_PASSWORD: '${ROOT_PASSWORD}'
      MYSQL_DATABASE: '${MYSQL_DATABASE}'
      MYSQL_USER: '${MYSQL_USER}'
      MYSQL_PASSWORD: '${MYSQL_PASSWORD}'
    volumes:
      - ./mysql:/var/lib/mysql
    networks:
      - proxy

networks:
  proxy:
    external: true
```


## Run this commands to set the variables
```shell
# Add variables for the docker images
TIMEZONE="$(cat /etc/timezone)"
PUID="$(id -u "${SUDO_USER:-$USER}")"
PGID="$(id -g "${SUDO_USER:-$USER}")"
ROOT_PASSWORD="$(gpg --gen-random --armor 1 20)"
MYSQL_DATABASE="$(gpg --gen-random --armor 1 6)"
MYSQL_USER="$(gpg --gen-random --armor 1 6)"
MYSQL_PASSWORD="$(gpg --gen-random --armor 1 14)"
```


## Create .env to store the variables for docker-compose.yml
```shell
# Create .env file
cat <<EOF > /home/"${SUDO_USER:-$USER}"/docker/.env
TIMEZONE="${TIMEZONE}"
PUID="${PUID}"
PGID="${PGID}"
ROOT_PASSWORD="${ROOT_PASSWORD}"
MYSQL_DATABASE="${MYSQL_DATABASE}"
MYSQL_USER="${MYSQL_USER}"
MYSQL_PASSWORD="${MYSQL_PASSWORD}"
EOF
```