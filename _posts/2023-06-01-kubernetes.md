---
title: Kubernetes/Kind Tutorial
date: 2023-06-02 12:00:00
categories: [Kubernetes, Kind]
tags: [kubernetes, kind]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/kubernetes-banner.png?raw=true){: .shadow }

## The Basics

This guide is aimed to fast-track your Kubernetes learning by focusing on a practical hands-on overview guide. When learning Kubernetes, you usually have an idea of some existing system you own and manage, or a website that you are building. The challenge is understanding which Kubernetes building blocks you need in order to run your workloads on Kubernetes

***The problem***: "I want to adopt Kubernetes"

***The problem***: "I have some common existing infrastructure"

***Our focus***: Solving the problem by learning each building block in order to port our infrastructure to Kubernetes. 

* [***Cheat Sheet***](https://senad-d.github.io/posts/kubernetes-cheatsheet/) for `kubectl`.

## Kubernetes Tools: kubectl

To manage and work with Kubernetes, you need `kubectl` Let's grab that from [***here***](https://kubernetes.io/docs/tasks/tools/)


## Run Kubernetes Locally

* Install `kubectl` to work with kubernetes 

    We'll head over to the [***kubernetes***](https://kubernetes.io/docs/tasks/tools/) site to download `kubectl` 

* Install the `kind` binary

    You will want to head over to the [***kind***](https://kind.sigs.k8s.io/) site

* Create a cluster 

```shell
kind create cluster --image kindest/node:v1.27.2
```

## Namespaces 

```shell
kubectl create namespace test
```

## Configmaps

* [***Environment Variables***](https://kubernetes.io/docs/tasks/inject-data-application/define-environment-variable-container/) for pods

* [***How to use***](https://kubernetes.io/docs/concepts/configuration/configmap/) configmaps


```shell
kubectl -n test create configmap mysql --from-literal MYSQL_RANDOM_ROOT_PASSWORD=1

kubectl -n test get configmaps
```

## Secrets

* [***How to use***](https://kubernetes.io/docs/concepts/configuration/secret/) secrets in pods

```shell
kubectl -n test create secret generic wordpress --from-literal WORDPRESS_DB_HOST=mysql --from-literal WORDPRESS_DB_USER=exampleuser --from-literal WORDPRESS_DB_PASSWORD=examplepassword --from-literal WORDPRESS_DB_NAME=exampledb

kubectl -n test create secret generic mysql --from-literal MYSQL_USER=exampleuser --from-literal MYSQL_PASSWORD=examplepassword --from-literal MYSQL_DATABASE=exampledb

kubectl -n test get secret
```


## Deployments

* Deployment [***documentation***](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)

[***Clone***](https://github.com/senad-d/KindDemo.git) Kubernetes example yaml files for deployment, services, statefulset, and ingress.

```shell
kubectl -n test apply -f deploy.yaml
kubectl -n test get pods
```

# Services

* Services [***documentation***](https://kubernetes.io/docs/concepts/services-networking/service/)

```shell
kubectl -n test apply -f service.yaml
kubectl -n test get svc
```

# Storage Class

* StorageClass [***documentation***](https://kubernetes.io/docs/concepts/storage/storage-classes/)

```shell
kubectl get storageclass
```

# Statefulset

* Statefulset [***documentation***](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)

```shell
kubectl -n test apply -f statefulset.yaml

kubectl -n test get pods
```

## Persistent Volumes

* Persistent [***documentation***](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)

## Port Forwarding

* We can access private service endpoints or pods using `port-forward` :

```shell
kubectl -n test get pods
kubectl -n test port-forward <pod-name> 8080:80
```

## Public Traffic

* In order to make our site public, its common practise to expose web servers via a proxy or API gateway.

## Ingress

* To use an ingress, we need an ingress controller

```shell
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.3/deploy/static/provider/cloud/deploy.yaml

kubectl -n ingress-nginx get pods

kubectl -n ingress-nginx --address 0.0.0.0 port-forward svc/ingress-nginx-controller 8080:80
```

* Create an Ingress

```shell
kubectl -n test apply -f ingress.yaml
```

## Stop the Kind cluster

```shell
kind delete cluster --name kind
```