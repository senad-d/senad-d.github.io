---
title: AWS Storage
date: 2021-03-14 12:00:00
categories: [Cloud, AWS]
tags: [aws, storage]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/backgroun.png?raw=true){: .shadow }

## Persistence of data with EC2 instances:

-   EBS volumes
    
-   Block storage
    
-   EBS snapshots as backups
    
-   Encryption is possible with EBS
    

## Network file systems:

-   EFS
    
-   NFS protocol
    
-   Mount points for connecting your EC2 instances
    
-   Multiple availability zones
    
-   Encryption in transit and at-rest
    
-   Thousands of concurrent connections
    

## Windows files systems using Server-Message-Block

-   Amazon FSx for Windows
    
-   File systems for HPC using Linux instances - Amazon FSx
      

## Backups between your data center and AWS using S3 or Glacier

-   AWS Storage Gateway! Either using File, Volume, or Tape Gateways
    

# Amazon Simple Store Service (S3)

-   Promoted as having unlimited storage capabilities making Amazon S3 extremely scalable
    
-   Limitations on the individual size of a single file that it can support. The smallest file size that it supports is zero bytes and the largest file size is five
    

## Storage Classes:

-   S3 Standard:
   Considered a general-purpose storage class. ideal for a range of use cases where you need high throughput/low latency with frequent access to your data
    

-   S3 Intelligent Tiering:
   Used when the frequency of access is unknown. Depending on your data access patterns it will move your objects between frequent and infrequent access tiers, optimizing storage costs automatically
    

-   S3 Standard infrequent access:
   Designed for data that does not need to be accessed frequently, yet still offers high throughput/low latency access
    

-   S3 One Zone Infrequent Access:
   Being an infrequent storage class it is designed for objects that are unlikely to be accessed frequently. Durability remains at 11 9's but only across a single AZ
    

# Amazon Glacier

## S3 Glacier:

-   The default Standard storage class within S3 Glacier offers a highly secure using in-transit and at-rest encryption low-cost and durable storage solution. Offers a variety of retrieval options depending on how urgently you need the data back, each offering a different price point.
    

## S3 Glacier Deep Archive:

-   The cheapest of all options focuses on long-term storage.
    

## S3 Glacier Retrieval Options:

-   Expedited:
   Used for urgent requirements which can be made available to you in 1- 5 minutes if your data being retrieved is below 250MB. This is the most expensive retrieval option
    

-   Standard:
   Can retrieve any of your archives regardless of size. Data available in 3 - 5 hours
    

-   Bulk: 
  Used to retrieve petabytes of data at a time and takes between 5 - 12 hours. This is the cheapest Of the retrieval options
    

# Lifecycle Rules:

-   It provides an automatic method of managing the life of your data while it is being stored on Amazon S3
    
-   Ability to configure and set specific criteria that will automatically move your data from one class to another for cost optimization or compliance
    
-   Once enabled on a bucket it can only be suspended, not disabled
    

# Transfer Acceleration:

-   Use transfer acceleration to speed up long-distance S3 data transfers.
    
-   Uses Edge locations to distribute traffic worldwide
    

## S3 operations not supported by transfer acceleration

-   GET Service (list buckets)
    
-   PUT Bucket (create bucket)
    
-   DELETE Bucket
    
-   Cross-region copies using PUT Object - Copy
    

# S3 Versioning

-   Allows for multiple versions of the same object to exist Retrieve previous versions of a file, or recover a deleted file
    
-   Versioning is not enabled by default, however, once you have enabled it, you can't disable it, you can only suspend it
    
-   Additional storage costs as you are storing multiple versions of the same file
    

# S3 Security

-   Access to S3 resources can be controlled both identity-based policies and resource-based policies
    
-   Identity-based policies are attached to the IAM identity requiring access
    
-   Resource-based pdicies are associated witl S3 bucket
    
-   Bucket policies are attached to buckets an require a 'Principal' which defines the identity the permissions apply to
    
-   Can grant cross-account access using bucket pdicies having to create and assume roles that are created within IAM
    
-   You use both IAM pdicies and bucket policies to control access
    
-   S3 Access Control Lists allow you to control access to buckets in addition to specific objects within a bucket by groupings and AWS accounts
    
-   It is not possible to implicitly deny access using ACLs
    
-   All policies will be evaluated together to determine the resulting access in accordance with the principle of least privileged
    
-   By default all public access is blocked
    
-   Cross Origin Resource Sharing, allows specific resources on a webpage to be requested from a different domain than its own
    
-   You can uilize CORS support to access resources stored in S3
    

# Amazon Elastic File System (EFS)

-   EFS is a fully managed, highly available and durable service that allows you to create shared file systems that can easily scale to petabytes in size with low latency access.
    

## There are 2 different storage classes of EFS:

### EFS standard

### EFS Infrequent Access (EFS-IA)

-   A cost saving of up to 92% can be achieved with EFS-IA
    
-   With EFS-IA there is an increased first-byte latency impact when both and writing data
    

# Lifecycle Management:

-   EFS Will automatically move data between Standard storage and EFS-IA storage class
    
-   Occurs when a file Fns not been read or written to for a set period of days
    
-   EFS will move the data to the IA storage class to save on cost once that period has been met. If the same file is accessed agaim the timer is reset, and it is moved back to the Standard storage class.
    

# Encryption:

-   EFS supports both encryption at rest and encryption in transit
    
-   Encryption at rest is managed by integrating with KMS
    

# Performance & Throughput

-   2 performance modes:
    
-   General Purpose - performance and is typically used for most use case
    
-   Max I/O - offers virtually unlirnited amounts of throughput and IOPS
    
-   2 throughput modes - measured by the rate of mebibytes.
    
-   Bursting Throughput - the default mode, the amount of throughput scales as your file system grows. So the more you store, the more throughm't is available to you
    
-   Provisioned Throughput - allows you to burst above your allocated allowance. -Which is based upon your file system size
    
-   Uses AWS Data Sync to migrate data into EFS
    

# Elastic Block Store (EBS)

## Block Level storage

### 1. SSD backed storage

### 2. HDD backed storage

-   Data is persistent and durable, even if you terminate/restart an EC2 instance
    
-   Provisioned IOPS (input'output operations per second)
    
-   Flexibility - The volume can be elastically scaled within the console or via the AWS CLI.
    
-   They can only be attached to resources within the same AZ
    
-   Ability to create point in time snapshots either manually or using Amazon CloudWatch Events
    
-   Volumes can be encrypted using the KMS service
    

# Snapshots:

-   EBS offers the ability to provide point in time backups of the entire volume as and when you need to using snapshots
    
-   Can be manually invoked at any time
    
-   Can be automated on a recurring schedule using Amazon CloudWatch events
    
-   Snapshots are stored on Amazon S3 and so are very durable and reliable
    
-   Snapshot backups are incremental, so each snapshot will only copy data that has changed since the previous snapshot was taken
    
-   A new volume can be created from an existing snapshot
    
-   You can copy a snapshot from one region to another
    
-   Any snapshot taken from an encrypted volume will also be encrypted
    
-   Any volume created from an encrypted volume will be encrypted
    
-   You cant create an encrypted snapshot from an unencrypted volume
    
-   You can't create an unencrypted snapshot of an encrypted volume
    

# FSx Amazon FSx

-   Amazon FSx is another storage service that focuses on file systems
    
-   FSx comes in 2 forms, Amazon FSx for Windows File Server, and Amazon FSx for Lustre
    
-   Each FSx option has been designed for very different needs and requirements
    

# Amazon FSx for Windows File Server

-   Provides a fully managed native Microsoft Windows File system on AWS
    
-   Easily move and migrate your windows-based workloads requiring file storage
    
-   The solution is built on Windows Server
    
-   Operates as shared file storage
    
-   Uses SSD storage for enhanced performance and throughput providing sub-millisecond latencies
    

## Full support for:

-   SMS Protocol
    
-   Windows NTFS
    
-   Active Directory integration
    
-   Distributed File System
    
-   ## Amazon FSx for Lustre
    
-   A fully managed file system designed for compute-intensive workloads, for example, Machine leaming and HPC
    
-   Ability to process massive data sets
    
-   Performance can run up to hundreds of GB per second throughput, millions of IOPS, and sub-millisecond latencies
    
-   Integration with Amazon S3
    
-   Supports cloud-bursting workloads from on-premises over Direct Connect and VPN connections


# AWS Storage Gateway
    
### 1. File
    
### 2. Volume (Stored volume and cached volume)
    
### 3. Tape gateway


# Stored volume gateways:

-   Often used as a way to back up your local storage volumes to S3 whilst ensuring your entire data library also remains locally on-premise for very low latency data access. Volumes are backed by Amazon S3
    
-   Volumes are mapped to your on-premise storage devices
    
-   Data is written to your local storage services (NAS, SAN, or DAS) and then asynchronously copied to S3 as EBS snapshots
    
-   Having your entire data set remain locally ensures you have the lowest latency possible to access your data
    
-   A buffer is used as a staging point for data that is waiting to be written to S3
    

# File gateways:

-   Allow you to securely store your files as objects within S3.
    
-   Mount or map drives to an S3 Bucket as if the share was held locally on your corporate network.
    
-   Files are sent to S3 over HTTPS and encrypted SSE-S3
    
-   A local on-premise cache is provisioned for accessing your most recently accessed files to optimize latency
    

# Cached volume gateways:

-   The primary data storage is on S3 rather than your local storage solution
    
-   Cached gateways utilize your data storage as a buffer and a cache for recently accessed data
    
-   The volumes themselves are backed by the Amazon S3
    

# Tape gateway:

-   Known as gateway VTL, virtual tape library
    
-   Backup your data to S3 from your own data center leveraging Amazon Glacier for data archiving
    
-   Essentially a cloud-based tape backup solution, replacing physical components with virtual ones.
    

# Amazon S3

-   used for storage of large files such as video files, images, static websites, and backup archive
    
-   Object-based storage service
    
-   Bucket - container for your data

# Amazon Elastic File System

-   allows you to store files that are accessible to a network resource
    
-   considered file-level storage
    
-   supports access by multiple EC2 instances at once
    
-   supports both NFS versions 4.1 and 4.0

# EC2 Instance Storage

-   the volumes physically reside on the same host that provides your EC2 instance itself
    
-   ephemeral storage for your EC2 instances
    
-   block-level storage
    

# Amazon Elastic Block Store (EBS)

-   persistent and durable block-level storage
    
-   used for data that is rapidly changing that might require specific Input/Output operations Per Second rate
    
-   provide point in time backups of the entire volume (snapshots)
    
-   SSD-backed storage - works with smaller blocks, and boot volumes for your EC2 instances
    
-   HDD-backed volumes - a higher rate of throughput, processing big data and logging information

# Amazon FSx

-   FSx for Windows File Server - operates as shared file storage, SMB protocol, Windows NTFS, Active Directory (AD) integration, and Distributed File System (DFS)
    
-   Amazon FSx for Lustre - compute-intensive workloads, supports cloud-bursting workloads from on-premises over Direct Connect and VPN connections

# AWS Storage Gateway

-   provide a gateway between your own data center's storage systems such as your SAN, NAS, or DAS and Amazon S3 and Glacier
    
-   File Gateways - a type of file share allowing you to mount or map drives to an S3 bucket as if the share was held locally on your corporate network
    
-   Volume Gateways -
    

-   Stored volume gateways -  backup your local storage volumes to Amazon S3 as EBS snapshots
    
-   Cached volume gateways - primary data storage is actually on Amazon S3 rather than your local storage solution
    
-   Tape Gateways - back up your data to S3 from your own corporate data center in addition to being able to leverage the storage classes within Glacier for data archiving for a far lower cost than S3
    
## Amazon Backup

-   acts as a central hub to manage backups across your environment, across multiple regions, centralizing management and providing full auditability in addition to assisting with specific compliance controls