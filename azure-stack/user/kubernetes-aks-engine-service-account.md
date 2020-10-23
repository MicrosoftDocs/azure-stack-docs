---
title: Enabling service account token volume projection for the AKS engine on Azure Stack Hub 
description: Learn how to enable service account token volume projection for the AKS engine on Azure Stack Hub
author: mattbriggs

ms.topic: article
ms.date: 10/23/2020
ms.author: mabrigg
ms.reviewer: waltero
ms.lastreviewed: 10/23/2020

# Intent: As an Azure Stack Hub user, I want to enable a service account token volume projection on the Kubernetes cluster using AKS on Azure Stack Hub.
# Keyword:  service account token volume projection kubernetes

---


# Enabling service account token volume projection for the AKS engine on Azure Stack Hub

Istio is a configurable, open source service-mesh layer that connects, monitors, and secures the containers in a Kubernetes cluster. Istio 1.3 and higher uses a feature in Kubernetes called *service account token volume projection*. This feature is not enabled by default in Kubernetes clusters deployed by AKS engine. In this article, you can find the API model json properties in the `apiServerConfig` element that shows the Kubernetes API server flags required to enable service account token volume projection for your cluster.

For more information about service account token volume projection, see [Service Account Token Volume Projection](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/#service-account-token-volume-projection).

## Enable service account token volume projection

To enable service account token volume projection, add the following settings into your API model json file. 

```json
{
    "kubernetesConfig": {
        "apiServerConfig": {
            "--service-account-api-audiences": "api,istio-ca",
            "--service-account-issuer": "kubernetes.default.svc",
            "--service-account-signing-key-file": "/etc/kubernetes/certs/apiserver.key"
        }
    }
}
```

For a full example API model, refer to [istio.json](https://github.com/Azure/aks-engine/blob/master/examples/service-mesh/istio.json).

## Next steps

- Read about the [The AKS engine on Azure Stack Hub](azure-stack-kubernetes-aks-engine-overview.md)
- [Upgrade a Kubernetes cluster on Azure Stack Hub](azure-stack-kubernetes-aks-engine-upgrade.md)
