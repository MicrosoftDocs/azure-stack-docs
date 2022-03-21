---
title: Vertical scaling of node pools Azure Kubernetes Services (AKS) on Azure Stack HCI
description: Learn about vertically scaling of node pools in Azure Kubernetes Service (AKS) on Azure Stack HCI
ms.topic: conceptual
author: mattbriggs
ms.author: mabrigg 
ms.lastreviewed: 03/18/2022
ms.reviewer: mikek
ms.date: 03/18/2022

# Intent: As a Kubernetes user, I want to use cluster autoscaler to grow my nodes to keep up with application demand.
# Keyword: vertical node autoscaling Kubernetes

---


# Vertical node autoscaling in Azure Kubernetes Services (AKS) on Azure Stack HCI

To keep up with application demands in Azure Kubernetes Service (AKS), customers need to adjust the number of nodes that run their workloads. In some cases scaling a cluster horizontally by adding additional nodes is not sufficient as application demand for more CPU cores or memory would require to re-deploy a new node pool and migration of the app which might also not be ideal in resource limited edge environments. To enable this flexibility Azure Kubernetes Service in Azure Stack HCI introduces the capability to change the SKU of the virtual machines in a given node pool.

> [!IMPORTANT]
> Horizontal node autoscaling is currently in PREVIEW.
> See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.
### How vertical node scaling in AKS on Azure Stack HCI works

In AKS on Azure Stack HCI target cluster node pools are managed internally as a machineDeployment. One property of an machineDeployment is the VMSize (SKU)  that was selected when the 'New-AksHciNodePool' command was executed.
To change the node pool to a different VM size (SKU) the user will use the 'Set-AksHciNodePool' command for changing the VM size for worker nodes and the 'Set-AksHciCluster' command to change the VM size for control plane nodes.

Once the user submits the command with the new VM size (SKU) a new machineDeployment for the node pool or cluster will be created replacing the existing machine set. This will trigger an update flow in the underlying deployment system which will, like during an OS or Kubernetes version upgrade, use a rolling update to replace one virtual machine in the node pool or control plane after the other ensuring the old node is correctly cordoned and drained before it is removed.

> ![NOTE] 
> The system assumes the user ensures there are enough hardware resources available to scale up the new machine set in place of the old machine set.

### Example process

#### Change the VM Size for a Linux worker node pool from 4 cores and 6 GB of memory to 4 cores and 8 GB of memory

First check what the current VM size is for the node pool on cluster 'mycluster'. From the output below we can see it is 'Standard_K8S3_v1'.

``` powershell
get-akshcinodepool -clustername mycluster
```

```output
Status       : {Error, Phase, Details}
ClusterName  : mycluster
NodePoolName : mycluster-linux
Version      : v1.22.4
OsType       : Linux
NodeCount    : 2
VmSize       : Standard_K8S3_v1
Phase        : scaling
```

Looking up 'Standard_K8S3_v1' in the list of available VM sizes shows that it has 4 cores and 6 GB of memory. 

``` powershell
Get-AksHciVmSize
```

```output
          VmSize CPU MemoryGB
          ------ --- --------
         Default 4   4
  Standard_A2_v2 2   4
  Standard_A4_v2 4   8
 Standard_D2s_v3 2   8
 Standard_D4s_v3 4   16
 Standard_D8s_v3 8   32
Standard_D16s_v3 16  64
Standard_D32s_v3 32  128
 Standard_DS2_v2 2   7
 Standard_DS3_v2 2   14
 Standard_DS4_v2 8   28
 Standard_DS5_v2 16  56
Standard_DS13_v2 8   56
 Standard_K8S_v1 4   2
Standard_K8S2_v1 2   2
Standard_K8S3_v1 4   6
```

The new size we want to set for 4 cores and 8 GB of memory would be 'Standard_A4_v2'
To update the node pool 'mycluster-linux' we will use the 'Set-AksHciNodePool' command which has been updated to accept a '-VMsize' parameter.

``` powershell
PS C:\> Set-AksHciNodePool -ClusterName mycluster -name mycluster-linux -vmsize Standard_A4_v2
```

After a few minutes the process is complete. We can check the result by running 'Get-AksHciNodePool' again and ensuring that the VmSize is now 'Standard_A4_v2'.

``` powershell
PS C:\> get-akshcinodepool -clustername mycluster

Status       : {Error, Phase, Details}
ClusterName  : mycluster
NodePoolName : mycluster-linux
Version      : v1.22.4
OsType       : Linux
NodeCount    : 2
VmSize       : Standard_A4_v2
Phase        : scaling
```

## Next Steps

See the documentation for the updated PowerShell commands.
- [Set-AksHciNodePool](reference/ps/set-akshcinodepool.md)
- [Set-AksHciCluster](reference/ps/set-akshcicluster.md)
- [Get-AksHciCluster](reference/ps/get-akshcicluster.md)