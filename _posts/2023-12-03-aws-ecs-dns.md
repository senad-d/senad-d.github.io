---
title: Configure ECS private DNS
date: 2023-12-03 12:00:00
categories: [ECS]
tags: [aws, ecs, dns]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/ECS-Anywhere.png?raw=true){: .shadow }

---

Ensuring effective communication among Elastic Container Service (ECS) services is paramount, particularly in automated processes. A robust solution is essential for establishing secure and highly available ECS tasks capable of seamless interaction. Leveraging the Private Hosted Zone within a Virtual Private Cloud (VPC) serves as a key component to achieve this.

To establish a private DNS for an AWS ECS cluster utilizing Service Discovery through AWS Cloud Map, the following general steps can be followed:

> We will demonstrate these steps using CloudFormation and aws-cli.
{: .prompt-tip }

1\. Create the simple ***ECS Cluster*** with a dedicated ***namespace***

```shell
ECSCluster:
    Type: 'AWS::ECS::Cluster'
    Properties:
      ClusterName: My-Cluster
      ServiceConnectDefaults: 
        Namespace: !Ref Namespace
      
Namespace:
    Type: 'AWS::ServiceDiscovery::PrivateDnsNamespace'
    Properties:
      Description: AWS Cloud Map private DNS namespace for resources in backend services
      Vpc: !Ref Vpc
      Name: local
      Properties:
        DnsProperties:
          SOA:
            TTL: 60
```

2\. Create ***ServiceDiscovery*** Service for the specific ECS Service you intend to run.

```shell
ServiceDiscovery:
    Type: 'AWS::ServiceDiscovery::Service'
    Properties:
      Description: Service based on a private DNS namespace
      DnsConfig:
        DnsRecords:
          - Type: A
            TTL: 60
          - Type: AAAA
            TTL: 60
        RoutingPolicy: WEIGHTED
      Name: example
      NamespaceId: !Ref Namespace

Outputs:
  OutputSD:
    Description: CloudFront Bucket
    Value: !GetAtt ServiceDiscovery.Arn
    Export:
      Name: ServiceDiscovery
```

3\. Now we can run new ECS services and add them to the service registries.

- Create ***Task Definition*** for a simple application: ***My_task.json***

```shell
{
  "containerDefinitions": [
    {
      "name": "app",
      "image": "nginx:latest",
      "cpu": 512,
      "memory": 1024,
      "essential": true,
      "portMappings": [
        {
            "containerPort": 80,
            "hostPort": 80,
            "protocol": "tcp"
        }
      ],
    }
  ],
  "family": "app",
  "cpu": "512",
  "memory": "1024",
  "networkMode": "awsvpc",
  "executionRoleArn": "<My_TASK_EXECUTION_ROLE>",
  "taskRoleArn": "<My_TASK_ROLE>",
  "runtimePlatform": {
    "operatingSystemFamily": "LINUX"
  },
  "requiresCompatibilities": ["FARGATE"]
}
```

- Register new Task Definition

```shell
aws ecs register-task-definition --cli-input-json file://My_task.json
```

- Create ***ECS Service*** for the new Task Definition

```shell
aws ecs create-service \
    --cluster My-Cluster \
    --service-name My-Service-Name \
    --desired-count 1 \
    --launch-type "FARGATE" \
    --service-registries "registryArn=<OutputSD-ARN>,containerName=app"\
    --service-connect-configuration "enabled=true,namespace=local" \
    --task-definition My-Task \
    --network-configuration "awsvpcConfiguration={subnets=[PrivateSubnetA,PrivateSubnetB],securityGroups=[AppSG]}"
```

4\. After starting the ECS Service, ***ServiceDiscovery*** creates a new DNS record in the Private Hosted Zone associated with the ***PrivateDnsNamespace*** we created earlier.

5\. We can confirm connectivity to the service by performing a quick ping test from AWS CloudShell or any service running within the VPC.

```shell
ping example.local
```

> To connect different services, you can use the new service name inside of other services. For instance, you can use an ECS Service to run a database and a separate ECS Service to run an application that needs to connect to that database. You can simply use the new DNS name ***app.local*** in Task Definition to connect.
{: .prompt-tip }
