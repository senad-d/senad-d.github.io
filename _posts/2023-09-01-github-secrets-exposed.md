---
title: How to get your GitHub secrets from GitHub Actions
date: 2023-09-01 08:00:00
categories: [GitHub, Actions]
tags: [github, actions, secret]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/git-banner.png?raw=true)

# GitHub Secrets

GitHub Actions is an automation and continuous integration/continuous deployment (CI/CD) platform provided by GitHub. It allows you to automate various tasks and workflows within your GitHub repositories, such as building, testing, and deploying your code. 

GitHub Actions allows you to store sensitive information, such as API keys or access tokens, as secrets. These secrets are encrypted and can be securely used within your workflows. You can securely store and access secrets within your GitHub Actions workflows, allowing you to automate tasks that require sensitive information without compromising security.

While GitHub Secrets are secure from being exposed in plaintext within your code and logs, they are not foolproof against users with repository access because anyone with write access to the repository can potentially modify or misuse them. GitHub Secrets primarily protect against accidental exposure in public code repositories and are best suited for protecting sensitive information from unintentional leaks rather than malicious actions from users with repository access.

# Access to the EKS using GitHub secrets

This post provides instructions for accessing the Amazon EKS service using GitHub secrets. The user is shown how to create a GitHub action, retrieve environment variables, add new credentials, and finally, access the EKS cluster using kubectl or Lens.

1\. Take note of your GitHub Secrets
  - Access GitHub's repository settings, locate the Secrets section.
  - Examine the names of your stored secrets for reference.

![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/github_secrets.png?raw=true)

2\. Create a GitHub action for the repository that has Admin access through the pipeline. 

```shell
name: test

on:
  workflow_dispatch:

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:

    - name: Get runner env variables
      run: env | base64

    - name: Get AWS secrets
      env:
        AWS_ACCESS_KEY_ID: ${\{ secrets.AWS_ACCESS_KEY_ID }}
        AWS_SECRET_ACCESS_KEY:  ${\{ secrets.AWS_SECRET_ACCESS_KEY }}
      run: |
        echo "AWS_ACCESS_KEY_ID= \$AWS_ACCESS_KEY_ID" | base64 
        echo "AWS_SECRET_ACCESS_KEY= \$AWS_SECRET_ACCESS_KEY" | base64

```
> After you copy this action remove all `\` symbols.
{: .prompt-tip }

3\. Run the action to get the environment variables from the runner

![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/github_act_secret.png?raw=true)

4\. The output is base64 encrypted and you need to decrypted it to extract the variables.

![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/github_runner_env_var.png?raw=true)

5\. Add new credentials

```shell
nano ~/.aws/credentials
```
```shell
[test]
aws_access_key_id = <aws_access_key_id>
aws_secret_access_key = <aws_secret_access_key>
region= <region>
```
```shell
export AWS_PROFILE=test
```

6\. Check if you ca access the EKS cluster
    
```shell
aws eks list-clusters

Output:
{
    "clusters": [
        "example1",
        "example2"
    ]
}
```

7\. Check out the AWS account 

```shell
aws sts get-caller-identity
```

8\. Get Kubeconfig file locally

```shell
aws eks update-kubeconfig --name example1
```

9\. You can now take control of EKS cluster

```shell
kubectl get pods -A
kubectl get all -n <name>
kubectl get deployment -n dev <name> -o yaml
```

