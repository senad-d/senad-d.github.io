---
title: Self-hosted GitHub Runners
date: 2023-12-03 11:00:00
categories: [GitHub, Actions]
tags: [github, runners]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.pro/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/git-banner.png?raw=true)

---

# Self hosted runners

I've implemented a robust `self-hosted` GitHub Actions runner tailored to amplify your DevOps workflow. This runner is intricately configured to seamlessly integrate Docker in Docker, Kubernetes, Terraform, Trivy, and AWS CLI, offering a versatile environment for your CI/CD pipeline.

> This self-hosted runner is designed to enhance the flexibility and efficiency of your GitHub Actions, aligning with best practices and ensuring a streamlined DevOps pipeline.
{: .prompt-tip }

## Key Components:

***Docker in Docker (DinD)***: This enables your runner to execute Docker commands within a Docker container, facilitating containerized builds and deployments.

***Kubernetes***: The runner is equipped to interact with Kubernetes, ensuring scalability and efficient management of containerized applications.

***Terraform***: Harness the power of Infrastructure as Code (IaC) with Terraform, automating the provisioning and deployment of your AWS resources.

***Trivy***: Prioritize security by incorporating Trivy, a comprehensive vulnerability scanner, into your pipeline. It scans container images for vulnerabilities and ensures a secure software supply chain.

***AWS CLI***: Seamlessly interact with AWS services by integrating the AWS Command Line Interface (CLI) into your runner. This facilitates AWS resource management and deployment from your CI/CD pipeline.

### Security

* Running in Docker needs high priviledges.
* Would not recommend to use these on public repositories.
* Would recommend to always run your CI systems in seperate Kubernetes clusters.

### Creating a Dockerfile

* Installing Docker CLI 
For this to work we need a `dockerfile` and follow instructions to [Install Docker](https://docs.docker.com/engine/install/debian/).</br>

Dockerfile
```Shell
FROM --platform=linux/amd64 debian:bookworm-slim

ARG RUNNER_VERSION="2.311.0"
ARG DEBIAN_FRONTEND=noninteractive

ENV GITHUB_PERSONAL_TOKEN ""
ENV GITHUB_OWNER ""
ENV GITHUB_REPOSITORY ""

# Install dependencies
RUN apt-get update && \
    apt-get install -y curl unzip wget apt-transport-https \
    gnupg lsb-release apt-utils ca-certificates jq sudo software-properties-common

# Add Docker's official GPG key:
RUN install -m 0755 -d /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
RUN echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update

# I only install the CLI, we will run docker in another container!
RUN apt-get install -y docker-ce-cli

# Install the GitHub Actions Runner 
RUN useradd -m github && \
    usermod -aG sudo github && \
    echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER github
WORKDIR /actions-runner

RUN curl -Ls https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz | tar xz \
    && sudo ./bin/installdependencies.sh

COPY --chown=github:github entrypoint.sh  /actions-runner/entrypoint.sh
COPY --chown=github:github scan.sh  /actions-runner/scan.sh
RUN sudo chmod u+x /actions-runner/entrypoint.sh && \
    sudo chmod u+x /actions-runner/scan.sh

# Install Trivy
RUN wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list && \
    sudo apt-get update && \
    sudo apt-get install trivy

# Install aws-cliv2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    sudo ./aws/install && \
    sudo rm awscliv2.zip && \
    sudo rm -rf aws

# Install kube-ctl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    sudo mv ./kubectl /usr/local/bin    

# Install terraform
RUN wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list && \
    sudo apt update && sudo apt-get install -y terraform

#working folder for the runner 
RUN sudo mkdir /home/github/work && \
    sudo chown github:github /home/github/work

# Clean up image
RUN sudo apt-get clean && \
    sudo apt-get -y remove unzip wget apt-utils \
    gnupg apt-transport-https software-properties-common lsb-release && \
    sudo rm -rf /usr/share/keyrings/trivy.gpg /etc/apt/keyrings/docker.gpg && \
    sudo apt-get autoremove -y && \
    sudo rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/actions-runner/entrypoint.sh"]

```

We only install the `docker` CLI. </br> 
This is because we want our running to be able to run docker commands , but the actual docker server runs elsewhere </br>
This gives you flexibility to tighten security by running docker on the host itself and potentially run the container runtime in a non-root environment </br>

* Installing Github Actions Runner 

We will need to install the [GitHub actions runner](https://github.com/actions/runner) in our `dockerfile`

Run a container to test installs: 

```Shell
docker build . -t github-runner:latest 
docker run -it -e GITHUB_PERSONAL_TOKEN=<token> -e GITHUB_OWNER=<owner> -e GITHUB_REPOSITORY=<repository> github-runner

```
> If you wish to create a runner for GitHub Organizations, you can generate a proper access tokens and not use the GITHUB_REPOSITORY variable.

## Deploy to Kubernetes 

Create Deployment:

```Shell
apiVersion: apps/v1
kind: Deployment
metadata:
  name: github-runner
  labels:
    app: github-runner
spec:
  replicas: 1
  selector:
    matchLabels:
      app: github-runner
  template:
    metadata:
      labels:
        app: github-runner
    spec:
      containers:
      - name: github-runner
        image: senaddizdarevic/git-hub-selfhosted-runner:latest
        resources:
          requests:
            memory: "20Mi"
            cpu: "250m"
          limits:
            memory: "512m"
            cpu: "500m"
        env:
        - name: GITHUB_OWNER
          valueFrom:
            secretKeyRef:
              name: github-secret
              key: GITHUB_OWNER
        - name: GITHUB_REPOSITORY
          valueFrom:
            secretKeyRef:
              name: github-secret
              key: GITHUB_REPOSITORY
        - name: GITHUB_PERSONAL_TOKEN 
          valueFrom:
            secretKeyRef:
              name: github-secret
              key: GITHUB_PERSONAL_TOKEN
        - name: DOCKER_HOST
          value: tcp://localhost:2375
        volumeMounts:
        - name: data
          mountPath: /work/
      - name: dind 
        image: docker:24.0.6-dind
        env:
        - name: DOCKER_TLS_CERTDIR
          value: ""
        resources:
            requests:
              memory: "20Mi"
              cpu: "125m"
            limits:
              memory: "128Mi"
              cpu: "250m"
        securityContext: 
            privileged: true 
        volumeMounts: 
          - name: docker-graph-storage 
            mountPath: /var/lib/docker 
          - name: data
            mountPath: /work/
      volumes:
      - name: docker-graph-storage 
        emptyDir: {}
      - name: data
        emptyDir: {}

```

Create a kubernetes secret with github details and apply the file:

```Shell
kubectl create ns github
kubectl -n github create secret generic github-secret `
  --from-literal GITHUB_OWNER=<owner> `
  --from-literal GITHUB_REPOSITORY=<repository> `
  --from-literal GITHUB_PERSONAL_TOKEN=<token>

kubectl -n github apply -f kubernetes.yaml
```

## Deploy locally with docker-compose

Create .env file:
```Shell
GITHUB_OWNER=<owner>
GITHUB_PERSONAL_TOKEN=<token>
```

Create new docker network:
```Shell
docker network create -d dnd
```
Create docker-compose.yml:

```Shell
version: '3'

services:
  runner:
    image: senaddizdarevic/git-hub-selfhosted-runner:latest
    env_file: .env
    container_name: runner
    restart: unless-stopped
    volumes:
      - data:/home/github/work/
    environment:
      GITHUB_PERSONAL_TOKEN: '${GITHUB_PERSONAL_TOKEN}'
      GITHUB_OWNER: '${GITHUB_OWNER}'
      DOCKER_HOST: tcp://docker:2375
    deploy:
      resources:
        limits:
          cpus: '0.50'
          memory: 512M
        reservations:
          cpus: '0.25'
          memory: 256M
    networks:
      - dnd
  docker:
    image: docker:24.0.6-dind
    container_name: dnd
    restart: unless-stopped
    privileged: true
    volumes:
      - data:/work/
      - docker-graph-storage:/var/lib/docker
    environment:
      DOCKER_TLS_CERTDIR: ''
    deploy:
      resources:
        limits:
          cpus: '0.50'
          memory: 512M
        reservations:
          cpus: '0.25'
          memory: 256M
    networks:
      - dnd
volumes:
  data:
    driver: local
  docker-graph-storage:
    driver: local
networks:
  dnd:
    external: true
```

Run containers:
```Shell
docker-compose up -d
```
> Docker compose does not remove the runners from GitHub Runners list for some unknown reason.
{: .prompt-tip }