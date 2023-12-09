---
title: AWS Compute
date: 2021-03-14 12:00:00
categories: [AWS, Basics]
tags: [aws, compute]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/backgroun.png?raw=true){: .shadow }

## Amazon Machine Images:

-   AMI's are digital templates of pre-configured EC2 instances allowing you to quickly launch a new instance
    
-   You have the choice of AWS-managed, custom, marketplace, and community AMI's
    

## Instance Types:

-   Instance types are defined by different parameters and their values, such as the amount of memory, network performance, storage, etc
    
-   As your instance type gets bigger, the parameter values (vCPU, storage, network performance) also increase
    
-   Some instances only support EBS and do not have support for ephemeral storage
    
-   General purpose instances give a good balance of computing, memory, and networking resources, so it's great for lots of different use cases
    
-   Compute-optimized instances are designed for compute-intensive workloads requiring high-performance processors
    
-   Memory-optimized instances help you deliver super-fast performance for processing data sets in memory
    
-   Accelerated computing instance types use hardware accelerators which are great for graphics and data pattern matching
    
-   Storage-optimized instances maintain low latency IOPS and read and write across to massive data sets locally
    

## EC2 Purchase Options

## On-demand instances:

-   Can be launched at any time
    
-   Provisioned and available within minutes
    
-   No duration limit
    
-   A flat cost rate paid by the second
    
-   Suitable for short term workloads
    
-   Used for irregular an interruptible workloads
    
-   Stop paying when the resource is stopped or terminated
    

## Spot instances:

-   Bid for unused EC2 compute resources huge cost savings can be achieved
    
-   There is no assurance that you will have spot instances for a fixed period of time
    
-   The instance is purchased when your bid price is higher than the fluctuating spot price
    
-   Spot price fluctuates depending on supply and demand of the unused resource
    
-   If your bid price drops below spot price a two-minute wami'ng is issued before the instance automatically terminates
    
-   Useful for workloads that can be suddenly interrupted
    

## Reserved instances:

-   Purchase instances at a discounted rate over a 1 or 3-year period
    
-   Savings can be as much as 75% compared to on-demand
    
-   All Upfront payment allows you to pay the entire resource for the single or 3-year period, and provides the biggest discount
    
-   Partial Upfront payment allows you to pay a smaller portion upfront and then a discount is applied to any hours used by the instance
    
-   No Upfront payment gives the smallest discount of the 3 options
    
-   Used for long-term predictable workloads
    

## Scheduled Instances:

-   Pay for the reservation of an instance on a recurring schedule, either daily, weekly or monthly
    
-   You are charged for the instance even if you don't use it
    
-   Used to run scheduled workloads that are not continuously running
    

## Capacity reservations

-   Reserve capacity for EC2 instances based on attributes such as instance type, platform and tenancy etc
    
-   Reserved within a particular availability zone for any period of time
    
-   Ensures you have capacity when its required
    
-   Can also be used in conjunction with your reserved insta providing you additional savings
    

## EC2 Tenancy

-   Tenancy relates to how many custorners are using the underlying hardware that your EC2 instance is running on
    
-   By default, your instance will be configured to run on shared tenancy
    
-   Dedicated tenancy ensures that your AWS account is the only customer to run EC2 instances on a single host
    
-   Dedicated tenancy can be used to meet security compliance controls
    
-   Dedicated tenancy comes at an increased cost
    
-   Dedicated hosts have the same principle as the dedicated instance, but provides additional flexibility and control
    
-   Dedicated hosts provide EC2 instance placement control and host recovery
    

## EC2 Storage

-   2 types of storage, Ephemeral and EBS
    
-   Ephemeral storage physically resides on the same host as the EC2 instance
    
-   Ephemeral storage is temporary, if the instance stops or terminates then the data will be lost. If it just restarts, the data is retained
    
-   EBS provides persistent storage as volumes
    
-   If your instance is stopped or terminated. EBS will retain your data
    
-   EBS volumes can be encrypted if you are storing sensitive data
    
-   EBS backups can be taken as snapshots and stored on Amazon S3
    

## EC2 Security

-   Key pairs are used to encrypt the credentials to the instance
    
-   Being a key pair, there is a public Key and private key
    
-   The public key encrypts the username and password for Windows instances
    
-   The private key is used to decrypt this data
    
-   Connectivity for Windows instances is managed over RDP (Port 3389)
    
-   For Linux instances the private key is used in conjunction with the public key to remotely connect onto the instance via SSH (Port 22)
    
-   The public key is held and kept by AWS
    
-   The private key is kept by you and you only have one opportunity to download it when it's created
    
-   You can use the same key pair for multiple instances
    

## EC2 Auto Scaling

-   Alows you to automatically increase or decrease your EC2 resources to meet the ć of your applications based on defined metrics and thresholds
    
-   Optimizes the cost of your EC2 fleet by scaling in resources that are no longer required
    
-   Scaling up: Increases the compute power of your instance, for example going from a M3-large to an M3-Xlarge
    
-   Scaling Out: Adds rnore instances of the same instance type, for example going from two M3 large instances to four M3 Large instances
    
-   Launch templates outline the AMI', instance type, IP requirements, Storage, etc when launching a new instance
    
-   Auto scaling groups define the desired capacity of the group using scaling policies, and which AZs should be used
    

## Elastic Load Balancer

-   ELBs help control the flow of inbound requests destined to a group of targets
    
-   Requests are distributed evenly across the targeted resource group
    
-   Targets can be a fleet ofEC2 instances, Lambda functions, a of IP addresses, or even containers split across different Availability Zones or in a single AZ
    
-   Internet facing ELBs are accessible via the internet and so have a public DNS name that can be resolved with public IP address
    
-   Internal ELB only has an internal IP address. It will only serve requests that originate from within your VPC itself
    
-   ELBs will automatically scale to meet your incoming traffic
    
-   To receive encrypted traffic over HTTPS your ELB needs a server certificate
    
-   The certificate must be issued by a certificate authority (CA) which could be the AWS Certificate Manager (ACM)
    
-   ELB allows you to manage loads across your target groups whereas EC2 auto scaling allows you to elastically scale those target groups based upon the demand
    
-   There are 3 types of ELB: Application  / Network  / Classic
    

## Load Balancer Types

## Application ELB

-   Operates at the application layer
    
-   When it receives a request it uses the configured listeners and rules to determine which target group to direct traffic to
    
-   Offers a flexible feature set for web apps running HTTP/HTTPS
    
-   Offers TLS termination
    
-   Cross-zone load balancing is always enabled
    

## Classic Load Balancer

-   Minimal feature set
    
-   It is considered best practice to use the ALB over the classic load balancer
    
-   Used for applications running in the EC2-Classic network
    

## Network Load balancer

-   Operates at Layer 4 of the OSI model
    
-   Balance requests purely based on the TCP and UDP protocols
    
-   Ultra-high performance with low latency
    
-   Capable of handling millions of requests a second
    
-   Cross-zone load balancing on the NLB can be enabled or disabled
    

## AWS Lambda

-   AWS Larnbda is a serverless compute service designed to run application code without having to manage and provision your own EC2 instances
    
-   You only pay for compute power when Lambda functions are invoked
    
-   In addition to compute power. you are also charged based on the number Of times your code runs
    
-   You can upload your code using the Management Console, AWS CLI or the SDK
    
-   Lambda functions execute your code upon specific triggers from supported event sources such as S3
    
-   Event sources are AWS services that can be used to trigger your Lambda functions
    
-   Downstream resources are resources that are required during the execution Of your Lambda function
    
-   Logging streams help you identify if your code is operating as
    
-   Event sources can either be poll or push-based
    
-   Event source mapping is the configuration that links your event source to your Lambda function.
    
-   Monitoring statistics related to your Lambda function within CloudWatch is configured by default
    
-   A dead-letter queue is used to receive payloads that were not processed due to a failed execution
    
-   The number of invocations determines how many times a function has been invoked