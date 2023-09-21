---
title: Plausible Analytics
date: 2022-03-03 12:00:00
categories: [Software, Plausible]
tags: [analytics, monitoring]
---
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/plausible-analytics.jpg?raw=true){: .shadow }

Plausible Analytics is an open source, simple, lightweight and privacy-friendly Google Analytics alternative. One aspect that makes Plausible different from many of the other web analytics tools such as Google Analytics is the fact that Plausible is fully open-source software.

[***Plausible Demo***](https://plausible.io/plausible.io)

[***Plausible Docs***](https://plausible.io/docs)

## Create docker-compose.yml file for running the containers for Plausible.
docker-compose.yml
```shell
version: "3.3"
services:
  mail:
    image: bytemark/smtp
    container_name: mail
    restart: always
    networks:
      - proxy

  plausible_db:
    image: postgres:14-alpine
    container_name: postgres
    restart: always
    volumes:
      - db-data:/var/lib/postgresql/data
    environment:
      - POSTGRES_PASSWORD=postgres
    networks:
      - proxy


  plausible_events_db:
    image: clickhouse/clickhouse-server:22.6-alpine
    container_name: plausible_events
    restart: always
    deploy:
        resources:
            limits:
              cpus: "0.75"
              memory: 1G
            reservations:
              cpus: "0.25"
              memory: 512M
    volumes:
      - event-data:/var/lib/clickhouse
      - ./clickhouse/clickhouse-config.xml:/etc/clickhouse-server/config.d/logging.xml:ro
      - ./clickhouse/clickhouse-user-config.xml:/etc/clickhouse-server/users.d/logging.xml:ro
    ulimits:
      nofile:
        soft: 262144
        hard: 262144
    networks:
      - proxy

  plausible:
    image: plausible/analytics:latest
    container_name: plausible
    restart: always
    command: sh -c "sleep 10 && /entrypoint.sh db createdb && /entrypoint.sh db migrate && /entrypoint.sh run"
    deploy:
        resources:
            limits:
              cpus: "0.50"
              memory: 512M
            reservations:
              cpus: "0.25"
              memory: 128M
    depends_on:
      - plausible_db
      - plausible_events_db
      - mail
    ports:
      - 8000:8000
    env_file:
      - plausible-conf.env
    networks:
      - proxy

volumes:
  db-data:
    driver: local
  event-data:
    driver: local

networks:
  proxy:
    external: true
```

## Run the commands to create a secret key and the plausible-conf.env file.

```shell
cat <<EOF >>./plausible-conf.env
BASE_URL=https://<your-domain>
SECRET_KEY_BASE=$(openssl rand -base64 64 | tr -d '\n')
#DISABLE_REGISTRATION=invite_only
EOF
```