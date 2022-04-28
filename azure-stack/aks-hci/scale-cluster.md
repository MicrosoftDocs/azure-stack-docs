---
title: Scale an Azure Kubernetes Service on Azure Stack HCI or Windows Server cluster
description: Learn how to scale the number of nodes in an Azure Kubernetes Service on Azure Stack HCI or Windows Server cluster.
ms.topic: article
ms.date: 04/25/2022
author: mattbriggs
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: jeguan
# Intent: As an IT Pro, I need to learn how to scale the number of nodes in an AKS cluster in order to run control plane nodes and worker nodes.
# Keyword: node count scale clusters control plane nodes
---

# Scale the node count in an Azure Kubernetes Service on Azure Stack HCI or Windows Server cluster

If the resource needs of your applications change, you can manually scale an AKS cluster to run a different number of control plane nodes and worker nodes. To do this, you must scale the control plane nodes and worker nodes separately.

## Scale the control plane nodes

Use the [Set-AksHciCluster](./reference/ps/set-akshcicluster.md) command to scale the control plane nodes. The following example scales the control plane nodes in a cluster named *mycluster* to three nodes. 

```powershell
Set-AksHciCluster -name mycluster -controlPlaneNodeCount 3
```

## Scale the worker nodes in the node pool

Use the [Set-AksHciNodePool](./reference/ps/set-akshcinodepool.md) command to scale the node pool. The following example scales a node pool called *linuxnodepool* in a cluster named *mycluster* to a node count of 3. 

```powershell
Set-AksHciNodePool -name mycluster -nodePoolName linuxnodepool -nodeCount 3
``` 

## Next steps

In this article, you learned how to manually scale an Azure Kubernetes Service on Azure Stack HCI or Windows Server cluster to increase or decrease the number of control plane nodes and worker nodes. Next, you can:
- [Deploy a Linux applications on a Kubernetes cluster](./deploy-linux-application.md).
- [Deploy a Windows Server application on a Kubernetes cluster](./deploy-windows-application.md).
