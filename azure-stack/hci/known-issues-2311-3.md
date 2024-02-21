---
title: Release notes with fixed and known issues in Azure Stack HCI 2311.3 GA release
description: Read about the known issues and fixed issues in Azure Stack HCI 2311 General Availability (GA) release.
author: ronmiab
ms.topic: conceptual
ms.date: 02/14/2024
ms.author: robess
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# View known issues in Azure Stack HCI 2311.3 General Availability release

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article identifies the critical known issues and their workarounds in Azure Stack HCI 2311.3 General Availability (GA) release.

The release notes are continuously updated, and as critical issues requiring a workaround are discovered, they're added. Before you deploy your Azure Stack HCI, carefully review the information contained in the release notes.

> [!IMPORTANT]
> The production workloads are only supported on the Azure Stack HCI systems running the generally available 2311.3 release. To run the GA version, you need to start with a new 2311 deployment and then update to 2311.3. <!-- Verify if customer needs to go from 2311.2 to 2311.3 -->

For more information about the new features in this release, see [What's new in 23H2](whats-new.md).

## Issues for version 2311.3

This software release maps to software version number **10.2311.3.7** <!-- Verify the version number -->. This release only supports updates from 2311 release.

Release notes for this version include the issues fixed in this release, known issues in this release, and release noted issues carried over from previous versions.

## Fixed issues

Here are the issues fixed in this release:

|Feature|Issue|Workaround/Comments|
|------|------|-------|
| Deployment |The first deployment step: **Before Cloud Deployment** when [Deploying via Azure portal](./deploy/deploy-via-portal.md) can take from 45 minutes to an hour to complete.| |
| Deployment <!--26039020--> |There is a sporadic heartbeat reliability issue in this release due to which the registration encounters the error: HCI registration failed. Error: Arc integration failed. |TThis issue is transient and hasn't been identified in this latest release. If you encounter this issue try rerunning the deployment. For more information, see [Rerun the deployment](./deploy//deploy-via-portal.md#rerun-deployment).   |
| Deployment <!--26088401--> |There is an intermittent issue in this release where the Arc integration validation fails with this error: Validator failed. Cannot retrieve the dynamic parameters for the cmdlet. PowerShell Gallery is currently unavailable.  Please try again later. |This issue is transient and hasn't been identified in this latest release. If you encounter this issue try rerunning the deployment. For more information, see [Rerun the deployment](./deploy/deploy-via-portal.md#rerun-deployment).   |

<!-- add new content -->

## Known issues in this release

Here are the known issues in this release:

|Feature|Issue|Workaround/Comments|
|------|------|----------|

<!-- add new content -->

## Known issues from previous releases

Here are the known issues from previous releases:

|Feature  |Issue  |Workaround  |
|---------|---------|---------|
| Arc VM management <!--26100653--> |Deployment or update of Arc Resource Bridge could fail when the automatically generated temporary SPN secret during this operation, starts with a hyphen.|Retry the deployment/update. The retry should regenerate the SPN secret and the operation will likely succeed.  |
| Arc VM management <!--X--> |Arc Extensions on Arc VMs stay in "Creating" state indefinitely. | Log in to the VM, open a command prompt, and type the following: <br> **Windows**: <br> `notepad C:\ProgramData\AzureConnectedMachineAgent\Config\agentconfig.json` <br> **Linux**: <br> `sudo vi /var/opt/azcmagent/agentconfig.json` <br>  Next, find the `resourcename` property. Delete the GUID that is appended to the end of the resource name, so this property matches the name of the VM. Then restart the VM.|
| Arc VM management <!--26066222--> |When a new server is added to an Azure Stack HCI cluster, storage path is not created automatically for the newly created volume.| You can manually create a storage path for any new volumes. For more information, see [Create a storage path](./manage/create-storage-path.md).  |
| Arc VM management <!--X--> |Restart of Arc VM operation completes after approximately 20 minutes although the VM itself restarts in about a minute.| There's no known workaround in this release.  |
| Arc VM management <!--26084213--> |In some instances, the status of the logical network shows as Failed in Azure portal. This occurs when you try to delete the logical network without first deleting any resources such as network interfaces associated with that logical network. <br>You should still be able to create resources on this logical network. The status is misleading in this instance.| If the status of this logical network was *Succeeded* at the time when this network was provisioned, then you can continue to create resources on this network.  |
| Arc VM management <!--26201356--> |In this release, when you update a VM with a data disk attached to it using the Azure CLI, the operation fails with the following error message: <br> *Couldn't find a virtual hard disk with the name*.| Use the Azure portal for all the VM update operations. For more information, see [Manage Arc VMs](./manage/manage-arc-virtual-machines.md) and [Manage Arc VM resources](./manage/manage-arc-virtual-machine-resources.md).  |
| Update <!----> |In rare instances, you may encounter this error while updating your Azure Stack HCI: Type 'UpdateArbAndExtensions' of Role 'MocArb' raised an exception: Exception Upgrading ARB and Extension in step [UpgradeArbAndExtensions :Get-ArcHciConfig] UpgradeArb: Invalid applianceyaml = [C:\AksHci\hci-appliance.yaml].  |If you see this issue, contact Microsoft Support to assist you with the next steps.   |
| Update <!--26176875--> | When you try to change your AzureStackLCMUserPassword using command: `Set-AzureStackLCMUserPassword`, you might encounter this error: </br></br> *Cannot find an object with identity: 'object id'*.| There's no known workaround in this release. |
| Networking <!--24524483--> |There is an infrequent DNS client issue in this release that causes the deployment to fail on a two-node cluster with a DNS resolution error: *A WebException occurred while sending a RestRequest. WebException.Status: NameResolutionFailure.* As a result of the bug, the DNS record of the second node is deleted soon after it is created resulting in a DNS error. |Restart the server. This operation registers the DNS record which prevents it from getting deleted. |
| Azure portal <!--25741164--> |In some instances, the Azure portal might take a while to update and the view might not be current.| You might need to wait for 30 minutes or more to see the updated view. |
| Arc VM management |Deleting a network interface on an Arc VM from Azure portal doesn't work in this release.| Use the Azure CLI to first remove the network interface and then delete it. For more information, see [Remove the network interface](/cli/azure/stack-hci-vm/nic#az-stack-hci-vm-nic-remove) and see [Delete the network interface](/cli/azure/stack-hci-vm/network/nic#az-stack-hci-vm-network-nic-delete).|
| Arc VM management| When you create a disk or a network interface in this release with underscore in the name, the operation fails.  |Make sure to not use underscore in the names for disks or network interfaces. |
| Deployment |Providing the OU name in an incorrect syntax isn't detected in the Azure portal. The incorrect syntax is however detected at a later step during cluster validation. |There's no known workaround in this release. |
| Deployment |In some instances, running the [Arc registration script](./deploy/deployment-arc-register-server-permissions.md#register-servers-with-azure-arc) doesn't install the mandatory extensions, Azure Edge device Management or Azure Edge Lifecycle Manager. |The workaround is to run the script again and make sure that all the mandatory extensions are installed before you [Deploy via Azure portal](./deploy/deploy-via-portal.md). |
| Deployment |Deployments via Azure Resource Manager time out after 2 hours. Deployments that exceed 2 hours show up as failed in the resource group though the cluster is successfully created.| To monitor the deployment in the Azure portal, go to the Azure Stack HCI cluster resource and then go to new **Deployments** entry. |
| Azure Site Recovery |Azure Site Recovery can't be installed on an Azure Stack HCI cluster in this release. |There's no known workaround in this release. |
| Update <!--X-->| When updating the Azure Stack HCI cluster via the Azure Update Manager, the update progress and results may not be visible in the Azure portal.| To work around this issue, on each cluster node, add the following registry key (no value needed):<br><br>`New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\HciCloudManagementSvc\Parameters" -force`</br><br> Then on one of the cluster nodes, restart the Cloud Management cluster group. </br><br>`Stop-ClusterGroup "Cloud Management"`</br><br>`Start-ClusterGroup "Cloud Management"`</br><br> This won't fully remediate the issue as the progress details may still not be displayed for a duration of the update process. To get the latest update details, you can [Retrieve the update progress with PowerShell](./update/update-via-powershell-23h2.md#step-4-download-check-readiness-and-install-updates). |



## Next steps

- Read the [Deployment overview](./deploy/deployment-introduction.md).
