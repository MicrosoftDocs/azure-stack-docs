---
title: AKS Edge Essentials PowerShell commands
description: PowerShell cmdlets for AKS Edge Essentials 
author: rcheeran
ms.author: rcheeran
ms.topic: reference
ms.date: 01/31/2023
---

# AKS Edge Essentials PowerShell module

## PowerShell commands

### [Add-AksEdgeNode](./add-aksedgenode.md)

Adds a new AksEdge node to the cluster.

### [Connect-AksEdgeArc](./connect-aksedgearc.md)

Connects the AKS Edge Essentials cluster running on this machine to Azure Arc for Kubernetes.

### [Copy-AksEdgeNodeFile](./copy-aksedgenodefile.md)

Copies a file to or from a node.

### [Disconnect-AksEdgeArc](./disconnect-aksedgearc.md)

Disconnects the AKS Edge Essentials cluster running on this machine from Azure Arc for Kubernetes.

### [Get-AksEdgeDeploymentInfo](./get-aksedgedeploymentinfo.md)

Gets AKS Edge Essentials deployment information.

### [Get-AksEdgeEventLog](./get-aksedgeeventlog.md)

Collects event logs from the deployment.

### [Get-AksEdgeKubeConfig](./get-aksedgekubeconfig.md)

Pulls the KubeConfig file from the specified node.

### [Get-AksEdgeLogs](./get-aksedgelogs.md)

Collects all the logs from the deployment.

### [Get-AksEdgeManagedServiceToken](./get-aksedgemanagedservicetoken.md)

Gets the AKS Edge Essentials managed service token, for instance for use for Azure ARC for Kubernetes connected cluster.

### [Get-AksEdgeNodeAddr](./get-aksedgenodeaddr.md)

Gets the VM's IP and MAC addresses.

### [Get-AksEdgeNodeConnectivityMode](./get-aksedgenodeconnectivitymode.md)

Gets the connectivity mode of the AKS Edge Essentials Linux node.

### [Get-AksEdgeNodeName](./get-aksedgenodename.md)

Gets the VM's hostname.

### [Get-AksEdgeUpgrade](./get-aksedgeupgrade.md)

Get whether AKS Edge Essentials is allowed to upgrade the Kubernetes version on update.

### [Invoke-AksEdgeNodeCommand](./invoke-aksedgenodecommand.md)

Executes an SSH command on the specified node.

### [Install-AksEdgeHostFeatures](./install-aksedgehostfeatures.md)

Installs missing required OS features.

### [New-AksEdgeConfig](./new-aksedgeconfig.md)

Creates the configuration file needed for a new AKS Edge Essentials deployment on this machine.

### [New-AksEdgeDeployment](./new-aksedgedeployment.md)

Creates a new AKS Edge Essentials deployment on this machine.

### [New-AksEdgeScaleConfig](./new-aksedgescaleconfig.md)

Creates the configuration file needed to scale the deployment to other machines.

### [Remove-AksEdgeDeployment](./remove-aksedgedeployment.md)

Removes the deployment from an existing cluster.

### [Remove-AksEdgeNode](./remove-aksedgenode.md)

Removes a local node from an existing cluster.

### [Set-AksEdgeBillingPodState](./set-aksedgebillingpodstate.md)

 Allows AIDE front end to set Billing pod state after joining Arc through Azure CLI.

### [Set-AksEdgeNodeConnectivityMode](./set-aksedgenodeconnectivitymode.md)

 Sets AKS Edge Essentials node connectivity mode.

### [Set-AksEdgeNodeToDrain](./set-aksedgenodetodrain.md)

Safely drains a node before your delete the node.

### [Set-AksEdgeUpgrade](./set-aksedgeupgrade.md)

Sets whether AKS Edge Essentials is allowed to upgrade the Kubernetes version on update.

### [Start-AksEdgeNode](./start-aksedgenode.md)

Starts the node VM if it's currently stopped.

### [Start-AksEdgeUpdate](./start-aksedgeupdate.md)

Starts the update process for updating AKS Edge Essentials.

### [Start-AksEdgeControlPlaneUpdate](./start-aksedgecontrolplaneupdate.md)

Updates the control plane nodes on this machine as a part of the update process.

### [Start-AksEdgeWorkerNodeUpdate](./start-aksedgeworkernodeupdate.md)

Updates any worker nodes on this machine as part of the update process.

### [Stop-AksEdgeNode](./stop-aksedgenode.md)

Stops the node VM if it's currently started.

### [Test-AksEdgeArcConnection](./test-aksedgearcconnection.md)

Checks whether the cluster is Azure Arc connected.

### [Test-AksEdgeDeployment](./test-aksedgedeployment.md)

Checks whether the deployment was created.

### [Test-AksEdgeNetworkParameters](./test-aksedgenetworkparameters.md)

Validates AKS Edge Essentials network parameters, useful as a pre-deployment check as well before scaling to multiple machines.

### [Test-AksEdgeNode](./test-aksedgenode.md)

Checks whether the VM was created.
