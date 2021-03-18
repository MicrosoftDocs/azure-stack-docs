---
title: Scale an Azure Kubernetes Service on Azure Stack HCI cluster
description: Learn how to scale the number of nodes in an Azure Kubernetes Service on Azure Stack HCI cluster.
ms.topic: article
ms.date: 03/02/2021
author: jessicaguan
ms.author: jeguan
---

# Scale the node count in an Azure Kubernetes Service on Azure Stack HCI cluster

If the resource needs of your applications change, you can manually scale an AKS cluster to run a different number of control plane nodes and worker nodes. The control plane nodes and worker nodes must be scaled separately.

## Scale the control plane nodes

Use the [Set-AksHciClusterNodeCount](set-akshciclusternodecount.md) command to scale the control plane nodes. The following example scales the control plane nodes in a cluster named *mycluster* to three nodes. 

```powershell
Set-AksHciClusterNodeCount -name mycluster -controlPlaneNodeCount 3
```

## Scale the worker nodes

Use the [Set-AksHciClusterNodeCount](set-akshciclusternodecount.md) command to scale the worker nodes. The following example scales the Linux nodes and Windows nodes in a cluster named *mycluster* to three and one nodes respectively.

```powershell
Set-AksHciClusterNodeCount -name mycluster -linuxNodeCount 3 -windowsNodeCount 1
``` 

## Next steps

In this article, you learned how to manually scale an Azure Kubernetes Service on Azure Stack HCI cluster to increase or decrease the number of control plane nodes and worker nodes. Next, you can:
- [Deploy a Linux applications on a Kubernetes cluster](./deploy-linux-application.md).
- [Deploy a Windows Server application on a Kubernetes cluster](./deploy-windows-application.md).
