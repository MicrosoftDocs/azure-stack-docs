---
title: Release notes with fixed and known issues in Azure Stack HCI 2311.2 GA release
description: Read about the known issues and fixed issues in Azure Stack HCI 2311 General Availability (GA) release.
author: alkohli
ms.topic: conceptual
ms.date: 02/26/2024
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# View known issues in Azure Stack HCI 2311.2 General Availability release

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article identifies the critical known issues and their workarounds in Azure Stack HCI 2311.2 General Availability (GA) release.

The release notes are continuously updated, and as critical issues requiring a workaround are discovered, they're added. Before you deploy your Azure Stack HCI, carefully review the information contained in the release notes.

> [!IMPORTANT]
> The production workloads are only supported on the Azure Stack HCI systems running the generally available 2311.2 release. To run the GA version, you need to start with a new 2311 deployment and then update to 2311.2.

For more information about the new features in this release, see [What's new in 23H2](whats-new.md).

## Issues for version 2311.2

This software release maps to software version number **10.2311.2.7**. This release only supports updates from 2311 release.

Release notes for this version include the issues fixed in this release, known issues in this release, and release noted issues carried over from previous versions.

## Fixed issues

Here are the issues fixed in this release:

|Feature|Issue|Workaround/Comments|
|------|------|-------|
| Add server and repair server <!--26154450--> | In this release, add server and repair server scenarios might fail with the following error: </br></br> *CloudEngine.Actions.InterfaceInvocationFailedException: Type 'AddNewNodeConfiguration' of Role 'BareMetal' raised an exception: The term 'Trace-Execution' is not recognized as the name of a cmdlet, function, script file, or operable program*. | Follow these steps to work around this error: </br></br> 1. Create a copy of the required PowerShell modules on the new node.</br></br> 2. Connect to a node on your Azure Stack HCI system.</br></br> 3. Run the following PowerShell cmdlet: </br></br> Copy-Item "C:\Program Files\WindowsPowerShell\Modules\CloudCommon" "\\newserver\c$\\Program Files\WindowsPowerShell\Modules\CloudCommon" -recursive </br></br> For more information, see [Prerequisite for add and repair server scenarios](../hci/manage/add-server.md#software-prerequisites). |
| Deployment <!--25963746--> |When you update 2310 to 2311 software, the service principal doesn't migrate.| If you encounter an issue with the software, use PowerShell to migrate the service principal.  |
| Deployment |If you select **Review + Create** and you haven't filled out all the tabs, the deployment begins and then eventually fails.|There's no known workaround in this release. |
| Deployment | This issue is seen if an incorrect subscription or resource group was used during registration. When you register the server a second time with Arc, the **Azure Edge Lifecycle Manager** extension fails during the registration, but the extension state is reported as **Ready**. | Before you run the registration the second time:<br><br>Make sure to delete the following folders from your servers: `C:\ecestore`, `C:\CloudDeployment`, and `C:\nugetstore`.<br>Delete the registry key using the  PowerShell cmdlet:<br>`Remove-Item HKLM:\Software\Microsoft\LCMAzureStackStampInformation` |
| Deployment |A new storage account is created for each run of the deployment. Existing storage accounts aren't supported in this release.| |
| Deployment |A new key vault is created for each run of the deployment. Existing key vaults aren't supported in this release.| |
| Deployment <!--25717459-->|On server hardware, a USB network adapter is created to access the Baseboard Management Controller (BMC). This adapter can cause the cluster validation to fail during the deployment.| Make sure to disable the BMC network adapter before you begin cloud deployment.|
| Deployment |The network direct intent overrides defined on the template aren't working in this release.|Use the Azure Resource Manager template to override this parameter and disable RDMA for the intents. |

## Known issues in this release

Here are the known issues in this release:

|Feature|Issue|Workaround/Comments|
|------|------|----------|
| Update <!--NA--> |In this release, if you run the `Test-CauRun` cmdlet before actually applying the 2311.2 update, you see an error message regarding a missing firewall rule to remotely shut down the Azure Stack HCI system.  | No action is required on your part as the missing rule is automatically created when 2311.2 updates are applied. <br><br>When applying future updates, make sure to run the `Test-EnvironmentReadiness` cmdlet instead of `Test-CauRun`. For more information, see [Step 2: Optionally validate system health](./update/update-via-powershell-23h2.md#step-2-optionally-validate-system-health).|
| Updates <!--26659591--> |In rare instances, if a failed update is stuck in an *In progress* state in Azure Update Manager, the **Try again** button is disabled. | To resume the update, run the following PowerShell command:<br>`Get-SolutionUpdate`\|`Start-SolutionUpdate`.|
| Updates <!--26659432--> |In some cases, `SolutionUpdate` commands could fail if run after the `Send-DiagnosticData` command.  | Make sure to close the PowerShell session used for `Send-DiagnosticData`. Open a new PowerShell session and use it for `SolutionUpdate` commands.|
| Updates <!--26417221--> |In very rare instances, when applying an update from 2311.0.24 to 2311.2.4, cluster status reports *In Progress* instead of expected *Failed to update*.   | Retry the update. If the issue persists, contact Microsoft Support.|
| Arc VM management <!--26423941--> |If the resource group used to deploy an Arc VM on your Azure Stack HCI has an underscore in the name, the guest agent installation will fail. As a result, you won't be able to enable guest management. | Make sure that there are no underscores in the resource groups used to deploy Arc VMs.|
| Cluster aware updating <!--26411980--> |Resume node operation failed to resume node. | This is a transient issue and could resolve on its own. Wait for a few minutes and retry the operation. If the issue persists, contact Microsoft Support.|
| Cluster aware updating <!--26346755--> |Suspend node operation was stuck for greater than 90 minutes. | This is a transient issue and could resolve on its own. Wait for a few minutes and retry the operation. If the issue persists, contact Microsoft Support.|

## Known issues from previous releases

Here are the known issues from previous releases:

|Feature  |Issue  |Workaround  |
|---------|---------|---------|
| Arc VM management <!--26100653--> |Deployment or update of Arc Resource Bridge could fail when the automatically generated temporary SPN secret during this operation, starts with a hyphen.|Retry the deployment/update. The retry should regenerate the SPN secret and the operation will likely succeed.  |
| Arc VM management <!--X--> |Arc Extensions on Arc VMs stay in "Creating" state indefinitely. | Log in to the VM, open a command prompt, and type the following: <br> **Windows**: <br> `notepad C:\ProgramData\AzureConnectedMachineAgent\Config\agentconfig.json` <br> **Linux**: <br> `sudo vi /var/opt/azcmagent/agentconfig.json` <br>  Next, find the `resourcename` property. Delete the GUID that is appended to the end of the resource name, so this property matches the name of the VM. Then restart the VM.|
| Arc VM management <!--26066222--> |When a new server is added to an Azure Stack HCI cluster, storage path isn't created automatically for the newly created volume.| You can manually create a storage path for any new volumes. For more information, see [Create a storage path](./manage/create-storage-path.md).  |
| Arc VM management <!--X--> |Restart of Arc VM operation completes after approximately 20 minutes although the VM itself restarts in about a minute.| There's no known workaround in this release.  |
| Arc VM management <!--26084213--> |In some instances, the status of the logical network shows as Failed in Azure portal. This occurs when you try to delete the logical network without first deleting any resources such as network interfaces associated with that logical network. <br>You should still be able to create resources on this logical network. The status is misleading in this instance.| If the status of this logical network was *Succeeded* at the time when this network was provisioned, then you can continue to create resources on this network.  |
| Arc VM management <!--26201356--> |In this release, when you update a VM with a data disk attached to it using the Azure CLI, the operation fails with the following error message: <br> *Couldn't find a virtual hard disk with the name*.| Use the Azure portal for all the VM update operations. For more information, see [Manage Arc VMs](./manage/manage-arc-virtual-machines.md) and [Manage Arc VM resources](./manage/manage-arc-virtual-machine-resources.md).  |
| Deployment <!--26039020--> |There's a sporadic heartbeat reliability issue in this release due to which the registration encounters the error: HCI registration failed. Error: Arc integration failed. |This issue is intermittent. Try rerunning the deployment. For more information, see [Rerun the deployment](./deploy//deploy-via-portal.md#rerun-deployment).   |
| Deployment <!--26088401--> |There's an intermittent issue in this release where the Arc integration validation fails with this error: Validator failed. Cannot retrieve the dynamic parameters for the cmdlet. PowerShell Gallery is currently unavailable.  Please try again later. |This issue is intermittent. Try rerunning the deployment. For more information, see [Rerun the deployment](./deploy/deploy-via-portal.md#rerun-deployment).   |
|Deployment <!--27183567--> |The AzureEdgeRemoteSupport extension shows as "Failed" in the cluster view and "Succeeded" in the node view. Additionally, the node view displays an incorrect extension name, "AzureEdgeEdgeRemoteSupport". | This issue is cosmetic and doesn't impact extension functionality. You may want to follow these steps to manually mitigate the issue: </br><br> 1. In the Azure portal, navigate to the resource group for your nodes.</br><br> 2. Go to each Arc node and uninstall the Remote Support extension. </br><br> 3. Allow up to 12 hours for the Azure Stack HCI Resource Provider to update the extensions. </br><br> This procedure enables the reinstallation of the extension, ensuring it displays the correct name, AzureEdgeRemoteSupport, and resolves any failures observed in the cluster view. </br><br> Optionally, you can use the cmdlet `sync-azurestackhci` to force a sync on any of the cluster nodes.|
| Update <!----> |In rare instances, you may encounter this error while updating your Azure Stack HCI: Type 'UpdateArbAndExtensions' of Role 'MocArb' raised an exception: Exception Upgrading ARB and Extension in step [UpgradeArbAndExtensions :Get-ArcHciConfig] UpgradeArb: Invalid applianceyaml = [C:\AksHci\hci-appliance.yaml].  |If you see this issue, contact Microsoft Support to assist you with the next steps.   |
| Update <!--26176875--> | When you try to change your AzureStackLCMUserPassword using command: `Set-AzureStackLCMUserPassword`, you might encounter this error: </br></br> *Cannot find an object with identity: 'object id'*.| If the issue occurs, contact Microsoft Support for next steps.  |
|Update <!----> |In this release, there's a health check issue preventing a single server running Azure Stack HCI from being updated via the Azure portal. | Use PowerShell to perform your update. For more information, see [Update your Azure Stack HCI, version 23H2 via PowerShell](./update/update-via-powershell-23h2.md). |
| Networking <!--24524483--> |There's an infrequent DNS client issue in this release that causes the deployment to fail on a two-node cluster with a DNS resolution error: *A WebException occurred while sending a RestRequest. WebException.Status: NameResolutionFailure.* As a result of the bug, the DNS record of the second node is deleted soon after it's created resulting in a DNS error. |Restart the server. This operation registers the DNS record, which prevents it from getting deleted. |
| Azure portal <!--25741164--> |In some instances, the Azure portal might take a while to update and the view might not be current.| You might need to wait for 30 minutes or more to see the updated view. |
| Arc VM management |Deleting a network interface on an Arc VM from Azure portal doesn't work in this release.| Use the Azure CLI to first remove the network interface and then delete it. For more information, see [Remove the network interface](/cli/azure/stack-hci-vm/nic#az-stack-hci-vm-nic-remove) and see [Delete the network interface](/cli/azure/stack-hci-vm/network/nic#az-stack-hci-vm-network-nic-delete).|
| Arc VM management| When you create a disk or a network interface in this release with underscore in the name, the operation fails.  |Make sure to not use underscore in the names for disks or network interfaces. |
| Deployment |Providing the OU name in an incorrect syntax isn't detected in the Azure portal. The incorrect syntax is however detected at a later step during cluster validation. |There's no known workaround in this release. |
| Deployment |In some instances, running the [Arc registration script](./deploy/deployment-arc-register-server-permissions.md#register-servers-with-azure-arc) doesn't install the mandatory extensions, Azure Edge device Management or Azure Edge Lifecycle Manager. |Run the script again and make sure that all the mandatory extensions are installed before you [Deploy via Azure portal](./deploy/deploy-via-portal.md). |
| Deployment |The first deployment step: **Before Cloud Deployment** when [Deploying via Azure portal](./deploy/deploy-via-portal.md) can take from 45 minutes to an hour to complete.| |
| Deployment |Deployments via Azure Resource Manager time out after 2 hours. Deployments that exceed 2 hours show up as failed in the resource group though the cluster is successfully created.| To monitor the deployment in the Azure portal, go to the Azure Stack HCI cluster resource and then go to new **Deployments** entry. |
| Azure Site Recovery |Azure Site Recovery can't be installed on an Azure Stack HCI cluster in this release. |There's no known workaround in this release. |
| Update <!--X-->| When updating the Azure Stack HCI cluster via the Azure Update Manager, the update progress and results may not be visible in the Azure portal.| To work around this issue, on each cluster node, add the following registry key (no value needed):<br><br>`New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\HciCloudManagementSvc\Parameters" -force`</br><br> Then on one of the cluster nodes, restart the Cloud Management cluster group. </br><br>`Stop-ClusterGroup "Cloud Management"`</br><br>`Start-ClusterGroup "Cloud Management"`</br><br> This won't fully remediate the issue as the progress details may still not be displayed for a duration of the update process. To get the latest update details, you can [Retrieve the update progress with PowerShell](./update/update-via-powershell-23h2.md#step-4-download-check-readiness-and-install-updates). |





## Next steps

- Read the [Deployment overview](./deploy/deployment-introduction.md).
