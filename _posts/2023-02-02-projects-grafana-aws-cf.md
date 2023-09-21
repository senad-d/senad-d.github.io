---
title: Grafana CloudFormation
date: 2023-02-02 12:00:00
categories: [Projects, Grafana, AWS, CloudFormation]
tags: [aws, grafana, cloudformation]
---
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/backgroun.png?raw=true){: .shadow }

CloudFormation template for creating an automated monitoring solution for AWS resources.
Add the Ec2 instance to VPC and Subnet of your choice and start monitoring resources in the account within 10 minutes.
Use a [***custom dashboard***](https://senad-d.github.io/posts/projects-openvpn-aws-dash/)


```shell
---
AWSTemplateFormatVersion : 2010-09-09
Description : Add Grafana EC2 to VPC
# Specifie parameters for the stack.
Parameters:
  ProjectName:
    Description: This will be used for for resource names, keyname and tagging. Resource name can include letters (A-Z and a-z), and dashes (-).
    Type: String
    MinLength: "5"
    Default: monitor
  VpcID:
    Description: Which VPC would you like to use for Ec2 instance?
    Type: AWS::EC2::VPC::Id
    ConstraintDescription : VPC must exist
  PublicSubnet:
    Description: Which Pulic Subnet would you like to use for the Ec2 instance?
    Type: AWS::EC2::Subnet::Id
    ConstraintDescription : Subnet must exist
  DNSName1:
    Description: This domain name will be used for colecting data for service up time metric.
    Type: String
    Default: example1.com
  DNSName2:
    Description: This domain name will be used for colecting data for service up time metric. (optional)
    Type: String
    Default: example2.com
  DNSName3:
    Description: This domain name will be used for colecting data for service up time metric. (optional)
    Type: String
    Default: example3.com
  InstanceType:
    Type: String
    AllowedValues:
      - t2.micro
      - t2.small
      - t2.medium
    Default: t2.micro
    Description : Select Instance Type.
  AmiId:
    Description: Region specific AMI from the Parameter Store
    Type: AWS::SSM::Parameter::Value<AWS::EC2::Image::Id>
    Default: /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2
    ConstraintDescription: Please enter Amazon Linux AMI link
  GrafanaKeyPair:
    Description: Which SSH Key would you like to use for remote access to Ec2 instance?
    Type: AWS::EC2::KeyPair::KeyName
    ConstraintDescription : Key Pair must exist
  SSHSourceCidr:
    Description: Enter IPv4 address allowed to access your Grafana Host via SSH?
    Type: String
    Default: 0.0.0.0/0
    AllowedPattern: "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?).){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(/([0-9]|[1-2][0-9]|3[0-2]))?$"
    ConstraintDescription: The value must be valid IPv4 CIDR block.
# Provide additional information about the template.
Metadata:
  AWS::CloudFormation::Interface:
    ParameterGroups:
      - Label:
          default: "Monitor AWS resources witg Grafana"
        Parameters:
          - ProjectName
          - VpcID
          - PublicSubnet
          - DNSName1
          - DNSName2
          - DNSName3
          - InstanceType
          - AmiId
          - GrafanaKeyPair
          - SSHSourceCidr
    ParameterLabels:
      ProjectName:
        default: "Resources names"
      VpcID:
        default: "Select VPC"
      PublicSubnet:
        default: "Select Subnet"
      DNSName1:
        default: "Enter main URL"
      DNSName2:
        default: "Enter second URL (optional)"
      DNSName3:
        default: "Enter third URL (optional)"
      InstanceType:
        default: "Select instance type"
      AmiId:
        default: "Select instance AMI"
      GrafanaKeyPair:
        default: "Allowed SSH KEY"
      SSHSourceCidr:
        default: "Allowed IP addresses"
# Specifie the stack resources and their properties.
Resources:
  # Creat EC2 Instance for Docker running Grafana, InfluxDB and Telegraf.
  Grafana:
    Type: AWS::EC2::Instance
    Properties:
      KeyName: !Ref GrafanaKeyPair
      BlockDeviceMappings:
      - DeviceName: /dev/xvda
        Ebs:
          VolumeType: gp2
          VolumeSize: 16
      ImageId: !Ref AmiId
      InstanceType: !Ref InstanceType
      InstanceInitiatedShutdownBehavior: stop
      DisableApiTermination: false
      IamInstanceProfile: !Ref GrafanaIamProfile
      NetworkInterfaces:
      - AssociatePublicIpAddress: true
        DeviceIndex: "0"
        GroupSet:
        - !Ref GrafanaSecurityGroup
        SubnetId: !Ref PublicSubnet
      UserData:
        Fn::Base64: !Sub |
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
      Tags:
        - Key: Name
          Value: !Sub ${ProjectName}.Ec2
        - Key: Description
          Value: Grafana instance for testing and configuring simple one click monitoring solution.
  # Creat Security grop for allowing the ingres on port 3000 and 22.
  GrafanaSecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      VpcId: !Ref VpcID
      GroupName: !Sub ${ProjectName}.SG
      GroupDescription: Security group for Grafana
      SecurityGroupIngress:
      - IpProtocol: tcp
        FromPort: 22
        ToPort: 22
        CidrIp: !Ref SSHSourceCidr
      - IpProtocol: tcp
        FromPort: 80
        ToPort: 80
        CidrIp: 0.0.0.0/0
      Tags:
        - Key: Name
          Value: !Sub ${ProjectName}.Ec2.SG
  # Creat IAM profile for Grafana instance.
  GrafanaIamProfile:
    Type: AWS::IAM::InstanceProfile
    Properties:
      Path: "/"
      Roles: [!Ref GrafanaRole]
  # Creat Role for Grafana instance.
  GrafanaRole:
    Type: AWS::IAM::Role
    Properties:
      RoleName: !Sub ${ProjectName}.AllowMetricsRole
      AssumeRolePolicyDocument:
        Statement:
          - Effect: Allow
            Principal:
              Service: ec2.amazonaws.com
            Action: sts:AssumeRole
      ManagedPolicyArns:
        - arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore
  # Creat Policy for allowing metrics to be read with CloudWatch.
  GrafanaPolicy:
    Type: AWS::IAM::Policy
    Properties:
      PolicyName: !Sub ${ProjectName}.AllowMetricsPolicy
      PolicyDocument:
        Version: "2012-10-17"
        Statement:
          - Effect: Allow
            Action:
              - "cloudwatch:DescribeAlarmsForMetric"
              - "cloudwatch:DescribeAlarmHistory"
              - "cloudwatch:DescribeAlarms"
              - "cloudwatch:ListMetrics"
              - "cloudwatch:GetMetricData"
              - "cloudwatch:GetInsightRuleReport"
              - "logs:DescribeLogGroups"
              - "logs:GetLogGroupFields"
              - "logs:StartQuery"
              - "logs:StopQuery"
              - "logs:GetQueryResults"
              - "logs:GetLogEvents"
              - "ec2:DescribeTags"
              - "ec2:DescribeRegions"
              - "ec2:DescribeInstances"
            Resource: "*"
      Roles:
        - !Ref GrafanaRole
#Names and values for the resorces.
Outputs:
  GrafanaIP:
    Description: Grafana Public IP
    Value: !GetAtt Grafana.PublicIp
  GrafanaUser:
    Description: Default Grafana username
    Value: admin
  GrafanaPass:
    Description: Default Grafana password
    Value: admin
```