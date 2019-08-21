---
title: Upgrade a Kubernetes cluster on Azure Stack | Microsoft Docs
description: Description
services: azure-stack
documentationcenter: ''
author: mattbriggs
manager: femila
editor: ''

ms.service: azure-stack
ms.workload: na
pms.tgt_pltfrm: na (Kubernetes)
ms.devlang: nav
ms.topic: article
ms.date: 08/22/2019
ms.author: mabrigg
ms.reviewer: waltero
ms.lastreviewed: 08/22/2019

---

# Upgrade a Kubernetes cluster on Azure Stack

*Applies to: Azure Stack integrated systems and Azure Stack Development Kit*

## Upgrade a cluster

The AKS Engine allows you to upgrade the cluster that was originally deployed using the tool. You can maintain the clusters using the AKS Engine. Your maintenance tasks are similar to any IaaS system. You should be aware of the availability of new updates and use the AKS Engine to apply them. 

Microsoft doesn't manage your cluster.

**For a cluster deployed in a connected matter**. Upgrades cover:

-   Kubernetes

-   Azure Stack Kubernetes provider

**For a cluster deployed in a disconnected matter**. Upgrades cover:

-   Kubernetes
-   Azure Stack Kubernetes provider
-   Base OS

When upgrading a production cluster, consider:

-   Are you using the correct cluster specification (`apimodel.json`) and resource group for the target cluster?
-   Are you using a reliable machine for the client machine to run the AKS Engine and from which you are performing upgrade operations?
-   Make sure that you have a backup cluster and that it is operational.
-   If possible, run the command from a VM within the same VNET to decrease the network hops and potential connectivity failures.
-   Make sure that your subscription will have enough quota through the entire process.
-   No system updates or scheduled tasks are planned.

Follow the instructions n the article, [Upgrading Kubernetes Clusters](https://github.com/Azure/aks-engine/blob/master/docs/topics/upgrade.md). 

You need to first determine the versions you can target for the upgrade. This version depends on the version you currently have and then use that version value to perform the upgrade.

Run the following commands:

```bash  
$ aks-engine get-versions
Version Upgrades
1.15.0
1.14.3  1.15.0
1.14.1  1.14.3, 1.15.0
1.13.7  1.14.1, 1.14.3
1.13.5  1.13.7, 1.14.1, 1.14.3
1.12.8  1.13.5, 1.13.7
1.12.7  1.12.8, 1.13.5, 1.13.7
1.11.10 1.12.7, 1.12.8
1.11.9  1.11.10, 1.12.7, 1.12.8
1.10.13 1.11.9, 1.11.10
1.10.12 1.10.13, 1.11.9, 1.11.10
1.9.11  1.10.12, 1.10.13
1.9.10  1.9.11, 1.10.12, 1.10.13
1.6.9   1.9.10, 1.9.11

$ aks-engine upgrade \
  --azure-env AzureStackCloud   
  --location <for an ASDK is local> \
  --resource-group kube-rg \
  --subscription-id xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \
  --api-model kube-rg/apimodel.json \
  --upgrade-version 1.13.5 \
  --client-id xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \
  --client-secret xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \

```

For example, according to the output of the `get-versions` command, if your current Kubernetes version is "1.13.5" you can upgrade to "1.13.7, 1.14.1, 1.14.3".

## Forcing an Upgrade

There may be conditions where you may want to force an upgrade of your cluster. For example, on day one you deploy a cluster in a disconnected environment using the latest Kubernetes version. The following day Ubuntu releases a patch to a vulnerability for which Microsoft generates a new **AKS Base Image**. You can apply the new image by forcing an upgrade using the same Kubernetes version you already deployed.

For instructions, see [Force upgrade](https://github.com/Azure/aks-engine/blob/master/docs/topics/upgrade.md#force-upgrade).

## Next steps

- Read about the [The AKS Engine on Azure Stack](azure-stack-kubernetes-aks-engine-overview.md)
- [Scale a Kubernetes cluster on Azure Stack](azure-stack-kubernetes-aks-engine-scale.md)
- [Rotate certificates for a Kubernetes cluster on Azure Stack](azure-stack-kubernetes-aks-engine-cert-rotate.md)