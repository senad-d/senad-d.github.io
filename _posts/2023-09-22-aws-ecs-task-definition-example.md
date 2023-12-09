---
title: Amazon Elastic Container Service Task Definition
date: 2023-09-22 12:00:00
categories: [ECS]
tags: [aws, ecs]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/ECS-Anywhere.png?raw=true){: .shadow }

# What is Amazon Elastic Container Service?

Amazon Elastic Container Service (Amazon ECS) is a fully managed container orchestration service that helps you easily deploy, manage, and scale containerized applications. As a fully managed service, Amazon ECS comes with AWS configuration and operational best practices built-in. It's integrated with both AWS and third-party tools, such as Amazon Elastic Container Registry and Docker. This integration makes it easier for teams to focus on building the applications, not the environment. You can run and scale your container workloads across AWS Regions in the cloud, and on-premises, without the complexity of managing a control plane.

## Task Definition
The task definition is a text file, in JSON format, that describes one or more containers, up to a maximum of ten, that form your application. 

The following are some of the parameters that you can specify in a task definition:

-   The Docker image to use with each container in your task
    
-   How much CPU and memory to use with each task or each container within a task
    
-   The launch type to use, which determines the infrastructure that your tasks are hosted on
    
-   The Docker networking mode to use for the containers in your task
    
-   The logging configuration to use for your tasks
    
-   Whether the task continues to run if the container finishes or fails
    
-   The command that the container runs when it's started
    
-   Any data volumes that are used with the containers in the task
    
-   The IAM role that your tasks use
    

For a complete list of task definition parameters, see [Task definition parameters](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html).

After you create a task definition, you can run the task definition as a task or a service.

-   A _task_ is the instantiation of a task definition within a cluster. After you create a task definition for your application within Amazon ECS, you can specify the number of tasks to run on your cluster.
    
-   An Amazon ECS _service_ runs and maintains your desired number of tasks simultaneously in an Amazon ECS cluster. How it works is that, if any of your tasks fail or stop for any reason, the Amazon ECS service scheduler launches another instance based on your task definition. It does this to replace it and thereby maintain your desired number of tasks in the service.

### Example task definition

```shell
{
    "containerDefinitions": [
        {
            "name": "app",
            "image": "<ECR-image>",
            "cpu": 0,
            "portMappings": [
                {
                    "containerPort": 9000,
                    "hostPort": 9000,
                    "protocol": "tcp"
                }
            ],
            "essential": true,
            "environment": [
                {
                    "name": "APP_ENV",
                    "value": ""
                },
                {
                    "name": "DB_PORT",
                    "value": ""
                },
                {
                    "name": "APP_NAME",
                    "value": ""
                },
                {
                    "name": "DB_USERNAME",
                    "value": ""
                },
                {
                    "name": "DB_CONNECTION",
                    "value": ""
                },
                {
                    "name": "APP_URL",
                    "value": ""
                },
                {
                    "name": "DB_HOST",
                    "value": ""
                }
                
            ],
            "mountPoints": [],
            "volumesFrom": [],
            "linuxParameters": {
                "initProcessEnabled": true
            },
            "secrets": [
                {
                    "name": "APP_KEY",
                    "valueFrom": ""
                },
                {
                    "name": "DB_PASSWORD",
                    "valueFrom": ""
                }
            ],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "",
                    "awslogs-region": "",
                    "awslogs-stream-prefix": ""
                }
            }
        },
        {
            "name": "nginx",
            "image": "nginx",
            "cpu": 0,
            "portMappings": [
                {
                    "containerPort": 80,
                    "hostPort": 80,
                    "protocol": "tcp"
                }
            ],
            "essential": true,
            "environment": [],
            "mountPoints": [],
            "volumesFrom": [],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "",
                    "awslogs-region": "",
                    "awslogs-stream-prefix": ""
                }
            }
        }
    ],
    "family": "",
    "taskRoleArn": "",
    "executionRoleArn": "",
    "networkMode": "awsvpc",
    "volumes": [],
    "placementConstraints": [],
    "requiresCompatibilities": [
        "FARGATE"
    ],
    "cpu": "512",
    "memory": "1024",
    "tags": []
}
```

> This JSON represents a basic configuration for running two containers in a Fargate task within an ECS cluster, where one container runs a web application (likely a PHP, Node.js, or similar service) and the other container serves as an Nginx reverse proxy or web server. Specific configuration details like environment variables, secrets, IAM roles, and networking settings would need to be tailored to your specific application and deployment requirements.
{: .prompt-tip }

### Create task definition with GitHub Action

- Bash script: `apptask.sh`

```shell
#!/bin/bash

###############################################
# This script is designed to generate a       #
# task definition template and set it up for  #
# seamless uploading to Amazon ECS, complete  #
# with all the required parameters.           #
###############################################

# Import variables
ENV="$1"
PROJECT="$2"
AZ="$3"
SECRET="$4"
ACCESS_KEY="$5"
SECRET_KEY="$6"
SES_USER="$7"
SES_PASS="$8"
SES_ENDPOINT="$9"
SES_EMAIL="${10}"
DB_USER="${11}"
DB_PASS="${12}"

# Get parameters from AWS Parameter Store
ID="$(aws sts get-caller-identity --query "Account" --output text)"
S3="$(aws ssm get-parameter --name "$ENV.CMS.$PROJECT" --query "Parameter.Value" --output text)"
LOGS="$(aws ssm get-parameter --name "$ENV.LogGroup.$PROJECT" --query "Parameter.Value" --output text)"
TASKEXROLE="$(aws ssm get-parameter --name "$ENV.EcsTaskExecutionRole.$PROJECT" --query "Parameter.Value" --output text)"
TASKROLE="$(aws ssm get-parameter --name "$ENV.EcsTaskRole.$PROJECT" --query "Parameter.Value" --output text)"
ECR="$(aws ssm get-parameter --name "$ENV.ECRepo.$PROJECT" --query "Parameter.Value" --output text)"
ECS="$(aws ssm get-parameter --name "$ENV.ECSCluster.$PROJECT" --query "Parameter.Value" --output text)"
TASK="$(aws ecs list-tasks --cluster "$ECS" --desired-status RUNNING --query 'taskArns[0]' --output text | awk '{print substr($0,length-31)}')"
IP="$(aws ecs describe-tasks --cluster "$ECS" --tasks "$TASK" --query 'tasks[].containers[].networkInterfaces[].privateIpv4Address' --output text)"

# Create new Database private IP parameter
aws ssm put-parameter --name "$ENV.DataBase.IP.$PROJECT" --type "String" --value "$IP" --overwrite

# Create new task definition for the Backend container
cat <<EOF >> ./"$PROJECT"-task.json
{
  "containerDefinitions": [
    {
      "name": "$PROJECT",
      "image": "$ID.dkr.ecr.$AZ.amazonaws.com/$ECR:latest",
      "memory": 1024,
      "essential": true,
      "linuxParameters": {
        "initProcessEnabled": true
      },
      "environment": [
        {
          "name": "MONGODB_URI",
          "value": "mongodb://$DB_USER:$DB_PASS@$IP:27017/admin"
        },
        {
          "name": "COOKIE_DOMAIN",
          "value": ""
        },
        {
          "name": "PAYLOAD_PUBLIC_SITE_URL",
          "value": ""
        },
        {
          "name": "PAYLOAD_PUBLIC_SERVER_URL",
          "value": ""
        },
        {
          "name": "PAYLOAD_CONFIG_PATH",
          "value": ""
        },
        {
          "name": "PAYLOAD_SERVER_PORT",
          "value": ""
        },
        {
          "name": "PAYLOAD_SECRET",
          "value": "$SECRET"
        },
        {
          "name": "S3_BUCKET_NAME",
          "value": "$S3"
        },
        {
          "name": "ACCESS_KEY",
          "value": "$ACCESS_KEY"
        },
        {
          "name": "SECRET_KEY",
          "value": "$SECRET_KEY"
        },
        {
          "name": "S3_ENDPOINT",
          "value": "https://$S3.s3.$AZ.amazonaws.com"
        },
        {
          "name": "S3_REGION",
          "value": "$AZ"
        },
        {
          "name": "EMAIL_MOCK",
          "value": "true"
        },
        {
          "name": "EMAIL_FROM",
          "value": "noreply@$SES_EMAIL"
        },
        {
          "name": "EMAIL_FROM_NAME",
          "value": "No-reply at $SES_EMAIL"
        },
        {
          "name": "EMAIL_HOST",
          "value": "$SES_ENDPOINT"
        },
        {
          "name": "EMAIL_PORT",
          "value": "465"
        },
        {
          "name": "EMAIL_USERNAME",
          "value": "$SES_USER"
        },
        {
          "name": "EMAIL_PASSWORD",
          "value": "$SES_PASS"
        },
        {
          "name": "NODE_ENV",
          "value": "production"
        }
      ],
      "command": [
        "yarn install && yarn serve"
      ],
      "entryPoint": [
        "/bin/sh",
        "-c"
      ],
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80,
          "protocol": "tcp"
        }
      ],
      "healthCheck": {
        "command": ["CMD", "echo", "WORKING"],
        "interval": 5,
        "timeout": 3,
        "startPeriod": 60,
        "retries": 3
      },
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "$LOGS",
          "awslogs-region": "$AZ",
          "awslogs-stream-prefix": "$PROJECT-ecs"
        }
      }
    }
  ],
  "family": "App-$PROJECT-TaskDefinition",
  "cpu": "512",
  "memory": "1024",
  "networkMode": "awsvpc",
  "executionRoleArn": "$TASKEXROLE",
  "taskRoleArn": "$TASKROLE",
  "runtimePlatform": {
    "operatingSystemFamily": "LINUX"
  },
  "requiresCompatibilities": ["FARGATE"]
}
EOF
```

- Github Action

```shell
name: 3 - Deploy Backend Container

env:
  PROJECT: 'name'
  AWS_ENV: 
  AWS_REGION: 
  AWS_ACCESS: 
  AWS_SECRET: 
  PAYLOAD_SECRET: 
  SES_USER: 
  SES_PASS: 
  SES_ENDPOINT: 
  SES_EMAIL: 
  DB_USERNAME: 
  DB_PASSWORD:


on:
  #schedule:
  #  - cron: '58 05 * * 1-5'  # at 7:58 UTC on every day-of-week from Monday through Friday
  workflow_dispatch:
  
jobs:
  Build_and_Deploy:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout
      uses: actions/checkout@v3

    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v3
      with:
        aws-access-key-id: 
        aws-secret-access-key: 
        aws-region: 

    - name: Create App Task Definition
      run: |
        sudo chmod +x ./apptask.sh && ./apptask.sh $AWS_ENV $PROJECT $AWS_REGION $PAYLOAD_SECRET $AWS_ACCESS $AWS_SECRET $SES_USER $SES_PASS $SES_ENDPOINT $SES_EMAIL $DB_USERNAME $DB_PASSWORD

    - name: Register new Task Definition
      run: |
        aws ecs register-task-definition --cli-input-json file://${{ env.PROJECT }}-task.json

    - name: Create a Service
      run: |
        aws ecs create-service \
        --cluster $(aws ssm get-parameter --name "${{ env.AWS_ENV }}.ECSCluster.${{ env.PROJECT }}" --query "Parameter.Value" --output text) \
        --service-name ${{ env.PROJECT }}-service \
        --task-definition $(aws ecs list-task-definitions | grep App-${{ env.PROJECT }}-TaskDefinition | tail -n 1 | sed s/\",// | sed s/\"// | sed 's/ //g') \
        --desired-count 1 \
        --enable-execute-command \
        --launch-type "FARGATE" \
        --network-configuration "awsvpcConfiguration={subnets=[$(aws ssm get-parameter --name "${{ env.AWS_ENV }}.PublicSubnetA.${{ env.PROJECT }}" --query "Parameter.Value" --output text)],securityGroups=[$(aws ssm get-parameter --name "${{ env.AWS_ENV }}.AppSG.${{ env.PROJECT }}" --query "Parameter.Value" --output text)],assignPublicIp=ENABLED}" \
        --load-balancers targetGroupArn=$(aws elbv2 describe-target-groups --names ${{ env.PROJECT }}-${{ env.AWS_ENV }}-Fargate --query "TargetGroups[0].TargetGroupArn" --output text),containerName=${{ env.PROJECT }},containerPort=80
```