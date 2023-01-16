---
title: Install existing applications with Helm in AKS hybrid
description: Learn how to use the Helm packaging tool to deploy containers on Azure Kubernetes Service (AKS) clusters in AKS hybrid.
services: container-service
author: sethmanheim
ms.topic: article
ms.date: 11/04/2022
ms.author: sethm 
ms.lastreviewed: 1/14/2022
ms.reviewer: scooley

# Customer intent: As a cluster operator or developer, I want to learn how to deploy Helm into an AKS cluster and then install and manage applications using Helm charts.
# Intent: As an IT Pro, I want to learn how to deploy Helm into an AKS cluster so that I can use Helm charts to install and manage applications.
# Keyword: Helm charts deploy Helm
---

# Install existing applications with Helm in AKS hybrid

[!INCLUDE [applies-to-azure stack-hci-and-windows-server-skus](includes/aks-hci-applies-to-skus/aks-hybrid-applies-to-azure-stack-hci-windows-server-sku.md)]

This article describes how to configure and use Helm to install and manage Kubernetes applications in a Kubernetes cluster in AKS hybrid.

[Helm][helm] is an open-source packaging tool that helps you install and manage the lifecycle of Kubernetes applications. Similar to Linux package managers such as *APT* and *Sum*, Helm is used to manage Kubernetes charts, which are packages of pre-configured Kubernetes resources.

## Before you begin

Verify that you have set up the following requirements:

* An [AKS cluster](./setup.md) with at least one Linux worker node that's up and running.
* You have configured your local `kubectl` environment to point to your AKS cluster. You can use the [Get-AksHciCredential](./reference/ps/get-akshcicredential.md) PowerShell command to access your cluster using `kubectl`.
* [Helm v3](https://helm.sh/docs/intro/install/) command line and prerequisites are installed.
* [Azure CLI](/cli/azure/install-azure-cli) can also be used to run commands, if you prefer this to PowerShell.

> [!IMPORTANT]
> [!INCLUDE [helm-charts-in-mixed-linux-windows-clusters](includes/helm-charts-in-mixed-linux-windows-clusters.md)]

## Verify your version of Helm

Use the `helm version` command to verify you have Helm 3 installed:

```console
helm version
```

The following example shows Helm version 3.5.4 installed:

```output
version.BuildInfo{Version:"v3.5.4", GitCommit:"1b5edb69df3d3a08df77c9902dc17af864ff05d1", GitTreeState:"clean", GoVersion:"go1.15.11"}
```

## Install an application with Helm v3

### Add Helm repositories

Use the [helm repo][helm-repo-add] command to add the *ingress-nginx* repository.

```console
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
```

### Find Helm charts

Helm charts are used to deploy applications into a Kubernetes cluster. To search for pre-created Helm charts, use the [helm search][helm-search] command:

```console
helm search repo ingress-nginx
```

The following condensed example output shows some of the Helm charts available for use:

```output
NAME                            CHART VERSION   APP VERSION     DESCRIPTION                                       
ingress-nginx/ingress-nginx     3.30.0          0.46.0          Ingress controller for Kubernetes using NGINX a...
```

To update the list of charts, use the [helm repo update][helm-repo-update] command.

```console
helm repo update
```

The following example shows a successful repo update:

```output
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "ingress-nginx" chart repository
Update Complete. ⎈ Happy Helming!⎈
```

### Run Helm charts

To install charts with Helm, use the [helm install][helm-install-command] command, and specify a release name and the name of the chart to install. To see a Helm chart installation in action, install a basic nginx deployment using a Helm chart.

The command below is provided twice, one for use in Azure CLI, and one for use in a PowerShell console. If you're running commands in a PowerShell console, you'll see the command includes the backtick ( ` ) to allow line continuation.

```console
helm install my-nginx-ingress ingress-nginx/ingress-nginx \
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux
```

```powershell
helm install my-nginx-ingress ingress-nginx/ingress-nginx `
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux `
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux
```

The following condensed example output shows the deployment status of the Kubernetes resources created by the Helm chart:

```output
>     --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
>     --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux

NAME: my-nginx-ingress
LAST DEPLOYED: Fri May 14 17:43:27 2021
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
The nginx-ingress controller has been installed.
It may take a few minutes for the LoadBalancer IP to be available.
You can watch the status by running 'kubectl --namespace default get services -o wide -w my-nginx-ingress-ingress-nginx-controller'
...
```

Use the `kubectl get services` command to get the *EXTERNAL-IP* of your service:

```console
kubectl --namespace default get services -o wide -w my-nginx-ingress-ingress-nginx-controller
```

For example, the command below shows the *EXTERNAL-IP* for the *my-nginx-ingress-ingress-nginx-controller* service:

```output
NAME                                        TYPE           CLUSTER-IP   EXTERNAL-IP      PORT(S)                      AGE   SELECTOR
my-nginx-ingress-ingress-nginx-controller   LoadBalancer   10.98.53.215 <EXTERNAL-IP>    80:31553/TCP,443:30784/TCP   72s   app.kubernetes.io/component=controller,app.kubernetes.io/instance=my-nginx-ingress,app.kubernetes.io/name=ingress-nginx
```

### List releases

To see a list of releases installed on your cluster, use the `helm list` command.

```console
helm list
```

The following example shows the *my-nginx-ingress* release deployed in the previous step:

```output
NAME                NAMESPACE    REVISION    UPDATED                                 STATUS      CHART                   APP VERSION
my-nginx-ingress    default      1           2021-05-14 17:43:27.1670709 +0000 UTC    deployed    nginx-ingress-3.30.0    0.46.0 
```

### Clean up resources

When you deploy a Helm chart, many Kubernetes resources are created. These resources include pods, deployments, and services. To clean up these resources, use the [helm uninstall][helm-cleanup] command and specify your release name, as found in the previous `helm list` command.

```console
helm uninstall my-nginx-ingress
```

The following example output shows the release named *my-nginx-ingress* has been uninstalled:

```output
release "my-nginx-ingress" uninstalled
```

## Next steps

For more information about managing Kubernetes application deployments with Helm, see the Helm documentation.

> [!div class="nextstepaction"]
> [Helm documentation][helm-documentation]

<!-- LINKS - external -->
[helm]: https://github.com/kubernetes/helm/
[helm-cleanup]: https://helm.sh/docs/intro/using_helm/#helm-uninstall-uninstalling-a-release
[helm-documentation]: https://helm.sh/docs/
[helm-install]: https://helm.sh/docs/intro/install/
[helm-install-command]: https://helm.sh/docs/intro/using_helm/#helm-install-installing-a-package
[helm-repo-add]: https://helm.sh/docs/intro/quickstart/#initialize-a-helm-chart-repository
[helm-search]: https://helm.sh/docs/intro/using_helm/#helm-search-finding-charts
[helm-repo-update]: https://helm.sh/docs/intro/using_helm/#helm-repo-working-with-repositories
            
<!-- LINKS - internal -->
[node-selectors]: adapt-apps-mixed-os-clusters.md#node-selector
[taints]: adapt-apps-mixed-os-clusters.md#taints-and-tolerations