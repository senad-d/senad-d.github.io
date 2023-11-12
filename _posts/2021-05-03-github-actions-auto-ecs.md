---
title: GitHub Actions for ECS service
date: 2021-04-02 12:00:00
categories: [Software, GitHub]
tags: [github, actions, aws, ecs]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/git-banner.png?raw=true)

# Introduction

You only need a GitHub repository to create and run a GitHub Actions workflow. 

The following example shows you how GitHub Actions jobs can be automatically triggered, where they run, and how they can interact with the code in your repository.

## Creating your workflow

Create a `.github/workflows` directory in your repository on GitHub if this directory does not already exist.

In the `.github/workflows` directory, create a file named like `github-actions.yml`.

## Example Start App YAML file:

> The double curly braces are missing for the GitHub action, don't forget to put them back.
{: .prompt-tip }

```shell
name: 3 - Build and Deploy Backend Container

env:
  AWS_ENV: 'dev'
  AWS_REGION: 'eu-west-1'
  APP_ADMIN_PASS: '$ secrets.ADMIN_PASS '
  SES_USER: '$ secrets.SES_USER '
  SES_PASS: '$ secrets.SES_PASS '
  SES_ID: '$ secrets.SES_ID '
  SES_ENDPOINT: '$ secrets.SES_ENDPOINT '


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
      uses: aws-actions/configure-aws-credentials@v1
      with:
        aws-access-key-id: ${\{secrets.AWS_ACCESS_KEY_ID_DEV}} 
        aws-secret-access-key: ${\{secrets.AWS_SECRET_ACCESS_KEY_DEV}} 
        aws-region: ${\{env.AWS_REGION}}

    - name: Create App Task Definition for ECS Fargate
      run: |
        sudo chmod +x ./infrastructure/ecs/apptask.sh && ./infrastructure/ecs/apptask.sh $AWS_ENV $AWS_REGION $SES_USER $SES_PASS $SES_ID $SES_ENDPOINT

    - name: Register new ECS Task Definition
      run: |
        aws ecs register-task-definition --cli-input-json file://infrastructure/ecs/App-task.json

    - name: Create a Backend Service in ECS Fargate
      run: |
        aws ecs create-service \
        --cluster $(aws ssm get-parameter --name "${\{env.AWS_REGION}}.ECSCluster.App" --query "Parameter.Value" --output text) \
        --service-name App-service \
        --task-definition $(aws ecs list-task-definitions | grep App-App-TaskDefinition | tail -n 1 | sed s/\",// | sed s/\"// | sed 's/ //g') \
        --desired-count 1 \
        --enable-execute-command \
        --launch-type "FARGATE" \
        --network-configuration "awsvpcConfiguration={subnets=[$(aws ssm get-parameter --name "${\{env.AWS_REGION}}.PublicSubnetA.App" --query "Parameter.Value" --output text)],securityGroups=[$(aws ssm get-parameter --name "${\{env.AWS_REGION}}.AppSG.App" --query "Parameter.Value" --output text)],assignPublicIp=ENABLED}" \
        --load-balancers targetGroupArn=$(aws elbv2 describe-target-groups --names ${\{env.AWS_REGION}}-App-Fargate-TG --query "TargetGroups[0].TargetGroupArn" --output text),containerName=App,containerPort=80
```

## Example Stop Data base YAML file:

> The double curly braces are missing for the GitHub action, don't forget to put them back.
{: .prompt-tip }

```shell
name: 2 - Build and Deploy DataBase

env:
  AWS_ENV: 'dev'
  AWS_REGION: 'eu-west-1'
  DB_USERNAME: $ secrets.DB_USERNAME 
  DB_PASSWORD: $ secrets.DB_PASSWORD 

on:
  #schedule:
  #  - cron: '55 05 * * 1-5'  # at 7:55 UTC on every day-of-week from Monday through Friday
  workflow_dispatch:
  
jobs:
  Build_and_Deploy:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout
      uses: actions/checkout@v3

    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v1
      with:
        aws-access-key-id: ${\{secrets.AWS_ACCESS_KEY_ID_DEV}} 
        aws-secret-access-key: ${\{secrets.AWS_SECRET_ACCESS_KEY_DEV}} 
        aws-region: ${\{env.AWS_REGION}}

    - name: Create DataBase Task Definition for ECS Fargate
      run: |
       sudo chmod +x ./infrastructure/ecs/dbtask.sh && ./infrastructure/ecs/dbtask.sh $AWS_ENV $AWS_REGION $DB_USERNAME $DB_PASSWORD

    - name: Register new ECS Task Definition
      run: |
        aws ecs register-task-definition --cli-input-json file://infrastructure/ecs/db-task.json

    - name: Create a Private DataBase Service in ECS Fatgate
      run: |
        aws ecs create-service \
        --cluster $(aws ssm get-parameter --name "${\{env.AWS_REGION}}.ECSCluster.App" --query "Parameter.Value" --output text) \
        --service-name CSI-DataBase-service \
        --task-definition $(aws ecs list-task-definitions | grep DataBase-CSI-TaskDefinition | tail -n 1 | sed s/\",// | sed s/\"// | sed 's/ //g') \
        --desired-count 1 \
        --enable-execute-command \
        --launch-type "FARGATE" \
        --network-configuration "awsvpcConfiguration={subnets=[$(aws ssm get-parameter --name "${\{env.AWS_REGION}}.PrivateSubnet.App" --query "Parameter.Value" --output text)],securityGroups=[$(aws ssm get-parameter --name "${\{env.AWS_REGION}}.SG.App.DataBase" --query "Parameter.Value" --output text)]}"
```

> After you copy this action remove `\` symbols from secrets.
{: .prompt-tip }

## Example Stop YAML file:

> The double curly braces are missing for the GitHub action, don't forget to put them back.
{: .prompt-tip }

```shell
name: 4 - Stop running ECS Fargate services

env:
  aws_env: 'dev'
  AWS_REGION: 'eu-west-1'

on:
  #schedule:
  #  - cron: '00 15 * * 1-5'  # at 17:00 UTC on every day-of-week from Monday through Friday
  workflow_dispatch:
  
jobs:
  Build_and_Deploy:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout
      uses: actions/checkout@v3

    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v1
      with:
        aws-access-key-id: ${\{secrets.AWS_ACCESS_KEY_ID_DEV}} 
        aws-secret-access-key: ${\{secrets.AWS_SECRET_ACCESS_KEY_DEV}} 
        aws-region: ${\{env.AWS_REGION}}

    - name: Stop App Services in ECS Fargate
      run: |
       aws ecs delete-service \
       --cluster $(aws ssm get-parameter --name "${\{env.AWS_REGION}}.ECSCluster.App" --query "Parameter.Value" --output text) \
       --service App-service \
       --force
       aws ecs delete-service \
       --cluster $(aws ssm get-parameter --name "${\{env.AWS_REGION}}.ECSCluster.App" --query "Parameter.Value" --output text) \
       --service CSI-DataBase-service \
       --force
```

> After you copy this action remove `\` symbols from secrets.
{: .prompt-tip }