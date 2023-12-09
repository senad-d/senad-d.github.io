---
title: AWS Networking
date: 2021-03-14 12:00:00
categories: [AWS]
tags: [aws, networking]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/backgroun.png?raw=true){: .shadow }

## Virtual Private Clouds (VPCs)

-   A VPC resides inside of the AWS Cloud and it's essentially your own isolated segment of the AWS Cloud itself
    
-   By default when you create your VPC only your account has access to it
    
-   VPCs allows you to deploy resources within your own secure environment, such as compute/storage/database etc
    
-   You are allowed up to five VPCs per region per AWS account
    
-   When you create your VPC you must define a CIDR IP block (/16 - /28)
    

## Management network components including:

-   Subnets / NACLs / Security Groups / NAT
    
-   Gateways / Internet Gateways / Route Tables /
    
-   Direct Connect/VPN Gateways
    

# Networking Components

## Subnets

-   Used to segment your VPC into multiple networks
    
-   Each subnet has it's own IP range which falls in the VPC CIDR block range
    
-   Public and private subnets
    
-   A public subnet is accessible from outside of your VPC
    
-   Resources in a public subnet must have a public IP address
    
-   Public subnets require an IGW and a route pointing to the IGW
    
-   Resources in a private subnet are inaccessible from the Internet
    
-   Each subnet exists in a single AZ
    

## Security Groups

-   Filter traffic both inbound and outbound at the instance level
    
-   All the rules within the SG will be assessed before a decision is made on the action
    
-   Allow rules only ('deny' rules not possible)
    
-   They have both inbound and outbound rule sets
    
-   Security groups are stateful
    

## NACLs

-   Virtual network-level firewalls associated to subnets
    
-   Control ingress and egress traffic between subnets
    
-   The default NACL allows all traffic
    
-   Each entry has a rule number
    
-   NACL is read in rule order
    
-   NACLs are stateless
    

## Internet Gateway (IGW)

-   A managed component that can be attached to your VPC
    
-   Acts as a gateway between your VPC and the outside world
    
-   Allows resources in the public subnet to access the internet
    

## NAT Gateway

-   A NAT gateway sits within the public subnet with an ElP
    
-   NAT GW allows private resources to access the internet
    
-   Private subnets need a route to the NAT GW to access it
    
-   It will block all incoming communications from the internet
    

## VPN/Direct Connect

## Virtual Private Network ([[OpenVPN for AWS]]):

-   To enable communications between VPC resources and those in a data centre you can use a VPN connection across the public internet
    
-   In your VPC you must attach a virtual gateway
    
-   In your data centre you must add a customer gateway (a hardware of software appliance)
    
-   The customer gateway has an endpoint attached to the virtual private gateway
    
-   Dynamic or static routing can be configured
    
-   Initiate a tunnel between the two endpoints which can only be done from your customer gateway
    
-   Configure the necessary routing to enable communicate over the VPN link
    

## Direct Connect:

-   Direct Connect enables you to create a private connection between your data centre and an AWS region, not just a VPC
    
-   Your Data Centre will connect to an AWS partner using dedicated links which contain Direct Connect infrastructure
    
-   This is a separate building to your remote data center
    
-   You can configure private virtual interfaces and also public virtual interfaces on your router for DC
    
-   Private virtual interfaces will connect to a virtual gateway in your VPC
    
-   Public virtual interfaces connects to an AWS region allowing access to public AWS resources such as Amazon S3
    
-   Offers high speed network connectivity to AWS
    

# VPC Endpoints

## There are 2 types of VPC Endpoint

-   Interface Endpoint
    
-   Gateway Endpoint
    

### Interface Endpoints:

-   During the creation of an interface endpoint for a service, a DNS hostname is associated With a private hosted zone in your VPC. In this hosted zone a record set for the default DNS name of the service is created resolving to the IP address of your interface endpoint. Applications already using that service do not need to be reconfigured, requests to that service using the default DNS name will now be resolved to the private IP address of the interface endpoint and will route through the internal AWS network instead of the internet.
    

### Gateway Endpoints:

-   Act as target used within your route tables to allow you to reach supported services (S3 and DynamoDB). During the creation of your Gateway endpoint you specify which route tables should be updated to add the new Target of the gateway endpoint. Any route table selected will have a route automatically added to include the new Gateway Endpoint. The entry of the route will have a prefix list of the associated service (Amazon S3 or DynamoDB) and the target entry will be VPC Endpoint ID. Gateway Endpoints only works with IPv4.
    

# Networking Features

## Elastic IP Address (EIP)

-   ElPs provide a persistent public IP address that you can associate with your instance
    
-   The IP address is associated with your account rather than an instance
    
-   You can attach an EIP address to an instance or an Elastic Network Interface, an ENI
    
-   You can also detach the EIP from an instance and re-attach it to another instance
    
-   Any unused ElPs will incur a cost
    

## Elastic Network Interfaces (ENI)

-   ENIs are logical virtual network cards within your VPC
    
-   They can be attached to your EC2 instances
    
-   The configuration is bound to the ENI and not the instance that it is attached to.
    
-   You can detach your ENI from one instance and reattach to another
    
-   Useful to create a management network
    

## Elastic Network Adapter (ENA)

-   Elastic Network Adapter (ENA)
    
-   Provides enhanced networking features to reach speeds of up to 100 Gbps for your Linux compute instances
    
-   They are not supported for all instances (must be running kernel versions 2.632 and 3.2 and above)
    
-   Offers higher bandwidth with increased packet per second (PPS) performance
    
-   Offered at no extra cost, and is included wit the latest version of the Arnazon Linux AMI
    

## AWS Global Accelerator

-   Allows you to get UDP and TCP traffic from your end user clients to your applications faster, quicker and more reliably using the AWS global infrastructure and specified endpoints
    
-   It uses two static IP addresses associated with a DNS name which is used as a fixed source to gain access to your application
    
-   These IP addresses can be mapped to multiple different endpoints
    
-   Global Accelerator intelligently routes customers requests across the most optimized path
    

#### There are 4 steps to set up AWS Global Accelerator:

	-   Create your accelerator select 2 IP addresses
    
	-   Create a listener to receive and process incoming connections based upon protocols and ports (UDP or TCP)
    
	-   Associate the listener with an endpoint group. Each endpoint group is associated with a different region, and within each group there are multiple endpoints.
    
	-   Associate and register your endpoints for your application. Either an ALB, NLB, an EC2 instance or an EIP
    

## Amazon Route 53

-   A highly available and scalable DNS, providing secure and reliable routing of requests
    
-   Uses the AWS global network of authoritative DNS servers to reduce latency
    

## Hosted Zones:

-   A container that holds information about how you want to route traffic for a domain such as [seki.ink](https://seki.ink)
    

## Public hosted zones:

-   Determines how traffic is routed on the internet
    

## Private hosted zones:

-   Determines how traffic is routed within a VPC
    

## Generic top-level domains (TLDs):

-   TLDs are used to help determine what information you might expect to find on the website
    

## Geographic domains:

-   Used to represent the geographical location of the site itself
    

## Resource record types:

-   Route 53 supports the most common types
    

## Alias records :

-   Act like a CNAME record allowing you to route your traffic to other AWS resources, such as ELBs, VPC Interface Endpoints, etc
    

## Routing Policies

### Simple Routing policy

-   This is the default policy, and it is for single resources that perform a given function
    

### Failover Routing Policy

-   This allows you to route traffic to different resources based upon ther helth
    

### Geo-Location Routing Policy

-   This lets you route traffic based on the geographic location of your user
    

### Geoproximity Routing policy

-   This policy is based upon the location of both the user and your resources
    

### Latency Routing Policy

-   This is suitable when you have resorces in multiple regions and want low latency
    

### Multivalue Answer Routing Policy

-   This allows you to get a response from a DNS request from up to 8 records at once that are picked at random
    

### Weighted Routing Policy

-   This is suitable when you have multiole resource records that preform the same function
    
-   To determan the probability, the formula is the weight of the individual resource record divided by the sum of the total value in resource record set
    

# Amazon CloudFront

-   A fault-tolerant and globally scalable content delivery network service
    
-   Speeds up distribution of static and dynamic content through its worldwide network of edge locations providing low latency to deliver the best performance through cached data
    
-   CloudFront uses distributions to control which source data it needs to redistribute
    
-   2 types of distribution: Web distribution and RTMP distribution
    
-   A CloudFront origin defines where the distribution is going to get the data to distribute across edge locations and it will be the DNS name of the S3 bucket or the HTTP server.
    
-   For additional security when working with S3 you can create and associate a CloudFront user called an Origin Access Identity (OAI). Only the OAI can access and serve content from your bucket preventing anyone circumventing your CloudFront
    
-   CloudFront offers ability to different caching behavior options, defining how you want the data at the edge location to be cached via various methods and policies.
    
-   Ability to define the locations of where your data should be distributed to ensure you receive the best performance for your customers