---
title: GitHub Actions for S3 upload
date: 2021-04-02 12:00:00
categories: [Software, GitHub, AWS]
tags: [github, actions, aws, s3]
---
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/git-banner.png?raw=true)

# Introduction

You only need a GitHub repository to create and run a GitHub Actions workflow. 

The following example shows you how GitHub Actions jobs can be automatically triggered, where they run, and how they can interact with the code in your repository.

## Creating your workflow

Create a `.github/workflows` directory in your repository on GitHub if this directory does not already exist.

In the `.github/workflows` directory, create a file named like `github-actions.yml`.

## Example YAML file:

> The double curly braces are missing for the GitHub actions, don't forget to put them back.

```shell
name: 0.1 - Copy Inf. templates

env:
  AWS_REGION: 'eu-west-1'
  B_ZONE_ID: $ secrets.HOSTED_ZONE_ID 
  B_ZONE_NAME: $ secrets.HOSTED_ZONE_NAME 
  B_CERT: $ secrets.WEB_CERT 
  F_ZONE_ID: $ secrets.HOSTED_ZONE_ID 
  F_ZONE_NAME: $ secrets.HOSTED_ZONE_NAME 
  F_CERT: $ secrets.WEB_CERT_CF 
  F_CERTP: $ secrets.WEB_CERT_CF 

on:
  workflow_dispatch:
  
jobs:
  Build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: $ secrets.AWS_ACCESS_KEY_ID_DEV 
          aws-secret-access-key: $ secrets.AWS_SECRET_ACCESS_KEY_DEV 
          aws-region: $ env.AWS_REGION 
      
      - name: Create CloudFormation templates
        run: |
          sudo chmod +x ./infrastructure/cloudformation/backend.sh && ./infrastructure/cloudformation/backend.sh $B_ZONE_ID $B_ZONE_NAME $B_CERT && \
          sudo chmod +x ./infrastructure/cloudformation/frontend.sh && ./infrastructure/cloudformation/frontend.sh $F_ZONE_ID $F_ZONE_NAME $F_CERT $F_CERTP

      - name: Copy infrastructure templates to S3
        run: |
          aws s3 sync ./infrastructure/cloudformation/ s3://csi/cloudformation/
```

## Example 2 YAML file:

> The double curly braces are missing for the GitHub actions, don't forget to put them back.

```shell
name: 0.2 - Build and Push Frontend to S3

env:
  aws_env: 'dev'
  AWS_REGION: 'eu-west-1'

on:
  #push:
  #  branches: ['main']
  #  paths: ['frontend/**']
  workflow_dispatch:
  
jobs:
  Build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      
      - name: Node checkout
        uses: actions/setup-node@v3
        with:
          node-version: '18'

      - name: Build Frontend and Connect it to Backend
        run: |
          npm install -g @quasar/cli
          cd frontend
          npm ci
          echo "BASE_API_URL=$ secrets.BASE_API_URL " > .env
          echo "productName=Construction Site Inventory" >> .env
          quasar build

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: $ secrets.AWS_ACCESS_KEY_ID_DEV 
          aws-secret-access-key: $ secrets.AWS_SECRET_ACCESS_KEY_DEV 
          aws-region: $ env.AWS_REGION 
      
      - name: Copy Frontend to Private S3 Bucket
        run: |
          aws s3 sync ./frontend/dist/spa/ s3://csi-$ env.aws_env /

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
          name: 'ConstructionSiteInventory - New Frontend Version'
          # For posting a rich message using Block Kit
          payload: |
            {
              "text": "ConstructionSiteInventory - New Frontend Version GitHub Action build result: $ job.status \n$ github.event.pull_request.html_url || github.event.head_commit.url ",
              "blocks": [
                {
                  "type": "section",
                  "text": {
                    "type": "mrkdwn",
                    "text": "ConstructionSiteInventory - New Frontend Version GitHub Action build result: $ job.status \n$ github.event.pull_request.html_url || github.event.head_commit.url "
                  }
                }
              ]
            }
        env:
          SLACK_WEBHOOK_TYPE: INCOMING_WEBHOOK
          SLACK_WEBHOOK_URL: $ secrets.SLACK_WEBHOOK_URL 
```