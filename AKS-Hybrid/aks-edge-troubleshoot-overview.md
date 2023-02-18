---
title: AKS Edge Essentials Troubleshoot Common Issues 
description: Common issues and workarounds
author: rcheeran
ms.author: rcheeran
ms.topic: conceptual
ms.date: 02/09/2023
ms.custom: template-concept
ms.reviewer: fcabrera
---

# AKS Edge Essentials Troubleshoot Common Issues

This overview provides guidance on how to find solutions for issues you encounter when using AKS Edge Essentials. Known issues and errors are organized by functional area. You can use the links provided in this article to find the solutions and workarounds to resolve them.

## Deployment Issues

1. Untrusted publisher issue:

Error: you see the message `Do you want to run software from this untrusted publisher? .....`

Workaround: Update your PowerShell execution policy to **RemoteSigned**:

```powershell
# Get the Execution Policy on the system
Get-ExecutionPolicy
# Set the Execution Policy for this process only
if ((Get-ExecutionPolicy) -ne "RemoteSigned") { Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process -Force }
```

## Arc Connectivity

1. Issues with `Disconnect-AksEdgeArc`:
    Issue: `Disconnect-AksEdgeArc` doesn't remove the pods from the cluster.

    Workaround: If the pods aren't cleaned up, run the below commands to manually cleanup the existing arc related resources before trying to reconnect again.

    ```powershell
        kubectl delete ns azure-arc
        kubectl delete clusterrolebinding azure-arc-operator
        kubectl delete secret sh.helm.release.v1.azure-arc.v1
    ```
2. Arc connectivity with a proxy setup:
    Issue: Arc connectivity doesn't work in a proxy environment
    Workaround: You can enable system-wide proxy settings by following Internet Options --> Connections --> LAN Settings. ![Screenshot showing Internet Options](./media/aks-edge/aks-edge-arc-proxy.png)