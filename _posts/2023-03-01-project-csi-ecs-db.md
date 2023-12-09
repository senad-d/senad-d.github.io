---
title: Create ECS Task Definition for Project database
date: 2023-03-01 12:00:00
categories: [Projects, ECS]
tags: [aws, ecs, task definition]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/backgroun.png?raw=true){: .shadow }

Create database task definition for ECS Faregate.

```shell
#!/bin/bash

########################################################
# Pull parameters from aws and store oders.            #
# in order to get IP address, username and password    #
# for the database running in the Fargate container    #
# ENV, AZ, DB_USERNAME and DB_PASSWORD are impoted     #
# from the pipeline.                                   #
########################################################

# Import variables from GitHub Secrets
ENV="$1"
AZ="$2"
DB_USERNAME="$3"
DB_PASSWORD="$4"
# Get parameters from AWS Parameter Store
LOGS="$(aws ssm get-parameter --name "$ENV.LogGroup.App" --query "Parameter.Value" --output text)"
EFS="$(aws ssm get-parameter --name "$ENV.AppSystemFiles.App" --query "Parameter.Value" --output text)"
TASKROLE="$(aws ssm get-parameter --name "$ENV.EcsDBTaskRole.App" --query "Parameter.Value" --output text)"
TASKEXROLE="$(aws ssm get-parameter --name "$ENV.EcsTaskExecutionRole.App" --query "Parameter.Value" --output text)"

# Create parameters for database
aws ssm put-parameter --name "$ENV.DataBase.DB_PASSWORD.App" --type "String" --value "$DB_PASSWORD" --overwrite
aws ssm put-parameter --name "$ENV.DataBase.DB_USERNAME.App" --type "String" --value "$DB_USERNAME" --overwrite


# Create new task definition for DataBase
cat <<EOF >> ./infrastructure/ecs/db-task.json
{
  "containerDefinitions": [
    {
      "name": "mysql",
      "image": "mysql:8.0",
      "essential": true,
      "memory": 2048,
      "linuxParameters": {
        "initProcessEnabled": true
      },
      "environment": [
        {
          "name": "MYSQL_USER",
          "value": "$DB_USERNAME"
        },
        {
          "name": "MYSQL_PASSWORD",
          "value": "$DB_PASSWORD"
        },
        {
          "name": "MYSQL_DATABASE",
          "value": "$DB_USERNAME"
        },
        {
          "name": "MYSQL_ROOT_PASSWORD",
          "value": "$DB_PASSWORD"
        }
      ],
      "mountPoints": [
        {
            "sourceVolume": "efs-db",
            "containerPath": "/var/lib/mysql"
        }
      ],
      "portMappings": [
        {
          "containerPort": 3306,
          "hostPort": 3306
        }
      ],
      "healthCheck": {
        "command": ["CMD", "mysqladmin", "ping", "-p$DB_PASSWORD"],
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
          "awslogs-stream-prefix": "ecs-db"
        }
      }
    }
  ],
  "volumes": [
      {
          "name": "efs-db",
          "efsVolumeConfiguration": {
            "fileSystemId": "$EFS"
          }
      }
  ],
  "family": "DataBase-CSI-TaskDefinition",
  "cpu": "1024",
  "memory": "2048",
  "networkMode": "awsvpc",
  "taskRoleArn": "$TASKROLE",
  "executionRoleArn": "$TASKEXROLE",
  "runtimePlatform": {
    "operatingSystemFamily": "LINUX"
  },
  "requiresCompatibilities": ["FARGATE"]
}
EOF
```