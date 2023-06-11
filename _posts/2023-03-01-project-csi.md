---
title: Dev env for Quasar and Laravel app on AWS ECS
date: 2023-03-01 12:00:00
categories: [Projects, CSI]
tags: [aws, ecs, quasar, laravel, dev]
---
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/backgroun.png?raw=true){: .shadow }

## App on AWS ECS Faregate

Construction Site Inventory is a cutting-edge application designed to revolutionize inventory tracking for large construction sites. With its user-friendly interface and powerful features, this application simplifies the complex task of managing inventory in construction projects. Leveraging the Quasar framework (version 2.6.0) for the frontend and the Laravel framework for the backend, Construction Site Inventory offers a robust and scalable solution for construction professionals.

To ensure seamless deployment and efficient operations, we have implemented the application on AWS. 

### Here's a quick guide on how to get started with the project in AWS:

1. Create a GitHub repository and upload all the necessary project files to it.

2. In AWS, create a new IAM user with the appropriate permissions for building the required infrastructure.

3. Establish an [***SES Verified Identity***](https://docs.aws.amazon.com/ses/latest/dg/creating-identities.html) for the email address used to send emails through Amazon SES.

4. Create an IAM user for SMTP authentication with Amazon SES.

5. Set up all the required GitHub Secrets for the Actions.

6. Generate [***Incoming Webhooks***](https://senad-d.github.io/posts/slack-webhook/) for Slack notifications.

7. Utilize the [***CloudFormation template***](https://senad-d.github.io/posts/project-csi-cf-static/) to create static resources.

8. Execute the GitHub [***Action to build the Docker image***](https://senad-d.github.io/posts/github-actions-docker-build/) and copy the CloudFormation templates to the designated S3 bucket.

9. Run the GitHub Action to copy [***Frontend files to S3***](https://senad-d.github.io/posts/github-actions-s3/), facilitating their usage with CloudFront.

10. Configure [***Automated Actions***](https://senad-d.github.io/posts/github-actions-auto-env/) to start and end the entire environment at specific times.

11. Initiate the AWS Infrastructure for the environment using the [***CloudFormation template***](https://senad-d.github.io/posts/project-csi-cf-resources/).

12. Create an [***ECS Service***](https://senad-d.github.io/posts/project-csi-ecs-db/) for the MySQL container, utilizing EFS for persistent storage, using the [***Github action to run the ECS service***](https://senad-d.github.io/posts/github-actions-auto-ecs/). 

13. Establish an [***ECS Service***](https://senad-d.github.io/posts/project-csi-ecs-app/) for the App container, integrated with a LoadBalancer and Route53.

14. Cease all ECS Services related to the application when required.

15. Delete the AWS Infrastructure at the end of the day to optimize resources.

Additionally, we have implemented automated Actions that trigger whenever files change within the "backend" and "frontend" directories. These Actions ensure efficient updates and maintenance of the application.

## Infrastructure

Here you can see the two different pipelines for production and development, and all the services that are going to be used in each environment.

![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/csi-infra.png?raw=true){: .shadow }

## GitHub Actions
Here you can observe actions that are needed for deploying infrastructure into AWS with help from GitHub actions.

![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/csi-project.png?raw=true){: .shadow }

## AWS Resources

This is a visual presentation of the resources that are created for this project in AWS.

CloudFormation template for Static resources needed for creating the resto of the infrastructure.
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/csi-static.png?raw=true){: .shadow }

CloudFormation template for running ECS Fargate containers running the backend and database. 
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/csi-backend.png?raw=true){: .shadow }

CloudFormation template for CloudFront distribution for the Frontend S3 bucket.
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/csi-frontend.png?raw=true){: .shadow }