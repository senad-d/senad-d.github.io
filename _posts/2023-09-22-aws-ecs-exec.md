---
title: Connecting Amazon ECS Exec for debugging
date: 2023-09-22 12:00:00
categories: [Cloud, AWS]
tags: [aws, ecs]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/ECS-Anywhere.png?raw=true){: .shadow }

# ECS Exec

ECS Exec makes use of AWS Systems Manager (SSM) Session Manager to establish a connection with the running container and uses AWS Identity and Access Management (IAM) policies to control access to running commands in a running container. This is made possible by bind-mounting the necessary SSM agent binaries into the container. The Amazon ECS or AWS Fargate agent is responsible for starting the SSM core agent inside the container alongside your application code.

## Prerequisites for using ECS Exec

Before you start using ECS Exec, make sure you that you have completed these actions:

-   Install and configure the AWS CLI. For more information, see [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-environment.html).
    
-   Install Session Manager plugin for the AWS CLI. For more information, see [Install the Session Manager plugin for the AWS CLI](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html).
    
-   You must use a task role with the appropriate permissions for ECS Exec. For more information, see [Task IAM role](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-iam-roles.html).
    
-   ECS Exec has version requirements depending on whether your tasks are hosted on Amazon EC2 or AWS Fargate:
    
    -   If you're using Amazon EC2, you must use an Amazon ECS optimized AMI that was released after January 20th, 2021, with an agent version of 1.50.2 or greater. For more information, see [Amazon ECS optimized AMIs](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html).
        
    -   If you're using AWS Fargate, you must use platform version `1.4.0` or higher (Linux) or `1.0.0` (Windows). For more information, see [AWS Fargate platform versions](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/platform_versions.html).

## Using ECS Exec

### Optional task definition changes

If you set the task definition parameter `initProcessEnabled` to `true`, this starts the init process inside the container, which removes any zombie SSM agent child processes found. The following provides an example.

```shell
{
    "taskRoleArn": "ecsTaskRole",
    "networkMode": "awsvpc",
    "requiresCompatibilities": [
        "EC2",
        "FARGATE"
    ],
    "executionRoleArn": "ecsTaskExecutionRole",
    "memory": ".5 gb",
    "cpu": ".25 vcpu",
    "containerDefinitions": [
        {
            "name": "amazon-linux",
            "image": "amazonlinux:latest",
            "essential": true,
            "command": ["sleep","3600"],
            "linuxParameters": {
                "initProcessEnabled": true
            }
        }
    ],
    "family": "ecs-exec-task"
}
```

### Turning on ECS Exec for your tasks and services

You can turn on the ECS Exec feature for your services and standalone tasks by specifying the `--enable-execute-command` flag when using one of the following AWS CLI commands: [`create-service`](https://docs.aws.amazon.com/cli/latest/reference/ecs/create-service.html), [`update-service`](https://docs.aws.amazon.com/cli/latest/reference/ecs/update-service-console-v2.html), [`start-task`](https://docs.aws.amazon.com/cli/latest/reference/ecs/start-task.html), or [`run-task`](https://docs.aws.amazon.com/cli/latest/reference/ecs/run-task.html).

For example, if you run the following command, the ECS Exec feature is turned on for a newly created service. For more information about creating services, see [create-service](https://docs.aws.amazon.com/cli/latest/reference/ecs/create-service.html).

```shell
aws ecs create-service \
    --cluster cluster-name \
    --task-definition task-definition-name \
    --enable-execute-command \
    --service-name service-name \
    --desired-count 1
```

After you turn on ECS Exec for a task, you can run the following command to confirm the task is ready to be used. If the `lastStatus` property of the `ExecuteCommandAgent` is listed as `RUNNING` and the `enableExecuteCommand` property is set to `true`, then your task is ready.

```shell
aws ecs describe-tasks \
    --cluster cluster-name \
    --tasks task-id
```

The following output snippet is an example of what you might see.

```shell
{
    "tasks": [
        {
            ...
            "containers": [
                {
                    ...
                    "managedAgents": [
                        {
                            "lastStartedAt": "2021-03-01T14:49:44.574000-06:00",
                            "name": "ExecuteCommandAgent",
                            "lastStatus": "RUNNING"
                        }
                    ]
                }
            ],
            ...
            "enableExecuteCommand": true,
            ...
        }
    ]
}
```

### Running commands using ECS Exec

After you have confirmed the `ExecuteCommandAgent` is running, you can open an interactive shell on your container using the following command. If your task contains multiple containers, you must specify the container name using the `--container` flag. Amazon ECS only supports initiating interactive sessions, so you must use the `--interactive` flag.

The following command will run an interactive `/bin/sh` command against a container named `` `container-name` `` for a task with an id of `task-id`.

```shell
aws ecs execute-command --cluster cluster-name \
    --task task-id \
    --container container-name \
    --interactive \
    --command "/bin/sh"
```