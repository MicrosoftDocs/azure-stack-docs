---
title: Enable quick restarts with Kernel Soft Reboot in Azure Stack HCI
description: How to enable and manage quick restarts by using Kernel Soft Reboot (KSR) when updating or servicing Azure Stack HCI clusters.
author: khdownie
ms.author: v-kedow
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 10/19/2021
---

# Enable quick restarts with Kernel Soft Reboot

> Applies to: Azure Stack HCI, version 21H2

New in Azure Stack HCI, version 21H2, Kernel Soft Reboot (KSR) is a premium feature available on all Azure Stack HCI integrated systems. You can use it when updating the cluster to reboot the servers faster than a normal reboot. This topic explains when to use a KSR over a normal reboot and provides instructions on using this feature on Azure Stack HCI.

## Why use Kernel Soft Reboot?

Traditionally, servicing a cluster (for example, applying software updates) requires putting each server in maintenance node, evacuating the server, installing updates, rebooting if necessary, and then repeating the process for every server in the cluster. Even though Cluster-Aware Updating (CAU) automates many of these tasks, when the cluster resumes, any new data written while under maintenance mode still needs to be resynced. The longer it takes to reboot a server, the more data must be resynced, and the longer the overall cluster update time.

Kernel Soft Reboot improves reboot performance by streamlining the operating system flow, minimizing the amount of data to be resynced and therefore reducing the overall cluster update time. The amount of time saved will be proportional to the memory and size of the server. As server resources such as available memory and drives increase, so does the time savings.

Take a few minutes to [watch the video](https://www.youtube.com/watch?v=tdfF2iBCIaE) comparing the performance of a normal reboot to a Kernel Soft Reboot on an idle server.

## When to use Kernel Soft Reboot

As this feature bypasses the lengthy and traditional reboot BIOS/FIRMWARE initialization, you can only use Kernel Soft Reboot for updates that do not require a firmware/BIOS initialization. Currently, you can use Kernel Soft Reboot optionally with the Cluster-Aware Updating WindowsUpdate plugin for Quality Updates and Hotfix plugin for MSI/MSU/EXEs files only.

## Enable Kernel Soft Reboot with Cluster-Aware Updating using PowerShell

In Azure Stack HCI, version 21H2, you can use PowerShell to set up and manage Kernel Soft Reboot for your Azure Stack HCI cluster.

>[!NOTE]
>The default reboot option for CAU updates is a normal reboot unless Kernel Soft Reboot is explicitly enabled using one of the following two options.

### Option 1: Enable Kernel Soft Reboot for all future CAU runs

Set the cluster private property with key `CauEnableSoftReboot` to value 1 if you want CAU to set Kernel Soft Reboot as the default reboot option for all supported updates.

```PowerShell
Get-Cluster | Set-ClusterParameter -Name CauEnableSoftReboot -Value 1 -Create 
```

>[!NOTE]
>Resetting this private property to any other value than 1 or deleting the property entirely will disable Kernel Soft Reboot on the cluster.

### Option 2: Use Kernel Soft Reboot with individual CAU runs

To use Kernel Soft Reboot with a specific Cluster-Aware Updating run, use the optional `AttemptSoftReboot` parameter when using CAU PowerShell cmdlets, such as in the following examples.

```PowerShell
Invoke-CauRun <other_options> -AttemptSoftReboot
```

```PowerShell
Add-CauClusterRole <other_options> -AttemptSoftReboot
```

```PowerShell
Set-CauClusterRole <other_options> -AttemptSoftReboot
```

### Skip Kernel Soft Reboot on certain servers

Ideally, all the servers in an Azure Stack HCI cluster should support Kernel Soft Reboot. However, you can set a registry setting on a server to make it opt out of using KSR.

Setting this registry value on any server in the cluster will cause Cluster-Aware Updating to skip Kernel Soft Reboot and attempt to reboot the server normally.

```
Key: SOFTWARE\Microsoft\Windows\CurrentVersion\ClusterAwareUpdating
Name: CauBypassSoftBootOnNode
Type: REG_SZ
Value: True
```

## Troubleshooting

To determine the type of reboot that was last performed, use `Get-CauReport` with `last` and `detailed` parameters to get the report for the last Cluster-Aware Updating run.

```PowerShell
$report = Get-CauReport <other_options> -Last -Detailed
$report.ClusterResult.NodeResults | fl Node,NodeRebootResult
```

The report should return a `NodeResults` list that contains the `NodeRebootResult` for each server in the cluster. The output should look something like this:

```
Node : VM01
NodeRebootResult : RebootSummaryResult : Succeeded
BootType : SoftBoot
SoftBootStatus : Enabled
```

The following table shows how each name-value pair provides more information on the last reboot for each server in the cluster.

| **Name** | **Value** |
|:----------------------|:---------------------|
| **Node** | States the name of the node in  the cluster. |
| **RebootSummaryResult** | Mentions if the last reboot was successful or not irrespective of the type of reboot requested and type of reboot performed. For example, if a user requests a KSR but a normal reboot was performed successfully, **RebootSummaryResult** would still return the value **Succeeded**. |
| **BootType** | Specifies the type of reboot performed in the last run. |
| **SoftBootStatus** | Indicates if Kernel Soft Reboot is **Enabled**, **NotEnabled**, **NotInstalled**, or **Bypassed** if the server opts out of Kernel Soft Reboot using registry key settings. |

For additional troubleshooting, see [Save-CauDebugTrace](/powershell/module/clusterawareupdating/save-caudebugtrace?view=windowsserver2019-ps).

## FAQ

This section answers frequently asked questions about Kernel Soft Reboot on Azure Stack HCI, version 21H2.

**Can I use Kernel Soft Reboot with Windows Server?**

- No. Kernel Soft Reboot is only available in Azure Stack HCI, version 21H2 and may only work on those validated as Integrated Systems.

**How can I tell if my hardware supports Kernel Soft Reboot?**

- All hardware marked as Integrated Systems in the [Azure Stack HCI Catalog](https://hcicatalog.azurewebsites.net) can perform Kernel Soft Reboot.

**Will Kernel Soft Reboot work with Validated Nodes?**

- Although this feature is not blocked on other HCI hardware, Validated Nodes are not required to test or support Kernel Soft Reboot. If you're using a Validated Node, you can try using Kernel Soft Reboot using the instructions in this article.

## Next steps

For more information, see also:

- [Update Azure Stack HCI clusters](update-cluster.md)
- [Cluster-Aware Updating PowerShell commands](/powershell/module/clusterawareupdating/?view=windowsserver2019-ps)
- [Cluster-Aware Updating requirements and best practices](/windows-server/failover-clustering/cluster-aware-updating-requirements)
