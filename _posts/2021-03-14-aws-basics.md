---
title: AWS Basics
date: 2021-03-14 11:00:00
categories: [AWS, AWS Basics]
tags: [aws, basics]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>

![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/backgroun.png?raw=true){: .shadow }
## Amazon EC2 instance
-   Amazon EC2 provides scalable computing capacity in the AWS Cloud
    
-   On-demand instances
    
-   Reserved instances
    
-   Scheduled instances
    
-   Spot instances
    
-   On-demand capacity reservations
    
-   2 types of storage, Ephemeral and EBS
    
-   Key pairs are used to encrypt the credentials to the instance
    
-   Allows you to automatically increase or decrease your EC2 resources to meet the demands
    

## AMI's & Instance types
-   AMIs are digital templates of pre-configured EC2 instance
    
-   Instance types are defined by different parameters and their values
    

## Elastic Load Balancer
-   ELBs help control the flow of inbound requests destined for a group of targets
    
-   Application ELB
    
-   Classic Load Balancer
    
-   Network Load balancer
    

## EKS - Elastic Container Service for Kubernetes
-   Kubernetes -  open-source container orchestration tool designed to automate, deploy, scale, and operate containerized applications
    

## AWS Lambda
-   AWS Lambda is a serverless computing service designed to run application code without having to manage and provision your EC2 instances
    

---

# AWS Storage

## Persistence of data with EC2 instances:
-   EBS volumes
    
-   Block storage
    
-   EBS snapshots as backups
    
-   Encryption is possible with EBS
    

## Network file systems:
-   EFS
    
-   NFS protocol
    
-   Mount points for connecting your EC2 instances
    
-   Encryption in transit and at-rest
    
-   Thousands of concurrent connections
    

## Windows files systems using Server-Message-Block
-   Amazon FSx for Windows
    
-   File systems for HPC using Linux instances - Amazon FSx
    

-   Backups between your data center and AWS using S3 or Glacier
    
-   AWS Storage Gateway! Either using File, Volume or Tape Gateways
    

---

# AWS Networking

## Virtual Private Clouds (VPCs)
-   A VPC resides inside of the AWS Cloud and it's essentially your own isolated segment of the AWS Cloud itself
    
-   Subnets: Used to segment your VPC into multiple networks
    
-   Security Groups: Filter traffic both inbound and outbound at the instance level
    
-   NACLs: Virtual network-level firewalls associated to subnets
    
-   Internet Gateway (IGW): A managed component that can be attached to your VPC
    
-   NAT Gateway: NAT GW allows private resources to access the internet
    

## Virtual Private Network (VPN)
-   To enable communications between VPC resources and those in a data centre you can use a VPN connection across the public internet
    

## Direct Connect
-   Direct Connect enables you to create a private connection between your data centre and an AWS region, not just a VPC
    

## VPC Endpoint
-   Interface Endpoint
    
-   Gateway Endpoint
    

## Elastic IP Address (EIP)
-   ElPs provide a persistent public IP address that you can associate with your instance
    

## Elastic Network Interfaces (ENI)
-   ENIs are logical virtual network cards within your VPC
    

## Elastic Network Adapter (ENA)
-   Provides enhanced networking features to reach speeds of up to 100 Gbps for your Linux compute instances
    

## AWS Global Accelerator
-   Allows you to get UDP and TCP traffic from your end user clients to your applications faster, quicker and more reliably using the AWS global infrastructure and specified endpoints
    

## Amazon Route 53
-   A highly available and scalable DNS, providing secure and reliable routing of requests
    

## Amazon CloudFront
-   Speeds up distribution of static and dynamic content through its worldwide network of edge locations providing low latency to deliver the best performance through cached data
    

---

# AWS Database Service

## Amazon RDS
-   A relation dartabase service that provides a simple way to provision, create, and scale a relational database
    

## Amazon Aurora
-   SQL - MySQL and PostgreSQL
    

## Amazon DynamoDB
-   DaynamoDB is a NoSQL database, designed to be used for ultra high preformance at any scale with single-digit latency, used comonly for gameing and IoT
    

## Amazon ElastiCashe
-   Improves the preformance through caching
    

---

# AWS Security

## AWS IAM:
-   Centrally manage and control security permissions for any identity requiring access to your AWS account and its resources
    

## AWS WAF:
-   Protection for your web apps or CloudFront distributions from common attack patterns (SQL Injection / Cross Site scripting)
    

## AWS Firewall Manager:
-   WAF managed between multiple AWS organizations
    

## AWS Shield:
-   Protection from DoS/DDoS attacks
    

## AWS Cognito:
-   Web and Mobile federated access
    

---

# AWS Encryption

## Key Management Service (KMS)
-   The Key Management Service is a managed service used to store and generate encryption keys
    

## AWS CloudHSM
-   A physical tamper-resistant hardware appliance that is used to protect and safeguard cryptographic material and encryption keys
    

## S3 Encryption Mechanisms
-   Server-side Encryption and Client-Side Encryption
    
-   SSE-S3, SSE-KMS, SSE-C and CSE-KMS, CSE-C
    

---

# AWS Architecture / Well-Architected Framework

## Simple Queue Service
-   It is a service that handles the delivery of messages between components
    
-   Simple Queue Service, Visibility Timeout, SQS Standard Queues, SQS FIFO Queues, Dead-Letter Queue
    

## Simple Notification Service
-   Users or endpoints can subscribe to this topic, where messages or events are published
    
-   SNS uses the concept of publishers and subscribers
    

## Stream Processing
-   Stream processing is used to collect, process, and query data in either real time or near real time to detect anomalies, generate awareness, or gain insight
    
-   Batch processing, Stream Processing, Never-ending Data, Limited Storage Capacity, Streams Flow With Time, Reactions in Real Time, Decoupled Architectures Improve Operational Efficiency
    

## Amazon Kinesis
-   Kinesis makes it easy to collect, process, and analyze various types of data streams such as event logs, social media feeds, clickstream data, application data, and IoT sensor data in real time or near real-time
    
-   Kinesis Video Streams
    
-   Kinesis Data Streams
    
-   Kinesis Data Firehose
    
-   Kinesis Data Analytics
    

---

# High Availability

## Backup and DR Strategies
-   RTO  - recovery time objective - time it takes after a disruption to restore a business process to its service level
    
-   RPO -  recovery point objective - acceptable amount of data loss measured in time
    
-   Pilot light, Warm Standby and Multi-Site
    

## High Availability vs Fault Tolerance
-   High Availability - maintaining a percentage of uptime which maintains operational performance
    
-   Fault - tolerant systems -  mirrorng the environment from a single region to a 2nd region
    

## AWS DR Storage Solution
-   Largely down to the particular RTO and RPO for the environment you are designing
    
-   Depend on you as a business, and how you are operating with an AWS, and your connectivity to your AWS infrastructure
    

## Amazon S3 as a Data Backup Solution
-   Bucket Policies, Access Control Lists, Lifecycle Policies, Multi-Factor Authentication Delete, Versioning and IAM Policies
    

## AWS Snowball for Data Transfer
-   Physical appliance used to securely transfer large amounts of dana
    

## AWS Storage Gateway for On-premise Data Backup
-   Allows you to provide a gateway between your own data center's storage systems such as your SAN, NAS or DAS and Amazon S3 and Glacier on AWS
    

# High availability in RDS

## RDS Multi AZ
-   When Multi-AZ is configured, a secondary RDS instance, known as a replica, is deployed within a different availability zone within the same region as the primary instance
    

## Read Replicas
-   Read-only traffic can be directed to the Read Replica
    
-   Read replicas are available for MySQL, MariaDB and PostgreSQL, DB engines, Amazon Aurora, Oracle, and SQL Server
    

## High Availability in Amazon Aurora
-   Database service with superior MySQL and PostgreSQL engine compliant service
    
-   Separates the compute layer from the storage layer
    
-   In the event that Aurora detects a master going offline, Aurora will either launch a replacement master or promote an existing read replica to the role of master, with the latter being the preferred option as it is quicker for this promotion to complete
    

## Aurora Single Master - Multiple Read Replicas
-   This type of cluster supports being stopped and started manually in its entirety
    

## Aurora Single Master
-   Replication of data is performed asynchronously in milliseconds - fast enough to give the impression that replication is happening synchronously
    

## Aurora Multi Master
-   An Aurora multi master setup leverages 2 compute instances configured in active-active read write configuration
    

## Aurora Serverless
-   Aurora Serverless is an elastic solution that autoscales the compute layer based on application demand, and only bills you when it's in use
    

## High Availability in DynamoDB
-   DynamoDB provides a secondary layer of availability in the form of cross region replication (Global Tables)
    

## On-Demand Backup and Restore
-   On demand backups allow you to request a full backup of a table, as it is at the very moment the backup request is made
    

## Point in Time Recovery
-   Point In Time Recovery or PITR - is an enhanced version of the on-demand backup and restore feature, providing you with the ability to perform point in time recoveries
    

## DynamoDB Accelerator (DAX)
-   DAX is an in-memory cache delivering a significant performance enhancement, up to 10 times as fast as the default DynamoDB settings, allowing response times to decrease from milliseconds to microseconds
    

---

# AWS Management

## Amazon CloudWatch:
-   If you need to monitor the health of different resources, set alerts, gather metrics
    

## AWS CloudTrail:
-   If you need to capture API calls being made across your AWS account
    

## AWS Config:
-   If you need to monitor, manage, and assess the configurational state of your resources
    

## AWS Organizations:
-   If you need to set up management and security controls across a multi AWS account level
    

## VPC Flow Logs:
-   If you need to capture network traffic at an interface, subnet or VPC level and review the logs in CloudWatch

---

Link: Creating new Stack, Creating an AWS Account, List all resources in AWS
