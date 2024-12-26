---
title: Create OpenVPN users from the list with GitHub Actions
date: 2023-02-01 12:00:00
categories: [Projects, OpenVPN]
tags: [aws, openvpn, actions]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/backgroun.png?raw=true){: .shadow }

To streamline and simplify the process of creating a larger number of users requiring access, you can utilize a GitHub Action. One prerequisite for its usage is that during the deployment of the [***CloudFormation template***](https://senad-d.github.io/posts/projects-openvpn-aws-cf/), you have provided a verified email address for SES.

Here's a step-by-step guide:

1. Create a new private repository and add secrets for actions to establish a connection with AWS.
2. Create an action to synchronize the user list with OpenVPN.
3. Generate a new user list in the email address format, with each user listed on a separate line. Save the file as:
	./users/vpn_user_list
	```shell
	mail1@example.com
	mail2@example.com
	mail3@example.com
	```
4. Once the changes are pushed to GitHub, your OpenVPN will create new users and send them an email containing the configuration file. Please note that the configuration file will expire within 24 hours of receiving the email.

By following these steps, you can efficiently generate OpenVPN users and automate the process using GitHub Actions.

* GitHub Action for creating OpenVPN users from the list

```shell
name: Manage OpenVPN users

env:
  AWS_REGION: 'us-west-1'
  PROJECT: '<cloudformation project name>'

on:
  push:
    branches: [main]
    paths: ['users/*']
  workflow_dispatch:


jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout
      uses: actions/checkout@v2

    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v1
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID_DEV }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY_DEV }}
        aws-region: ${{ env.AWS_REGION }}

    - name: Manage users
      run: |
        ID="Key=InstanceIds,Values=$(aws ssm get-parameter --name ${{ env.PROJECT }}.Ec2-Id --query "Parameter.Value" --output text)"
        S3="$(aws ssm get-parameter --name ${{ env.PROJECT }}.S3-Id --query "Parameter.Value" --output text)"

        # Push new list to S3 bucket
        aws s3 sync ./users s3://$S3/users.txt
        
        # Update old user lists
        aws ssm send-command \
        --comment "Update old user lists" \
        --targets $ID \
        --document-name "AWS-RunShellScript" \
        --parameters 'commands=["mv /root/list_of_all_users.txt /root/list_of_vpn_users.txt"]' \
        --output table

        # Get new user list from S3 bucket
        aws ssm send-command \
        --comment "Get new user list" \
        --targets $ID \
        --document-name "AWS-RunShellScript" \
        --parameters 'commands=["aws s3api get-object --bucket $S3 --key /vpn_user_list /root/list_of_all_users.txt"]' \
        --output table

        # Update users fom the new list
        aws ssm send-command \
        --comment "Update users" \
        --targets $ID \
        --document-name "AWS-RunShellScript" \
        --parameters 'commands=["cd /root/ && ./users.sh"]' \
        --output table
```
