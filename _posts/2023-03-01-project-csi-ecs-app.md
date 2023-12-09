---
title: Create ECS Task Definition for CSI app
date: 2023-03-01 12:00:00
categories: [Projects]
tags: [aws, ecs, task definition]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/backgroun.png?raw=true){: .shadow }

Create application task definition for ECS Faregate.

```shell
#!/bin/bash

########################################################
# Pull parameters from aws in order to get IP address, #
# username and password for the database running in    #
# the Fargate container                                #
# ENV and AZ are imported from the pipeline.           #
########################################################

# Import variables from GitHub Secrets
ENV="$1"
AZ="$2"
SES_USER="$3"
SES_PASS="$4"
SES_ID="$5"
SES_ENDPOINT="$6"
# Get parameters from AWS Parameter Store
ID="$(aws sts get-caller-identity --query "Account" --output text)"
LOGS="$(aws ssm get-parameter --name "$ENV.LogGroup.App" --query "Parameter.Value" --output text)"
TASKEXROLE="$(aws ssm get-parameter --name "$ENV.EcsTaskExecutionRole.App" --query "Parameter.Value" --output text)"
TASKROLE="$(aws ssm get-parameter --name "$ENV.EcsTaskRole.App" --query "Parameter.Value" --output text)"
ECR="$(aws ssm get-parameter --name "$ENV.ECRepo.App" --query "Parameter.Value" --output text)"
ECS="$(aws ssm get-parameter --name "$ENV.ECSCluster.App" --query "Parameter.Value" --output text)"
TASK="$(aws ecs list-tasks --cluster "$ECS" --desired-status RUNNING --query 'taskArns[0]' --output text | awk '{print substr($0,length-31)}')"
IP="$(aws ecs describe-tasks --cluster "$ECS" --tasks "$TASK" --query 'tasks[].containers[].networkInterfaces[].privateIpv4Address' --output text)"
DB_USERNAME="$(aws ssm get-parameter --name "$ENV.DataBase.DB_USERNAME.App" --query "Parameter.Value" --output text)"
DB_PASSWORD="$(aws ssm get-parameter --name "$ENV.DataBase.DB_PASSWORD.App" --query "Parameter.Value" --output text)"

# Create new Database private IP parameter
aws ssm put-parameter --name "$ENV.DataBase.IP.App" --type "String" --value "$IP" --overwrite

# Create new task definition for the Backend container
cat <<EOF >> ./infrastructure/ecs/App-task.json
{
  "containerDefinitions": [
    {
      "name": "App",
      "image": "$ID.dkr.ecr.$AZ.amazonaws.com/$ECR:latest",
      "memory": 2048,
      "essential": true,
      "linuxParameters": {
        "initProcessEnabled": true
      },
      "environment": [
        {
          "name": "DB_HOST",
          "value": "$IP"
        },
        {
          "name": "DB_DATABASE",
          "value": "$DB_USERNAME"
        },
        {
          "name": "DB_USERNAME",
          "value": "$DB_USERNAME"
        },
        {
          "name": "DB_PASSWORD",
          "value": "$DB_PASSWORD"
        },
        {
          "name": "MAIL_USERNAME",
          "value": "$SES_USER"
        },
        {
          "name": "MAIL_PASSWORD",
          "value": "$SES_PASS"
        },
        {
          "name": "MAIL_FROM_ADDRESS",
          "value": "$SES_ID"
        },
        {
          "name": "MAIL_HOST",
          "value": "$SES_ENDPOINT"
        }
      ],
      "command": [
        "/var/www/html/env_create.sh \$DB_HOST \$DB_USERNAME \$DB_PASSWORD \$MAIL_USERNAME \$MAIL_PASSWORD \$MAIL_FROM_ADDRESS \$MAIL_HOST"
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
        "startPeriod": 10,
        "retries": 3
      },
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "$LOGS",
          "awslogs-region": "$AZ",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ],
  "family": "App-App-TaskDefinition",
  "cpu": "1024",
  "memory": "2048",
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