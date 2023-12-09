---
title: GitHub Actions for building Docker image
date: 2021-04-02 12:00:00
categories: [GitHub]
tags: [github, actions, docker]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/git-banner.png?raw=true)

# Introduction

You only need a GitHub repository to create and run a GitHub Actions workflow. 

The following example shows you how GitHub Actions jobs can be automatically triggered, where they run, and how they can interact with the code in your repository.

## Creating your workflow

Create a `.github/workflows` directory in your repository on GitHub if this directory does not already exist.

In the `.github/workflows` directory, create a file named like `github-actions.yml`.

## Example YAML file:

> The double curly braces are missing for the GitHub action, don't forget to put them back.
{: .prompt-tip }

```shell
name: 0.3 - Build and Push Backend Image

env:
  AWS_REGION: 'X-x-X'
  aws_env: 'dev'

on:
  #push:
  #  branches: [ dev ]
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

    - name: Retrieve an authentication token
      run: |
        aws ecr get-login-password \
        --region ${\{env.AWS_REGION}}  | docker login \
        --username AWS \
        --password-stdin $(aws sts get-caller-identity --query "Account" --output text).dkr.ecr.${\{env.AWS_REGION}} .amazonaws.com

    - name: Build docker image
      run: |
        docker build -t $(aws ssm get-parameter --name "$ env.aws_env .ECRepo.App" \
        --query "Parameter.Value" --output text) \
        -f ./Dockerfile .

    - name: Tag docker image
      run: |
        docker tag $(aws ssm get-parameter --name "$ env.aws_env .ECRepo.App" --query "Parameter.Value" --output text):latest $(aws sts get-caller-identity --query "Account" --output text).dkr.ecr.${\{env.AWS_REGION}} .amazonaws.com/$(aws ssm get-parameter --name "$ env.aws_env .ECRepo.App" --query "Parameter.Value" --output text):latest

    - name: Push docker image to ECR repository
      run: | 
        docker push $(aws sts get-caller-identity --query "Account" --output text).dkr.ecr.${\{env.AWS_REGION}} .amazonaws.com/$(aws ssm get-parameter --name "$ env.aws_env .ECRepo.App" --query "Parameter.Value" --output text):latest
```


## Example Update docker image YAML file:

> The double curly braces are missing for the GitHub action, don't forget to put them back.
{: .prompt-tip }

```shell
name: 0.4 - Push new Backend Image and Update ECS 

env:
  aws_env: 'dev'
  AWS_REGION: 'eu-west-1'

on:
  #push:
  #  branches: ['main']
  #  paths: ['backend/**']
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

    - name: Retrieve an authentication token
      run: |
        aws ecr get-login-password --region ${\{env.AWS_REGION}}  | docker login \
        --username AWS \
        --password-stdin $(aws sts get-caller-identity --query "Account" --output text).dkr.ecr.${\{env.AWS_REGION}} .amazonaws.com

    - name: Build new Backend docker image
      run: |
        docker build -t $(aws ssm get-parameter --name "$ env.aws_env .ECRepo.App" --query "Parameter.Value" --output text) \
        -f ./Dockerfile .

    - name: Tag docker image version
      run: |
        docker tag $(aws ssm get-parameter --name "$ env.aws_env .ECRepo.App" --query "Parameter.Value" --output text):latest $(aws sts get-caller-identity --query "Account" --output text).dkr.ecr.${\{env.AWS_REGION}} .amazonaws.com/$(aws ssm get-parameter --name "$ env.aws_env .ECRepo.App" --query "Parameter.Value" --output text):latest

    - name: Push docker image to ECR repository
      run: | 
        docker push $(aws sts get-caller-identity \
        --query "Account" \
        --output text).dkr.ecr.${\{env.AWS_REGION}} .amazonaws.com/$(aws ssm get-parameter --name "$ env.aws_env .ECRepo.App" --query "Parameter.Value" --output text):latest

    - name: Update ECS cluster with new Backend image
      run: | 
        aws ecs update-service \
        --cluster $(aws ssm get-parameter --name "$ env.aws_env .ECSCluster.App" --query "Parameter.Value" --output text) \
        --service App-service \
        --force-new-deployment

# Send notification to Slack private chanel.
  slack-workflow-status:
    if: always()
    name: Post Workflow Status To Slack
    needs:
      - Build_and_Deploy
    runs-on: ubuntu-latest
    steps:
      - name: Slack Workflow Notification
        id: slack
        uses: slackapi/slack-github-action@v1.23.0
        with:
          # Optional Input
          name: 'Project - New Backend Version'
          # For posting a rich message using Block Kit
          payload: |
            {
              "text": "Project - New Backend Version GitHub Action build result: $ job.status \n$ github.event.pull_request.html_url || github.event.head_commit.url ",
              "blocks": [
                {
                  "type": "section",
                  "text": {
                    "type": "mrkdwn",
                    "text": "Project - New Backend Version GitHub Action build result: $ job.status \n$ github.event.pull_request.html_url || github.event.head_commit.url "
                  }
                }
              ]
            }
        env:
          SLACK_WEBHOOK_TYPE: INCOMING_WEBHOOK
          SLACK_WEBHOOK_URL: ${\{secrets.SLACK_WEBHOOK_URL}} 
```