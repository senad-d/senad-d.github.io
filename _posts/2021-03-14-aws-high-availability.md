---
title: AWS High Availability
date: 2021-03-14 12:00:00
categories: [AWS, AWS Basics]
tags: [aws, high availability]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/backgroun.png?raw=true){: .shadow }

Designing for high availability, fault tolerance and cost efficiency

## Backup and DR Strategies

-   RTO  - recovery time objective - time it takes after a disruption to restore a business process to its service level
    
-   RPO -  recovery point objective - acceptable amount of data loss measured in time
    
-   Backup and restore - In the event of a disaster, archives can be recovered from Amazon S3, andthe data can then be restored directly to Cloud resources
    
-   Pilot light - In the event of a disaster, resources can be scaled up and out as and when needed
    
-   Warm Standby - In the event of a disaster, the standby environment will be scaled up for production mode, quickly and easily
    
-   Multi-Site - In the event of a disaster, traffic is redirected over to the AWS solution (AWS environment complete duplicate of your production environment) by updating the DNS record in Route 53
    

## Testing Recovered Data

#### The following steps outline the different fail-back approaches:

#### Backup and restore

 1. Freeze data changes to the DR site.

 2. Take a backup.

 3. Restore the backup to the primary site.

 4. Re-point users to the primary site

 5. unfreeze the changes.

#### Pilot light, warm standby, and multi-site

 1 . Establish reverse mirroring/replication from the DR site back to the primary site, once the primary site has caught up with the changes.

 2. Freeze data changes to the DR site.

 3. Re-point users to the primary site.

 4. Unfreeze the changes.

## High Availability vs Fault Tolerance

-   High Availability - maintaining a percentage of uptime which maintains operational performance
    
-   Fault - tolerant systems -  mirroring the environment from a single region to a 2nd region
    

## AWS DR Storage Solution

-   Largely down to the particular RTO and RPO for the environment you are designing
    
-   Depend on you as a business, and how you are operating with an AWS, and your connectivity to your AWS infrastructure
    

## Amazon S3 as a Data Backup Solution

-   S3 offers a great level of durability and availability of your data, which is perfect for DR use cases
    
-   From a DR point of view, you want to configure configuring Cross Region Replication to help with reduce latency of data retrieval and Governance and Compliance
    
-   From a performance perspective, S3 is able to handle multiple concurrent, and as a result, Amazon recommends that for any file that you're trying to upload to S3, larger than 100MB, than you should implement multipart upload
    
-   Multipart upload essentially allows you to upload a single large object by breaking it down into smaller contiguous chunks of dana
    
-   IAM Policies. These are identity and access management policies that can be used to both allow and restrict access to S3 buckets and objects at a very granular level depending on identities permissions
    
-   Bucket Policies. This are JSON policies assigned to individual buckets, whereas IAM Policies are permissions relating to an identity, a user group, or role. These Bucket Policies can also define who or what has access to that bucket's contents
    
-   Access Control Lists. These allow you to control which user or AWS account can access a Bucket or object, using a range of permissions, such as read, write, or full control, et cetera
    
-   Lifecycle Policies. Lifecycle Policies allow you to automatically manage and move data between classes, allowing specific data to be relocated based on compliance and governance controls you might have in place
    
-   MFA Delete. Multi-Factor Authentication Delete ensures that a user has to enter a 6 digit MFA code to delete an object, which prevents accidental deletion due to human error
    
-   Versioning. Enabling versioning on an S3 bucket, ensures you can recover from misuse of an object or accidental deletion, and revert back to an older version of the same data object. The consideration with versioning is that it will require additional space as a separate object is created for each version, so that's something to bear in mind
    

## AWS Snowball for Data Transfer

-   Physical appliance used to securely transfer large amounts of dana
    
-   The snowball appliance comes as either a 50 terabyte or 80 terabyte storage device
    
-   By default, all data transferred to the snowball appliance is automatically encrypted using 256-bit encryption keys generated from KMS
    
-   The appliance can also be tracked using the AWS Simple Notification Service with text messages or via the AWS Management Console
    
-   AWS Snowball is also HIPAA compliant allowing you to transfer protected health information in and out of S3
    
-   As a general rule, if your data retrieval will take longer than a week using your existing connection method, then you should consider using AWS Snowball
    

## AWS Storage Gateway for On-premise Data Backup

-   Allows you to provide a gateway between your own data center's storage systems such as your SAN, NAS or DAS and Amazon S3 and Glacier on AWS
    
-   Software appliance that can be stored within your own data center which allows integration between your on-premise storage and that of AWS
    
-   It offers file, volume and tape gateway configurations which you can use to help with your DR and data backup solutions
    
-   File gateways allow you to securely store your files as objects within S3. Using as a type of file share which allows you mount on map drives to an S3 bucket as if the share was held locally on your own corporate network
    
-   Stored volume gateways are often used as a way to backup your local storage volumes to Amazon S3 whilst ensuring your entire data library also remains locally on-premise for very low latency data access. Volumes created and configured within the storage gateway are backed by Amazon S3 and are mounted as iSCSI devices that your applications can then communicate with
    
-   Cached volume gateways are differed to stored volume gateways in that the primary data storage is actually Amazon S3 rather than your own local storage solution, cache volume gateways do utilize your local data storage as a buffer and the cache for recently accessed data to help maintain low latency
    
-   Gateway VTL allows you again to back up your data to S3 from your own corporate data center but also leverage Amazon Glacier for data archiving. Virtual Tape Library is essentially a cloud based tape backup solution replacing physical components with virtual ones
    
-   Storage Gateway. The gateway itself is configured as a tape gateway which as a capacity to hold 1500 virtual tapes.
    
-   Virtual Tapes. These are a virtual equivalent to a physical backup tape cartridge which can by anything from 100 gig to two and a half terabytes in size. And any data stored on the virtual tapes are backed by AWS S3 and appear in the virtual tape library.
    
-   Virtual Tape Library. VTL. As you may have guessed these are virtual equivalents to a tape library that contain your virtual tapes.
    
-   Tape Drives. Every VTL comes with ten virtual tape drives which are presented to your backup applications is iSCSI devices.
    
-   Media Changer. This is a virtual device that manages tapes to and from the tape drive to your VTL and again it's presented as an iSCSI device to your backup applications.
    
-   Archive. This is equivalent to an off-site tape backup storage facility where you can archive tapes from your virtual tape library to Amazon Glacier which as we already know, is used as a cold storage solution. If retrieval of the tapes are required, storage gateway uses the standard retrieval option which can take between 3 - 5 hours to retrieve your data.
    

## High availability in RDS

### RDS Multi AZ

-   That this is a feature that is used to help with resiliency and business continuity
    
-   When Multi-AZ is configured, a secondary RDS instance, known as a replica, is deployed within a different availability zone within the same region as the primary instance
    
-   Provides a failover option for a primary RDS instance
    
-   The replication of data between the primary RDS database and the secondary replica instance happens synchronously
    
-   Database engines use the failover mechanism when Multi-AZ is in use and configured
    
-   Oracle
    
-   MySQL
    
-   MariaDB
    
-   PostgreSQL
    
-   RDS updates the DNS record to point to the secondary instance within 60-120 seconds
    
-   This Failover process will happen in the following scenarios on the primary instance:
    
-   Patching maintenance
    
-   Host failure
    
-   Availability zone failure
    
-   Instance rebooted with Failover
    
-   DB instance class is modified
    

-   The RDS Failover triggers an event which is recorded as RDS-EVENT-0025 when the failover process is complete
    
-   These events are also recorded within the RDS Console
    
-   SQL Server Multi-AZ is achieved through the use of SQL Server Mirroring
    
-   Multi-AZ is available on SQL Server 2008 R2, 2012, 2014, 2016 and 2017 on both Standard and Enterprise Editions
    
-   SQL Mirroring provisions a secondary RDS instance in a separate AZ than that of the primary RDS instance to help vvith resilience and fault tolerance
    
-   Both primary and secondary instances in SQL Server mirroring use the same Endpoint
    
-   You need to ensure you have your environment configured correctly
    
-   A DB subnet group must be configured with a minimum of 2 different AZ's within it
    
-   You can specify which availability zone the standby mirrored instance will reside in
    
-   To check which AZ the standby instance is in you can use the AWS CLI command 'describe—db—instances'
    

-   Amazon Aurora is different to the previous DB engines when it comes to resiliency across more than a single AZ
    
-   Aurora DB clusters are fault tolerant by default
    
-   This is achieved within the cluster by replicating the data across different instances in different AZs
    
-   Aurora can automatically provision and launch a new primary instance in the event of a failure, which can take up to 10 minutes
    
-   Multi-AZ on an Aurora cluster allows RDS to provision a replica within a different AZ automatically
    
-   Amazon Aurora is different to the previous DB engines when it comes to resiliency across more than a single AZ
    
-   Should a failure occur, the replica instance is promoted to the new primary instance without having to wait 10 minutes
    
-   This creates a highly available and resilient database solution
    
-   It is possible to create up to 15 replicas if required, each with a different a priority
    

# Read Replicas 

-    A snapshot is taken from your database
    
-   Once the snapshot is completed, a read replica instance is created
    
-   The read replica maintains a secure asynchronous link between itself and the primary database
    
-   At this point, read-only traffic can be directed to the Read Replica
    
-   Read replicas are available for MySQL, MariaDB and PostgreSQL, DB engines, Amazon Aurora, Oracle, and SQL Server
    
-   It is possible to deploy more than one read replica for a primary DB
    
-   Adding more replicas allows you to scale your read performance to a wider range of applications
    
-   You are able to deploy read replicas in different regions
    
-   It is also possible to promote an existing read replica to replace the primary DB in the event of an incident
    
-   During any maintenance of the primary instance, read traffic can be served via your read replicas
    

## READ REPLICAS ON MYSQL

-   Read replicas are only supported where the source DB is running MySQL 5.6 or later
    
-   The retention value of the automatic backups of the primary DB needs to set to a value of 1 or more
    
-   Replication is also only possible when using an InnoDB storage engine, which is transactional
    
-   It is also possible to have nested read replica chains
    
-   A read replica replicates from your source DB and can then act as a source DB for another read replica
    
-   This chain can only be a maximum of 4 layers deep The same prerequisites must also apply to the source read replica
    
-   You can have up to a maximum of 5 read replicas per each source DB
    
-   If an outage occurs with the primary instance, RDS automatically redirects the read replica source to the secondary DB
    
-   Amazon Cloudwatch can monitor the synchronisation between the source DB and the read replica through a metric known as ReplicaLag
    

## READ REPLICAS ON MARIADB

-   You still need to have the backup retention period greater than O, and you can only have 5 read replicas per source DB
    
-   The same read replicas nesting rules apply and you also have the same monitoring metric for CloudVVatch
    
-   You can be running ANY version of MariaDB for read replicas
    

## READ REPLICAS ON POSTGRESQL

-   The automatic backup retention value needs to be greater than O and the limitation of read replicas is 5 per source DB
    
-   When using PostereSQL, you need to run version 9.3.5 or later for read replicas
    
-   The native PostereSQL streaming replication is used to handle the replication and creation of the read replica
    
-   The connection between the master and the read replica instance replicates data asynchronously between the 2 instances
    
-   PostereSQL allows you to create a Multi-AZ read replica instance
    
-   PostgreSQL does not allow nested read replicas
    
-   A role is used to manage replication when using PostgreSQL
    

# High Availability in Amazon Aurora

## Amazon Aurora:

-   AWS's fastest growing service
    
-   Database service with superior MySQL and PostgreSQL engine compliant service
    
-   Separates the compute layer from the storage layer
    
-   Separating the compute layer and storage layer from each other is a key architectural decision which allows you to dial up and down the availability of your data - mostly in the way that read replicas can be easily introduced and removed at will
    
-   The storage layer is shared amongst all compute nodes within the cluster regardless of the cluster configuration
    
-   Aurora can handle up to 3 copies lost for reads, and up to 4 copies lost for writes
    
-   The compute layer is implemented using EC2 instances
    
-   The storage layer is presented to the compute layer as a single logical volume
    

## Data Management RDS vs Aurora

-   When compared with RDS - the management of data from a replication viewpoint is fundamentally different
    
-   With RDS data needs to be replicated from the master to each of its replicas
    
-   Aurora on the other hand has no need for replication since it uses and shares a single logical volume amongst all compute instances.
    

## Aurora Data Consistency

-   Aurora uses a quorum and gossip protocol baked within the storage layer to ensure that the data remains consistent
    
-   Together the quorum and gossip protocol provide a continuous self healing mechanism for the data The peer to peer gossip protocol is used to ensure that data is copied across each of the 6 storage nodes
    
-   Aurora in general, and regardless of the compute layer setup - always provides 6 way replicated storage across 3 availability zones
    
-   Because of Aurora's storage layer design, Aurora is only supported in regions that have 3 or more availability zones
    
-   Aurora provides both automatic and manual failover of the master either of which takes approximately 30 seconds to complete
    

-   In the event that Aurora detects a master going offline, Aurora will either launch a replacement master or promote an existing read replica to the role of master, with the latter being the preferred option as it is quicker for this promotion to complete
    

## Connection Endpoints

-   Connection endpoints are created by the service to allow you to connect particular compute instances of the cluster
    
-   There are 4 different connection endpoint types:
    

## Cluster Endpoint:

-   The cluster endpoint points to the current master database instance. Using the Cluster endpoint allows your application to perform read and writes against the master instance.
    

## Reader Endpoint:

-   The reader endpoint load balancers connections across the read replica fleet within the cluster.
    

## Custom Endpoint:

-   A custom endpoint load balancer's connections across a set of cluster instances that you choose and register within the custom endpoint. Custom endpoints can be used to group instances based on instance size or maybe group them on a particular db parameter group. You can then dedicate the custom endpoint for a specific role or task within your organization - for example, you may have a requirement to generate month end reports - therefore you connect to a custom endpoint that has been specifically set up for this task.
    

## Instance Endpoint:

-   An instance endpoint maps directly to a cluster instance. Each and every cluster instance has its own instance endpoint. You can use an instance endpoint when you want fine-grained control over which instance you need to service your requests
    

## General Points

-   Read intensive workloads should connect via the reader endpoint
    
-   Reader and Custom connection endpoints are designed to load balance connections across their members
    
-   Connection endpoint load balancing is implemented internally using Route 53 DNS
    
-   Be careful in the client layer not to cache the connection endpoint lookups longer than their specified TTLs
    
-   Connection endpoints are mostly applicable and used in "Single Master with Multiple Read Replica" setups
    

## Aurora Single Master - Multiple Read Replicas

-   This type of cluster supports being stopped and started manually in its entirety
    
-   When you stop and start a cluster, all underlying compute instances are either stopped or started
    
-   When stopped the cluster remains stopped for up to 7 days, after which it will automatically restart
    
-   Daily backups are automatically performed with a default retention period of 1 day and for which can be adjusted up to a maximum retention period of 35 days
    
-   Additionally on-demand manual snapshots can be performed on the database at any time
    
-   Manual snapshots are stored indefinitely until you explicitly choose to delete them. Restores are performed into a new database
    

## Aurora Single Master

-   Replication of data is performed asynchronously in milliseconds - fast enough to give the impression that replication is happening synchronously
    
-   Read replicas can be deployed in different availability zones within the same VPC or if required can be launched as cross region replicas
    
-   Each read replica can be tagged with a label indicating priority in terms of which one gets promoted to the role of master in the event of the master going down
    
-   The master can be rebooted in 60 or less seconds
    

## Aurora Multi Master

-   An Aurora multi master setup leverages 2 compute instances configured in active-active read write configuration
    
-   This configuration deploys an active-active pair of compute instances, each instance being deployed into different availability zones.
    
-   If an instance outage occurs in one availability zone, all database writes can be redirected to the remaining active instance - all without the need to perform a failover
    
-   A maximum of 2 compute instances can be configured currently as masters in a multi master cluster
    
-   You can not add read replicas to a multi master cluster
    
-   Load balancing connection logic must be implemented and performed within the client
    

## Aurora Serverless

-   Aurora Serverless is an elastic solution that auto-scales the compute layer based on application demand and only bills you when it's in use
    
-   Aurora Serverless is ideally suited for applications that exhibit variable workloads and/or have infrequent data accessing and modification needs
    
-   When provisioning an Aurora Serverless database you need to configure lower and upper limits for capacity
    
-   Capacity is measured in ACUs - which stands for Aurora Capacity Units
    
-   Aurora will continually adjust and optimize capacity based on incoming demand - and will stay within the limits specified
    
-   The underlying compute instances are automatically started and stopped based on the current demand
    
-   Instances can be cold-booted in a matter of seconds
    
-   If the traffic starts to drop off it will begin scaling down, and if enabled, actually shut down the computer entirely when there's no demand for it
    
-   When the computer is turned off, you only end up paying for the storage capacity used
    
-   An Aurora Serverless database is configured with a single connection endpoint which makes sense - given that it is designed to be serverless - this endpoint is used for both reading and writes
    
-   Web Service Data API feature - available only on Aurora Serverless databases
    
-   The Web Service Data API makes implementing Lambda functions that need to perform data lookups and or mutations within an Aurora serverless database a breeze
    
-   Aurora Serverless performs a continuous automatic backup of the database with a default retention period of 1 day - which can be manually increased to a maximum retention period of 35 days
    
-   Backup gives you the capability of restoring to a point in time within the currently configured backup retention period
    
-   Restores are performed to a new serverless database cluster
    

## High Availability in DynamoDB

## DynamoDB

-   NoSQL schemaless managed service
    
-   Built and provided by AWS
    
-   DynamoDB performance is constant and stays consistent even with tables that are many terabytes in size
    
-   Designed internally to automatically partition data and incoming traffic across multiple partitions
    
-   Partitions are stored on numerous backend servers distributed across three availability zones within a single region
    
-   A DynamoDb partition is a dedicated area of SSD storage allocated to a table and which is automatically replicated synchronously across 3 availability zones within a particular region
    
-   DynamoDB takes care of performing both the partition management and replication for you
    
-   The synchronous AZ replication protects against any single node outage and/or a full availability zone outage
    
-   The synchronous replication takes place using low latency interconnects between each of the availability zones within a region and ensures high-speed sub-second replication
    
-   Dialing up and down the provisioned throughput of a DynamoDB database is possible, and ensures that your DynamoDB database can meet the needs of your application as it grows
    
-   DynamoDB provides a secondary layer of availability in the form of cross-region replication (Global Tables)
    
-   A Global table gives you the capability to replicate a single table across 1 or many alternate regions
    
-   A Global Table elevates the availability of your data and enables applications to take advantage of data locality
    
-   Users can be served data directly from the closest geographically located table replica
    
-   A single DynamoDB table can be globally replicated to 1 or multiple other tables located in different AWS regions
    
-   Replication must take place within an AWS account - that is you cannot configure Global tables in different AWS accounts
    
-   Global Tables implement multi-master read/write capability with eventual consistency. Both read and write can be performed against any one of the configured global tables. All writes will then be replicated in near sub-second to time to all other globally configured tables of the same table name
    
-   Existing DynamoDB tables can be converted into Global tables either by using the relevant configuration options exposed within the AWS DynamoDB console - or by using the aws cli and executing the “aws dynamodb update-table” command specifying one or several regions into which the table should be replicated
    

### On-Demand Backup and Restore

-   On-demand backups allow you to request a full backup of a table, as it is at the very moment the backup request is made
    
-   On-demand, backups are manually requested and can be performed either through the AWS DynamoDB console or by using the AWS CLI
    
-   Scheduling on-demand backups provides you with the ability to restore table data to a point in time
    
-   On-demand, backups remain in the account until they are explicitly requested to be deleted by an administrator
    
-   Backups typically finish within seconds and have zero impact on the table performance and availability
    

### On-demand, backups are useful in the following situations:

-   Table corruption - rare but possible
    
-   Long-term regulatory, compliance, and/or auditing data requirements
    
-   Testing scenarios
    

### Point in Time Recovery

-   Point In Time Recovery or PITR - is an enhanced version of the on-demand backup and restore feature, providing you with the ability to perform point-in-time recoveries
    
-   Point In Time Recovery operates at the table level, and when enabled provides you with the ability to perform a point-in-time recovery for any time between the current time and the last 35 days
    
-   The restoration will always be performed into a new table - of which you specify the new table name at the time of restoration request
    
-   Table restoration can be performed in the same region as the original table, or in a different region altogether
    
-   This feature is extremely handy in situations when you’re modifying data and wants a safety net in place for the situation where your data modifications didn’t result in the way they should have
    

## DynamoDB Accelerator (DAX)

-   DAX is an in-memory cache delivering a significant performance enhancement, up to 10 times as fast as the default DynamoDB settings, allowing response times to decrease from milliseconds to microseconds
    
-   It is a fully managed feature offered by AWS and as a result, is also highly available
    
-   Dax is also highly scalable making it capable of handling millions of requests per second without any requirement for you to modify any logic to your applications or solutions
    
-   Your DAX deployment can start with a multi-node cluster, containing a minimum of 3 nodes, which you can quickly and easily modify and expand, reaching a maximum of 10 nodes, with 1 primary and 9 read replicas. This provides the ability to handle millions of requests per second
    
-   Your DAX deployment can start with a multi-node cluster, containing a minimum of 3 nodes, which you can quickly and easily modify and expand, reaching a maximum of 10 nodes, with 1 primary and 9 read replicas
    
-   It can also enable you to reduce your provisioned read capacity within DynamoDB
    
-   Reducing the provisioned requirements on your DynamoDB DB will also reduce your overall costs
    
-   From a security perspective, DAX also supports encryption at rest. This ensures that any cached data is encrypted using the 256-bit Advanced Encryption
    
-   Standard algorithm with the integration of the Key Management Service (KMS) to manage the encryption keys
    
-   DAX is a separate entity from DynamoDB and so architecturally it sits outside of DynamoDB and is placed within your VPC, whereas DynamoDB sits outside of your VPC and is accessed via an endpoint
    
-   DAX will deploy a node in each of the subnets of the subnet group, with one of those nodes being the primary and the remaining nodes will act as read replicas
    
-   To allow your EC2 instances to interact with DAX you will need to install a DAX Client on those EC2 instances
    
-   This client then intercepts and directs all DynamoDB API calls made from your client to your new DAX cluster endpoint, where the incoming request is then load balanced and distributed across all of the nodes in the cluster
    
-   You must ensure that the security group associated with your DAX Cluster is open to TCP port 8111 on the inbound rule set
    
-   If a request received by DAX from your client is a read request, such as a GetItem, BatchGetItem, Query, or Scan, then the DAX cluster will try and process the request if it has the data cached
    
-   If DAX does not have the request in its cache (a cache miss) then the request will be sent to DynamoDB for the results to be returned to the client
    
-   These results will also then be stored by DAX within its cache and distributed to the remaining read replicas in the DAX cluster
    
-   With regards to any write request made by the client, the data is first written to DynamoDB before it is written to the cache of the DAX cluster
    
-   DAX does not process any requests relating to table operations and management, for example, if you wanted to create, update, or delete tables