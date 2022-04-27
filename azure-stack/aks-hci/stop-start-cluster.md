---
title: Stop and restart a cluster on Azure Kubernetes Service on Azure Stack HCI
description: Learn how to stop and restart a cluster on Azure Kubernetes Service (AKS) on Azure Stack HCI.
author: mattbriggs
ms.topic: how-to
ms.date: 08/09/2021
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: EkeleAsonye
---

# Stop and start an AKS on Azure Stack HCI and Windows Server cluster

Your workloads may not need to run continuously, and to save resource costs, you might need to stop (or shut down) your AKS on Azure Stack HCI and Windows Server cluster. To stop a cluster, run the commands described in this article from your Hyper-V host to power down the different components. This article also covers how to start a stopped cluster and how to verify that the control plane nodes are running after a restart.

## Before you begin

This article assumes that you have an existing AKS on Azure Stack HCI and Windows Server cluster installed and configured on your machine. If you need to install a cluster, see the AKS on Azure Stack HCI and Windows Server quickstart to [set up an AKS host and deploy a workload cluster](kubernetes-walkthrough-powershell.md). 

## Stop an Azure Stack HCI or Windows Server cluster

To stop (or shut down) a cluster, you must first stop the cluster service and then stop the local and/or remote computers. 

### Stop the cluster service
Use the [Stop-Cluster](/powershell/module/failoverclusters/stop-cluster?view=windowsserver2019-ps&preserve-view=true) PowerShell command to shut down an Azure Stack HCI or Windows Server cluster and stop the cluster service on all nodes in the cluster. Running this command stops all services and applications configured in the cluster. 

> [!IMPORTANT]
> When you run `Stop-Cluster`, all other nodes and VM-based applications in the cluster will also be impacted.

To stop the cluster service on all nodes of the local cluster, open PowerShell as an administrator and run the following command on one of the machines in the cluster:

```powershell
PS:> Stop-Cluster 
```
After running this command, type Y [Yes] to confirm that you want to stop the cluster. 

> [!NOTE]
> If you run `Stop-Cluster` twice on the same machine, or on more than one machine in the cluster, you'll receive an error that says _No cluster service running_.

### Stop the local or remote computers
To shut down the local and remote computers, use the [Stop-Computer](/powershell/module/microsoft.powershell.management/stop-computer?view=powershell-7.1&preserve-view=true) PowerShell command as shown below:

```powershell
PS:> Stop-Computer 
```

## Start an Azure Stack HCI or Windows Server cluster

To start a stopped Azure Stack HCI or Windows Server cluster, you first restart the operating system on the local and/or remote computers, and then restart the cluster. 

To restart the operating system on your local and remote computers, use the following [Restart-Computer](/powershell/module/microsoft.powershell.management/restart-computer?view=powershell-7.1&preserve-view=true) PowerShell command:

```powershell
PS:> Restart-Computer 
```

To restart all the nodes of the Azure Stack HCI or Windows Server cluster, use the [Start-Cluster](/powershell/module/failoverclusters/start-cluster?view=windowsserver2019-ps&preserve-view=true) PowerShell command as shown below:  

```powershell
PS:> Start-Cluster 
```

A node can only function as part of a cluster when the cluster service is running. 

> [!NOTE]
> You cannot remotely run **Start-Cluster** without CredSSP authentication on the server machine.
 
You can verify that your cluster has started by using the [Get-ClusterNode](/powershell/module/failoverclusters/get-clusternode?view=windowsserver2019-ps&preserve-view=true) PowerShell command as shown in the example below:

```powershell
PS:> Get-ClusterNode -ErrorAction SilentlyContinue | foreach-object { 
        $node = $_.Name 
        $state = $_.State 
        Write-Host "$node State = $state" 
      	} 
```
The output would be similar to the following list of cluster nodes:

```Output
TK5-3WP15R1625 State = Up
TK5-3WP15R1627 State = Up
TK5-3WP15R1629 State = Up
TK5-3WP15R1631 State = Up
```

## Verify the control plane nodes are running

To verify the control plane nodes are running, enumerate the VMs and make sure their state is _running_. To view the status of your control plane VM from your Hyper-V host, run the following PowerShell command on a physical machine that contains the management cluster control plane VM:

```powershell
PS:> $controlPlanes = Get-VM | ? { $_.Name -like '*-control-plane-*' -and $_.State -eq 'Running' } | % { $_.Name } 
```

If you run this command on a machine other than the one with the control plane VM, you'll receive a null output.

The example output is shown below:

```Output
c8bf39ad-67bd-4a7d-ac77-638be6eecf46-control-plane-0-d38498de
my-cluster-control-plane-q9mbp-ae97a3e5
```

If the control plane node is not running, restart the VM by running the following PowerShell command: 

```powershell
PS:> Restart-VM -name $vmName -force 
```

## Next steps

- [Scale the node count in an AKS on Azure Stack HCI and Windows Server cluster](scale-cluster.md)
- [Upgrade the AKS on Azure Stack HCI and Windows Server host](update-akshci-host-powershell.md)

