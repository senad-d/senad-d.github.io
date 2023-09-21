---
title: Test AWS credentials using AWS CLI
date: 2022-06-01 12:00:00
categories: [Cloud, AWS]
tags: [aws-cli, iam]
---
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/backgroun.png?raw=true){: .shadow }

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