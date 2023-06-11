---
title: Dev env for Mendix app on AWS ECS
date: 2023-03-01 12:00:00
categories: [Projects, WSM]
tags: [aws, ecs, mendix, dev]
---
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/backgroun.png?raw=true){: .shadow }

Application is designed to streamline the management of available office space. Developed using Mendix, this solution offers businesses a comprehensive platform to effectively track and optimize their office resources.

To ensure seamless deployment and efficient operation, application leverages the power of AWS. Here's a brief overview of the AWS setup for running the application:

### 1. GitHub Repository Creation:

A dedicated GitHub repository was established to host all the necessary project files, enabling collaborative development and version control.

### 2. CloudFormation Template for Static Resources:

Static resources were created using a CloudFormation template, allowing for easy provisioning and management of essential infrastructure components.

### 3. Docker Image Building and CloudFormation Template Management:

Actions were implemented to automatically build the Docker image for the application and create/copy CloudFormation templates to an S3 bucket, ensuring efficient deployment and configuration.

### 4. Scheduled Environment Management:

Automated actions were configured to start and end the entire environment at specific times, minimizing manual intervention.

#### The process includes:

Infrastructure creation using the CloudFormation template to establish the environment.

Creation of an ECS Service for the Postgres container with EFS for persistent storage.

Creation of an ECS Service for the Mendix container across two availability zones (AZs) with a Load Balancer and Route53 integration.

Stopping all ECS Services and subsequently deleting the infrastructure when not in use.

## Continuous Mendix Application Updates:

Github actions were implemented to trigger the update of the Mendix application whenever a new .mpr file is pushed to the repository, ensuring that the application is always up-to-date.

By leveraging AWS and Mendix, this application offers a robust and user-friendly solution for managing office environments.

## GitHub Actions

For the CD/CI pipeline, the next workflows will be used:
- Create and Copy CF temp to S3
	- Use bash script to create a CloudFormation template for the Infrastructure
	- Copy infrastructure templates
- Build and Push Mendix Image
	- Build docker image
	- Tag docker image
	- Push the docker image to a repository
- Projects/WorkSpaceManager/Git/Create AWS Infrastructure
	- Create Mendix application stack
- Projects/WorkSpaceManager/Git/Build and Deploy Postgres DB
	- Create DataBase Task Definition
	- Register DataBase Task Definition
	- Create a Private Database Fagate Service
- Build and Deploy Mendix App
	- Create App Task Definition
	- Register App Task Definition
	- Create a two Public Mendix Fargate Service
- Stop Fargate Services
	- Stop Mendix Application Services
- Delete AWS Infrastructure
	- Delete the Mendix application stack
- Update and Push the new image
	- Build docker image
	- Tag docker image
	- Push the docker image to a repository
	- Update the ECS cluster with a new image

![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/wsm-pipeline.png?raw=true){: .shadow }

## AWS resources

For the AWS, we will use the CloudFormation templates to provision resources and Task Definitions for ECS Services.
- AWS static Infrastructure
	- S3 - CloudFormation templates
	- ECR - Mendix Docker image
	- EFS - database persistent files
	- LogGroup - ECS logs
- AWS Application Infrastructure
	- VPC
	- IGW
	- Subnets
	- RouteTables
	- NatGateway
	- Load Balancer
	- Route53
	- ECS Cluster
	- EFS MountTarget
	- Security Groups
	- Roles
	- Parameters
	- Outputs
- Create ECS Task Definition for DB
	- Pull the AWS parameters and place them in the variables
	- Create a YAML file for Task Definition
- Create ECS Task Definition for Mendix
	- Pull the AWS parameters and place them in the variables
	- Create a YAML file for Task Definition

For building a Docker image the  Mendix Buildpack for Docke is used
- Docker Mendix Buildpack
	- Create a Docker image from the Mendix application

![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/wsm-env.png?raw=true){: .shadow }