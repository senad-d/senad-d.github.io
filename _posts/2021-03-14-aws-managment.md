---
title: AWS Management
date: 2021-03-14 12:00:00
categories: [AWS, AWS Basics]
tags: [aws, management]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.pro/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/backgroun.png?raw=true){: .shadow }

Amazon CloudWatch: If you need to monitor the health of different resources, set alerts, gather metrics
  
AWS CloudTrail: If you need to capture API calls being made across your AWS account
  
AWS Config: If you need to monitor, manage, and assess the configurational state of your resources
  
AWS Organizations: If you need to set up management and security controls across a multi AWS account level

VPC Flow Logs: If you need to capture network traffic at an interface, subnet or VPC level and review the logs in CloudWatch


## CloudWatch

-   A global service designed to be your window into the health performance of your applications and infrastructure
    
-   Dashboards provide a visual display of metrics and alarms relating to your resources to form a unified view
    
-   Dashboards can then be viewed from within the AWS Management Console
    
-   Metrics enable you to monitor a specific element of an application or resource over a period of time
    
-   Different services will offer different metrics
    
-   By default everyone has access to a free set of Metrics
    
-   Default monitoring records metrics every 5 minutes
    
-   Detailed monitoring records metrics every minute for additional cost
    
-   Custom metrics can be created for your applications
    
-   Anomaly detection will identify activity that sits outside of the normal baseline parameters
    
-   Alarms allow you to implement automatic actions based on thresholds configured against metrics
    
-   Alarm states can be 0K, ALARM or INSUFFICIENT_DATA
    
-   EventBridge connects to your own applications allowing you to respond to events that occur in your application as they happen
    
-   CloudWatch Logs gives you a centralized location to house all of your logs from different AWS services
    
-   The Unified CloudWatch Agent collects logs and additional metric data from EC2 instances
    

## AWS CloudTrail

-   The primary function of CloudTrail is to record and track all AWS API requests made
    
-   API calls can be programmatic requests initiated from a user using an SDK, the AWS CLI, from within the AWS Management Console, or even from a request made by another AWS service
    
-   CloudTrail also records and associates other identifying metadata with all the events, for example the identity of the caller, the timestamp of when the request was initiated, and the source IP address
    
-   Records are stored in log files which are typically created every five minutes and stored on S3
    
-   Log files can also be sent to CloudWatch Logs
    
-   Its a global service with support for all regions
    
-   It can be used very effectively as a security analysis tool by detecting irregular trends or restricted API calls
    
-   Helps with root cause identification of incidents
    
-   Used in accordance with internal and external audits
    

## AWS config

-   AWSConfig is designed to record and capture resource changes within your environrnent
    
-   Central location to collate and review data abouta specific resource type within your environment
    
-   Comes with a resource history allowing you to review all changes on a given resource
    
-   Provide a snapshot in time of current resource configurations
    
-   Enable notifications of when a change has occurred on a resource with SNS integrations
    
-   Integrations with CloudTrail allow you to see who made a change and when
    
-   You can enforce rules that check the compliancy of your resource against specific controls
    
-   Using resource relationships you can identify what resource is connected with another, for example what ENI is associated with which instance, in which subnet, in which VPC
    
-   AWS Config is region specific
    

## AWS Organizations

-   AWS Organizations provides a means of centrally managing and categorizing multiple AWS accounts that you own
    
-   Helps to maintain your AWS environment from a security, compliance, and account management perspective
    
-   Components include Organizations, Organizational Units (0U), Accounts, Service Control Policies
    
-   An Organization forms a hierarchical Structlure of multiple AWS accounts
    
-   At the very top Of this Orgmization there is Root a container, all Other AWS and OU's sit underneath it
    
-   OU's provide a means of categorizing your AWS Accounts
    
-   An OU can connect directly below the Root or even below another OU (which can be nested up to 5 times)
    
-   Accounts are your AWS accounts
    
-   Service control policies, SCPs, allow you to control What services and features are accessible from Within an AWS
    
-   SCPs can either be associatd with the Organizational units, or individual accounts
    
-   An SCP acts as a permission boundary that sets the maximum permission level for the objects that it is applied to
    
-   In each Organization one account with act as the Master account and all other accounts will be Member accounts
    
-   An Organization can be deployed with "All Features', which is default and uses enhanced account management features, or just with 'Consolidating Billing' features enabled which just gives a subset of features, providing basic management tools enabling you to manage billing centrally across all your accounts
    

## VPC Flow Logs

-   VPC Flow Logs allows you to capture IP traffic information that flows between your network interfaces of your resources within your VPC
    
-   They can help you resolve incidents with network communication and traffic flow
    
-   VPC Flow Log data is sent to CloudWatch logs
    
-   They are not supported by the EC2-Cassic environment
    
-   To alter a VPC Flow Log configuration you need to delete it and then recreate a new one
    
-   The following traffic is not monitored and captured by the logs:
    
-   DHCP traffic within the VPC
    
-   Traffic from instances destined for the Amazon DNS Server
    
-   Any traffic destined to the IP address for the VPC default router
    
-   Traffic to and from the following addresses, 169.254.169.254 and 169.254.169.123
    
-   Traffic between a network load balancer interface and an endpoint network interface

-   VPC Flow Logs can be created for a network interface on one of your instances, a subnet or a VPC