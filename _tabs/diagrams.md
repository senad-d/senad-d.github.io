---
# the default layout is 'page'
icon: fa fa-cubes
order: 5
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>

# Infrastructure diagrams

## 1\. ECS Fargate with CloudFront distribution - AWS
In the realm of AWS, ECS Fargate serves as an orchestration powerhouse for running containers without the burden of managing infrastructure. It dynamically scales based on workloads, adapting to changing demands effortlessly.

Imagine your database residing within an ECS container, ensuring a standardized and secure environment. This encapsulation facilitates consistent deployments and provides robust isolation.

On the frontend, leverage the scalable storage of S3 for static assets, delivered globally by CloudFront for low-latency content distribution.

Deployment becomes a technical symphony with ECS supporting blue-green deployments, allowing seamless updates and rollbacks through versioned container images.

For monitoring and troubleshooting, CloudWatch captures detailed logs and insights, acting as the grand observatory for your application's performance.

Fargate's cost-effectiveness stems from its serverless model, where you pay only for the computational resources consumed by your containers.

![ECS](https://github.com/senad-d/senad-d.github.io/blob/b81c05fa558c1917ee6fae1fec1d3f0667777ff0/_media/gif/ecs_infra.gif?raw=true){: .shadow }

## 2\. Multi tenancy AWS account (IaaS)
AWS Control Tower creates a landing zone. It’s the enterprise-wide container that holds all your organizational units (OUs), accounts, users, and other resources. In its landing zone, AWS Control Tower can accommodate three types of OUs:

-   **Root OU:** contains all other OUs.
-   **Shared OU:** contains the log archive and audit member shared accounts.
-   **Environment OU:** contains the member accounts of your environments.

![Multi tenancy](https://github.com/senad-d/senad-d.github.io/blob/b81c05fa558c1917ee6fae1fec1d3f0667777ff0/_media/gif/Multi-Tenancy-AWS-ACC.gif?raw=true){: .shadow }



