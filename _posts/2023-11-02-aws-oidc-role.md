---
title: Use IAM roles to connect GitHub Actions to actions in AWS
date: 2023-11-02 12:00:00
categories: [AWS, OIDC]
tags: [aws, iam]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/OpenID_logo.png?raw=true){: .shadow }

Use Web Identity or OpenID Connect (OIDC) federated identity providers instead of creating AWS Identity and Access Management users in your AWS account. With an identity provider (IdP), you can manage your user identities outside of AWS and give these external user identities permissions to access AWS resources in your account. 

![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/github-aws-oidc.svg?raw=true){: .shadow }

# Prerequisites

To follow along with this blog post, you should have the following prerequisites in place:

-   The ability to [create a new GitHub Actions workflow file](https://docs.github.com/en/actions/using-workflows/about-workflows#create-an-example-workflow) in the .github/workflows/ directory under a branch of a GitHub repository
-   An AWS account
-   Access to the following IAM permissions in the account:
    -   Must be able to [create an OpenID Connect IdP](https://docs.aws.amazon.com/IAM/latest/APIReference/API_CreateOpenIDConnectProvider.html)
    -   Must be able to [create an IAM role and attach a policy](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_job-functions_create-policies.html)

# Create OIDC provider, IAM role and scope the trust policy

Connect to your AWS account and create the ***`oidc.sh`*** script.

```shell
#!/bin/bash

NAME="$1"
INFRA_REPO="$2"
FRONTEND_REPO="$3"
BACKEND_REPO="$4"
URL="$5"
ACCOUNT_ID=$(aws sts get-caller-identity --output text --query Account --no-cli-pager)

# Create OIDC id
OIDC_URL=$(curl $URL \
  | jq -r '.jwks_uri | split("/")[2]')

OIDC_ID=$(echo | openssl s_client -servername "$OIDC_URL" -showcerts -connect "$OIDC_URL":443 2> /dev/null \
  | sed -n -e '/BEGIN/h' -e '/BEGIN/,/END/H' -e '$x' -e '$p' | tail +2 \
  | openssl x509 -fingerprint -noout \
  | sed -e "s/.*=//" -e "s/://g" \
  | tr "ABCDEF" "abcdef")

# Create an OIDC provider in your account
aws iam create-open-id-connect-provider \
  --url "https://token.actions.githubusercontent.com" \
  --thumbprint-list "$OIDC_ID" \
  --client-id-list "sts.amazonaws.com"

# Create OIDC Role
REPOS=("$INFRA_REPO" "$FRONTEND_REPO" "$BACKEND_REPO")
OIDC_TRUST='{
    "Version": "2012-10-17",
    "Statement": ['

# Loop through the repositories to create the trust statements
for REPO in "${REPOS[@]}"; do
    OIDC_TRUST+="
        {
            \"Effect\": \"Allow\",
            \"Principal\": {
                \"Federated\": \"arn:aws:iam::$ACCOUNT_ID:oidc-provider/token.actions.githubusercontent.com\"
            },
            \"Action\": \"sts:AssumeRoleWithWebIdentity\",
            \"Condition\": {
                \"StringEquals\": {
                    \"token.actions.githubusercontent.com:sub\": \"repo:$REPO::ref:refs/heads/main\",
                    \"token.actions.githubusercontent.com:aud\": \"sts.amazonaws.com\"
                }
            }
        },"
done

# Remove the trailing comma and close the JSON
OIDC_TRUST=${OIDC_TRUST%,}
OIDC_TRUST+='
    ]
}'

aws iam create-role \
  --role-name "$NAME"-oidc \
  --description "OIDC role" \
  --assume-role-policy-document "$OIDC_TRUST" \
  --no-cli-pager

OIDC_POLICY=$(echo -n '{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": [
              "*"
          ],
          "Resource": "*"
      }
      ]
}')

aws iam put-role-policy \
  --role-name "$NAME"-oidc \
  --policy-name "$NAME"-oidc-policy \
  --policy-document "$OIDC_POLICY" \

```
> Edit ***`OIDC_POLICY`***: Assign a minimum level of permissions to the role.
{: .prompt-tip }

> ***`oidc.sh`*** script allows you to create the OIDC connection IAM Role for new the AWS environment.
{: .prompt-tip }


## Usage


```shell
NAME="Name"
INFRA_REPO="account/project-infra"
FRONTEND_REPO="account/project-frontend"
BACKEND_REPO="account/project-backend"
URL="https://token.actions.githubusercontent.com/.well-known/openid-configuration"

./oidc.sh "$NAME" "$INFRA_REPO" "$FRONTEND_REPO" "$BACKEND_REPO" "$URL"
```

## Create a GitHub action to invoke the AWS CLI

- Create a basic workflow file, such as main.yml, in the .github/workflows directory of your repository. 

- Paste the following example workflow into the file.

```shell
# This is a basic workflow to help you get started with Actions
name:Connect to an AWS role from a GitHub repository

# Controls when the action will run. Invokes the workflow on push events but only for the main branch
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

env:
  AWS_REGION : <"us-east-1"> #Change to reflect your Region
  NAME: <name> #Change to reflect your IAM role’s name

# Permission can be added at job level or workflow level    
permissions:
      id-token: write   # This is required for requesting the JWT
      contents: read    # This is required for actions/checkout
jobs:
  AssumeRoleAndCallIdentity:
    runs-on: ubuntu-latest
    steps:
      - name: Git clone the repository
        uses: actions/checkout@v3
      - name: configure aws credentials
        uses: aws-actions/configure-aws-credentials@v1.7.0
        with:
          role-to-assume: <arn:aws:iam::111122223333:role/${{ env.NAME }}-oidc>
          role-session-name: GitHub_to_AWS_via_FederatedOIDC
          aws-region: ${{ env.AWS_REGION }}
      # Hello from AWS: WhoAmI
      - name: Sts GetCallerIdentity
        run: |
          aws sts get-caller-identity
```

## Audit the role usage: Query CloudTrail logs

The final step is to view the AWS CloudTrail logs in your account to audit the use of this role.

### To view the event logs for the GitHub action:

1.  In the AWS Management Console, open CloudTrail and choose **Event History**.
2.  In the **Lookup attributes** list, choose **Event source**.
3.  In the search bar, enter sts.amazonaws.com.
4.  You should see the GetCallerIdentity and AssumeRoleWithWebIdentity events.

You can also view one event at a time.