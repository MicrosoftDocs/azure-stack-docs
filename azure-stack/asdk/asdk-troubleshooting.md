---
title: Troubleshoot the ASDK | Microsoft Docs
description: Learn how to troubleshoot Azure Stack Development Kit (ASDK).
services: azure-stack
documentationcenter: ''
author: justinha
manager: femila
editor: ''

ms.assetid: 
ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 02/12/2019
ms.author: justinha
ms.reviewer: misainat
ms.lastreviewed: 10/15/2018

---
# Troubleshoot the ASDK
This article provides common troubleshooting info for the Azure Stack Development Kit (ASDK). If you're experiencing an issue that isn't documented, make sure to check the [Azure Stack MSDN Forum](https://social.msdn.microsoft.com/Forums/azure/home?forum=azurestack) for assistance.  

> [!IMPORTANT]
> Because the ASDK is an evaluation environment, there's no official support offered through Microsoft Customer Support Services (CSS).

The recommendations for troubleshooting issues described in this section are derived from several sources and may or may not resolve your particular issue. Code examples are provided "as is" and expected results can't be guaranteed. This section is subject to frequent edits and updates as improvements to the product are implemented.

## Deployment
### Deployment failure
If you experience a failure during installation, you can restart the deployment from the failed step by using the -rerun option of the deployment script. For example:

  ```powershell
  cd C:\CloudDeployment\Setup
  .\InstallAzureStackPOC.ps1 -Rerun
  ```

### At the end of the deployment, the PowerShell session is still open and doesn't show any output
This behavior is probably just the result of the default behavior of a PowerShell command window when it's been selected. The ASDK deployment has succeeded but the script was paused when selecting the window. You can verify setup has completed by looking for the word "select" in the titlebar of the command window. Press the ESC key to unselect it, and the completion message should be shown after it.

## Virtual machines
### Default image and gallery item
A Windows Server image and gallery item must be added before deploying VMs in Azure Stack.

### After restarting my Azure Stack host, some VMs don't automatically start.
After rebooting your host, you may notice Azure Stack services aren't immediately available. This is because Azure Stack [infrastructure VMs](asdk-architecture.md#virtual-machine-roles) and RPs take some time to check consistency, but will eventually start automatically.

You might also notice that tenant VMs don't automatically start after a reboot of the ASDK host. This is a known issue, and just requires a few manual steps to bring them online:

1.  On the ASDK host, start **Failover Cluster Manager** from the Start Menu.
2.  Select the cluster **S-Cluster.azurestack.local**.
3.  Select **Roles**.
4.  Tenant VMs appear in a *saved* state. Once all Infrastructure VMs are running, right-click the tenant VMs and select **Start** to resume the VM.

### I've deleted some VMs, but still see the VHD files on disk. Is this behavior expected?
Yes, this is expected behavior. It's designed this way because:

* When you delete a VM, VHDs aren't deleted. Disks are separate resources in the resource group.
* When a storage account gets deleted, the deletion is visible immediately through Azure Resource Manager, but the disks it may contain are still kept in storage until garbage collection runs.

If you see "orphan" VHDs, it's important to know if they're part of the folder for a storage account that was deleted. If the storage account wasn't deleted, it's normal that they're still there.

You can read more about configuring the retention threshold and on-demand reclamation in [manage storage accounts](../operator/azure-stack-manage-storage-accounts.md).

## Storage
### Storage reclamation
It can take up to 14 hours for reclaimed capacity to show up in the portal. Space reclamation depends on various factors including usage percentage of internal container files in block blob store. Therefore, depending on how much data is deleted, there's no guarantee on the amount of space that could be reclaimed when garbage collector runs.

## Next steps
[Visit the Azure Stack support forum](https://social.msdn.microsoft.com/Forums/azure/home?forum=azurestack)
