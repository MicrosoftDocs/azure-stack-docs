---
title: Uninstall AKS on Windows
description: Learn how to uninstall AKS IoT. 
author: rcheeran
ms.author: rcheeran
ms.topic: how-to
ms.date: 11/07/2022
ms.custom: template-how-to
---

# Uninstall an AKS cluster on Windows

Follow the steps in this article to uninstall AKS lite.

## Disconnect your cluster from Arc

If you've connected your cluster to Arc, it's recommended that you disconnect it before uninstalling your cluster.

In your **LaunchPrompt.cmd**, run:

```powershell
Disconnect-ArcIotK8s
```

If you're using PowerShell 7 and the new API, you can test the Arc connection status using the `Test-ArcIotK8sConnection` cmdlet, and disconnect it using:

```powershell
Set-AksIotArcConnection -connect $false
```

## Remove your application from cluster

To clean up, delete all resources using:

```bash
kubectl delete -f linux-sample.yaml
```

## Remove AKS-IoT cluster

Always tear down your clusters before you uninstall the AKS-IoT MSI. To remove an AKS-IoT cluster, run the following cmdlet:

```powershell
Remove-AksIotNode
```

> [!NOTE]
> If your single machine cluster doesn't clean up properly, run `hnsdiag list networks`, then delete any existing AKS-IoT network objects using `hnsdiag delete networks <ID>`.

## Uninstall AKS-IoT

On your machine, go to **Settings > Apps > Apps & Features**. Alternatively, you can also go to **Control Panel > Uninstall a Program**. From there, look for **Azure Kubernetes Service on Windows IoT**. Select **uninstall**.

If you encounter any issues uninstalling AKS-IoT, try [downloading this troubleshooting tool](https://support.microsoft.com/topic/fix-problems-that-block-programs-from-being-installed-or-removed-cca7d1b6-65a9-3d98-426b-e9f927e1eb4d) to uninstall.

## Uninstall Azure CLI

See [Uninstall Azure CLI](/cli/azure/install-azure-cli-windows&tabs=azure-powershell#uninstall).

## Next steps

[Overview](aks-lite-overview.md)
