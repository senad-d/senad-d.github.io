---
title: Create AWS OIDC for GitHub Actions
date: 2023-10-20 12:00:00
categories: [Cloud, AWS]
tags: [aws, ses]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/OpenID_logo.png?raw=true){: .shadow }

Use Web Identity or OpenID Connect (OIDC) federated identity providers instead of creating AWS Identity and Access Management users in your AWS account. With an identity provider (IdP), you can manage your user identities outside of AWS and give these external user identities permissions to access AWS resources in your account. 

# Create IAM OIDC Role in AWS

Connect to your AWS account as an admin user and create the ***`create_oidc.sh`*** script.

```shell
#!/bin/bash

NAME="$1"
INFRA_REPO="$2"
FRONTEND_REPO="$3"
BACKEND_REPO="$4"
ACCOUNT_ID=$(aws sts get-caller-identity --output text --query Account --no-cli-pager)

# Create OIDC
OIDC_URL=$(curl https://token.actions.githubusercontent.com/.well-known/openid-configuration \
  | jq -r '.jwks_uri | split("/")[2]')

OIDC_ID=$(echo | openssl s_client -servername "$OIDC_URL" -showcerts -connect "$OIDC_URL":443 2> /dev/null \
  | sed -n -e '/BEGIN/h' -e '/BEGIN/,/END/H' -e '$x' -e '$p' | tail +2 \
  | openssl x509 -fingerprint -noout \
  | sed -e "s/.*=//" -e "s/://g" \
  | tr "ABCDEF" "abcdef")

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
                    \"token.actions.githubusercontent.com:sub\": \"repo:$REPO:*\",
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

> **create_oidc.sh** script allows you to create the OIDC connection IAM Role for new the AWS environment.


## Usage


```shell
NAME="Name"
INFRA_REPO="account/project-infra"
FRONTEND_REPO="account/project-frontend"
BACKEND_REPO="account/project-backend"

./create_oidc.sh "$NAME" "$INFRA_REPO" "$FRONTEND_REPO" "$BACKEND_REPO"
```
