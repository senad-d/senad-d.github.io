---
title: AWS Database Service
date: 2021-03-14 12:00:00
categories: [AWS, AWS Basics]
tags: [aws, database]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/backgroun.png?raw=true){: .shadow }

## Amazon RDS

-   A relation database service that provides a simple way to provision, create, and scale a relational database
    
-   It's a managed service, removing many administrative operations
    
-   Support a range of different DB engines including MySQL / Amazon Azur / Oracle / SQL Server
    
-   Run across a range of computing sizes and types
    
-   Deploy your RDS instance in a single AZ, or Multi-AZ for HA
    
-   Multi-AZ configures a secondary RDS instance within a different AZ in the same region
    
-   The second instance acts as a failover for your primary RDS instance
    
-   The replication of data between the primary and secondary replicas happens synchronously
    
-   During failure, RDS will update the DNS record to point to the secondary instance
    
-   Aurora storage will scale automatically as your database grows
    
-   RDS provides an automatic backup feature
    
-   Manual backups can also be taken [[Delete RDS snapshots]]
    
-   Aurora backtrack allows you to go back in time on the database to recover from an error
    

### Multi-AZ Failover happens when:

-   Patching maintenance is performed in the primary instance
    
-   The primary database has a host failure
    
-   If the AZ of the primary database fails
    
-   If the primary instance was rebooted with failover
    
-   If the primary database instance class on the primary database is modified
    

## Amazon Aurora

-   Fully Managed
    
-   SQL - MySQL and PostgreSQL
    
-   Distribute, fault-tolerant, self-healing storage, system that auto-scale
    
-   Replication across 3 AZs
    
-   Up to 15 low-latency read replicas
    
-   Aurora Multi-Master
    
-   Aurora Serverless
    
-   Automated Failover
    
-   Point in time recovery
    
-   Continuous Backups to S3
    
-   Encryption at rest - KMS customer key
    
-   Encryption in transit - SSL
    

## Amazon DynamoDB

-   DaynamoDB is a NoSQL database
    
-   Designed to be used for ultra-high performance at any scale with single-digit latency
    
-   Used commonly for gaming and IoT
    
-   A fully managed service
    
-   Easy to configure, you can set a table name and primary key and accept all other defaults
    
-   Ability to set provisioned level of read and write capacity
    
-   DynamoDB global indexes let you query across the entire table to find any record that matches a particular value
    
-   Local secondary indexes can only help find data within a single partition key
    
-   DynamoDB will automatically allocate more space for your table as it grows
    
-   Encryption of your tablet is enabled by default for data at rest
    
-   Dana is automatically replicated across three different AZ's
    
-   DynamoDB will be fast no matter how large your table grows, unlike a relational database, which can slow down as the table gets large
    
-   Although DynamoDB performance can scale up as your needs grow, your performance is limited to the amount of read and write throughput that you've provisioned for each table
    

## Amazon ElastiCashe

-   ElastiCashe makes it easy to deploy, operate, and scale open-source, in-memory data stores in the cloud
    
-   Improves the performance through caching
    
-   ElastiCashe can be used for any application that can benefit from increased performance using an in-memory cache
    
-   Generally used to improve read-only performance
    
-   Supports both Memcached and Redis engines
    

-   Memcached:
    

-   A high-performance sub-millisecond latency Memcached-compatible in-memory key store service
    
-   Can either be used as a cache in addition to a data store
    
-   Recognized for its speed, performance, and its simplicity
    
-   Suits workloads where memory allocation is going to be consistent and the increased performance is more important than the additional features that Redis offers
    

### Amazon ElastiCache for Redis:

- Purely an in-memory data store designed for high performance and again provides sub-millisecond latency on a huge scale to real-time applications
    
- Offers a more robust set of features to that of Memcached