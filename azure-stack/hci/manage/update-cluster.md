---
title: Update Azure Stack HCI clusters
description: How to apply operating system and firmware updates to Azure Stack HCI using Windows Admin Center and PowerShell.
author: khdownie
ms.author: v-kedow
ms.topic: article
ms.date: 04/16/2020
---

# Update Azure Stack HCI clusters

> Applies to: Windows Server 2019

When updating Azure Stack HCI clusters, the goal is to maintain availability by updating only one server node at a time. Many operating system updates require taking the server offline, for example to do a restart or to update software such as the network stack. We recommend using [Cluster-Aware Updating (CAU)](/windows-server/failover-clustering/cluster-aware-updating), a feature that automates the software updating process on clustered servers while maintaining availability. CAU can be used on all editions of Windows Server, including Server Core installations.

## Configure Cluster-Aware Updating

To use CAU, you must first install the **Failover Clustering** feature in Windows Server on each cluster node, using either Windows Admin Center or PowerShell, and [create and validate a failover cluster](/windows-server/failover-clustering/create-failover-cluster#create-a-failover-cluster-by-using-windows-powershell). You must also install the **Failover Clustering Tools**, which are part of the **Remote Server Administration Tools** and are installed by default when you install the Failover Clustering feature using Windows Admin Center (is this true)? 

### Install Failover Clustering and Failover Clustering Tools using PowerShell

To check if a cluster or server has the Failover Clustering feature already installed, issue the **Get-WindowsFeature** PowerShell cmdlet from your management PC, or run it directly on the cluster or server without the -ComputerName parameter:

```PowerShell
Get-WindowsFeature -Name Failover* -ComputerName Server1
```

Make sure "Install State" says Installed, and that an X appears before Failover Clustering. 

If the Failover Clustering feature is not installed, install it with the **Install-WindowsFeature** cmdlet:

```PowerShell
Install-WindowsFeature –Name Failover-Clustering –IncludeManagementTools -ComputerName Server1
```

You'll also  need the the Failover Cluster Module for PowerShell, which includes Windows Powershell cmdlets for managing failover clusters. It also includes the Cluster-Aware Updating module for Windows PowerShell, for installing software updates on failover clusters. To check if a cluster or server has the Failover Cluster Module for PowerShell already installed, issue the **Get-WindowsFeature** PowerShell cmdlet from your management PC, or run it directly on the cluster or server without the -ComputerName parameter:

```PowerShell
Get-WindowsFeature -Name RSAT-Clustering-PowerShell -ComputerName Server1
```

If the Failover Cluster Module for PowerShell is not installed, install it with the **Install-WindowsFeature** cmdlet:

```PowerShell
Install-WindowsFeature –Name RSAT-Clustering-PowerShell -ComputerName Server1
```

### Choose an updating mode

Cluster-Aware Updating can coordinate the complete cluster updating operation in two modes:  
  
-   **Self-updating mode** For this mode, the CAU clustered role is configured as a workload on the failover cluster that is to be updated, and an associated update schedule is defined. The cluster updates itself at scheduled times by using a default or custom updating run profile. During the updating run, the CAU Update Coordinator process starts on the node that currently owns the CAU clustered role, and the process sequentially performs updates on each cluster node. To update the current cluster node, the CAU clustered role fails over to another cluster node, and a new Update Coordinator process on that node assumes control of the updating run. In self-updating mode, CAU can update the failover cluster by using a fully automated, end-to-end updating process. An administrator can also trigger updates on-demand in this mode, or simply use the remote-updating approach if desired. 
  
-   **Remote updating mode** For this mode, a remote computer (usually a Windows 10 PC) that has network connectivity to the failover cluster but is not a member of the failover cluster is configured with the Failover Clustering Tools. From the remote computer, called the Update Coordinator, the administrator triggers an on-demand updating run by using a default or custom updating run profile. Remote updating mode is useful for monitoring real-time progress during the updating run, and for clusters that are running on Server Core installations.  


   > [!NOTE]
   > Starting with Windows 10 October 2018 Update, RSAT is included as a set of "Features on Demand" right from Windows 10. Simply go to **Settings > Apps > Apps & features > Optional features > Add a feature > RSAT: Failover Clustering Tools**. To see installation progress, click the Back button to view status on the "Manage optional features" page. The installed feature will persist across Windows 10 version upgrades. To install RSAT for Windows 10 prior to the October 2018 Update, [download an RSAT package](https://www.microsoft.com/en-us/download/details.aspx?id=45520).

### Add CAU cluster role to configure self-updating

The **Get-CauClusterRole** cmdlet displays the configuration properties of the CAU cluster role on the specified cluster.

```PowerShell
Get-CauClusterRole -ClusterName Cluster1
```

If the role is not yet configured on the cluster, you will see the following error message:

Get-CauClusterRole : The current cluster is not configured with a Cluster-Aware Updating clustered role.

To add the CAU cluster role for self-updating mode using PowerShell, use the **Add-CauClusterRole** cmdlet and supply the appropriate [parameters](/powershell/module/clusterawareupdating/add-cauclusterrole?view=win10-ps#parameters), as in the following example:

```PowerShell
Add-CauClusterRole -ClusterName Cluster1 -MaxFailedNodes 0 -RequireAllNodesOnline -EnableFirewallRules -VirtualComputerObjectName Cluster1-CAU -Force -CauPluginName Microsoft.WindowsUpdatePlugin -MaxRetriesPerNode 3 -CauPluginArguments @{ 'IncludeRecommendedUpdates' = 'False' } -StartDate "3/2/2020 3:00:00 AM" -DaysOfWeek 4 -WeeksOfMonth @(3) -verbose
```

   > [!NOTE]
   > The above command must be run from a management PC or domain controller.

## Scan cluster for applicable updates

You can use the **Invoke-CAUScan** cmdlet to scan cluster nodes for applicable updates and get a list of the initial set of updates that are applied to each node in a specified cluster:

```PowerShell
Invoke-CauScan -ClusterName Cluster1 -CauPluginName Microsoft.WindowsUpdatePlugin -Verbose
```

Generation of the list can take a few minutes to complete. The preview list includes only an initial set of updates; it does not include updates that might become applicable after the initial updates are installed.

## Scan and install updates

To scan cluster nodes for applicable updates and perform a full updating run on the specified cluster, use the **Invoke-CAURun** cmdlet:

```PowerShell
Invoke-CauRun -ClusterName Cluster1 -CauPluginName Microsoft.WindowsUpdatePlugin -MaxFailedNodes 1 -MaxRetriesPerNode 3 -RequireAllNodesOnline -Force
```

This command performs a scan and a full updating run on the cluster named Cluster1. This cmdlet uses the Microsoft.WindowsUpdatePlugin plug-in and requires that all cluster nodes be online before the running this cmdlet. In addition, this cmdlet allows no more than three retries per node before marking the node as failed, and allows no more than one node to fail before marking the entire updating run as failed. Because the command specifies the Force parameter, the cmdlet runs without displaying confirmation prompts.

The updating run process includes the following: 
- Scanning for and downloading applicable updates on each cluster node
- Moving currently running clustered roles off each cluster node
- Installing the updates on each cluster node
- Restarting cluster nodes if required by the installed updates
- Moving the clustered roles back to the original nodes

The updating run process also includes ensuring that quorum is maintained, checking for additional updates that can only be installed after the initial set of updates are installed, and saving a report of the actions taken.

## Check on the status of an updating run

An administrator can get summary information about an updating run in progress by running the **Get-CauRun** cmdlet:

```PowerShell
Get-CauRun -ClusterName Cluster1

RunId                   : 834dd11e-584b-41f2-8d22-4c9c0471dbad 
RunStartTime            : 10/13/2019 1:35:39 PM 
CurrentOrchestrator     : NODE1 
NodeStatusNotifications : { 
Node      : NODE1 
Status    : Waiting 
Timestamp : 10/13/2019 1:35:49 PM 
} 
NodeResults             : { 
Node                     : NODE2 
Status                   : Succeeded 
ErrorRecordData          : 
NumberOfSucceededUpdates : 0 
NumberOfFailedUpdates    : 0 
InstallResults           : Microsoft.ClusterAwareUpdating.UpdateInstallResult[] 
}
```

## Next steps

For related information, see also:

- [Updating drive firmware in Storage Spaces Direct](/windows-server/storage/update-firmware)
