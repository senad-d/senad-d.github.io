---
title: Test AWS credentials using AWS CLI
date: 2023-05-29 12:00:00
categories: [Cloud, AWS]
tags: [aws cli, iam]
---
# Test AWS credentials using AWS CLI
Testing for AWS credentials is a straightforward operation.

## Using get-caller-identity
There is a single API call that will always work regardless of permissions: GetCallerIdentity
```shell
aws sts get-caller-identity
```

Output:
```shell
{
    "UserId": "AIDA...",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/thomas"
}
```

The `Arn` value depends on the type of credentials, but mostly includes the human-friendly name.

In addition, checking the status is reliable: `0` for success, `255` for failure.