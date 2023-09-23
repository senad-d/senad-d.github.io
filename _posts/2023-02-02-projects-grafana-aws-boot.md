---
title: Grafana bootstrap script for AWS
date: 2023-02-02 12:00:00
categories: [Projects, Grafana, AWS, Bootstrap]
tags: [aws, grafana, bootstrap]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/backgroun.png?raw=true){: .shadow }

Bootstrap script for Amazon-Linux AMI. This script installs docker and docker-compose. Runs Grafana, InfluxDB, and Telegraf with custom configuration files. 


```shell
#!/bin/bash

yum update -y
yum install wget curl git docker -y
curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
usermod -a -G docker ec2-user
newgrp docker
chown -R ec2-user:docker /home/ec2-user/docker
systemctl enable docker.service
systemctl start docker.service
mkdir -p /home/ec2-user/docker/grafana/{provisioning,dashboards}
mkdir -p /home/ec2-user/docker/grafana/provisioning/{datasources,dashboards}
mkdir -p /home/ec2-user/docker/telegraf/etc
cat <<EOF > /home/ec2-user/docker/configuration.env
# Grafana options
GF_SECURITY_ADMIN_USER=admin
GF_SECURITY_ADMIN_PASSWORD=admin
GF_INSTALL_PLUGINS=

# InfluxDB options
INFLUXDB_DB=influx
INFLUXDB_ADMIN_USER=$(date +%s | sha256sum | base64 | head -c 8 ; echo)
INFLUXDB_ADMIN_PASSWORD=$(date +%s | sha256sum | base64 | head -c 12 ; echo)
EOF

cat <<EOF > /home/ec2-user/docker/telegraf/etc/telegraf.conf
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
  urls = ["${DNSName1}", "${DNSName2}", "${DNSName3}"]
  interval = "30s"
  count = 4
  ping_interval = 1.0
  timeout = 2.0
EOF

cat <<EOF > /home/ec2-user/docker/grafana/provisioning/datasources/datasource.yml
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
  - name: CloudWatch
    type: cloudwatch
    jsonData:
      authType: default
      defaultRegion: ${AWS::Region}
EOF

cat <<EOF > /home/ec2-user/docker/grafana/provisioning/dashboards/dashboard.yml
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

git clone https://<github-key>@github.com/senad-dizdarevic/grafana-dash.git /home/ec2-user/temp
mv /home/ec2-user/temp/AWS/AWS-dash.json /home/ec2-user/docker/grafana/dashboards/dash.json
mv /home/ec2-user/temp/AWS/grafana-conf /home/ec2-user/docker/grafana/defaults.ini
rm -rf /home/ec2-user/temp

cat <<EOF > /home/ec2-user/docker/docker-compose.yml
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

docker-compose -f /home/ec2-user/docker/docker-compose.yml up -d

cat <<EOF > ~/mycron
0 0 * * * yum -y update --security
EOF
crontab ~/mycron
/opt/aws/bin/cfn-signal -e $? --stack ${AWS::StackName} --resource myASG --region ${AWS::Region}
```