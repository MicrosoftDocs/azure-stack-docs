---
title: Uninstall AKS on Windows #Required; page title is displayed in search results. Include the brand.
description: Steps to uninstall AKS IoT #Required; article description that is displayed in search results. 
author: rcheeran #Required; your GitHub user alias, with correct capitalization.
ms.author: rcheeran #Required; microsoft alias of author; optional team alias.
#ms.service: #Required; service per approved list. slug assigned by ACOM.
ms.topic: how-to #Required; leave this attribute/value as-is.
ms.date: 10/03/2022 #Required; mm/dd/yyyy format.
ms.custom: template-how-to #Required; leave this attribute/value as-is.
---
# Uninstalling AKS cluster on Windows

## Disconnect your cluster from Arc

If you have connected your cluster to Arc, it is recommended to disconnect it before uninstalling your cluster.

In your `LaunchPrompt.cmd`, simply run:

```powershell
Disconnect-ArcIotK8s
```

If you are using PowerShell 7 and the new API, you can test the Arc connection status using `Test-ArcIotK8sConnection` and disconnect it using:

```powershell
Set-AksIotArcConnection -connect $false
```

## Remove your application from cluster

To clean up, delete all resources using:

```bash
kubectl delete -f linux-sample.yaml
```

## Remove AKS-IoT cluster

**ALWAYS tear down your clusters before you uninstall the AKS-IoT MSI.**

To remove an AKS-IoT cluster:

```powershell
Remove-AksIotNode
```

>[!NOTE]
>If your single machine cluster doesn't clean up properly, run `hnsdiag list networks`, then delete any existing AKS-IoT network objects using `hnsdiag delete networks <ID>`.

## Uninstall AKS-IoT

In your machine, go to `Settings` > `Apps` > `Apps & Features`. Alternatively, you can also go to `Control Panel` > `Uninstall a Program`.
From there, look for `Azure Kubernetes Service on Windows IoT (Private Preview)`. Click uninstall.

If you run into any issues uninstalling AKS-IoT, try downloading this [troubleshooter](https://support.microsoft.com/topic/fix-problems-that-block-programs-from-being-installed-or-removed-cca7d1b6-65a9-3d98-426b-e9f927e1eb4d) to uninstall.

## Uninstall Azure CLI

See [Uninstall Azure CLI](/cli/azure/install-azure-cli-windows?view=azure-cli-latest&tabs=azure-powershell#uninstall).

## Next steps

Please let the [Microsoft team](mailto:projecthaven@microsoft.com) know about your experience!

[Overview](aks-lite-overview.md)
