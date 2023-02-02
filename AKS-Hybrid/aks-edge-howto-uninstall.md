---
title: Uninstall AKS Edge Essentials
description: Learn how to uninstall AKS Edge Essentials. 
author: rcheeran
ms.author: rcheeran
ms.topic: how-to
ms.date: 12/05/2022
ms.custom: template-how-to
---

# Uninstall an AKS Edge Essentials cluster

Follow the steps in this article to uninstall AKS Edge Essentials.

## Disconnect from Azure Arc

If you used `Connect-AideArcKubernetes` to connect to Azure Arc, run `Disconnect-AideArcKubernetes` to disconnect your cluster from Azure Arc. For a complete clean-up, delete the service principal and resource group you created for this example.

```powershell
Disconnect-AideArcKubernetes
```

If you used `Connect-AksEdgeArc` to connect to Arc, run `Disconnect-AksEdgeArc` to disconnect your cluster from Azure Arc.

```powershell
Disconnect-AksEdgeArc -JsonConfigFilePath .\aksedge-config.json
```

You can also manually remove the cluster from Arc using the Azure portal and delete the arc pods in the cluster.

## Remove your application from cluster

Delete the applications that you deployed using the following command.

```powershell
kubectl delete -f ./path-to-your-YAML-file/app.yaml
```

For example, if you deployed the sample Linux application, you can delete it using:

```powershell
kubectl delete -f linux-sample.yaml
```

## Remove nodes on a single-machine cluster

To remove the Windows node only,

```powershell
Remove-AksEdgeNode -nodeType Windows
```

To remove your single machine cluster with a `Linux` or `LinuxandWindows` workload run:

```powershell
Remove-AksEdgeDeployment
(or)
Remove-AksEdgeDeployment -Force #to forcefully remove all.
```

You can't remove the Linux node alone in this configuration, you must remove the deployment if you need to remove Linux node.

> [!NOTE]
> If your single machine cluster doesn't clean up properly, run `hnsdiag list networks`, then delete any existing AKS edge network objects using `hnsdiag delete networks <ID>`.

> [!NOTE]
> There is a known issue in which repeatedly creating a new deployment and removing the node may result in an "error during ConnectToVirtualMachine". If this occurs, reboot your system to resolve the error.

## Remove nodes on a multi-machine cluster

Be careful when removing control plane nodes and make sure you have another working control plane node before doing so.

To remove a **Windows** only node:

```powershell
Remove-AksEdgeNode -NodeType Windows
```

To remove a **Linux** only node:

```powershell
Remove-AksEdgeNode -NodeType Linux
```

To remove both:

```powershell
Remove-AksEdgeDeployment
```

> [!NOTE]
> There is a known issue in which repeatedly creating a new deployment and removing the node can result in an error. If this occurs, reboot your system to resolve the error.

## Uninstall AKS edge

On your machine, go to **Settings > Apps > Apps & Features**. Alternatively, you can also go to **Control Panel > Uninstall a Program**. From there, look for **Azure Kubernetes Service Edge Essentials (Public Preview)**. Click **Uninstall**.

> [!NOTE]
> You may want to reboot your machine right after the uninstall so that all resources are cleaned and your machine is ready for a new installation in the future.

If you encounter any issues uninstalling AKS edge, try [downloading this troubleshooting tool](https://support.microsoft.com/topic/fix-problems-that-block-programs-from-being-installed-or-removed-cca7d1b6-65a9-3d98-426b-e9f927e1eb4d) to uninstall.

## Uninstall Azure CLI

See [Uninstall Azure CLI](/cli/azure/install-azure-cli-windows#uninstall).

## Uninstall Az Powershell

See [How to uninstall Azure Powershell modules](/powershell/azure/uninstall-az-ps).

## Next steps

[Overview](aks-edge-overview.md)
