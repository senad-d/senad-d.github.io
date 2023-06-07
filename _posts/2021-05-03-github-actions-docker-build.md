---
title: Quickstart for GitHub Actions
date: 2021-04-02 12:00:00
categories: [Software, GitHub]
tags: [github, actions]
---
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/git-banner.png?raw=true)

# Introduction

You only need a GitHub repository to create and run a GitHub Actions workflow. 

The following example shows you how GitHub Actions jobs can be automatically triggered, where they run, and how they can interact with the code in your repository.

## Creating your workflow

Create a `.github/workflows` directory in your repository on GitHub if this directory does not already exist.

In the `.github/workflows` directory, create a file named like `github-actions.yml`.

Example YAML file:

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
        aws-access-key-id: \${{ secrets.AWS_ACCESS_KEY_ID_DEV }}
        aws-secret-access-key: \${{ secrets.AWS_SECRET_ACCESS_KEY_DEV }}
        aws-region: \${{ env.AWS_REGION }}

    - name: Retrieve an authentication token
      run: |
        aws ecr get-login-password \
        --region \${{ env.AWS_REGION }} | docker login \
        --username AWS \
        --password-stdin $(aws sts get-caller-identity --query "Account" --output text).dkr.ecr.\${{ env.AWS_REGION }}.amazonaws.com

    - name: Build docker image
      run: |
        docker build -t \$(aws ssm get-parameter --name "\${{ env.aws_env }}.ECRepo.App" \
        --query "Parameter.Value" --output text) \
        -f ./Dockerfile .

    - name: Tag docker image
      run: |
        docker tag \$(aws ssm get-parameter --name "\${{ env.aws_env }}.ECRepo.App" --query "Parameter.Value" --output text):latest $(aws sts get-caller-identity --query "Account" --output text).dkr.ecr.\${{ env.AWS_REGION }}.amazonaws.com/\$(aws ssm get-parameter --name "\${{ env.aws_env }}.ECRepo.App" --query "Parameter.Value" --output text):latest

    - name: Push docker image to ECR repository
      run: | 
        docker push \$(aws sts get-caller-identity --query "Account" --output text).dkr.ecr.\${{ env.AWS_REGION }}.amazonaws.com/\$(aws ssm get-parameter --name "\${{ env.aws_env }}.ECRepo.App" --query "Parameter.Value" --output text):latest
```