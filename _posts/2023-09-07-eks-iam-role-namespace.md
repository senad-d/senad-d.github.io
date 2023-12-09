---
title: Create AWS IAM Role for accessing the EKS namespace
date: 2023-09-07 08:00:00
categories: [EKS]
tags: [iam, aws, eks, role]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/eks-banner.png?raw=true)

This guide delves into the essential process of creating an AWS IAM Role tailored specifically for accessing an EKS namespace. By following the steps outlined in this tutorial, you'll gain a comprehensive understanding of how to set up fine-grained access control, enhancing the security and manageability of your Kubernetes workloads on AWS EKS. 


1\. Create the IAM Role
- Attach a policy to the IAM role that grants permissions to assume the role.
```shell
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource": "arn:aws:iam::YOUR_ACCOUNT_ID:role/YOUR_ROLE_NAME"
        }
    ]
}
```

  - Update the Trust Relationship of the Role.
  ```shell
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::YOUR_ACCOUNT_ID:group/GROUP_NAME"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  ```

2\. Retrieve the existing aws-auth **`ConfigMap`**.
```shell
kubectl get configmap aws-auth -n kube-system -o yaml > aws-auth-cm.yaml
```

3\. Edit **`aws-auth-cm.yaml`** to add your role mapping.
```shell
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: arn:aws:iam::YOUR_ACCOUNT_ID:role/YOUR_ROLE_NAME
      username: YOUR_ROLE_NAME
      groups:
        - system:authenticated
```

4\. Apply the updated **`ConfigMap`**:
```shell
kubectl apply -f aws-auth-cm.yaml
```

5\. Set up Kubernetes **`RBAC`**.

- **`namespace-role.yaml`**:

```shell
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: YOUR_NAMESPACE
  name: namespace-role
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list", "watch"]  # Adjust the permissions as needed
```

- **`namespace-rolebinding.yaml`**:

```shell
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: namespace-rolebinding
  namespace: YOUR_NAMESPACE
subjects:
- kind: User
  name: "arn:aws:iam::YOUR_ACCOUNT_ID:role/YOUR_ROLE_NAME"
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: namespace-role
  apiGroup: rbac.authorization.k8s.io
```

6\. Apply changes to the EKS cluster
```shell
kubectl apply -f namespace-role.yaml
kubectl apply -f namespace-rolebinding.yaml
```


![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/IAM-Role-EKS.png?raw=true)