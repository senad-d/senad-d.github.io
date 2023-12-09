---
title: AWS Security
date: 2021-03-14 12:00:00
categories: [AWS, Basics]
tags: [aws, security]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/backgroun.png?raw=true){: .shadow }

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
    

# Identity & Access Management

-   IAM service is used to centrally manage and control security permissions for any identity requiring access to your AWS account and its resources.
    

## Users

-   Users are objects created to represent an identity
    
-   Can be configured to have AWS Management Console Access, or programmatic access
    
-   Programmatic access requires an access key ID and secret access key ID
    
-   Configuring MFA allows for an additional level of security to be applied
    
-   Permissions can be applied to Users
    
-   Each user must be unique within the AWS Account
    

## Groups

-   Groups are used to authorize access to AWS resources, through the use of AWS Policies
    
-   They contain IAM Users
    
-   Have IAM Policies associated that will allow or explicitly deny access to AWS resources
    
-   Policies can be AWS managed or customer managed policies
    
-   Groups normally relate to a specific requirement or job role
    
-   Any users that are a member of that group inherit the permissions applied to the group
    
-   Users can belong to more than one group
    

## Roles

-   Roles allow users and other AWS services and applications to adopt a set of temporary IAM permissions to access AWS resources
    
-   Users must adopt a role to use it
    
-   EC2 instances can be associated with a role granting permissions for that instance to access AWS resources on an applications behalf
    
-   AWS Service Role: Used by other services that would assume the role to perform specific functions
    
-   AWS Service-Linked Role: Very specific pre-defined roles that are associated to certain AWS services
    
-   Cross-Account Roles: Provides access between AVVS accounts
    
-   Identity Provider Access Role: Grants access to web identity provider / single sign on to SAML providers
    

## Policies

-   IAM policies are used to assign permissions to users, groups, and roles
    
-   Formatted as JSON documents
    
-   Each policy will have at least one statement with a number of parameters
    

-   Action: These are the actions that the policy permits or denies and focus on API calls for different services
    
-   Effect: This element can either be set to allow or deny. A 'deny takes precedence over an 'allow' when evaluating permissions
    
-   Resource: Specifies the resource you wish the and "Effect" to be applied to referenced by its ARN
    
-   Condition: This is an optional element which allows you to control when the permissions will be effective based upon set criteria
    
-   Principal (only used by resource-based policies such as S3 bucket policies): Defines the identity that the policy refers to, for example a specific IAM user
    

-   You can have either Managed Policies or In-line Policies
    
-   Managed policies are AWS Managed or Customer and can be attached to multiple users or groups
    
-   Inline Policies are directly embedded into a specific user, Group, or Role
    
-   Policy evaluation: By default, all access to a resource is denied. Access will only be allowed if an explicit '"Allow" has been specified. If a single "Deny" exists within any policy associated to the same identity against the same resource, then that "Deny" will override any previous "Allow" that may exist for the same resource and action
    
-   An explicit "Deny" will always take precedence over an explicit "Allow"
    

# AWS Web Application Firewall (WAF)

-   The main function of AWS WAF is to provide protection of your web applications from malicious attacks and risks for example:
    

-   SQL Injection
    
-   Cross site scripting
    
-   The OWASP Top 10 security risks
    
-   Common Vulnerabilities and Exposures (CVE)
    
-   Integrated with Amazon CloudFront distributions, Application Load Balancers and API Gateway
    
-   Used to distinguish between harmful and the legitimate requests to your applications and site.
    
-   Will protect and block harmful traffic
    
-   Web Access Control Lists are associated to a resource for example a CloudFront distribution
    
-   Web ACLs contain conditions and Rules
    
-   Conditions specify what element of the incoming request should be analysed by WAF
    
-   Rules contain the conditions that you want to use to filter the incoming web requests
    
-   using both the rules and conditions you block, allow or account the traffic
    
-   Rules are added to the Web Access control list
    
-   WAF rules are executed in the order that they appear within a Web ACL
    

# AWS Firewall Manager

-   Firewall Manager has been designed to help you manage WAF in a multi-account environment with simplicity and control
    
-   It automatically protects resources that are added to your account as they become active
    
-   Prerequisites Of using Firewall Manager include:
    

-   You must ensure that your AWS Account is a part of an AWS Organization with all features enabled, not just consolidated billing
    
-   You must define which AWS account will act as the Firewall Manager Admin account
    
-   You must have AWS Config enabled
    

-   Firewall manager used WAF rules, rule groups and Firewall Manager policies
    
-   Rule groups allow you to group together one or more WAF rules that will all have the same action applied when the conditions are met within a rule
    
-   You can create your own rule group or purchase existing rule groups pre-configured with set AWS WAF rules
    
-   You can only have 10 rules per rule group which can't be increased
    
-   Firewall Manager Policies contain the rule groups that you want to assign to your AWS resources
    
-   Used to manage WAF rules between multiple accounts. AWS WAF rules are selected first, which contain conditions. WAF rules can then be added to a rule group which will have either a block or alow acount action associated. Finally, a rule group is then added to an AWS Firewall Manager Policy which is then associated to AWS resources, such as your cloud front distributions or application load balances.
    

# AWS Shield

-   AWS Shield is closely related to both AWS WAF and also the AWS Firewall Manager
    
-   It has been designed to help protect your infrastructure against distributed denial of service attacks, commonly known as DDoS.
    

## AWS Shield Standard

-   Free to all AWS customers
    
-   Offers DDoS protection against some common layer 3 and 4 DDoS attacks
    

## AWS Shield Advanced:

-   Contains the full set of protective features
    
-   Offers enhanced protection to EC2, CloudFront, ELB and Route 53
    
-   Access to a DDoS response team (DRT) at AWS
    
-   Offers protection against layer 3, 4 and 7
    

# Amazon Cognito

-   Amazon Cognito is an authentication and user management service used commonly with web and mobile applications
    
-   Offers full integration with external identity providers (Apple, Facebook, Google, and Amazon, etc)
    
-   Integrates with your own Active Directory using SAML
    
-   It uses Users Pools and Identity Pools for governing authentication and verification access
    

## User Pools:

-   Used to create and maintain a directory of your users for your mobile or web application
    
-   Manages sign up, and signing in for you users
    
-   Utilise external Identity providers, such as Facebook, Amazon etc, or by using SAML for MS-AD
    

## Identity Pools:

-   Provide temporary access AWS Credentials for your authenticated users or unauthenticated guests
    
-   Operates in conjunction with User pools
    
-   Allows your users to access AWS services sitting outside of your application
    
-   Ability to federate using external identity providers
    
-   The main is that User pools provide a method of authentication through identity verification allowing them to sign into your web or mobile application using an identity provider or the local Cognito user directory. Where as Identity pools are typically used to help control access using temporary credentials to access AWS services on your applications behalf