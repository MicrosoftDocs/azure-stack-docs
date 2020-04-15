---
title: Update Azure Stack HCI clusters
description: How to apply operating system, firmware, and application updates to Azure Stack HCI using Windows Admin Center and PowerShell.
author: khdownie
ms.author: v-kedow
ms.topic: article
ms.date: 04/15/2020
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
  
-   **Self-updating mode** For this mode, the CAU clustered role is configured as a workload on the failover cluster that is to be updated, and an associated update schedule is defined. The cluster updates itself at scheduled times by using a default or custom Updating Run profile. During the Updating Run, the CAU Update Coordinator process starts on the node that currently owns the CAU clustered role, and the process sequentially performs updates on each cluster node. To update the current cluster node, the CAU clustered role fails over to another cluster node, and a new Update Coordinator process on that node assumes control of the Updating Run. In self-updating mode, CAU can update the failover cluster by using a fully automated, end-to-end updating process. An administrator can also trigger updates on-demand in this mode, or simply use the remote-updating approach if desired. In self-updating mode, an administrator can get summary information about an Updating Run in progress by connecting to the cluster and running the **Get-CauRun** Windows PowerShell cmdlet.  
  
-   **Remote updating mode** For this mode, a remote computer (usually a Windows 10 PC) that has network connectivity to the failover cluster but is not a member of the failover cluster is configured with the Failover Clustering Tools. From the remote computer, called the Update Coordinator, the administrator triggers an on-demand Updating Run by using a default or custom Updating Run profile. Remote updating mode is useful for monitoring real-time progress during the Updating Run, and for clusters that are running on Server Core installations.  


   > [!NOTE]
   > Starting with Windows 10 October 2018 Update, RSAT is included as a set of "Features on Demand" right from Windows 10. Simply go to Settings > Apps > Apps & features > Optional features > Add a feature > RSAT: Failover Clustering Tools. To see installation progress, click the Back button to view status on the "Manage optional features" page. The installed feature will persist across Windows 10 version upgrades. To install RSAT for Windows 10 prior to the October 2018 Update, [download an RSAT package](https://www.microsoft.com/en-us/download/details.aspx?id=45520).

### Create CAU role to configure self-updating

## Next steps

For related information, see also:

- [Updating drive firmware in Storage Spaces Direct](/windows-server/storage/update-firmware)
