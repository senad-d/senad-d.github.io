---
title: Connect EKS to specific RDS data base
date: 2023-06-18 12:00:00
categories: [EKS, RDS]
tags: [iam, aws, rds, eks]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/backgroun.png?raw=true){: .shadow }

Imagine having an EKS cluster with multiple namespaces with multiple pods that should not be able to see or communicate with other namespaces or any other resources, except for specific resources such as databases within the RDS instance.
To create a new, completely isolated project with its own namespaces within a single EKS cluster and an RDS instance, and subsequently add users through IAM, you should follow the next steps.

Create resources: 

1.  [***IAM role and policy***](https://senad-d.github.io/posts/eks-rds-connection/#use-iam-to-connect-rds-and-eks)
2.  [***RDS database user***](https://senad-d.github.io/posts/eks-rds-connection/#configure-rds-users)
3.  [***RBAC for EKS***](https://senad-d.github.io/posts/eks-rds-connection/#configure-rbac-in-eks)
4.  [***RDS Proxy (optional)***](https://senad-d.github.io/posts/eks-rds-connection/#connecting-eks-to-rds-by-using-proxy-(optional))

![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/VNP_auth.png?raw=true){: .shadow }

> In this diagram, you can observe a visual illustration of integrating EKS with RDS using IAM.
{: .prompt-tip }

---

## Use IAM to connect RDS and EKS

To connect users or applications running in Amazon Elastic Kubernetes Service (EKS) to a specific database within a RDS instance using IAM roles, you can follow these steps:

* Create an IAM policy: 

Start by creating an IAM policy that grants the necessary permissions for accessing the specific database in the RDS instance. The policy should include permissions for actions such as `rds-db:connect`, `rds-db:executeSql`, and other relevant permissions. 

```shell
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "rds-db:connect",
        "rds-db:executeSql"
      ],
      "Resource": [
        "arn:aws:rds-db:<region>:<account-id>:dbuser:<db-resource-id>/<username>"
      ]
    }
  ]
}
```

> Replace `<region>`, `<account-id>`, `<db-resource-id>`, and `<username>` with the appropriate values for your environment.
{: .prompt-tip }

* Create an IAM role: 

Create an IAM role and attach the IAM policy you created in step 1 to this role.

* Configure the Kubernetes service account: 

Modify the Kubernetes service account associated with your users or applications in EKS. You can do this by adding an annotation to the service account, specifying the IAM role to be assumed. 

```shell
apiVersion: v1
kind: ServiceAccount
metadata:
  name: my-app-service-account
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::<account-id>:role/my-iam-role
```

> Replace `<account-id>` and `my-iam-role` with your AWS account ID and the name of the IAM role you created in step 2.
{: .prompt-tip }

* Grant RDS IAM authentication access: 

Enable IAM database authentication for the RDS instance and create a database user associated with the IAM role. This allows users or applications assuming the IAM role to authenticate with the RDS instance using their IAM credentials. The database user should be created with appropriate permissions to access the desired database.

* Configure the application or user credentials: 

Modify your application or user credentials to use IAM database authentication when connecting to the RDS instance. This typically involves configuring the database connection string or parameters to include the IAM authentication option.

With these steps in place, the users or applications running in EKS will be limited to accessing only the specific database within the RDS instance. IAM roles provide a secure and convenient way to manage access control for your EKS workloads, integrating with IAM and RDS for fine-grained permissions management.

## Configure RDS users

To configure the underlying Amazon RDS database to restrict access to specific databases based on IAM permissions, you can follow these steps:

* Enable IAM database authentication: 

Enable IAM database authentication for your Amazon RDS instance. This allows users to authenticate to the database using their IAM credentials.

* Create an IAM policy: 

Create an IAM policy that grants permissions to access the specific databases within the RDS instance. The policy should be associated with an IAM role or user and specify the appropriate actions and resources. For example, you can grant `rds-data:ExecuteStatement` permissions for the desired databases. 

```shell
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "rds-data:ExecuteStatement",
      "Resource": "arn:aws:rds-db:<region>:<account-id>:dbuser:<db-resource-id>/<username>"
    }
  ]
}
```

> Replace `<region>`, `<account-id>`, `<db-resource-id>`, and `<username>` with the relevant values for your environment.
{: .prompt-tip }

* Attach the IAM policy: 

Attach the IAM policy created in step 2 to the IAM role or user associated with the IAM users who will access the RDS database.

* Configure the database user: 

Create a database user within the RDS instance associated with the IAM user. This user represents the IAM user within the database and should have the necessary privileges to access the desired databases. You can create the user using the AWS CLI or database management tool specific to your database engine.

* Grant privileges to the database user: 

Grant the appropriate privileges to the database user for the specific databases. This can be done using SQL commands executed against the RDS instance. For example, using MySQL, you can use the `GRANT` statement to assign privileges to the user:

```shell
GRANT ALL PRIVILEGES ON database_name.* TO 'database_user'@'%';
```

> Replace `database_name` with the name of the specific database and `database_user` with the username associated with the IAM user.
{: .prompt-tip }

By following these steps, you are configuring the RDS database to leverage IAM authentication and assigning appropriate privileges to the database user based on the IAM user's permissions. This way, only users with the necessary IAM permissions will be able to authenticate and access the specified databases within the RDS instance.

## Connecting EKS to RDS by using Proxy (optional)

RDS Proxy can be used to connect Amazon Elastic Kubernetes Service (EKS) pods to an Amazon RDS database. RDS Proxy acts as an intermediary between the application running in your EKS cluster and the RDS database, providing several benefits for managing database connections in a Kubernetes environment.

### Here's how RDS Proxy can be used with EKS pods:

* Deploy RDS Proxy: 

First, you need to deploy an RDS Proxy in your AWS account. You can create and configure the RDS Proxy using the AWS Management Console, AWS CLI, or AWS SDKs.

* Configure RDS Proxy endpoint: 

Once the RDS Proxy is created, you'll obtain an endpoint for the proxy. This endpoint will be used by your EKS pods to connect to the RDS database.

* Modify application connection settings: 

Update your application's database connection settings to use the RDS Proxy endpoint instead of directly connecting to the RDS database. The application will now establish connections with the RDS Proxy, which will handle connection pooling, scalability, and high availability.

* IAM authentication with RDS Proxy: 

Enable IAM database authentication for the RDS database. When the EKS pods connect to the RDS Proxy, they will authenticate using their IAM credentials. This eliminates the need to manage database credentials within your application or Kubernetes cluster.
    
By using RDS Proxy, you can achieve benefits such as connection pooling, improved scalability, and automatic failover for your EKS pods connecting to the RDS database. RDS Proxy manages the database connections efficiently, reducing the overhead and complexity of managing connections within your application.

Additionally, RDS Proxy integrates seamlessly with IAM authentication, enhancing security by allowing your EKS pods to authenticate with the RDS database using their IAM roles or IAM users' credentials. This provides a more secure and manageable approach to database authentication in an EKS environment.

## Configure RBAC in EKS

In the situation where you are connecting EKS pods to an RDS database, you may need to configure Role-Based Access Control (RBAC) for EKS depending on your specific requirements. RBAC allows you to define fine-grained access controls and permissions for different entities within the Kubernetes cluster, including users, service accounts, and roles.

## RBAC can be useful for scenarios such as:

* Controlling access to the EKS cluster:

RBAC can help you define who has access to perform operations on the EKS cluster, such as deploying or managing pods.

* Granting permissions to service accounts:

You can use RBAC to define roles and bind them to service accounts associated with your EKS pods. This allows you to grant specific permissions to those pods for interacting with other resources, such as the RDS Proxy or other AWS services.

## To configure RBAC in EKS, you can follow these general steps:

* Create a Kubernetes Role: 

Define a Kubernetes Role that specifies the permissions required for the pods to interact with resources like the RDS Proxy. This could include permissions to access the RDS Proxy endpoint or other relevant resources.

* Create a Kubernetes RoleBinding: 

Create a RoleBinding that binds the Role created in the previous step to the appropriate service account associated with your EKS pods. This associates the permissions defined in the Role with the pods using the specified service account.

* Apply RBAC configuration: 

Apply the RBAC configuration (Role and RoleBinding) to your EKS cluster using the `kubectl apply` command or by applying the configuration through Kubernetes manifests.

```shell
# my-role.yaml
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: your-namespace
  name: my-role
rules:
apiGroups: [""]
  resources: ["endpoints"]
  verbs: ["get", "list", "watch"]

# my-role-binding.yaml
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  namespace: your-namespace
  name: my-role-binding
subjects:
kind: ServiceAccount
  name: your-service-account
  namespace: your-namespace
roleRef:
  kind: Role
  name: my-role
  apiGroup: rbac.authorization.k8s.io
```

> Replace `your-namespace` with the namespace in which your pods and service accounts reside. Also, replace `your-service-account` with the appropriate service account associated with your pods.
{: .prompt-tip }

Once you have defined and applied the RBAC configuration, the specified service account and associated pods will have the permissions granted by the Role. This allows the pods to interact with the RDS Proxy or other resources as defined in the RBAC configuration.

Remember that RBAC is a powerful mechanism for managing access control within your EKS cluster. It is important to carefully define and review the roles and permissions to ensure the appropriate level of security and access control for your application and resources.

Terraform can be employed in conjunction with GitHub Actions to automate the entire process of creating new projects/namespaces.