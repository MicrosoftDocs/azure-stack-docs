---
title: AKS for light edge commands #Required; page title is displayed in search results. Include the brand.
description: Powershell cmdlets for AKS #Required; article description that is displayed in search results. 
author: rcheeran #Required; your GitHub user alias, with correct capitalization.
ms.author: rcheeran #Required; microsoft alias of author; optional team alias.
#ms.service: #Required; service per approved list. slug assigned by ACOM.
ms.topic: reference #Required; leave this attribute/value as-is.
ms.date: 09/30/2022 #Required; mm/dd/yyyy format.
ms.custom: template-tutorial #Required; leave this attribute/value as-is.
---



# AKS on Windows

## Module Powershell Commands

### [Add-AksEdgeNode](./Add-AksIotNode.md)

Adds a new AksIot node to the cluster.

### [Get-AksEdgeClusterJoinData](./Get-AksIotClusterJoinData.md)

Pulls the cluster join data from a Linux control plane node.

### [Get-AksEdgeDeploymentInfo](./Get-AksIotDeploymentInfo.md)

Gets AksIot deployment information.

### [Get-AksEdgeEventLog](./Get-AksIotEventLog.md)

Collects event logs from the deployment.

### [Get-AksEdgeKubeConfig](./Get-AksIotKubeConfig.md)

Pulls the KubeConfig file from the Linux node.

### [Get-AksEdgeLinuxNodeAddr](./Get-AksIotLinuxNodeAddr.md)

Gets the Linux VM's IP and MAC addresses

### [Get-AksEdgeLinuxNodeName](./Get-AksIotLinuxNodeName.md)

Gets the Linux VM's hostname

### [Get-AksEdgeLogs](./Get-AksIotLogs.md)

Collects all the logs from the deployment.

### [Get-AksEdgeManagedServiceToken](./Get-AksIotManagedServiceToken.md)

Gets the AksIot managed service token, for instance for use for Azure ARC for Kubernetes connected cluster.

### [Invoke-AksEdgeLinuxNodeCommand](./Invoke-AksIotLinuxNodeCommand.md)

Executes an SSH command on the Linux VM.

### [New-AksEdgeDeployment](./New-AksIotDeployment.md)

Creates a new AksIot deployment on this machine.

### [Remove-AksEdgeNode](./Remove-AksIotNode.md)

Removes a local node from an existing cluster.

### [Set-AksEdgeArcConnection](./Set-AksIotArcConnection.md)

Connects or disconnects the AKS on Windows IoT cluster running on this machine to or from Azure Arc forKubernetes.

### [Start-AksEdgeLinuxNode](./Start-AksIotLinuxNode.md)

Starts the Linux node VM if it's currently stopped.

### [Stop-AksEdgeLinuxNode](./Stop-AksIotLinuxNode.md)

Stops the Linux node VM if it's currently started.

### [Test-AksEdgeLinuxNode](./Test-AksIotLinuxNode.md)

Checks whether the Linux VM was created.

### [Test-AksEdgeNetworkParameters](./Test-AksIotNetworkParameters.md)

Validates AksIot network parameters, useful as a pre-deployment step.

## Next steps

- Try out the [Quickstart](../../aks-lite-quickstart.md)
- [Overview](../../aks-lite-overview.md)
- [Uninstall AKS cluster](../../aks-lite-howto-uninstall.md)
<!--
Remove all the comments in this template before you sign-off or merge to the 
main branch.
-->
