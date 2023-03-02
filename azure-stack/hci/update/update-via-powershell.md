---
title: Update Azure Stack HCI clusters via PowerShell (preview)
description: How to apply operating system, service, and Solution extension updates to Azure Stack HCI using PowerShell (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.date: 03/01/2023
---

# Update your Azure Stack HCI solution via PowerShell (preview)

> Applies to: Azure Stack HCI, versions 22H2 and later

This article describes how to apply a solution update via PowerShell cmdlets on your Azure Stack HCI clusters. This procedure applies to both a single node and multi-node clusters that are running software versions with Lifecycle Manager installed. If your Azure Stack HCI cluster was created using a new deployment of version 22H2, then Lifecycle Manager was automatically installed as part of the deployment.


## About solution updates using the Lifecycle Manager

This article focuses on solution updates that can consist of platform, service, and solution extension updates. For more information on each of these types of updates, see [What's in an Update](placeholder.md).


## Prerequisites

Before you apply the solution updates, make sure that you've access to:

- An Azure Stack HCI cluster that is running 2302 or higher. The cluster should be registered with the service in Azure.
- The solution update package <insert a link here>. You will side-load these updates.


## Connect to your cluster

To connect to one of the nodes of your Azure Stack HCI cluster, follow these steps:

- Run PowerShell as administrator on the client that you are using to connect to your cluster.
- Open a remote PowerShell session to a node on your Azure Stack HCI cluster. Run the following command:

## Step 1: Discover available updates

The first step is to identify which solution updates are available for your cluster.


## Known issues

The following are known issues when applying a solution update on your cluster from Azure Stack HCI, version 20H2 to version 21H2.

### Couldn't install updates

This error message is seen when Windows Admin Center loses connectivity to the managed servers, so it's likely that the updates are actually being installed. Simply wait a few minutes and refresh your browser, and you should see the true update status. You can also use `Get-CauRun` to check the status of the updating run with PowerShell, and then refresh your browser when the run is complete.

:::image type="content" source="media/update-cluster/known-issues.png" alt-text="This error message is seen when Windows Admin Center loses connectivity to the managed servers, so it's likely that the updates are actually being installed. Refresh your browser." lightbox="media/update-cluster/known-issues.png"::::::

### Couldn't check for updates

This error message is seen when Windows Admin Center loses connectivity to the managed servers, so it's likely that the updates are actually being installed. Simply wait a few minutes and refresh your browser, and you should see the true update status. You can also use `Get-CauRun` to check the status of the updating run with PowerShell and then refresh your browser when the run is complete.

This message is also seen when the clustered servers have mixed versions of patches installed. This causes the `Invoke_CAUScan` command with `RollingUpgrade` plugin to return multiple feature updates. To mitigate this issue, apply the [May 20, 2021 preview update (KB5003237)](https://support.microsoft.com/en-us/topic/may-20-2021-preview-update-kb5003237-0c870dc9-a599-4a69-b0d2-2e635c6c219c) to all servers in the cluster before attempting to update the cluster.

### Multiple prompts for login credentials

In older versions of Windows Admin Center, you may be prompted to authenticate multiple times during an updating run. Either authenticate each time when prompted or go back to **Connections** and re-connect to the cluster.

### Cluster readiness check doesn't complete

At times, the readiness check remains in **Checking** status for the cluster validation tests and never finishes. This is predominantly seen in non-English Azure Stack HCI clusters due to localization issues. 

When `Test-Cluster` finishes on the machines (usually after a couple of minutes), Windows Admin Center may not recognize that the checks have completed. Because `Test-Cluster` does succeed behind the scenes in this scenario, you can download the `Test-Cluster` report file directly from the servers to validate cluster health before continuing with the updating run. Alternatively, run `Test-Cluster` using PowerShell on any of the servers in the cluster.

### CredSSP credentials error

In older versions of Windows Admin Center, you may encounter the error message "You can't use Cluster Aware Updating without enabling CredSSP and providing explicit credentials" when you've already done so. This issue is fixed in Windows Admin Center version 2110.

### CredSSP session endpoint permissions issue

During an updating run, you may see a notification to enable CredSSP, along with an error message: "Couldn't enable CredSSP delegation. Connecting to the remote server failed."

This CredSSP error is seen when Windows Admin Center is running on a local PC and when the Windows Admin Center user is not the same user who installed Windows Admin Center on the machine.

To mitigate this problem, Microsoft has introduced a Windows Admin Center CredSSP administrators group. Add your user account to the Windows Admin Center CredSSP Administrators group on your local PC and then sign back in, and the error should go away.

### Naming mismatch on operating system versions

Although the update header says Azure Stack HCI 22H2, if a cluster hasn't joined the preview channel, it will only receive the publicly offered 21H2 GA update. This is a hard-coding mismatch.

## Next steps

For related information, see also:

- [Cluster-Aware Updating (CAU)](/windows-server/failover-clustering/cluster-aware-updating)
- [Cluster-Aware Updating requirements and best practices](/windows-server/failover-clustering/cluster-aware-updating-requirements)
- [Troubleshoot CAU: Log Files for Cluster-Aware Updating](https://social.technet.microsoft.com/wiki/contents/articles/13414.troubleshoot-cau-log-files-for-cluster-aware-updating.aspx)
- [Manage quick restarts with Kernel Soft Reboot](kernel-soft-reboot.md)
- [Updating drive firmware in Storage Spaces Direct](/windows-server/storage/update-firmware)
- [Validate an Azure Stack HCI cluster](../deploy/validate.md)
