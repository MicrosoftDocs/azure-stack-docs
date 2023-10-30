---
title: Troubleshoot common issues in AKS Edge Essentials 
description: Learn about common issues and workarounds in AKS Edge Essentials. 
author: rcheeran
ms.author: rcheeran
ms.topic: conceptual
ms.date: 10/17/2023
ms.custom: template-concept
ms.reviewer: fcabrera
---

# Troubleshoot common issues in AKS Edge Essentials

This article describes how to find solutions for issues you encounter when using AKS Edge Essentials. Known issues and errors are organized by functional area. You can use the links provided in this article to find solutions and workarounds to resolve them.

## Open a support request

See the [Get support](/azure/aks/hybrid/help-support?tabs=aksee) article for information about how to use the Azure portal to get support or open a support request for AKS Edge Essentials.

## Deployment issues

### Untrusted publisher issue

Error message: "Do you want to run software from this untrusted publisher? ....."

Workaround: Update your PowerShell execution policy to **RemoteSigned**:

```powershell
# Get the execution policy on the system
Get-ExecutionPolicy
# Set the execution policy for this process only
if ((Get-ExecutionPolicy) -ne "RemoteSigned") { Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process -Force }
```

### Low disk space causes precached container images to be deleted

When the node runs out of disk space, some of the preloaded images are garbage collected by the `containerd` runtime. In this case, first free up some disk space, and then run the following command to pull the cached images again:

```powershell
    Invoke-AksEdgeNodeCommand -NodeType Linux -command "sudo /path/to/script/reimport-ci.sh
```

This script checks for the missing images and reimports them as needed.

### Azure Arc connectivity

1. Issue: `Disconnect-AksEdgeArc` doesn't remove the pods from the cluster.

   Workaround: If the pods aren't cleaned up, run the following commands to manually clean up the existing Azure Arc-related resources before trying to reconnect again:

   ```powershell
       kubectl delete ns azure-arc
       kubectl delete clusterrolebinding azure-arc-operator
       kubectl delete secret sh.helm.release.v1.azure-arc.v1
   ```

2. Issue: Azure Arc connectivity doesn't work in a proxy environment.

   Workaround: You can enable system-wide proxy settings by following **Internet options > Connections > LAN Settings**.

   :::image type="content" source="media/aks-edge/aks-edge-azure-arc-proxy.png" alt-text="Screenshot showing internet options." lightbox="media/aks-edge/aks-edge-azure-arc-proxy.png":::

## Next steps

[AKS Edge Essentials overview](aks-edge-overview.md)
