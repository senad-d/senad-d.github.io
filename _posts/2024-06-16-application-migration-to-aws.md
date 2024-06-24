---
title: How to migrate local Application to AWS
date: 2024-06-16 11:00:00
categories: [Migration]
tags: [aws, migration]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.pro/js/script.js"></script>
![migration](https://github.com/senad-d/senad-d.github.io/blob/e89749986a2196c8f9e4032d3918f08b95532340/_media/migration/migration.png?raw=true)
{: .shadow }

# What Is AWS Application Migration Service?

AWS Application Migration Service (MGN) is a highly automated lift-and-shift (rehost) solution that simplifies, expedites, and reduces the cost of migrating applications to AWS. It allows companies to lift-and-shift a large number of physical, virtual, or cloud servers without compatibility issues, performance disruption, or long cutover windows. MGN replicates source servers into your AWS account. When you’re ready, it automatically converts and launches your servers on AWS so you can quickly benefit from the cost savings, productivity, resilience, and agility of the Cloud. Once your applications are running on AWS, you can leverage AWS services and capabilities to quickly and easily replatform or refactor those applications – which makes lift-and-shift a fast route to modernization.

![MGN](https://github.com/senad-d/senad-d.github.io/blob/e89749986a2196c8f9e4032d3918f08b95532340/_media/migration/welcome.png?raw=true)
{: .shadow }

# Migrating to AWS: A Step-by-Step Guide

AWS MGN is the recommended service for migrating applications to AWS without modifying them. Here's a simplified guide:

![diagram](https://github.com/senad-d/senad-d.github.io/blob/e89749986a2196c8f9e4032d3918f08b95532340/_media/migration/diagram.png?raw=true)
{: .shadow }

## **1. Getting Started**


* Ensure you meet the [network requirements](https://docs.aws.amazon.com/mgn/latest/ug/preparing-environments.html).
* Create IAM User for the agent.
* In the AWS MGN console, create a replication settings template.

![template](https://github.com/senad-d/senad-d.github.io/blob/e89749986a2196c8f9e4032d3918f08b95532340/_media/migration/template.png?raw=true)
{: .shadow }

## **2. Adding Source Servers**

* Install the AWS MGN Replication Agent on your source servers (Linux or Windows).

![agent](https://github.com/senad-d/senad-d.github.io/blob/e89749986a2196c8f9e4032d3918f08b95532340/_media/migration/agent.png?raw=true)
{: .shadow }

* The agent will be added to the console and start syncing data.

![cli](https://github.com/senad-d/senad-d.github.io/blob/e89749986a2196c8f9e4032d3918f08b95532340/_media/migration/cli.png?raw=true)
{: .shadow }

## **3. Configuring Launch Settings**

* Define how test or cutover instances will launch for each source server.

![cli](https://github.com/senad-d/senad-d.github.io/blob/e89749986a2196c8f9e4032d3918f08b95532340/_media/migration/lounchset.png?raw=true)
{: .shadow }

## **4. Launching a Test Instance**

* Launch a test instance to verify your source server functions properly in AWS.
* Use SSH to connect and test functionality.

![cli](https://github.com/senad-d/senad-d.github.io/blob/e89749986a2196c8f9e4032d3918f08b95532340/_media/migration/testec2.png?raw=true)
{: .shadow }

## **5. Performing a Cutover**

* Cutover to migrate your source server to AWS.

![cli](https://github.com/senad-d/senad-d.github.io/blob/e89749986a2196c8f9e4032d3918f08b95532340/_media/migration/conv-serv.png?raw=true)
{: .shadow }

* After cutover, redirect users to the migrated server.
* Finalize the cutover to mark the migration complete.

![cli](https://github.com/senad-d/senad-d.github.io/blob/e89749986a2196c8f9e4032d3918f08b95532340/_media/migration/finalize.png?raw=true)
{: .shadow }

**Additional Points**

* Test your migration at least a week before cutover.
* Use CloudWatch, EventBridge, and CloudTrail for monitoring.
* Revert a test or cutover if needed.
* AWS MGN is free for 90 days, but AWS infrastructure usage incurs charges.

**Resources**

* For detailed instructions, refer to the AWS Application Migration Service [documentation](https://docs.aws.amazon.com/mgn/latest/ug/what-is-application-migration-service.html).
* AWS MGN is available in specific regions. Use CloudEndure Migration or AWS SMS for unsupported regions or if agent installation is not possible.
