---
title: Uninstall AKS on Windows
description: Learn how to uninstall AKS IoT. 
author: rcheeran
ms.author: rcheeran
ms.topic: how-to
ms.date: 11/07/2022
ms.custom: template-how-to
---

# Uninstall an AKS cluster

Follow the steps in this article to uninstall AKS lite.

## Disconnect your cluster from Arc

If you've connected your cluster to Arc, it is recommended to disconnect it before uninstalling your cluster.

In your **AksEdgePrompt.cmd** file, run:

```powershell
Disconnect-ArcIotK8s
```

If you're using PowerShell 7 and the new API, you can test the Arc connection status using `Test-ArcIotK8sConnection` and disconnect it using:

```powershell
Set-AksEdgeArcConnection -connect $false
```

You can also manually remove the cluster from Arc using the Azure portal.

## Remove your application from cluster

To clean up, delete all resources using:

```powershell
kubectl delete -f linux-sample.yaml
```

## Remove nodes on a single-machine cluster

To remove the windows node only,

```powershell
Remove-AksEdgeNode -workloadType Windows
```

To remove your single machine cluster with a `Linux` or `LinuxandWindows` workload run:

```powershell
Remove-AksEdgeDeployment
```

You can't remove the Linux node alone, you must remove the deployment if you need to remove Linux node.

> [!NOTE]
> If your single machine cluster doesn't clean up properly, run `hnsdiag list networks`, then delete any existing AKS edge network objects using `hnsdiag delete networks <ID>`.

> [!NOTE] There is a known issue in which repeatedly creating a new deployment and removing the node may result in an "error during ConnectToVirtualMachine". If this occurs, reboot your system to resolve the error.

## Remove nodes on a multi-machine cluster

Before removing a node, make sure to drain the node that you'll be removing with `Set-AksEdgeNodeToDrain`. This ensures the safe de-allocation of the node's resources and that the application pods are gracefully shut down and transferred to other remaining nodes.

Be careful when removing control plane nodes and make sure you have another working control plane node before doing so.

To remove a **Windows** only node:

```powershell
Set-AksEdgeNodeToDrain -WorkloadType Windows
Remove-AksEdgeNode -WorkloadType Windows
```

To remove a **Linux** only node:

```powershell
Set-AksEdgeNodeToDrain -WorkloadType Linux
Remove-AksEdgeNode -WorkloadType Linux
```

To remove both:

```powershell
Set-AksEdgeNodeToDrain -WorkloadType LinuxAndWindows
Remove-AksEdgeDeployment
```

> [!NOTE] There is a known issue in which repeatedly creating a new deployment and removing the node can result in an error. If this occurs, reboot your system to resolve the error.

## Uninstall AKS edge

On your machine, go to **Settings > Apps > Apps & Features**. Alternatively, you can also go to **Control Panel > Uninstall a Program**. From there, look for **Azure Kubernetes Service on Windows IoT (Public Preview)**. Click **Uninstall**.

If you encounter any issues uninstalling AKS edge, try [downloading this troubleshooting tool](https://support.microsoft.com/topic/fix-problems-that-block-programs-from-being-installed-or-removed-cca7d1b6-65a9-3d98-426b-e9f927e1eb4d) to uninstall.

## Uninstall Azure CLI

See [Uninstall Azure CLI](/cli/azure/install-azure-cli-windows&tabs=azure-powershell#uninstall).

## Next steps

[Overview](aks-lite-overview.md)
