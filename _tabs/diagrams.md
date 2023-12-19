---
# the default layout is 'page'
icon: fa fa-cubes
order: 5
tags: [diagrams, infrastructure]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>

# Infrastructure diagrams

## 1\. ECS Fargate with CloudFront distribution - AWS
![ECS](https://github.com/senad-d/senad-d.github.io/blob/b81c05fa558c1917ee6fae1fec1d3f0667777ff0/_media/gif/ecs_infra.gif?raw=true){: .shadow }

## 2\. Multi tenancy AWS account (IaaS)
AWS Control Tower creates a landing zone. It’s the enterprise-wide container that holds all your organizational units (OUs), accounts, users, and other resources. In its landing zone, AWS Control Tower can accommodate three types of OUs:

-   **Root OU:** contains all other OUs.
-   **Shared OU:** contains the log archive and audit member shared accounts.
-   **Environment OU:** contains the member accounts of your environments.

![Multi tenancy](https://github.com/senad-d/senad-d.github.io/blob/b81c05fa558c1917ee6fae1fec1d3f0667777ff0/_media/gif/Multi-Tenancy-AWS-ACC.gif?raw=true){: .shadow }



