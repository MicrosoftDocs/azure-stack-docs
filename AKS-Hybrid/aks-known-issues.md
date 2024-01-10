---
title: Known issues in AKS on Azure Stack HCI (preview)
description: Learn about known issues in the current version of AKS on Azure Stack HCI.
ms.topic: how-to
author: sethmanheim
ms.date: 12/14/2023
ms.author: sethm 
ms.lastreviewed: 12/14/2023
ms.reviewer: guanghu

---

# Known issues in AKS on Azure Stack HCI (preview)

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

This article identifies critical known issues and their workarounds in AKS on Azure Stack HCI, version 23H2.

The article describes known issues in AKS for all Azure Stack HCI 23H2 releases. These known issues are continuously updated, and as critical issues requiring a workaround are discovered, they're added. Before you deploy your Kubernetes clusters on Azure Stack HCI, carefully review this information.

## Known issues in version 2311

This release maps to software version 10.2311.0.26 of Azure Stack HCI.

| Feature          | Issue                                                                                                                     | Workaround/Comments                                                                                                                        |
|------------------|---------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------|
| Portal           | Specifying a Kubernetes version during cluster creation is not supported in the Azure portal.                                       | You can use Azure CLI to create the Kubernetes cluster with a supported Kubernetes version.                                                |
| Portal           | The available list of VM types is not complete when creating Kubernetes clusters in the Azure portal.                            |                                                                                                                                            |
| Cluster upgrade  | The Azure CLI command for cluster upgrade `az akshybrid upgrade` does not work without specifying the target Kubernetes version. | You must specify the target Kubernetes version when you run the `az akshybrid upgrade` command with the `--version <target version>` parameter. |
| Supported VM size | The `az akshybrid vmsize` command does not correctly return the required available VM types.                                 | Wait for 10 minutes and rerun the same command to view the supported VM types.                                                 |

## Next steps

- [Review AKS on Azure Stack HCI 23H2 prerequisites](aks-hci-network-system-requirements.md)
- [What's new in AKS on Azure Stack HCI](aks-preview-overview.md)
