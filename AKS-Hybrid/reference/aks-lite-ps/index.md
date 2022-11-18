---
title: AKS Edge commands #Required; page title is displayed in search results. Include the brand.
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

### [Add-AksEdgeNode](./add-aksedgenode.md)

Adds a new AksIot node to the cluster.

### [Export-AksEdgeWorkerNodeConfig](./export-aksedgeworkernodeconfig.md)

Pulls the cluster join data from a Linux control plane node.

### [Get-AksEdgeDeploymentInfo](./get-aksedgedeploymentinfo.md)

Gets AksIot deployment information.

### [Get-AksEdgeEventLog](./get-aksedgeeventlog.md)

Collects event logs from the deployment.

### [Get-AksEdgeKubeConfig](./get-aksedgekubeconfig.md)

Pulls the KubeConfig file from the Linux node.

### [Get-AksEdgeNodeAddr](./get-aksedgenodeaddr.md)

Gets the VM's IP and MAC addresses

### [Get-AksEdgeNodeName](./get-aksedgenodename.md)

Gets the VM's hostname

### [Get-AksEdgeLogs](./get-aksedgelogs.md)

Collects all the logs from the deployment.

### [Get-AksEdgeManagedServiceToken](./get-aksedgemanagedservicetoken.md)

Gets the AksIot managed service token, for instance for use for Azure ARC for Kubernetes connected cluster.

### [Invoke-AksEdgeNodeCommand](./invoke-aksedgenodecommand.md)

Executes an SSH command on the Linux VM.

### [New-AksEdgeDeploymentConfig](./new-aksedgedeploymentconfig.md)

Creates the configuration file needed for a new AksIot deployment on this machine.


### [New-AksEdgeDeployment](./new-aksedgedeployment.md)

Creates a new AksIot deployment on this machine.

### [Remove-AksEdgeDeployment](./remove-aksedgedeployment.md)

Removes the deployment from an existing cluster.

### [Remove-AksEdgeNode](./remove-aksedgenode.md)

Removes a local node from an existing cluster.

### [Set-AksEdgeNodeToDrain](./set-aksedgenodetodrain.md)

Safely drains a node before your delete the node. 

### [Set-AksEdgeArcConnection](./set-aksedgearcconnection.md)

Connects or disconnects the AKS on Windows IoT cluster running on this machine to or from Azure Arc forKubernetes.

### [Start-AksEdgeNode](./start-aksedgenode.md)

Starts the node VM if it's currently stopped.

### [Stop-AksEdgeNode](./stop-aksedgenode.md)

Stops the node VM if it's currently started.

### [Test-AksEdgeDeployment](./test-aksedgedeployment.md)

Checks whether the deployment was created.

### [Test-AksEdgeNode](./test-aksedgenode.md)

Checks whether the Linux VM was created.

### [Test-AksEdgeNetworkParameters](./test-aksedgenetworkparameters.md)

Validates AksIot network parameters, useful as a pre-deployment step.

## Next steps

- Try out the [Quickstart](../../aks-lite-quickstart.md)
- [Overview](../../aks-lite-overview.md)
- [Uninstall AKS cluster](../../aks-lite-howto-uninstall.md)
<!--
Remove all the comments in this template before you sign-off or merge to the 
main branch.
-->
