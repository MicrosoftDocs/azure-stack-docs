---
title: Upgrade the Kubernetes version of AKS workload clusters with Windows Admin Center
description: Learn how to upgrade the Kubernetes version of AKS workload clusters on Azure Stack HCI using Windows Admin Center
ms.topic: article
ms.date: 07/07/2021
author: v-susbo
ms.author: v-susbo
---

## Upgrade the Kubernetes version of a workload cluster using Windows Admin Center

This article describes how to upgrade an AKS on Azure Stack HCI workload cluster to a new Kubernetes version. We recommend that you [update the AKS hosts](update-akshci-host-wac.md) to a new version of the operating system before updating the Kubernetes version.

We recommend updating an AKS workload cluster on Azure Stack HCI at least once every 60 days. New updates are available every 30 days. All updates are done in a rolling update flow to avoid outages in workload availability. When you bring a _new_ node with a newer build into the cluster, resources move from the _old_ node to the _new_ node, and when this completes successfully, the _old_ node is decommissioned and removed from the cluster.

To upgrade the Kubernetes version of a workload cluster with Windows Admin Center, follow these steps: 

1. On the Windows Admin Center **Connections** page, connect to your management cluster.
2. Select the **Azure Kubernetes Service** tool from the **Tools** list. When the tool loads, you will see the **Overview** page.
3. Select the workload cluster you wish to upgrade.
4. Select **Settings** under Kubernetes clusters to navigate to the **Settings** page. 
5. Select **Update now** to upgrade your workload cluster’s Kubernetes version. 

The following update scenarios are not supported in Windows Admin Center: 

- We currently do not support skipping a patch update. You can only update a workload cluster to the next available patch version even when a minor update is available.  
- A workload cluster update performs a patch Kubernetes update without updating the OS version. 

These update scenarios will addressed in an upcoming release. However, you can [use PowerShell](upgrade.md) to run these update operations. 

## Next steps

In this article, you learned how to upgrade AKS workload clusters on Azure Stack HCI. Next, you can:
- [Deploy a Linux applications on a Kubernetes cluster](./deploy-linux-application.md).
- [Deploy a Windows Server application on a Kubernetes cluster](./deploy-windows-application.md).
