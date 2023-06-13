---
title: Getting Started with Amazon EKS using Terraform
date: 2023-14-06 12:00:00
categories: [Cloud, AWS, EKS]
tags: [eks, terraform]
---
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/terraform-banner.png?raw=true){: .shadow }

## Define variables for a Terraform configuration (variables.tf)

1. ***region***: This variable is used to specify the AWS region where the infrastructure will be deployed. The default value is set to "ap-southeast-2", which corresponds to the Asia Pacific (Sydney) region.

2. ***cluster_name***: This variable is used to specify the name of the EKS cluster. The default value is set to "getting-started-eks".

3. ***map_accounts***: This variable is used to define additional AWS account numbers that will be added to the aws-auth ConfigMap. The aws-auth ConfigMap is used to configure access for IAM users and roles in an EKS cluster. The variable type is set to a list of strings, and the default value includes two AWS account numbers: "777777777777" and "888888888888".

4. ***map_roles***: This variable is used to define additional IAM roles that will be added to the aws-auth ConfigMap. The variable type is set to a list of objects, where each object contains the properties rolearn, username, and groups. The rolearn specifies the IAM role ARN, username specifies the desired username, and groups specifies the groups to which the role belongs. The default value includes one IAM role with the following values:

- rolearn: "arn:aws:iam::66666666666:role/role1"
- username: "role1"
- groups: ["system:masters"]

5. ***map_users***: This variable is used to define additional IAM users that will be added to the aws-auth ConfigMap. Similar to map_roles, it is a list of objects with properties userarn, username, and groups. The default value includes two IAM users with the following values:

- User 1:
    - userarn: "arn:aws:iam::66666666666:user/user1"
    - username: "user1"
    - groups: ["system:masters"]

- User 2:
    - userarn: "arn:aws:iam::66666666666:user/user2"
    - username: "user2"
    - groups: ["system:masters"]

These variables allow you to customize various aspects of the Terraform configuration, such as the region, cluster name, and additional IAM users and roles that should have access to the EKS cluster.

```shell
variable "region" {
  default     = "ap-southeast-2"
  description = "AWS region"
}

variable "cluster_name" {
  default = "getting-started-eks"
}

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)

  default = [
    "777777777777",
    "888888888888",
  ]
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      rolearn  = "arn:aws:iam::66666666666:role/role1"
      username = "role1"
      groups   = ["system:masters"]
    },
  ]
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::66666666666:user/user1"
      username = "user1"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::66666666666:user/user2"
      username = "user2"
      groups   = ["system:masters"]
    },
  ]
}
```