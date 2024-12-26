---
title: Monitoring Kubernetes using the kube-prometheus-stack
date: 2023-06-25 12:00:00
categories: [Kubernetes, Monitoring]
tags: [kubernetes, kind, monitoring]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/kubernetes-banner.png?raw=true){: .shadow }

Grafana and Prometheus are a powerful monitoring solution. It allows you to visualize, query, and alert metrics no matter where they are stored. Today, we’ll install and configure Prometheus and Grafana in Kubernetes using kube-prometheus-stack. By the end of this tutorial you be able to observe and visualize your entire Kubernetes cluster with Grafana and Prometheus.


## Getting Started

* Create a cluster 

```shell
kind create cluster --image kindest/node:v1.27.2
```
* Create namespace

```shell
kubectl create namespace monitoring
```

* Echo username and password to a file

```shell
echo -n 'adminuser' > ./admin-user # change your username
echo -n 'p@ssword!' > ./admin-password # change your password
```

* Create a Kubernetes Secret

```shell
kubectl create secret generic grafana-admin-credentials --from-file=./admin-user --from-file=admin-password -n monitoring
```

* Remove username and password file from filesystem

```shell
rm admin-user && rm admin-password
```

* Verify the username and password

```shell
kubectl get secret -n monitoring grafana-admin-credentials -o jsonpath="{.data.admin-user}" | base64 --decode
kubectl get secret -n monitoring grafana-admin-credentials -o jsonpath="{.data.admin-password}" | base64 --decode
```

* Create a values file to hold our helm values

```shell
cat <<EOF > values.yaml
fullnameOverride: prometheus

defaultRules:
  create: true
  rules:
    alertmanager: true
    etcd: true
    configReloaders: true
    general: true
    k8s: true
    kubeApiserverAvailability: true
    kubeApiserverBurnrate: true
    kubeApiserverHistogram: true
    kubeApiserverSlos: true
    kubelet: true
    kubeProxy: true
    kubePrometheusGeneral: true
    kubePrometheusNodeRecording: true
    kubernetesApps: true
    kubernetesResources: true
    kubernetesStorage: true
    kubernetesSystem: true
    kubeScheduler: true
    kubeStateMetrics: true
    network: true
    node: true
    nodeExporterAlerting: true
    nodeExporterRecording: true
    prometheus: true
    prometheusOperator: true

alertmanager:
  fullnameOverride: alertmanager
  enabled: true
  ingress:
    enabled: false

grafana:
  enabled: true
  fullnameOverride: grafana
  forceDeployDatasources: false
  forceDeployDashboards: false
  defaultDashboardsEnabled: true
  defaultDashboardsTimezone: utc
  serviceMonitor:
    enabled: true
  admin:
    existingSecret: grafana-admin-credentials
    userKey: admin-user
    passwordKey: admin-password

kubeApiServer:
  enabled: true

kubelet:
  enabled: true
  serviceMonitor:
    metricRelabelings:
      - action: replace
        sourceLabels:
          - node
        targetLabel: instance

kubeControllerManager:
  enabled: true
#  endpoints: # ips of servers 
#    - 192.168.30.38
#    - 192.168.30.39
#    - 192.168.30.40

coreDns:
  enabled: true

kubeDns:
  enabled: false

kubeEtcd:
  enabled: true
#  endpoints: # ips of servers
#    - 192.168.30.38
#    - 192.168.30.39
#    - 192.168.30.40
  service:
    enabled: true
    port: 2381
    targetPort: 2381

kubeScheduler:
  enabled: true
#  endpoints: # ips of servers
#    - 192.168.30.38
#    - 192.168.30.39
#    - 192.168.30.40

kubeProxy:
  enabled: true
#  endpoints: # ips of servers
#    - 192.168.30.38
#    - 192.168.30.39
#    - 192.168.30.40

kubeStateMetrics:
  enabled: true

kube-state-metrics:
  fullnameOverride: kube-state-metrics
  selfMonitor:
    enabled: true
  prometheus:
    monitor:
      enabled: true
      relabelings:
        - action: replace
          regex: (.*)
          replacement: $1
          sourceLabels:
            - __meta_kubernetes_pod_node_name
          targetLabel: kubernetes_node

nodeExporter:
  enabled: true
  serviceMonitor:
    relabelings:
      - action: replace
        regex: (.*)
        replacement: $1
        sourceLabels:
          - __meta_kubernetes_pod_node_name
        targetLabel: kubernetes_node

prometheus-node-exporter:
  fullnameOverride: node-exporter
  podLabels:
    jobLabel: node-exporter
  extraArgs:
    - --collector.filesystem.mount-points-exclude=^/(dev|proc|sys|var/lib/docker/.+|var/lib/kubelet/.+)($|/)
    - --collector.filesystem.fs-types-exclude=^(autofs|binfmt_misc|bpf|cgroup2?|configfs|debugfs|devpts|devtmpfs|fusectl|hugetlbfs|iso9660|mqueue|nsfs|overlay|proc|procfs|pstore|rpc_pipefs|securityfs|selinuxfs|squashfs|sysfs|tracefs)$
  service:
    portName: http-metrics
  prometheus:
    monitor:
      enabled: true
      relabelings:
        - action: replace
          regex: (.*)
          replacement: $1
          sourceLabels:
            - __meta_kubernetes_pod_node_name
          targetLabel: kubernetes_node
  resources:
    requests:
      memory: 512Mi
      cpu: 250m
    limits:
      memory: 2048Mi

prometheusOperator:
  enabled: true
  prometheusConfigReloader:
    resources:
      requests:
        cpu: 200m
        memory: 50Mi
      limits:
        memory: 100Mi

prometheus:
  enabled: true
  prometheusSpec:
    replicas: 1
    replicaExternalLabelName: "replica"
    ruleSelectorNilUsesHelmValues: false
    serviceMonitorSelectorNilUsesHelmValues: false
    podMonitorSelectorNilUsesHelmValues: false
    probeSelectorNilUsesHelmValues: false
    retention: 6h
    enableAdminAPI: true
    walCompression: true

thanosRuler:
  enabled: false
EOF
```

* Create our kube-prometheus-stack

```shell
helm install -n monitoring prometheus prometheus-community/kube-prometheus-stack -f values.yaml
```

* Port Forwarding Grafana

```shell
kubectl port-forward -n monitoring svc/grafana 51000:80
```

* Visit Grafana

```shell
http://localhost:51000/
```

If you make changes to your values.yaml you can deploy these changes by running

```shell
helm upgrade -n monitoring prometheus prometheus-community/kube-prometheus-stack -f values.yaml
```

## Out of the box dashboards

![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/k8s-grafana.png?raw=true){: .shadow }

## Add logs to Grafana 

* Install Loki

```shell
helm install loki grafana/loki-stack -n monitoring
```

* Add Data source to Grafana

```shell
http://loki:3100/
```

![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/loki-grafana-datasource.png?raw=true){: .shadow }

* Add Dashboard

```shell
15141
```
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/loki-grafana-dash.png?raw=true){: .shadow }

## Stop the cluster

```shell
kind delete cluster --name kind
```
