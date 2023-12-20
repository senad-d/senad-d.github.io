---
title: Grafana for AWS
date: 2023-02-02 12:00:00
categories: [Projects, Grafana]
tags: [aws, grafana]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.pro/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/backgroun.png?raw=true){: .shadow }

A CloudFormation template for adding an EC2 instance with a fully automated bootstrap script to create monitoring that automatically connects to AWS CloudWatch for metrics and allows users easy viewing of key metrics for AWS resources.

<details><summary> Video </summary>

<div style="max-width: 100%; max-height: auto;">
  <video controls style="width: 100%; height: auto;">
    <source src="https://github.com/senad-d/senad-d.github.io/raw/main/_media/video/grafana_aws.mp4" type="video/mp4">
    Your browser does not support the video tag.
  </video>
</div>

</details>

## AWS Resources used:
-   [***Monitoring CloudFormation***](https://senad-d.github.io/posts/projects-grafana-aws-cf/)
	1.  Ec2 instance creation
	2.  Vpc Selection
	3.  Subnet selection
	4.  Security group creation
-   Monitoring [***bootstrap***](https://senad-d.github.io/posts/projects-grafana-aws-boot/) script for installing and running Docker-compose 
-   Docker-compose.yml for  Cloud Monitoring with Grafana, InfluxDB, and Telegraf 
-   Configured telegraf.conf and InfluxDB to work automatically
-   Created a custom dashboard for Grafana using metrics from CloudWatch ([[AWS Management#CloudWatch]]) and InfluxDB

![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/grafana_env.jpg?raw=true){: .shadow }

### 1. CloudFormation template

Created Monitoring CloudFormation for creating resources in AWS needed to start monitoring Account metrics.

### 2. Docker-compose.yml  for Grafana, InfluxDB and Telegraf.

Docker-compose YAML to be able to easily run containers for Monitoring containing InfluxDB for querying data and Telegraf for data aggregation in order to get service up time metric.

### 3. .env files for InfluxDB an Telegraf.

```shell
cat <<EOF > /home/ec2-user/docker/configuration.env
# Grafana options
GF_SECURITY_ADMIN_USER=admin
GF_SECURITY_ADMIN_PASSWORD=admin
GF_INSTALL_PLUGINS=

# InfluxDB options
INFLUXDB_DB=influx
# Create random user and pass
INFLUXDB_ADMIN_USER=$(date +%s | sha256sum | base64 | head -c 8 ; echo)
INFLUXDB_ADMIN_PASSWORD=$(date +%s | sha256sum | base64 | head -c 12 ; echo)
```

### 4. Edit custom telegraf.conf 

Edit telegraf.conf file to connect telegraf to InfluxDB

### 5. Created Grafana datasource for CloudWatch and InfluxDB

Create previsioned Grafana datasource.yml to connect Grafana to CloudWatch datasource and InfluxDB datasource.

### 6. Create provisioning dashboard for Grafana

```shell
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
```

### 7. Created GitHub private repository and access token with only permission to clone that repository.

Placed dash.json file and grafana default.ini file in this repository to be used in a bootstrap script with the access token.

```shell
git clone https://<access token>@github.com/user/repo.git /home/ec2-user/temp
mv /home/ec2-user/temp/dash.json /home/ec2-user/docker/grafana/dashboards/dash.json
mv /home/ec2-user/temp/grafana-conf /home/ec2-user/docker/grafana/defaults.ini
rm -rf /home/ec2-user/temp
```