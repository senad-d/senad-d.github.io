---
title: Policy engine for Kubernetes.
date: 2023-06-25 12:00:00
categories: [Software, Kubernetes]
tags: [kubernetes, policy]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/kubernetes-banner.png?raw=true){: .shadow }

## About Kyverno

Kyverno is a policy engine designed specifically for Kubernetes. Some of its many features include:

-   policies as Kubernetes resources (no new language to learn!)
-   validate, mutate, generate, or cleanup (remove) any resource
-   verify container images for software supply chain security
-   inspect image metadata
-   match resources using label selectors and wildcards
-   validate and mutate using overlays (like Kustomize!)
-   synchronize configurations across Namespaces
-   block non-conformant resources using admission controls, or report policy violations
-   self-service reports (no proprietary audit log!)
-   self-service policy exceptions
-   test policies and validate resources using the Kyverno CLI, in your CI/CD pipeline, before applying to your cluster
-   manage policies as code using familiar tools like `git` and `kustomize`

Kyverno allows cluster administrators to manage environment specific configurations independently of workload configurations and enforce configuration best practices for their clusters. Kyverno can be used to scan existing workloads for best practices, or can be used to enforce best practices by blocking or mutating API requests.

## How Kyverno works

Kyverno runs as a [dynamic admission controller](https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/) in a Kubernetes cluster. Kyverno receives validating and mutating admission webhook HTTP callbacks from the Kubernetes API server and applies matching policies to return results that enforce admission policies or reject requests.

Kyverno policies can match resources using the resource kind, name, label selectors, and much more.

Mutating policies can be written as overlays (similar to [Kustomize](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/#bases-and-overlays)) or as a RFC 6902 JSON Patch. Validating policies also use an overlay style syntax, with support for pattern matching and conditional (if-then-else) processing.

Policy enforcement is captured using Kubernetes events. For requests that are either allowed or existed prior to introduction of a Kyverno policy, Kyverno creates Policy Reports in the cluster which contain a running list of resources matched by a policy, their status, and more.

The diagram below shows the high-level logical architecture of Kyverno.

![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/kyverno-architecture.png?raw=true){: .shadow }

The **Webhook** is the server which handles incoming AdmissionReview requests from the Kubernetes API server and sends them to the **Engine** for processing. It is dynamically configured by the **Webhook Controller** which watches the installed policies and modifies the webhooks to request only the resources matched by those policies. The **Cert Renewer** is responsible for watching and renewing the certificates, stored as Kubernetes Secrets, needed by the webhook. The **Background Controller** handles all generate and mutate-existing policies by reconciling UpdateRequests, an intermediary resource. And the **Report Controllers** handle creation and reconciliation of Policy Reports from their intermediary resources, Admission Reports and Background Scan Reports.

Kyverno also supports high availability. A highly-available installation of Kyverno is one in which the controllers selected for installation are configured to run with multiple replicas. Depending on the controller, the additional replicas may also serve the purpose of increasing the scalability of Kyverno. See the [high availability page](https://kyverno.io/docs/high-availability/) for more details on the various Kyverno controllers, their components, and how availability is handled in each one.

## Install Kyverno using Helm[](https://kyverno.io/docs/installation/methods//#install-kyverno-using-helm)

Kyverno can be deployed via a Helm chart–the recommended and preferred method for a production install–which is accessible either through the Kyverno repository or on [Artifact Hub](https://artifacthub.io/). Both generally available and pre-releases are available with Helm.

* In order to install Kyverno with Helm, first add the Kyverno Helm repository.

```shell
# Add the Kyverno Helm repository.
helm repo add kyverno https://kyverno.github.io/kyverno/
# Scan the new repository for charts.
helm repo update
# Optionally, show all available chart versions for Kyverno.
helm search repo kyverno -l
```

* Use Helm to create a Namespace and install Kyverno in a highly-available configuration.

```shell
helm install kyverno kyverno/kyverno -n kyverno --create-namespace \
--set admissionController.replicas=3 \
--set backgroundController.replicas=2 \
--set cleanupController.replicas=2 \
--set reportsController.replicas=2
```

## Quick Start Guides

Add the policy below to your cluster. It contains a single validation rule that requires that all Pods have the team label. Kyverno supports different rule types to validate, mutate, generate, cleanup, and verify image configurations. The field validationFailureAction is set to Enforce to block Pods that are non-compliant. Using the default value Audit will report violations but not block requests.

```shell
kubectl create -f- << EOF
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: require-labels
spec:
  validationFailureAction: Enforce
  rules:
  - name: check-team
    match:
      any:
      - resources:
          kinds:
          - Pod
    validate:
      message: "label 'team' is required"
      pattern:
        metadata:
          labels:
            team: "?*"
EOF
```

* Try creating a Deployment without the required label.

```shell
kubectl create deployment nginx --image=nginx
```

* You should see an error.

```shell
error: failed to create deployment: admission webhook "validate.kyverno.svc-fail" denied the request: 

resource Deployment/default/nginx was blocked due to the following policies:

require-labels:
  autogen-check-team: 'validation error: label ''team'' is
    required. Rule autogen-check-team failed at path /spec/template/metadata/labels/team/'
```
In addition to the error returned, Kyverno also produces an Event in the same Namespace which contains this information.

> Kyverno may be configured to exclude system Namespaces like `kube-system` and `kyverno`. Make sure you create the Deployment in a user-defined Namespace or the `default` Namespace (for testing only).
{: .prompt-tip }

* Now, create a Pod with the required label.

```shell
kubectl run nginx --image nginx --labels team=backend
```

This Pod configuration is compliant with the policy and is allowed.

Now that the Pod exists, wait just a few seconds longer and see what other action Kyverno took. Run the following command to retrieve the Policy Report that Kyverno just created.

```shell
kubectl get policyreport
```

Notice that there is a single Policy Report with just one result listed under the “PASS” column. This result is due to the Pod we just created having passed the policy.

```shell
NAME                  PASS   FAIL   WARN   ERROR   SKIP   AGE
cpol-require-labels   1      0      0      0       0      2m46s
```

Now that you’ve experienced validate policies and seen a bit about policy reports, clean up by deleting the policy you created above.

```shell
kubectl delete clusterpolicy require-labels
```

> Find more policy's on [***GitHub***](https://github.com/kyverno/policies)
{: .prompt-tip }