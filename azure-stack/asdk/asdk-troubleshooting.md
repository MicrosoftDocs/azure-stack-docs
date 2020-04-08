---
title: Troubleshoot the ASDK 
description: Learn how to troubleshoot Azure Stack Development Kit (ASDK).
author: justinha

ms.topic: article
ms.date: 11/05/2019
ms.author: justinha
ms.reviewer: misainat
ms.lastreviewed: 11/05/2019

# Intent: As an ASDK user, I want to troubleshoot the ASDK so I can solve some common problems.
# Keyword: troubleshoot asdk

---

# Troubleshoot the ASDK
This article provides common troubleshooting info for the Azure Stack Development Kit (ASDK). For help with Azure Stack integrated systems, see [Microsoft Azure Stack troubleshooting](../operator/azure-stack-troubleshooting.md). 

Because the ASDK is an evaluation environment, Microsoft Customer Support Services (CSS) does not provide support. If you're experiencing an issue that isn't documented, you can get help from experts on the [Azure Stack MSDN Forum](https://social.msdn.microsoft.com/Forums/azure/home?forum=azurestack). 


## Deployment
### Deployment failure
If you experience a failure during installation, you can restart the deployment from the failed step by using the -rerun option of the deployment script. For example:

  ```powershell
  cd C:\CloudDeployment\Setup
  .\InstallAzureStackPOC.ps1 -Rerun
  ```

### At the end of the deployment, the PowerShell session is still open and doesn't show any output
This behavior is probably just the result of the default behavior of a PowerShell command window when it's been selected. The ASDK deployment has succeeded but the script was paused when selecting the window. You can verify setup has completed by looking for the word "select" in the titlebar of the command window. Press the ESC key to unselect it, and the completion message should be shown after it.

### Template validation error parameter osProfile is not allowed

If you get an error message during template validation that the parameter 'osProfile' is not allowed, make sure you are using the correct versions of the APIs for these components:

- [Compute](https://docs.microsoft.com/azure-stack/user/azure-stack-profiles-azure-resource-manager-versions#microsoftcompute)
- [Network](https://docs.microsoft.com/azure-stack/user/azure-stack-profiles-azure-resource-manager-versions#microsoftnetwork)

To copy a VHD from Azure to Azure Stack, use [AzCopy 7.3.0](https://docs.microsoft.com/azure-stack/user/azure-stack-storage-transfer#download-and-install-azcopy). Work with your vendor to resolve issues with the image itself. For more information about the WALinuxAgent requirements for Azure Stack, see [Azure LinuX Agent](../operator/azure-stack-linux.md#azure-linux-agent).

### Deployment fails due to lack of external access
When deployment fails at stages where external access is required, an exception like the following example will be returned:

```
An error occurred while trying to test identity provider endpoints: System.Net.WebException: The operation has timed out.
   at Microsoft.PowerShell.Commands.WebRequestPSCmdlet.GetResponse(WebRequest request)
   at Microsoft.PowerShell.Commands.WebRequestPSCmdlet.ProcessRecord()at, <No file>: line 48 - 8/12/2018 2:40:08 AM
```
If this error occurs, make sure all minimum networking requirements have been met by reviewing the [deployment network traffic documentation](../operator/deployment-networking.md). A network checker tool is also available for partners as part of the Partner Toolkit.

Other deployment failures are typically due to problems connecting to resources on the Internet.

To verify connectivity to resources on the Internet, you can perform the following steps:

1. Open PowerShell.
2. Enter-PSSession to the WAS01 or any of the ERCs VMs.
3. Run the following cmdlet: 
   ```powershell
   Test-NetConnection login.windows.net -port 443
   ```

If this command fails, verify the TOR switch and any other network devices are configured to [allow network traffic](../operator/azure-stack-network.md).


## Virtual machines
### Default image and gallery item
A Windows Server image and gallery item must be added before deploying VMs in Azure Stack.

### After restarting my Azure Stack host, some VMs don't automatically start
After rebooting your host, you may notice Azure Stack services aren't immediately available. This is because Azure Stack [infrastructure VMs](asdk-architecture.md#virtual-machine-roles) and RPs take some time to check consistency, but will eventually start automatically.

You might also notice that tenant VMs don't automatically start after a reboot of the ASDK host. You can bring them online with a few manual steps:

1.  On the ASDK host, start **Failover Cluster Manager** from the Start Menu.
2.  Select the cluster **S-Cluster.azurestack.local**.
3.  Select **Roles**.
4.  Tenant VMs appear in a *saved* state. Once all Infrastructure VMs are running, right-click the tenant VMs and select **Start** to resume the VM.

### I've deleted some VMs, but still see the VHD files on disk 
This behavior is by design:

* When you delete a VM, VHDs aren't deleted. Disks are separate resources in the resource group.
* When a storage account gets deleted, the deletion is visible immediately through Azure Resource Manager, but the disks it may contain are still kept in storage until garbage collection runs.

If you see "orphan" VHDs, it's important to know if they're part of the folder for a storage account that was deleted. If the storage account wasn't deleted, it's normal that the VHDs remain.

You can read more about configuring the retention threshold and on-demand reclamation in [manage storage accounts](../operator/azure-stack-manage-storage-accounts.md).

## Storage
### Storage reclamation
It can take up to 14 hours for reclaimed capacity to show up in the portal. Space reclamation depends on various factors including usage percentage of internal container files in block blob store. Therefore, depending on how much data is deleted, there's no guarantee on the amount of space that could be reclaimed when garbage collector runs.

## Next steps
[Visit the Azure Stack support forum](https://social.msdn.microsoft.com/Forums/azure/home?forum=azurestack)
