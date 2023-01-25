---
title: Upgrade the Kubernetes version of Azure Kubernetes Service workload clusters with Windows Admin Center
description: Learn how to upgrade the Kubernetes version of Azure Kubernetes Service (AKS) workload clusters in AKS hybrid
ms.topic: article
ms.date: 10/20/2022
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 1/14/2022
ms.reviewer: abha
# Intent: As an IT Pro, I want to learn how to use Windows Admin Center to upgrade my AKS clusters.
# Keyword: upgrade version Kubernetes upgrade Windows Admin Center
---

# Upgrade the Kubernetes version of an AKS workload cluster using Windows Admin Center

[!INCLUDE [applies-to-azure stack-hci-and-windows-server-skus](includes/aks-hci-applies-to-skus/aks-hybrid-applies-to-azure-stack-hci-windows-server-sku.md)]

This article describes how to upgrade an Azure Kubernetes Service (AKS) workload cluster to a new Kubernetes version in AKS hybrid. You should [update the AKS hosts](update-akshci-host-windows-admin-center.md) to a new version of the operating system before updating the Kubernetes version.

> [!NOTE]
> You can also use PowerShell to [upgrade AKS workload clusters](upgrade.md).

We recommend updating an AKS workload cluster in AKS hybrid at least once every 60 days. New updates are available every 30 days. To avoid outages in workload availability, rolling updates are performed.

When you bring a _new_ node with a newer build into the cluster, resources move from the _old_ node to the _new_ node, and when the resources are successfully moved, the _old_ node is decommissioned and removed from the cluster.

## Upgrade the Kubernetes version

To upgrade the Kubernetes version of an AKS workload cluster with Windows Admin Center, follow these steps: 

1. On the Windows Admin Center **Connections** page, connect to your management cluster.
2. Select **Azure Kubernetes Service** from the **Tools** list. When the tool loads, you will see the **Overview** page.
3. Select the workload cluster you wish to upgrade.
4. Select **Settings** under Kubernetes clusters to navigate to the **Settings** page. 

   [ ![Screenshot showing the Settings option for Kubernetes clusters in Windows Admin Center.](./media/wac-kubernetes-upgrade/kubernetes-upgrade-settings.png) ](./media/wac-kubernetes-upgrade/kubernetes-upgrade-settings.png#lightbox)

5. Select **Update now** to upgrade your workload cluster's Kubernetes version. 

   [ ![Screenshot showing the Update Now button on the Host Settings page in Windows Admin Center.](./media/wac-kubernetes-upgrade/kubernetes-cluster-update-now.png) ](./media/wac-kubernetes-upgrade/kubernetes-cluster-update-now.png#lightbox)

The following update scenarios aren't supported in Windows Admin Center, but you can [use PowerShell](upgrade.md) to do them:

- Windows Admin Center doesn't support skipping a patch update. You can only update a workload cluster to the next available patch version, even when a minor update is available.  
- Windows Admin Center doesn't support upgrading the OS image of the Kubernetes cluster without updating the Kubernetes version.

## Next steps

In this article, you learned how to upgrade AKS workload clusters in AKS hybrid. Next, you can:
- [Deploy a Linux application on a Kubernetes cluster](./deploy-linux-application.md).
- [Deploy a Windows Server application on a Kubernetes cluster](./deploy-windows-application.md).
