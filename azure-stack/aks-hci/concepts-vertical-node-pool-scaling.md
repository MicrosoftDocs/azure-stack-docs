---
title: Vertical node scaling in Azure Kubernetes Service (AKS) on Azure Stack HCI
description: Learn about the vertically scaling of node pools in Azure Kubernetes Service (AKS) on Azure Stack HCI
ms.topic: conceptual
author: mattbriggs
ms.author: mabrigg 
ms.lastreviewed: 03/18/2022
ms.reviewer: mikek
ms.date: 03/18/2022

# Intent: As a Kubernetes user, I want to use increase my VM size in place to grow my nodes to keep up with application demand.
# Keyword: vertical node scaling Kubernetes

---
# Vertical node scaling in Azure Kubernetes Service on Azure Stack HCI

You can change the size of the virtual machines in a given node pool to increase the resources available to your node pool.

To keep up with app demands in Azure Kubernetes Service (AKS), you may need to adjust the number of nodes that run your workloads. In some cases, scaling a cluster horizontally by adding additional nodes isn't sufficient to meet the demands from your app for more CPU cores or memory. Without vertical node scaling, you would need to redeploy to a new node pool and move the app. This might not be ideal in resource limited edge environments. To enable this flexibility AKS in Azure Stack HCI introduces the capability to change the virtual machine (VM) size (SKU) of the VMs in a given node pool.

> [!IMPORTANT]
> Vertical node scaling is currently in PREVIEW.
> See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.
## How vertical node scaling in AKS on Azure Stack HCI and Windows Server works

In AKS on Azure Stack HCI and Windows Server target cluster node pools are managed internally as a **machineDeployment**. One property of a **machineDeployment** is the VM size (SKU) that was selected when the `New-AksHciNodePool` command was executed.

To change the node pool to a different VM size (SKU), you can use the `Set-AksHciNodePool` command for changing the VM size for worker nodes and the `Set-AksHciCluster` command to change the VM size for control plane nodes.

Once you submit the command with the new VM size (SKU), a new **machineDeployment** for the node pool or cluster will be created replacing the existing machine set. This triggers an update flow in the underlying deployment system. Similar to an OS or Kubernetes version upgrade the new **machineDeployment** uses a rolling update to replace one virtual machine in the node pool or control plane after the other. Each upgrade checks that the old node is correctly cordoned and drained before it's removed.

> [!NOTE]
> The system assumes that you have checked that are enough hardware resources available to scale up the new machine set in place of the old machine set.

## Example process

The following example illustrates vertical node scaling.
### Change the VM Size for a Linux worker node pool from 4 cores and 6 GB of memory to 4 cores and 8 GB of memory

First, check what the current VM size is for the node pool on cluster `mycluster`. From the output, you can see it's `Standard_K8S3_v1`.

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

Look up `Standard_K8S3_v1` in the list of available VM sizes shows that it has four cores and six GB of memory. 

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

The new size you want to set for four cores and eight GB of memory would be `Standard_A4_v2`.
To update the node pool `mycluster-linux` you'll use the `Set-AksHciNodePool` cmdlet, which has been updated to accept a `-VMsize` parameter.

``` powershell
Set-AksHciNodePool -ClusterName mycluster -name mycluster-linux -vmsize Standard_A4_v2
```

After a few minutes the process is complete. You can check the result by running `Get-AksHciNodePool` again and verify that the `VmSize` is now `Standard_A4_v2`.

``` powershell
get-akshcinodepool -clustername mycluster
```

```outpout
Status       : {Error, Phase, Details}
ClusterName  : mycluster
NodePoolName : mycluster-linux
Version      : v1.22.4
OsType       : Linux
NodeCount    : 2
VmSize       : Standard_A4_v2
Phase        : scaling
```

## Next steps

See the documentation for the updated PowerShell commands.
- [Set-AksHciNodePool](reference/ps/set-akshcinodepool.md)
- [Set-AksHciCluster](reference/ps/set-akshcicluster.md)
- [Get-AksHciCluster](reference/ps/get-akshcicluster.md)