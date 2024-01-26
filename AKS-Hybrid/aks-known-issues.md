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
| Cluster deployment            | Creating a Kubernetes cluster using Azure CLI in a different region than the Azure Stack HCI custom location's region is not supported.                                        | Create a resource group in the same region as the Azure Stack HCI custom location region. Use the default option to create a Kubernetes cluster using Azure CLI.                                                 |
| HCI upgrade           | After an Azure Stack HCI cluster is upgraded to GA (version 2311.2), the Kubernetes cluster created in the preview version (2311.0) doesn't work properly using the new Azure CLI and the portal.                             |  Delete the old Kubernetes cluster created using the preview version using `az akshybrid delete`, and create a new one after you upgrade to GA.                                                                                                        |
| Cluster deployment  | Creating a Kubernetes cluster in a different Azure subscription than the Azure Stack HCI custom location's Azure subscription is not supported. | Ensure that the Kubernetes cluster is in the same Azure subscription as the one in which the Azure Stack HCI custom location resource is located. |
| Cluster deployment  | After the Kubernetes cluster creation succeeds, it can take 2-3 hours to complete the Arc onboarding. The **Status**, **Last Connectivity Time**, and **Agent version** fields might not be fully populated until the Arc onboarding is complete.                                 | Wait for 2-3 hours and see if the properties are populated. You can check the properties using Azure CLI (`az aksarc show`), or from the Azure portal.                                                 |

## Next steps

- [Review AKS on Azure Stack HCI 23H2 prerequisites](aks-hci-network-system-requirements.md)
