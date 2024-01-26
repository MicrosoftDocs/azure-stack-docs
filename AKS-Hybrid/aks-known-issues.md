---
title: Known issues in AKS enabled by Azure Arc
description: Learn about known issues in the current version of AKS enabled by Arc.
ms.topic: how-to
author: sethmanheim
ms.date: 01/26/2024
ms.author: sethm 
ms.lastreviewed: 01/26/2024
ms.reviewer: guanghu

---

# Known issues in AKS enabled by Azure Arc

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

This article identifies critical known issues and their workarounds in AKS enabled by Arc, version 23H2.

The article describes known issues in AKS for all Azure Stack HCI 23H2 releases. These known issues are continuously updated, and as critical issues requiring a workaround are discovered, they're added. Before you deploy your Kubernetes clusters on Azure Stack HCI, carefully review this information.

## Known issues in version 2311.2

This release maps to software version 10.2311.2.7 of Azure Stack HCI.

| Feature          | Issue                                                                                                                     | Workaround/Comments                                                                                                                        |
|------------------|---------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------|
| Cluster deployment            | The operation to the default node pool fails if the Kubernetes cluster is created using Azure CLI in a region that's different from the Azure Stack HCI custom location's region.                                          | Create a resource group in the same region as the Azure Stack HCI custom location region. Use the default option to create a Kubernetes cluster using Azure CLI.                                                 |
| HCI upgrade           | After an Azure Stack HCI cluster is upgraded to GA (version 2311.2), some operations (such as scaling and updating) cannot be performed on the cluster created in the preview version (2311.0).                             |  Use [`az aksarc upgrade`](/cli/azure/aksarc#az-aksarc-upgrade) to upgrade the Kubernetes version of the affected cluster to a GA-supported version. You can run [`az aksarc get-versions`](/cli/azure/aksarc#az-aksarc-get-versions) to list all the supported versions on your system.                                                                                                          |
| HCI upgrade  | After an Azure Stack HCI cluster is upgraded to GA (version 2311.2), the Kubernetes cluster created in the preview version (2311.0) will not work properly if its cluster name has more than 31 characters.  | Delete this cluster and create a new one with a cluster name that has fewer than 31 chars. |

## Next steps

- [AKS network prerequisites](aks-hci-network-system-requirements.md)
- [System requirements for AKS Arc](system-requirements.md)