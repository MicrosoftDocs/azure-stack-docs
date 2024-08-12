---
title: Release notes with known issues in Azure Stack HCI 2311 release (preview)
description: Read about the known issues and fixed issues in Azure Stack HCI 2311 releases (preview).
author: alkohli
ms.topic: conceptual
ms.date: 02/06/2024
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# View known issues in Azure Stack HCI 2311 release (preview)

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article identifies the critical known issues and their workarounds in Azure Stack HCI 2311 release.

The release notes are continuously updated, and as critical issues requiring a workaround are discovered, they're added. Before you deploy your Azure Stack HCI, carefully review the information contained in the release notes.

For more information about the new features in this release, see [What's new in 23H2](whats-new.md#features-and-improvements-in-2311).

[!INCLUDE [important](../includes/hci-preview.md)]

## Issues for version 2311

This software release maps to software version number **10.2311.0.26**. This release supports new deployments and updates from 2310.

Release notes for this version include the  issues fixed in this release,  known issues in this release, and release noted issues carried over from previous versions.

## Fixed issues

Here are the issues fixed in this release:

|Feature|Issue|
|------|------|
| Networking |Use of proxy isn't supported in this release. |
| Security <!--25420275--> |When using the `Get-AzsSyslogForwarder` cmdlet with `-PerNode` parameter, an exception is thrown. You aren't able to retrieve the `SyslogForwarder` configuration information of multiple nodes. |
| Deployment <!--25710482--> |During the deployment, Microsoft Open Cloud (MOC) Arc Resource Bridge installation fails with this error: Unable to find a resource that satisfies the requirement Size [0] Location [MocLocation].: OutOfCapacity\"\n". |
| Deployment <!--25624270-->|Entering an incorrect DNS updates the DNS configuration in hosts during the validation and the hosts can lose internet connectivity. |
| Deployment |Password for deployment user (also referred to as `AzureStackLCMUserCredential` during Active Directory prep) and local administrator can't include a `:`(colon).| 
| Arc VM management <!--25778815-->| Detaching a disk via the Azure CLI results in an error in this release. |
| Arc VM management <!--25628443/25635316-->| A resource group with multiple clusters only shows storage paths of one cluster.|
| Arc VM management <!--25527606--> | When you create the Azure Marketplace image on Azure Stack HCI, sometimes the download provisioning state doesn't match the download percentage on Azure Stack HCI cluster. The provisioning state is returned as succeeded while the download percentage is reported as less than 100.|
| Arc VM management <!--25661776--> |In this release, depending on your environment, the VM deployments on Azure Stack HCI system can take 30 to 45 minutes. |
| Arc VM management <!--25675277--> | While creating Arc VMs via the Azure CLI on Azure Stack HCI, if you provide the friendly name of marketplace image, an incorrect Azure Resource Manager ID is built and the VM creation errors out.|


## Known issues in this release

Here are the known issues in this release:

|Feature|Issue|Workaround/Comments|
|------|------|----------|
| Arc VM management <!--26100653--> |Deployment or update of Arc Resource Bridge could fail when the automatically generated SPN secret during this operation, starts with a hyphen.|Retry the deployment/update. The retry should regenerate the SPN secret and the operation will likely succeed.  |
| Arc VM management <!--X--> |Arc Extensions on Arc VMs stay in "Creating" state indefinitely. | Sign into the VM, open a command prompt, and type the following: <br> **Windows**: <br> `notepad C:\ProgramData\AzureConnectedMachineAgent\Config\agentconfig.json` <br> **Linux**: <br> `sudo vi /var/opt/azcmagent/agentconfig.json` <br>  Next, find the `resourcename` property. Delete the GUID that is appended to the end of the resource name, so this property matches the name of the VM. Then restart the VM.|
| Arc VM management <!--26066222--> |When a new server is added to an Azure Stack HCI cluster, storage path isn't created automatically for the newly created volume.| You can manually create a storage path for any new volumes. For more information, see [Create a storage path](./manage/create-storage-path.md).  |
| Arc VM management <!--X--> |Restart of Arc VM operation completes after approximately 20 minutes although the VM itself restarts in about a minute.| There's no known workaround in this release.  |
| Arc VM management <!--26084213--> |In some instances, the status of the logical network shows as Failed in Azure portal. This occurs when you try to delete the logical network without first deleting any resources such as network interfaces associated with that logical network. <br>You should still be able to create resources on this logical network. The status is misleading in this instance.| If the status of this logical network was *Succeeded* at the time when this network was provisioned, then you can continue to create resources on this network.  |
| Arc VM management <!--26201356--> |In this release, when you update a VM with a data disk attached to it using the Azure CLI, the operation fails with the following error message: <br> *Couldn't find a virtual hard disk with the name*.| Use the Azure portal for all the VM update operations. For more information, see [Manage Arc VMs](./manage/manage-arc-virtual-machines.md) and [Manage Arc VM resources](./manage/manage-arc-virtual-machine-resources.md).  |
| Deployment <!--25963746--> |Before you update 2310 to 2311 software, make sure to run the following cmdlets on one of your Azure Stack HCI nodes: <br>`Import-module C:\CloudDeployment\CloudDeployment.psd1`<br>`Import-module C:\CloudDeployment\ECEngine\EnterpriseCloudEngine.psd1`</br><br>`$Parameters = Get-EceInterfaceParameters -RolePath 'MocArb' -InterfaceName 'DeployPreRequisites'`</br><br>`$cloudRole = $Parameters.Roles["Cloud"].PublicConfiguration`</br><br>`$domainRole = $Parameters.Roles["Domain"].PublicConfiguration`</br><br>`$securityInfo = $cloudRole.PublicInfo.SecurityInfo`</br><br>`$cloudSpUser = $securityInfo.AADUsers.User` \| `Where-Object Role -EQ "DefaultARBApplication"`</br><br>`$cloudSpCred = $Parameters.GetCredential($cloudSpUser.Credential)`</br><br>`Set-ECEServiceSecret -ContainerName "DefaultARBApplication" -Credential $cloudSpCred`|This script helps migrate the service principal.  |
| Deployment <!--26039020--> |There's a sporadic heartbeat reliability issue in this release due to which the registration encounters the error: HCI registration failed. Error: Arc integration failed. |This issue is intermittent. Try rerunning the deployment. For more information, see [Rerun the deployment](./deploy//deploy-via-portal.md#rerun-deployment).   |
| Deployment <!--26088401--> |There's an intermittent issue in this release where the Arc integration validation fails with this error: Validator failed. Can't retrieve the dynamic parameters for the cmdlet. PowerShell Gallery is currently unavailable.  Please try again later. |This issue is intermittent. Try rerunning the deployment. For more information, see [Rerun the deployment](./deploy/deploy-via-portal.md#rerun-deployment).   |
|Deployment <!--27183567--> |The AzureEdgeRemoteSupport extension shows as "Failed" in the cluster view and "Succeeded" in the node view. Additionally, the node view displays an incorrect extension name, "AzureEdgeEdgeRemoteSupport". | This issue is cosmetic and doesn't impact extension functionality. You may want to follow these steps to manually mitigate the issue: </br><br> 1. In the Azure portal, navigate to the resource group for your nodes.</br><br> 2. Go to each Arc node and uninstall the Remote Support extension. </br><br> 3. Allow up to 12 hours for the Azure Stack HCI Resource Provider to update the extensions. </br><br> This procedure enables the reinstallation of the extension, ensuring it displays the correct name, AzureEdgeRemoteSupport, and resolves any failures observed in the cluster view. </br><br> Optionally, you can use the cmdlet `sync-azurestackhci` to force a sync on any of the cluster nodes.|
| Update <!----> |In rare instances, you may encounter this error while updating your Azure Stack HCI: Type 'UpdateArbAndExtensions' of Role 'MocArb' raised an exception: Exception Upgrading ARB and Extension in step [UpgradeArbAndExtensions :Get-ArcHciConfig] UpgradeArb: Invalid applianceyaml = [C:\AksHci\hci-appliance.yaml].  |If you see this issue, contact Microsoft Support to assist you with the next steps.   |
| Update <!--26176875--> | When you try to change your AzureStackLCMUserPassword using command: `Set-AzureStackLCMUserPassword`, you might encounter this error: </br></br> *Cannot find an object with identity: 'object id'*.| There's no known workaround in this release. |
|Update <!----> |In this release, there's a health check issue preventing a single server running Azure Stack HCI from being updated via the Azure portal. | Use PowerShell to perform your update. For more information, see [Update your Azure Stack HCI, version 23H2 via PowerShell](./update/update-via-powershell-23h2.md). |
|Update <!--26426548--> | When you update from the 2311 build to Azure Stack HCI 23H2, the update health checks stop reporting in the Azure portal after the update reaches the Install step. | Microsoft is actively working to resolve this issue, and there's no action required on your part. Although the health checks aren't visible in the portal, they're still running and completing as expected.|
| Add server and repair server <!--26154450--> | In this release, add server and repair server scenarios might fail with the following error: </br></br> *CloudEngine.Actions.InterfaceInvocationFailedException: Type 'AddNewNodeConfiguration' of Role 'BareMetal' raised an exception: The term 'Trace-Execution' isn't recognized as the name of a cmdlet, function, script file, or operable program*. | Follow these steps to work around this error: </br></br> 1. Create a copy of the required PowerShell modules on the new node. </br></br> 2. Connect to a node on your Azure Stack HCI system. </br></br> 3. Run the following PowerShell cmdlet: </br></br> Copy-Item "C:\Program Files\WindowsPowerShell\Modules\CloudCommon" "\\newserver\c$\\Program Files\WindowsPowerShell\Modules\CloudCommon" -recursive </br></br> For more information, see [Prerequisite for add and repair server scenarios](../hci/manage/add-server.md#software-prerequisites). |


## Known issues from previous releases

Here are the known issues from previous releases:


|Feature  |Issue  |Workaround  |
|---------|---------|---------|
| Networking <!--24524483--> |There's an infrequent DNS client issue in this release that causes the deployment to fail on a two-node cluster with a DNS resolution error: *A WebException occurred while sending a RestRequest. WebException.Status: NameResolutionFailure.* As a result of the bug, the DNS record of the second node is deleted soon after it's created resulting in a DNS error. |Restart the server. This operation registers the DNS record, which prevents it from getting deleted. |
| Azure portal <!--25741164--> |In some instances, the Azure portal might take a while to update and the view might not be current.| You might need to wait for 30 minutes or more to see the updated view. |
| Arc VM management |Deleting a network interface on an Arc VM from Azure portal doesn't work in this release.| Use the Azure CLI to first remove the network interface and then delete it. For more information, see [Remove the network interface](/cli/azure/stack-hci-vm/nic#az-stack-hci-vm-nic-remove) and see [Delete the network interface](/cli/azure/stack-hci-vm/network/nic#az-stack-hci-vm-network-nic-delete).|
| Arc VM management| When you create a disk or a network interface in this release with underscore in the name, the operation fails.  |Make sure to not use underscore in the names for disks or network interfaces. |
| Deployment |Providing the OU name in an incorrect syntax isn't detected in the Azure portal. The incorrect syntax is however detected at a later step during cluster validation. |There's no known workaround in this release. |
| Deployment <!--25717459-->|On server hardware, a USB network adapter is created to access the Baseboard Management Controller (BMC). This adapter can cause the cluster validation to fail during the deployment.| Make sure to disable the BMC network adapter before you begin cloud deployment.|
| Deployment |A new storage account is created for each run of the deployment. Existing storage accounts aren't supported in this release.| |
| Deployment |A new key vault is created for each run of the deployment. Existing key vaults aren't supported in this release.| |
| Deployment |In some instances, running the [Arc registration script](./deploy/deployment-arc-register-server-permissions.md#register-servers-with-azure-arc) doesn't install the mandatory extensions, Azure Edge device Management or Azure Edge Lifecycle Manager. |The workaround is to run the script again and make sure that all the mandatory extensions are installed before you [Deploy via Azure portal](./deploy/deploy-via-portal.md). |
| Deployment |The first deployment step: **Before Cloud Deployment** when [Deploying via Azure portal](./deploy/deploy-via-portal.md) can take from 45 minutes to an hour to complete.| |
| Deployment |The network direct intent overrides defined on the template aren't working in this release.|Use the Azure Resource Manager template to override this parameter and disable RDMA for the intents. |
| Deployment |Deployments via Azure Resource Manager time out after 2 hours. Deployments that exceed 2 hours show up as failed in the resource group though the cluster is successfully created.| To monitor the deployment in the Azure portal, go to the Azure Stack HCI cluster resource and then go to new **Deployments** entry. |
| Deployment |If you select **Review + Create** and you haven't filled out all the tabs, the deployment begins and then eventually fails.|There's no known workaround in this release. |
| Deployment | This issue is seen if an incorrect subscription or resource group was used during registration. When you register the server a second time with Arc, the **Azure Edge Lifecycle Manager** extension fails during the registration, but the extension state is reported as **Ready**. | Before you run the registration the second time:<br><br>Make sure to delete the following folders from your server(s): `C:\ecestore`, `C:\CloudDeployment`, and `C:\nugetstore`.<br>Delete the registry key using the  PowerShell cmdlet:<br>`Remove-Item HKLM:\Software\Microsoft\LCMAzureStackStampInformation` |
| Azure Site Recovery |Azure Site Recovery can't be installed on an Azure Stack HCI cluster in this release. |There's no known workaround in this release. |
| Update <!--X-->| When updating the Azure Stack HCI cluster via the Azure Update Manager, the update progress and results might not be visible in the Azure portal.| To work around this issue, on each cluster node, add the following registry key (no value needed):<br><br>`New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\HciCloudManagementSvc\Parameters" -force`</br><br> Then on one of the cluster nodes, restart the Cloud Management cluster group. </br><br>`Stop-ClusterGroup "Cloud Management"`</br><br>`Start-ClusterGroup "Cloud Management"`</br><br> This won't fully remediate the issue as the progress details might still not be displayed for a duration of the update process. To get the latest update details, you can [Retrieve the update progress with PowerShell](./update/update-via-powershell-23h2.md#step-4-download-check-readiness-and-install-updates). |


## Next steps

- Read the [Deployment overview](./deploy/deployment-introduction.md).
