---
title: Azure Grafana bootstrap script
date: 2023-02-02 13:00:00
categories: [Projects, Grafana]
tags: [azure, grafana, bootstrap]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.pro/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/azure-banner.png?raw=true){: .shadow }

Bootstrap script for Ubuntu 18.04-LTE image. This script installs docker and docker-compose. Runs Docker-compose.yml for Cloud Monitoring (Grafana, InfluxDB, and Telegraf) with custom configuration files. 


```shell
#!/bin/bash

### If you are runing just a bash script make shure to change DNS names
DNS1="example.com"
DNS2="example1.com" # optional
DNS3="example2.com" # optional
########################################

apt update -y
apt install wget curl git docker.io -y
curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
newgrp docker
useradd -g docker -s /usr/bin/bash -m docker
usermod -a -G docker azureuser
systemctl enable docker.service
systemctl start docker.service
mkdir -p /home/azureuser/docker/grafana/{provisioning,dashboards}
mkdir -p /home/azureuser/docker/grafana/provisioning/{datasources,dashboards}
mkdir -p /home/azureuser/docker/telegraf/etc
chown -R azureuser:docker /home/azureuser/docker
cat <<EOF > /home/azureuser/docker/configuration.env
# Grafana options
GF_SECURITY_ADMIN_USER=admin
GF_SECURITY_ADMIN_PASSWORD=admin
GF_INSTALL_PLUGINS=

# InfluxDB options
INFLUXDB_DB=influx
INFLUXDB_ADMIN_USER=$(date +%s | sha256sum | base64 | head -c 8 ; echo)
INFLUXDB_ADMIN_PASSWORD=$(date +%s | sha256sum | base64 | head -c 12 ; echo)
EOF

cat <<EOF > /home/azureuser/docker/telegraf/etc/telegraf.conf
[global_tags]

[agent]
  interval = "30s"
  round_interval = true
  metric_buffer_limit = 10000
  flush_buffer_when_full = true
  collection_jitter = "0s"
  flush_interval = "10s"
  flush_jitter = "0s"
  debug = false
  quiet = false
  hostname = ""

[[outputs.influxdb]]
  urls = ["http://influxdb:8086"] # required
  database = "influx" # required
  precision = "s"
  timeout = "5s"

[[inputs.statsd]]
  protocol = "udp"
  max_tcp_connections = 250
  tcp_keep_alive = false
  service_address = ":8125"
  delete_gauges = true
  delete_counters = true
  delete_sets = true
  delete_timings = true
  percentiles = [90]
  metric_separator = "_"
  parse_data_dog_tags = false
  allowed_pending_messages = 10000
  percentile_limit = 1000

[[inputs.cpu]]
  percpu = true
  totalcpu = true
  fielddrop = ["time_*"]
  collect_cpu_time = false
  report_active = false

[[inputs.disk]]
  ignore_fs = ["tmpfs", "devtmpfs", "devfs", "iso9660", "overlay", "aufs", "squashfs"]

[[inputs.diskio]]

[[inputs.kernel]]

[[inputs.mem]]

[[inputs.processes]]

[[inputs.swap]]

[[inputs.system]]

[[inputs.net]]

[[inputs.netstat]]

[[inputs.interrupts]]

[[inputs.linux_sysctl_fs]]

[[inputs.ping]]
  urls = ["$DNS1", "$DNS2", "$DNS3"]
  interval = "30s"
  count = 4
  ping_interval = 1.0
  timeout = 2.0
EOF

cat <<EOF > /home/azureuser/docker/grafana/provisioning/datasources/datasource.yml
apiVersion: 1

deleteDatasources:
  - name: Influxdb
    orgId: 1
datasources:
  - name: InfluxDB
    type: influxdb
    access: proxy
    orgId: 1
    url: http://influxdb:8086
    password: "admin"
    user: "admin"
    database: "influx"
    basicAuth: false
    isDefault: true
    jsonData:
      timeInterval: "30s"
    version: 1
    editable: false
  - name: Azure Monitor
    type: grafana-azure-monitor-datasource
    access: proxy
    jsonData:
      azureAuthType: msi
    version: 1
EOF

cat <<EOF > /home/azureuser/docker/grafana/provisioning/dashboards/dashboard.yml
apiVersion: 1

providers:
- name: 'dash'
  orgId: 1
  folder: ''
  type: file
  disableDeletion: false
  updateIntervalSeconds: 30
  options:
    path: /var/lib/grafana/dashboards/
    foldersFromFilesStructure: true
EOF

git clone https://<github-key>@github.com/senad-dizdarevic/grafana-dash.git /home/azureuser/docker/temp
mv /home/azureuser/docker/temp/Azure/Azure-dash.json /home/azureuser/docker/grafana/dashboards/dash.json
mv /home/azureuser/docker/temp/Azure/grafana-conf /home/azureuser/docker/grafana/defaults.ini
rm -rf /home/azureuser/docker/temp

cat <<EOF > /home/azureuser/docker/docker-compose.yml
version: '3.6'
services:
  telegraf:
    image: telegraf:1.18-alpine
    volumes:
      - ./telegraf/etc/telegraf.conf:/etc/telegraf/telegraf.conf:ro
    depends_on:
      - influxdb
    links:
      - influxdb
    ports:
      - '8125:8125/udp'

  influxdb:
    image: influxdb:1.8-alpine
    env_file: configuration.env
    ports:
      - '8086:8086'
    volumes:
      - ./:/imports
      - influxdb_data:/var/lib/influxdb

  grafana:
    image: grafana/grafana:9.1.8
    depends_on:
      - influxdb
    env_file: configuration.env
    links:
      - influxdb
    ports:
      - '80:3000'
    volumes:
      - grafana_data:/var/lib/grafana
      - ./grafana/provisioning/:/etc/grafana/provisioning/
      - ./grafana/dashboards/:/var/lib/grafana/dashboards/
      - ./grafana/defaults.ini:/usr/share/grafana/conf/defaults.ini

volumes:
  grafana_data: {}
  influxdb_data: {}
EOF

docker-compose -f /home/azureuser/docker/docker-compose.yml up -d
```