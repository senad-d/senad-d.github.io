---
title: AWS Encryption
date: 2021-03-14 12:00:00
categories: [AWS, AWS Basics]
tags: [aws, encryption]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/backgroun.png?raw=true){: .shadow }

## Key Management Service (KMS)

-   The Key Management Service is a managed service used to store and generate encryption keys
    
-   Integrated with other AWS services
    
-   Different keys perform different roles and functions
    
-   AWS does not have access to your keys within KMS
    
-   Customer Master Keys (CMK) cannot be recovered if they are deleted
    
-   KMS is used for encryption at rest only
    
-   Has an integration with AWS CloudTrail to audit and track how your encryption keys are being used
    
-   KMS is not a multi-region service
    
-   The CMK can generate, encrypt and decrypt data encryption keys, which are then used outside of
    
-   the KMS service by other AWS services to perform encryption against your data
    
-   CMKs can be AWS-managed or customer-managed
    
-   Key Policies allows you to define who can use and access a particular key within KMS
    
-   Key policies are tied to the CMKs
    
-   Grants can control access to CMKs held within KMS
    


## AWS CloudHSM

  

-   A physical tamper-resistant hardware appliance that is used to protect and safeguard cryptographic material and encryption keys
    
-   Provides HSMs that are validated to Federal Information Processing Standards (FIPS) 140-2 Level 3
    
-   It is a single-tenant device
    
-   HSM clusters act as a single unit when configured and deployed
    
-   Multiple HSMs provide an element of high availability
    
-   Requests to your CloudHSM cluster are load-balanced between the cluster
    
-   CloudHSMs must be deployed within a VPC
    

  
## S3 Encryption Mechanisms

#### Server-side Encryption


-   SSE-S3 - Default Encryption
    
-   SSE-KMS - Encryption backed by the Key Management Service (KMS)
    
-   SSE-C - Encryption using customer-provided keys
    


#### Client-Side Encryption

-   CSE-KMS - Encryption backed by the Key Management Service (KMS)
    
-   CSE-C - Encryption using customer-provided keys