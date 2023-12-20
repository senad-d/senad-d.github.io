---
title: Use multiple AWS accounts using AWS CLI
date: 2022-06-01 12:00:00
categories: [AWS, CLI]
tags: [aws-cli, iam]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.pro/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/backgroun.png?raw=true){: .shadow }

[Configure AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)

Using multiple AWS accounts from the command line is natively handled with profiles in the AWS CLI.

## Using aws configure
Using the aws configure command, multiple profiles can be configured.
```shell
aws configure --profile account1
AWS Access Key ID : ...
AWS Secret Access Key : ...
Default region name : ...
Default output format : ...
```

Then, the `--profile account1` option may be used with future commands.
```shell
aws s3 ls --profile account1
```

Or an environment variable may be set.
```shell
export AWS_PROFILE=account1
aws s3 ls # uses account1 credentials
```
Note: If the profile is named `--profile default`, it will represent the default profile when no `--profile argument` is provided.

## Manually setting credentials
The `~/.aws/credentials` and `~/.aws/config` files can be modified directly.

- Add the credentials to the `~/.aws/credentials` file

```shell
[default]
aws_access_key_id=accesskey
aws_secret_access_key=secretaccesskey

[account1]
aws_access_key_id=accesskey
aws_secret_access_key=secretaccesskey
```

- Add the profile to the `~/.aws/config` file

```shell
[default]
region=us-east-1
output=json

[profile account1]
region=us-east-1
output=json
```

- Use the `--profile argument` or set the `AWS_PROFILE` environment variable.

```shell
aws s3 ls --profile account1
```

or you can use

```shell
export AWS_PROFILE=account1

aws s3 ls # uses account1 credentials
```

## Use export to login

### Add access key and secret key:
```shell
export AWS_ACCESS_KEY_ID=<YOUR_AWS_IAM_ACCESS_KEY_ID>  
export AWS_SECRET_ACCESS_KEY=<YOUR_AWS_IAM_SECRET_ACCESS_KEY>
```

### Check the identity
```shell
aws sts get-caller-identity
```

### Add IAM Role to the `~/.aws/config` file
```shell
[profile role1]
region = eu-central-1
source_profile = default
role_arn = arn:aws:iam::05449:role/administrator
```
### Asume Role:
```shell
export AWS_PROFILE=role1
```
## Security Token Service (STS) and exports the credentials obtained from the assumed role into environment variables.
Assumes an IAM role using STS, retrieves the temporary credentials for that role, and exports them into environment variables. These environment variables can then be used in subsequent commands or scripts to authenticate and access AWS services using the assumed role's permissions.
```shell
aws sts assume-role --role-arn arn:aws:iam::123456789:role/admin --role-session-name build-sandbox > aws.json
          export AWS_ACCESS_KEY_ID=$(jq '.Credentials.AccessKeyId' -r aws.json)
          export AWS_SECRET_ACCESS_KEY=$(jq '.Credentials.SecretAccessKey' -r aws.json)
          export AWS_SESSION_TOKEN=$(jq '.Credentials.SessionToken' -r aws.json)
```