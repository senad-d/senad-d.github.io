---
title: Quickstart for GitHub Actions
date: 2021-04-02 12:00:00
categories: [Software, GitHub]
tags: [github, actions]
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

> The double curly braces are missing for the GitHub actions, don't forget to put them back.

```shell
name: 0.3 - Update and Push Image

env:
  aws_env: 'dev'
  AWS_REGION: 'eu-west-1'

on:
  push:
    branches: ['master']
    paths: ['*.mpr']
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
        aws-access-key-id: $ secrets.AWS_ACCESS_KEY_ID_DEV 
        aws-secret-access-key: $ secrets.AWS_SECRET_ACCESS_KEY_DEV 
        aws-region: $ env.AWS_REGION 

    - name: Retrieve an authentication token
      run: |
        aws ecr get-login-password --region $ env.AWS_REGION  | docker login \
        --username AWS \
        --password-stdin $(aws sts get-caller-identity --query "Account" --output text).dkr.ecr.$ env.AWS_REGION .amazonaws.com

    - name: Build docker image
      run: |
        docker build -t $(aws ssm get-parameter --name "$ env.aws_env .ECRepo.hrfbapp" --query "Parameter.Value" --output text) \
        -f ./infra/Dockerfile .

    - name: Tag docker image
      run: |
        docker tag $(aws ssm get-parameter --name "$ env.aws_env .ECRepo.hrfbapp" --query "Parameter.Value" --output text):latest $(aws sts get-caller-identity --query "Account" --output text).dkr.ecr.$ env.AWS_REGION .amazonaws.com/$(aws ssm get-parameter --name "$ env.aws_env .ECRepo.hrfbapp" --query "Parameter.Value" --output text):latest

    - name: Push docker image to repository
      run: | 
        docker push $(aws sts get-caller-identity \
        --query "Account" \
        --output text).dkr.ecr.$ env.AWS_REGION .amazonaws.com/$(aws ssm get-parameter --name "$ env.aws_env .ECRepo.hrfbapp" --query "Parameter.Value" --output text):latest

    - name: Update ECS cluster with new image
      run: | 
        aws ecs update-service \
        --cluster $(aws ssm get-parameter --name "$ env.aws_env .ECSCluster.hrfbapp" --query "Parameter.Value" --output text) \
        --service hrfbapp-service \
        --force-new-deployment

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
          name: 'hrfbapp - New App Version'
          # For posting a rich message using Block Kit
          payload: |
            {
              "text": "hrfbapp - New App Version GitHub Action build result: $ job.status \n$ github.event.pull_request.html_url || github.event.head_commit.url ",
              "blocks": [
                {
                  "type": "section",
                  "text": {
                    "type": "mrkdwn",
                    "text": "hrfbapp - New App Version GitHub Action build result: $ job.status \n$ github.event.pull_request.html_url || github.event.head_commit.url "
                  }
                }
              ]
            }
        env:
          SLACK_WEBHOOK_TYPE: INCOMING_WEBHOOK
          SLACK_WEBHOOK_URL: $ secrets.SLACK_WEBHOOK_URL 
```

## Viewing your workflow results

- On GitHub.com, navigate to the main page of the repository.

- Under your repository name, click  Actions.

- In the left sidebar, click the workflow you want to display.

- From the list of workflow runs, click the name of the run you want to see.

- In the left sidebar of the workflow run page, under Jobs, select the Action.

- The log shows you how each of the steps was processed. Expand any of the steps to view its details.

![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/github-actions-resault.png?raw=true){: .shadow }

## More starter workflows

GitHub provides preconfigured starter workflows that you can customize to create your own continuous integration workflow. GitHub analyzes your code and shows you CI starter workflows that might be useful for your repository. For example, if your repository contains Node.js code, you'll see suggestions for Node.js projects. You can use starter workflows as a starting place to build your custom workflow or use them as-is.

You can browse the full list of starter workflows in the [actions/starter-workflows](https://github.com/actions/starter-workflows) repository.

## Next steps

GitHub Actions can help you automate nearly every aspect of your application development processes. Ready to get started? Here are some helpful resources for taking your next steps with GitHub Actions:

- For continuous integration (CI) workflows to build and test your code, see "[Automating builds and tests](https://docs.github.com/en/actions/automating-builds-and-tests)."
- For building and publishing packages, see "[Publishing packages](https://docs.github.com/en/actions/publishing-packages)."
- For deploying projects, see "[Deployment](https://docs.github.com/en/actions/deployment)."
- For automating tasks and processes on GitHub, see "[Managing issues and pull requests](https://docs.github.com/en/actions/managing-issues-and-pull-requests)."
- For examples that demonstrate more complex features of GitHub Actions, including many of the above use cases, see "[Examples](https://docs.github.com/en/actions/examples)." You can see detailed examples that explain how to test your code on a runner, access the GitHub CLI, and use advanced features such as concurrency and test matrices.