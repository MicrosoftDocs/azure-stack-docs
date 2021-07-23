---
title: Stop and restart a cluster on Azure Kubernetes Service on Azure Stack HCI
description: Learn how to stop and restart a cluster on Azure Kubernetes Service (AKS) on Azure Stack HCI.
author: EkeleAsonye
ms.topic: how-to
ms.date: 07/23/2021
ms.author: v-susbo
---

# Stop and start an AKS on Azure Stack HCI cluster

Your workloads may not need to run continuously, and to save resource costs, you might need to shut down your AKS on Azure Stack HCI cluster. To shut down a cluster, run the commands described in this article from your Hyper-V host to power down the different components. This article also covers how to restart a cluster and how to verify that the control plane nodes are running after a restart.

## Before you begin

This article assumes that you have an existing AKS on Azure Stack HCI cluster installed and configured on your machine. If you need to install a cluster, see the AKS on Azure Stack HCI quickstart to [set up an AKS host and deploy a workload cluster](kubernetes-walkthrough-powershell.md). 

## Stop an AKS on Azure Stack HCI cluster

To stop (or shut down) a cluster, you must first stop the cluster service and then stop the local amd/or remote computers. 

Use the [Stop-Cluster](/powershell/module/failoverclusters/stop-cluster?view=windowsserver2019-ps) PowerShell command to shut down an AKS on Azure Stack HCI cluster and stop the cluster service on all nodes in the cluster. Running this command stops all services and applications configured in the cluster. 

To stop the Cluster service on all nodes of the local cluster, open PowerShell as an administrator and run the following command:

```powershell
PS:> Stop-Cluster 
```

To shut down the local and remote computers, use the [Stop-Computer](/powershell/module/microsoft.powershell.management/stop-computer?view=powershell-7.1) PowerShell command as shown below:

```powershell
PS:> Stop-Computer 
```

## Start an AKS on Azure Stack HCI cluster

To start a stopped AKS on Azure Stack HCI cluster, you first restart the operating system on the local and remote computers, and then restart the cluster. 

To restart the operating system on your local and remote computers, use the following [Restart-Computer](/powershell/module/microsoft.powershell.management/restart-computer?view=powershell-7.1) PowerShell command:

```powershell
PS:> Restart-Computer 
```

Use the [Start-Cluster](/powershell/module/failoverclusters/start-cluster?view=windowsserver2019-ps) PowerShell command to restart the cluster. All nodes of your AKS on Azure Stack HCI cluster on which cluster service is yet to start can be started with  

```powershell
PS:> Start-Cluster 
```

A node only functions as part of a cluster when the cluster service is running on that node. 

> [!NOTE]
> You cannot remotely run **Start-Cluster** without CredSSP authentication on the server machine.
 
You can verify when your cluster has started by using the [Get-ClusterNode](/powershell/module/failoverclusters/get-clusternode?view=windowsserver2019-ps) PowerShell command as shown in the example below:

```powershell
PS:> Get-ClusterNode -ErrorAction SilentlyContinue | foreach-object { 
        $node = $_.Name 
        $state = $_.State 
        Write-Host "$node State = $state" 
      	} 
```

## Verify the control plane nodes are running

To verify the control plane nodes are running, enumerate the VMs and make sure the state is _running_. Using PowerShell, run the following command to view the status of your control plane VM from your Hyper-V host: 

```powershell
PS:> $controlPlanes = Get-VM | ? { $_.Name -like '*-control-plane-*' -and $_.State -eq 'Running' } | % { $_.Name } 
```

If the control plane node is not running, restart the VM by running the following PowerShell command: 

```powershell
PS:> Restart-VM -name $vmName -force 
```

## Next steps

- [Scale the node count in an AKS on Azure Stack HCI cluster](scale-cluster.md)
- [Upgrade the AKS on Azure Stack HCI host](update-akshci-host-powershell.md)

