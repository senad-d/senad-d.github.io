---
# the default layout is 'page'
icon: fa fa-cubes
order: 5
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.pro/js/script.js"></script>

# Simplifying Deployment with GitHub and AWS
Efficient software development hinges on optimizing deployment workflows. By harnessing the power of GitHub, AWS EKS, and ArgoCD, we can achieve seamless deployment automation and management.

In this approach, distinct GitHub repositories are employed for the application, pipeline, and infrastructure components:

🔹 **Application Repository:** Any changes here automatically trigger the deployment pipeline.

🔹 **Pipeline Repository:** Updates in this repository are responsible for tweaking infrastructure configurations.

🔹 **Infrastructure Repository:** Contains Terraform code for managing infrastructure and Kubernetes manifests for configuring AWS EKS.

🔹 **ArgoCD:** It diligently monitors the infrastructure repository for alterations, promptly syncing them with the AWS EKS cluster.

This organizational structure fosters a smooth, hands-off deployment process, reducing manual intervention and boosting overall efficiency. Embrace the power of GitHub and ArgoCD to streamline your deployment workflows today!

![fllow_github](https://github.com/senad-d/senad-d.github.io/blob/ac39f0c1b1ca15d422605929e7d0d87f1f683664/_media/gif/GitHub-flow-v2.gif?raw=true){: .shadow }

# ECS Fargate with CloudFront distribution - AWS
In the realm of AWS, ECS Fargate serves as an orchestration powerhouse for running containers without the burden of managing infrastructure. It dynamically scales based on workloads, adapting to changing demands effortlessly.

Imagine your database residing within an ECS container, ensuring a standardized and secure environment. This encapsulation facilitates consistent deployments and provides robust isolation.
On the frontend, leverage the scalable storage of S3 for static assets, delivered globally by CloudFront for low-latency content distribution. Deployment becomes a technical symphony with ECS supporting blue-green deployments, allowing seamless updates and rollbacks through versioned container images. For monitoring and troubleshooting, CloudWatch captures detailed logs and insights, acting as the grand observatory for your application's performance. Fargate's cost-effectiveness stems from its serverless model, where you pay only for the computational resources consumed by your containers.

![ECS](https://github.com/senad-d/senad-d.github.io/blob/b81c05fa558c1917ee6fae1fec1d3f0667777ff0/_media/gif/ecs_infra.gif?raw=true){: .shadow }

# Multi tenancy AWS account (IaaS)
In the shared realm of AWS, multi-tenancy is a collaborative tale where diverse tenants coexist on common ground.
Imagine a community where tenants enjoy Cost Efficiency, pooling resources for shared gains. They optimize resource use, efficiently allocating EC2 instances and storage—creating a symphony of Resource Optimization. As the community grows, the narrative unfolds with seamless Scalability, allowing tenants to dynamically adapt. Security, a vigilant guardian, ensures Isolation and Security through well-configured VPCs and IAM roles. In this shared space, Operational Efficiency takes center stage, streamlining tasks like monitoring and updates across tenants. AWS Organizations becomes a hub for Centralized Management, fostering collaboration in billing, compliance, and overall account management.Flexibility becomes a recurring theme, with the shared environment adapting to diverse workloads. Real-life scenarios include SaaS providers hosting multiple customers and enterprises managing departmental applications within a unified AWS account.

![Multi tenancy](https://github.com/senad-d/senad-d.github.io/blob/673c8dbb7c8953dc4fe46794a6e9a5628cb327ed/_media/gif/AWS-Cloud.gif?raw=true){: .shadow }


# K8s Deployments

This diagram provides a clear overview of the deployment of an application in a Kubernetes cluster, along with the interactions between its various components. 

In Kubernetes, Pods are the smallest units that can be scheduled, hosting containers that facilitate shared storage and network resources. ReplicaSets (rs) ensures that a specified number of identical Pods are always running. Deployments (deploy) provide a control layer that allows for declarative scaling of replicas, along with additional features like rollback and various update strategies. Kubernetes employs ConfigMaps (cm), key-value dictionaries for configuration data, and Secrets (secret) for sensitive information like passwords. Persistent Volumes (pv) provide an abstraction of underlying storage, allowing data to persist through container restarts. Persistent Volume Claims (pvc) enable Pods to request provisioned volumes. Services (svc) provide abstractions allowing access to Pods via selectors, and balance incoming traffic between Pods, eliminating the need to know individual Pod IPs. Ingress (ing) controllers, such as NGINX or Traefik, facilitate path rewriting and load balancing. Service Accounts (sa) are used to provide an identity for processes that run in a Pod.

![k8s Deployments](https://github.com/senad-d/senad-d.github.io/blob/047ec0ebea07b2fa87d7cac1d1956eb1a8afa432/_media/gif/k8s_deployment.gif?raw=true){: .shadow }
