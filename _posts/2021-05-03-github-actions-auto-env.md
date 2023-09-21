---
title: GitHub Actions for starting and stopping AWS resources
date: 2021-04-02 12:00:00
categories: [Software, GitHub]
tags: [github, actions, aws]
---
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/git-banner.png?raw=true)

# Introduction

You only need a GitHub repository to create and run a GitHub Actions workflow. 

The following example shows you how GitHub Actions jobs can be automatically triggered, where they run, and how they can interact with the code in your repository.

## Creating your workflow

Create a `.github/workflows` directory in your repository on GitHub if this directory does not already exist.

In the `.github/workflows` directory, create a file named like `github-actions.yml`.

## Example Start YAML file:

> The double curly braces are missing for the GitHub action, don't forget to put them back.

```shell
name: 1 - Create AWS Inf. Stack

env:
  aws_env: 'dev'
  AWS_REGION: 'eu-west-1'


on:
  #schedule:
  #  - cron: '50 05 * * 1-5'  # at 7:50 UTC on every day-of-week from Monday through Friday
  workflow_dispatch:
  
jobs:
  Build:
    runs-on: ubuntu-latest
    steps:
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: $ secrets.AWS_ACCESS_KEY_ID_DEV 
          aws-secret-access-key: $ secrets.AWS_SECRET_ACCESS_KEY_DEV 
          aws-region: $ env.AWS_REGION 
      
      - name: Create App backend stack
        run: |
          aws cloudformation create-stack \
          --stack-name App-backend-resources \
          --template-url https://csi-resources-$ env.aws_env .s3.$ env.AWS_REGION .amazonaws.com/cloudformation/backend.yml \
          --parameters ParameterKey=Environment,ParameterValue=$ env.aws_env   \
          --capabilities CAPABILITY_IAM
          aws cloudformation wait stack-create-complete --stack-name App-backend-resources

      - name: Create App frontend stack
        run: |
          aws cloudformation create-stack \
          --stack-name App-frontend-resources \
          --template-url https://csi-resources-$ env.aws_env .s3.$ env.AWS_REGION .amazonaws.com/cloudformation/frontend.yml \
          --parameters ParameterKey=Environment,ParameterValue=$ env.aws_env   \
          --capabilities CAPABILITY_IAM
          aws cloudformation wait stack-create-complete --stack-name App-frontend-resources

# Send notification to Slack private chanel.
  slack-workflow-status:
    if: always()
    name: Post Workflow Status To Slack
    needs:
      - Build
    runs-on: ubuntu-latest
    steps:
      - name: Slack Workflow Notification
        id: slack
        uses: slackapi/slack-github-action@v1.23.0
        with:
          # Optional Input
          name: 'ConstructionSiteInventory - Create App application stack'
          # For posting a rich message using Block Kit
          payload: |
            {
              "text": "ConstructionSiteInventory - Create App application stack GitHub Action build result: $ job.status \n$ github.event.pull_request.html_url || github.event.head_commit.url ",
              "blocks": [
                {
                  "type": "section",
                  "text": {
                    "type": "mrkdwn",
                    "text": "ConstructionSiteInventory - Create App application stack GitHub Action build result: $ job.status \n$ github.event.pull_request.html_url || github.event.head_commit.url "
                  }
                }
              ]
            }
        env:
          SLACK_WEBHOOK_TYPE: INCOMING_WEBHOOK
          SLACK_WEBHOOK_URL: $ secrets.SLACK_WEBHOOK_URL 
```

## Example Stop YAML file:

> The double curly braces are missing for the GitHub action, don't forget to put them back.

```shell
name: 5 - Delete AWS Inf. Stack

env:
  aws_env: 'dev'
  AWS_REGION: 'eu-west-1'

on:
  #schedule:
  #  - cron: '02 15 * * 1-5'  # at 17:02 UTC on every day-of-week from Monday through Friday
  workflow_dispatch:
  
jobs:
  Build:
    runs-on: ubuntu-latest
    steps:
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: $ secrets.AWS_ACCESS_KEY_ID_DEV 
          aws-secret-access-key: $ secrets.AWS_SECRET_ACCESS_KEY_DEV 
          aws-region: $ env.AWS_REGION 
      
      - name: Delete App frontend stack
        run: |
          aws cloudformation delete-stack --stack-name App-frontend-resources
          aws cloudformation wait stack-delete-complete --stack-name App-frontend-resources
      
      - name: Delete App backend stack
        run: |
          aws cloudformation delete-stack --stack-name App-backend-resources
          aws cloudformation wait stack-delete-complete --stack-name App-backend-resources
      
# Send notification to Slack private chanel.
  slack-workflow-status:
    if: always()
    name: Post Workflow Status To Slack
    needs:
      - Build
    runs-on: ubuntu-latest
    steps:
      - name: Slack Workflow Notification
        id: slack
        uses: slackapi/slack-github-action@v1.23.0
        with:
          # Optional Input
          name: 'ConstructionSiteInventory - Delete App application stack'
          # For posting a rich message using Block Kit
          payload: |
            {
              "text": "ConstructionSiteInventory - Delete App application stack GitHub Action build result: $ job.status \n$ github.event.pull_request.html_url || github.event.head_commit.url ",
              "blocks": [
                {
                  "type": "section",
                  "text": {
                    "type": "mrkdwn",
                    "text": "ConstructionSiteInventory - Delete App application stack GitHub Action build result: $ job.status \n$ github.event.pull_request.html_url || github.event.head_commit.url "
                  }
                }
              ]
            }
        env:
          SLACK_WEBHOOK_TYPE: INCOMING_WEBHOOK
          SLACK_WEBHOOK_URL: $ secrets.SLACK_WEBHOOK_URL 
```
