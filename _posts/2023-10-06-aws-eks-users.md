---
title: Add additional IAM users/roles to EKS ConfigMap
date: 2023-10-06 11:00:00
categories: [EKS]
tags: [aws, eks]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/kubernetes-banner.png?raw=true){: .shadow }

To add additional IAM users to an Amazon Elastic Kubernetes Service (EKS) cluster's ConfigMap, you typically use the aws-auth ConfigMap to define the IAM roles or users that are authorized to interact with the cluster. Here are the steps to add IAM users to the aws-auth ConfigMap:

1.  **Create IAM Group, Role and User:**
    - Create IAM group, role or user that you want to associate with your EKS cluster. 
    
    ```shell
    NAME="<name>"
    
    ACCOUNT_ID=$(aws sts get-caller-identity --output text --query Account --no-cli-pager)
    POLICY=$(echo -n '{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"AWS":"arn:aws:iam::'; echo -n     "$ACCOUNT_ID"; echo -n ':root"},"Action":"sts:AssumeRole","Condition":{}}]}')
    
    aws iam create-role \
      --role-name "$NAME" \
      --description "EKS role." \
      --assume-role-policy-document "$POLICY" \
      --output text \
      --query 'Role.Arn' \
      --no-cli-pager 
    
    aws iam create-group --group-name "$NAME" --no-cli-pager

    ADMIN_GROUP_POLICY=$(echo -n '{
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "AllowAssumeOrganizationAccountRole",
          "Effect": "Allow",
          "Action": "sts:AssumeRole",
          "Resource": "arn:aws:iam::'; echo -n "$ACCOUNT_ID"; echo -n ':role/'"$NAME"'-eks-admin"
        }
      ]
    }')

    aws iam put-group-policy \
      --group-name "$NAME"-eks-admin \
      --policy-name "$NAME"-eks-admin-policy \
      --policy-document "$ADMIN_GROUP_POLICY" \
      --no-cli-pager 

    aws iam create-user --user-name "$NAME" --no-cli-pager
    aws iam add-user-to-group --group-name "$NAME" --user-name "$NAME"
    ```

2.  **Associate IAM Roles/Users with the EKS Cluster:**
    
    -   To edit the `aws-auth` ConfigMap, you must log in as an EKS cluster administrator user. Then, you can use the `kubectl edit` command or create a YAML file to apply changes.
    ```shell
    kubectl get configmap aws-auth -n kube-system -o yaml > aws-auth-cm.yaml
    ```
    > Get current ConfigMap from EKS
    {: .prompt-tip }
    
3.  **Edit the `aws-auth` ConfigMap:**
    -   Here's an example of a YAML file to associate an IAM user with your EKS cluster:

    aws-auth-cm.yaml
    ```shell
    apiVersion: v1
    kind: ConfigMap
    data:
      mapRoles: |
        - groups:
          - system:bootstrappers
          - system:nodes
          rolearn: arn:aws:iam::123456789012:user/your-iam-user
          username: your-eks-username-1
        - groups:
          - system:masters
          rolearn: arn:aws:iam::123456789012:user/your-iam-user-2
          username: your-eks-username-2
        []
    metadata:
      name: aws-auth
      namespace: kube-system
    ```
    > Replace `arn:aws:iam::123456789012:user/your-iam-user` with the actual IAM user ARN you want to associate with your cluster and `your-eks-username` with the desired Kubernetes username.
    {: .prompt-tip }

4.  **Apply the ConfigMap:**
    -   If you've created the YAML file as shown above, you can apply it using the `kubectl apply` command:
    ```shell
    kubectl apply -f aws-auth-cm.yaml
    ```
    > If you used `kubectl edit`, save the changes.
    {: .prompt-tip }

5.  **Test Access:**
    -   After applying the ConfigMap, the IAM user should have access to your EKS cluster as specified in the `aws-auth` ConfigMap.
    ```shell
    kubectl get pods -A
    ```

Please make sure that the IAM user or role you associate with your EKS cluster has the necessary permissions for the actions they need to perform within the cluster.

Remember that IAM roles should be used for worker nodes (for nodes to access AWS services), while IAM users are typically used for cluster administration purposes. Be cautious when granting extensive permissions to IAM users, especially those mapped to `system:masters`, as they will have full control over the cluster. Always follow the principle of least privilege for security.
