---
title: Release notes with fixed and known issues in Azure Local previous releases - version 23xx
description: Read about the known issues and fixed issues in Azure Local previous releases - version 23xx.
author: alkohli
ms.topic: troubleshooting-general
ms.date: 02/11/2026
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: hyperconverged
---

# Known issues in Azure Local previous releases - version 23xx

This article identifies critical known issues and their workarounds in Azure Local previous releases - version 23xx.

> [!NOTE]
> Azure Local previous releases - version 23xx are not in a supported state. For more information, see [Azure Local release information](../release-information-23h2.md).

## Issues for version 2311.5

This software release maps to software version number **10.2311.5.6**. This release only supports updates from 2311 release.

Release notes for this version include the issues fixed in this release, known issues in this release, and release noted issues carried over from previous versions.

### Fixed issues

Here are the fixed issues in this release:

|Feature  |Issue  |Workaround/Comments  |
|---------|-------|------------|
| Azure Local VM management <!--26084213--> |In some instances, the status of the logical network shows as Failed in Azure portal. This occurs when you try to delete the logical network without first deleting any resources such as network interfaces associated with that logical network. <br>You should still be able to create resources on this logical network. The status is misleading in this instance.| This issue is now fixed.  |

### Known issues in this release

Here are the known issues in this release:

|Feature  |Issue  |Workaround/Comments  |
|---------|------------------|----------|
|Update <!--27176454-->|Download operations don't terminate after the specified timeout of 6 hours. |Microsoft is actively working to resolve this issue. If you encounter this issue, contact Microsoft Support for next steps.|
|Update <!--27210359-->|Update is in Failed state: DownloadFailed. Summary XML from ECE not present. |Microsoft is actively working to resolve this issue. If you encounter this issue, contact Microsoft Support for next steps.|

### Known issues from previous releases

Here are the known issues from previous releases:

|Feature  |Issue  |Workaround/Comments  |
|---------|---------|---------|
| Azure Local VM management <!--27229189--> |When a new node is added into the cluster, it fails with: Node add failed at ERROR: An older version of the Azure Local VM cluster extension is installed on your cluster. |Make sure you have the latest firewall requirements including endpoint `https://hciarcvmscontainerregistry.azurecr.io` on port 443. This endpoint is required for Azure Local VM container registry. |
|Azure Local VM management <!--27197239--> |When you update to 10.2311.4.5, the arcbridge status shows "UpgradeFailed" on the Azure portal. |Make sure you have the latest firewall requirements including endpoint `https://hciarcvmscontainerregistry.azurecr.io` on port 443. This endpoint is required for Azure Local VM container registry.  |
| Deployment <!--26039020 could not reproduce--> |There's a sporadic heartbeat reliability issue in this release due to which the registration encounters the error: HCI registration failed. Error: Arc integration failed. |This issue is intermittent. Try rerunning the deployment. For more information, see [Rerun the deployment](../deploy/deploy-via-portal.md#resume-deployment).   |
| Deployment <!--26088401 could not reproduce--> |There's an intermittent issue in this release where the Arc integration validation fails with this error: ```Validator failed. Can't retrieve the dynamic parameters for the cmdlet. PowerShell Gallery is currently unavailable.  Please try again later.``` |This issue is intermittent. Try rerunning the deployment. For more information, see [Rerun the deployment](../deploy/deploy-via-portal.md#resume-deployment).   |
|Deployment <!--27183567--> |The AzureEdgeRemoteSupport extension shows as "Failed" in the cluster view and "Succeeded" in the node view. Additionally, the node view displays an incorrect extension name, "AzureEdgeRemoteSupport". | This issue is cosmetic and doesn't impact extension functionality. You may want to follow these steps to manually mitigate the issue: </br><br> 1. In the Azure portal, navigate to the resource group for your nodes.</br><br> 2. Go to each Arc node and uninstall the Remote Support extension. </br><br> 3. Allow up to 12 hours for the Azure Local Resource Provider to update the extensions. </br><br> This procedure enables the reinstallation of the extension, ensuring it displays the correct name, AzureEdgeRemoteSupport, and resolves any failures observed in the cluster view. </br><br> Optionally, you can use the cmdlet `sync-azurestackhci` to force a sync on any of the cluster nodes.|
|Update <!----> |In this release, there's a health check issue preventing a single server running Azure Local from being updated via the Azure portal. | Use PowerShell to perform your update. For more information, see [Update your Azure Local via PowerShell](../update/update-via-powershell-23h2.md). |
| Azure portal <!--25741164--> |In some instances, the Azure portal might take a while to update and the view might not be current.| You might need to wait for 30 minutes or more to see the updated view. |
| Deployment |In some instances, running the [Arc registration script](../deploy/deployment-arc-register-server-permissions.md) doesn't install the mandatory extensions, Azure Edge device Management or Azure Edge Lifecycle Manager. |The workaround is to run the script again and make sure that all the mandatory extensions are installed before you [Deploy via Azure portal](../deploy/deploy-via-portal.md). |
| Deployment |The first deployment step: **Before Cloud Deployment** when [Deploying via Azure portal](../deploy/deploy-via-portal.md) can take from 45 minutes to an hour to complete.| |

## Issues for version 2311.4

This software release maps to software version number **10.2311.4.6**. This release only supports updates from 2311 release.

Release notes for this version include the issues fixed in this release, known issues in this release, and release noted issues carried over from previous versions.

### Fixed issues

Here are the fixed issues in this release:

|Feature  |Issue  |Workaround/Comments  |
|---------|-------|------------|
| Azure Local VM management| When you create a disk or a network interface in this release with underscore in the name, the operation fails.  |Make sure to not use underscore in the names for disks or network interfaces. |
| Azure Local VM management <!--26423941--> |If the resource group used to deploy an Azure Local VM on your Azure Local  has an underscore in the name, the guest agent installation fails. As a result, you won't be able to enable guest management. | Make sure that there are no underscores in the resource groups used to deploy Azure Local VMs.|

### Known issues in this release

Here are the known issues in this release:

|Feature  |Issue  |Workaround/Comments  |
|---------|---------|---------|
| Azure Local VM management <!--27229189--> |When a new node is added into the cluster, it fails with: Node add failed at ERROR: An older version of the Azure Local VM cluster extension is installed on your cluster. |Make sure you have the latest firewall requirements including endpoint `https://hciarcvmscontainerregistry.azurecr.io` on port 443. This endpoint is required for Azure Local VM container registry. |
|Azure Local VM management <!--27197239--> |When you update to 10.2311.4.5, the arcbridge status shows "UpgradeFailed" on the Azure portal. |Make sure you have the latest firewall requirements including endpoint `https://hciarcvmscontainerregistry.azurecr.io` on port 443. This endpoint is required for Azure Local VM container registry.  |

### Known issues from previous releases

Here are the known issues from previous releases:

|Feature  |Issue  |Workaround/Comments  |
|---------|---------|---------|
| Deployment <!--26039020 could not reproduce--> |There's a sporadic heartbeat reliability issue in this release due to which the registration encounters the error: HCI registration failed. Error: Arc integration failed. |This issue is intermittent. Try rerunning the deployment. For more information, see [Rerun the deployment](../deploy//deploy-via-portal.md#resume-deployment).   |
| Deployment <!--26088401 could not reproduce--> |There's an intermittent issue in this release where the Arc integration validation fails with this error: ```Validator failed. Can't retrieve the dynamic parameters for the cmdlet. PowerShell Gallery is currently unavailable.  Please try again later.``` |This issue is intermittent. Try rerunning the deployment. For more information, see [Rerun the deployment](../deploy/deploy-via-portal.md#resume-deployment).   |
|Deployment <!--27183567--> |The AzureEdgeRemoteSupport extension shows as "Failed" in the cluster view and "Succeeded" in the node view. Additionally, the node view displays an incorrect extension name, "AzureEdgeRemoteSupport". | This issue is cosmetic and doesn't impact extension functionality. You may want to follow these steps to manually mitigate the issue: </br><br> 1. In the Azure portal, navigate to the resource group for your nodes.</br><br> 2. Go to each Arc node and uninstall the Remote Support extension. </br><br> 3. Allow up to 12 hours for the Azure Local  Resource Provider to update the extensions. </br><br> This procedure enables the reinstallation of the extension, ensuring it displays the correct name, AzureEdgeRemoteSupport, and resolves any failures observed in the cluster view. </br><br> Optionally, you can use the cmdlet `sync-azurestackhci` to force a sync on any of the cluster nodes.|
|Update <!----> |In this release, there's a health check issue preventing a single server running Azure Local  from being updated via the Azure portal. | Use PowerShell to perform your update. For more information, see [Update your Azure Local via PowerShell](../update/update-via-powershell-23h2.md). |
| Azure portal <!--25741164--> |In some instances, the Azure portal might take a while to update and the view might not be current.| You might need to wait for 30 minutes or more to see the updated view. |
| Deployment |In some instances, running the [Arc registration script](../deploy/deployment-arc-register-server-permissions.md) doesn't install the mandatory extensions, Azure Edge device Management or Azure Edge Lifecycle Manager. |The workaround is to run the script again and make sure that all the mandatory extensions are installed before you [Deploy via Azure portal](../deploy/deploy-via-portal.md). |
| Deployment |The first deployment step: **Before Cloud Deployment** when [Deploying via Azure portal](../deploy/deploy-via-portal.md) can take from 45 minutes to an hour to complete.| |

## Issues for version 2311.3

This software release maps to software version number **10.2311.3.12**. This release only supports updates from 2311 release.

Release notes for this version include the issues fixed in this release, known issues in this release, and release noted issues carried over from previous versions.

### Fixed issues

Here are the issues fixed in this release:

|Feature  |Issue  |Workaround  |
|---------|---------|---------|
| Update <!--26176875--> | When you try to change your AzureStackLCMUserPassword using command: `Set-AzureStackLCMUserPassword`, you might encounter this error: </br></br> ```Can't find an object with identity: 'object id'*.```| If the issue occurs, contact Microsoft Support for next steps.  |
| Azure Local VM management <!--26201356--> |In this release, when you update a VM with a data disk attached to it using the Azure CLI, the operation fails with the following error message: <br> *Couldn't find a virtual hard disk with the name*.| This issue is now fixed.  |

### Known issues in this release

There's no known issue in this release. Any previously known issues have been fixed in subsequent releases.

### Known issues from previous releases

Here are the known issues from previous releases:

|Feature  |Issue  |Workaround  |
|---------|---------|---------|
| Deployment <!--26039020 could not reproduce--> |There's a sporadic heartbeat reliability issue in this release due to which the registration encounters the error: HCI registration failed. Error: Arc integration failed. |This issue is intermittent. Try rerunning the deployment. For more information, see [Rerun the deployment](../deploy//deploy-via-portal.md#resume-deployment).   |
| Deployment <!--26088401 could not reproduce--> |There's an intermittent issue in this release where the Arc integration validation fails with this error: ```Validator failed. Can't retrieve the dynamic parameters for the cmdlet. PowerShell Gallery is currently unavailable.  Please try again later.``` |This issue is intermittent. Try rerunning the deployment. For more information, see [Rerun the deployment](../deploy/deploy-via-portal.md#resume-deployment).   |
|Deployment <!--27183567--> |The AzureEdgeRemoteSupport extension shows as "Failed" in the cluster view and "Succeeded" in the node view. Additionally, the node view displays an incorrect extension name, "AzureEdgeRemoteSupport". | This issue is cosmetic and doesn't impact extension functionality. You may want to follow these steps to manually mitigate the issue: </br><br> 1. In the Azure portal, navigate to the resource group for your nodes.</br><br> 2. Go to each Arc node and uninstall the Remote Support extension. </br><br> 3. Allow up to 12 hours for the Azure Local Resource Provider to update the extensions. </br><br> This procedure enables the reinstallation of the extension, ensuring it displays the correct name, AzureEdgeRemoteSupport, and resolves any failures observed in the cluster view. </br><br> Optionally, you can use the cmdlet `sync-azurestackhci` to force a sync on any of the cluster nodes.|
|Update <!----> |In this release, there's a health check issue preventing a single server running Azure Local from being updated via the Azure portal. | Use PowerShell to perform your update. For more information, see [Update your Azure Local via PowerShell](../update/update-via-powershell-23h2.md). |
| Azure portal <!--25741164--> |In some instances, the Azure portal might take a while to update and the view might not be current.| You might need to wait for 30 minutes or more to see the updated view. |
| Azure Local VM management| When you create a disk or a network interface in this release with underscore in the name, the operation fails.  |Make sure to not use underscore in the names for disks or network interfaces. |
| Deployment |In some instances, running the [Arc registration script](../deploy/deployment-arc-register-server-permissions.md#) doesn't install the mandatory extensions, Azure Edge device Management or Azure Edge Lifecycle Manager. |The workaround is to run the script again and make sure that all the mandatory extensions are installed before you [Deploy via Azure portal](../deploy/deploy-via-portal.md). |
| Deployment |The first deployment step: **Before Cloud Deployment** when [Deploying via Azure portal](../deploy/deploy-via-portal.md) can take from 45 minutes to an hour to complete.| |
| Azure Local VM management <!--26423941--> |If the resource group used to deploy an Azure Local VM has an underscore in the name, the guest agent installation fails. As a result, you won't be able to enable guest management. | Make sure that there are no underscores in the resource groups used to deploy Azure Local VMs.|

## Issues for version 2311.2

This software release maps to software version number **10.2311.2.7**. This release only supports updates from 2311 release.

Release notes for this version include the issues fixed in this release, known issues in this release, and release noted issues carried over from previous versions.

### Fixed issues

Here are the issues fixed in this release:

|Feature|Issue|Workaround/Comments|
|------|------|-------|
| Add server and repair server <!--26154450--> | In this release, add server and repair server scenarios might fail with the following error: </br></br> *CloudEngine.Actions.InterfaceInvocationFailedException: Type 'AddNewNodeConfiguration' of Role 'BareMetal' raised an exception: The term 'Trace-Execution' is not recognized as the name of a cmdlet, function, script file, or operable program*. | Follow these steps to work around this error: </br></br> 1. Create a copy of the required PowerShell modules on the new node.</br></br> 2. Connect to a node on your Azure Local system.</br></br> 3. Run the following PowerShell cmdlet: </br></br> Copy-Item "C:\Program Files\WindowsPowerShell\Modules\CloudCommon" "\\newserver\c$\\Program Files\WindowsPowerShell\Modules\CloudCommon" -recursive </br></br> For more information, see [Prerequisite for add and repair server scenarios](../manage/add-server.md#software-prerequisites). |
| Deployment <!--25963746--> |When you update 2310 to 2311 software, the service principal doesn't migrate.| If you encounter an issue with the software, use PowerShell to migrate the service principal.  |
| Deployment |If you select **Review + Create** and you haven't filled out all the tabs, the deployment begins and then eventually fails.|There's no known workaround in this release. |
| Deployment | This issue is seen if an incorrect subscription or resource group was used during registration. When you register the server a second time with Arc, the **Azure Edge Lifecycle Manager** extension fails during the registration, but the extension state is reported as **Ready**. | Before you run the registration the second time:<br><br>Make sure to delete the following folders from your servers: `C:\ecestore`, `C:\CloudDeployment`, and `C:\nugetstore`.<br>Delete the registry key using the  PowerShell cmdlet:<br>`Remove-Item HKLM:\Software\Microsoft\LCMAzureStackStampInformation` |
| Deployment |A new storage account is created for each run of the deployment. Existing storage accounts aren't supported in this release.| |
| Deployment |A new key vault is created for each run of the deployment. Existing key vaults aren't supported in this release.| |
| Deployment <!--25717459-->|On server hardware, a USB network adapter is created to access the Baseboard Management Controller (BMC). This adapter can cause the cluster validation to fail during the deployment.| Make sure to disable the BMC network adapter before you begin cloud deployment.|
| Deployment |The network direct intent overrides defined on the template aren't working in this release.|Use the Azure Resource Manager template to override this parameter and disable RDMA for the intents. |
| Azure Local VM management <!--26100653--> |Deployment or update of Azure Arc resource bridge could fail when the automatically generated temporary SPN secret during this operation, starts with a hyphen.| This issue is now fixed.  |
| Azure Local VM management <!--26066222--> |When a new server is added to an Azure Local instance, storage path isn't created automatically for the newly created volume.| This issue is now fixed.  |
| Update <!----> |In rare instances, you may encounter this error while updating your Azure Local instance: `Type 'UpdateArbAndExtensions' of Role 'MocArb' raised an exception: Exception Upgrading ARB and Extension in step [UpgradeArbAndExtensions :Get-ArcHciConfig] UpgradeArb: Invalid applianceyaml = [C:\AksHci\hci-appliance.yaml]`.  |If you see this issue, contact Microsoft Support to assist you with the next steps.   |

### Known issues in this release

Here are the known issues in this release:

|Feature|Issue|Workaround/Comments|
|------|------|----------|
| Update <!--NA--> |In this release, if you run the `Test-CauRun` cmdlet before actually applying the 2311.2 update, you see an error message regarding a missing firewall rule to remotely shut down the Azure Local system.  | No action is required on your part as the missing rule is automatically created when 2311.2 updates are applied. <br><br>When applying future updates, make sure to run the `Get-SolutionUpdateEnvironment` cmdlet instead of `Test-CauRun`.|
| Azure Local VM management <!--26423941--> |If the resource group used to deploy an Azure Local VM has an underscore in the name, the guest agent installation will fail. As a result, you won't be able to enable guest management. | Make sure that there are no underscores in the resource groups used to deploy Azure Local VMs.|

### Known issues from previous releases

Here are the known issues from previous releases:

|Feature  |Issue  |Workaround  |
|---------|---------|---------|
| Deployment <!--26039020--> |There's a sporadic heartbeat reliability issue in this release due to which the registration encounters the error: HCI registration failed. Error: Arc integration failed. |This issue is intermittent. Try rerunning the deployment. For more information, see [Rerun the deployment](../deploy/deploy-via-portal.md#resume-deployment).   |
| Deployment <!--26088401--> |There's an intermittent issue in this release where the Arc integration validation fails with this error: Validator failed. Cannot retrieve the dynamic parameters for the cmdlet. PowerShell Gallery is currently unavailable.  Please try again later. |This issue is intermittent. Try rerunning the deployment. For more information, see [Rerun the deployment](../deploy/deploy-via-portal.md#resume-deployment).   |
|Deployment <!--27183567--> |The AzureEdgeRemoteSupport extension shows as "Failed" in the cluster view and "Succeeded" in the node view. Additionally, the node view displays an incorrect extension name, "AzureEdgeRemoteSupport". | This issue is cosmetic and doesn't impact extension functionality. You may want to follow these steps to manually mitigate the issue: </br><br> 1. In the Azure portal, navigate to the resource group for your nodes.</br><br> 2. Go to each Arc node and uninstall the Remote Support extension. </br><br> 3. Allow up to 12 hours for the Azure Local Resource Provider to update the extensions. </br><br> This procedure enables the reinstallation of the extension, ensuring it displays the correct name, AzureEdgeRemoteSupport, and resolves any failures observed in the cluster view. </br><br> Optionally, you can use the cmdlet `sync-azurestackhci` to force a sync on any of the cluster nodes.|
| Update <!--26176875--> | When you try to change your AzureStackLCMUserPassword using command: `Set-AzureStackLCMUserPassword`, you might encounter this error: </br></br> *Cannot find an object with identity: 'object id'*.| If the issue occurs, contact Microsoft Support for next steps.  |
|Update <!----> |In this release, there's a health check issue preventing a single server running Azure Local from being updated via the Azure portal. | Use PowerShell to perform your update. For more information, see [Update your Azure Local via PowerShell](../update/update-via-powershell-23h2.md). |
| Azure portal <!--25741164--> |In some instances, the Azure portal might take a while to update and the view might not be current.| You might need to wait for 30 minutes or more to see the updated view. |
| Azure Local VM management| When you create a disk or a network interface in this release with underscore in the name, the operation fails.  |Make sure to not use underscore in the names for disks or network interfaces. |
| Deployment |In some instances, running the [Arc registration script](../deploy/deployment-arc-register-server-permissions.md) doesn't install the mandatory extensions, Azure Edge device Management or Azure Edge Lifecycle Manager. |Run the script again and make sure that all the mandatory extensions are installed before you [Deploy via Azure portal](../deploy/deploy-via-portal.md). |
| Deployment |The first deployment step: **Before Cloud Deployment** when [Deploying via Azure portal](../deploy/deploy-via-portal.md) can take from 45 minutes to an hour to complete.| |

## Issues for version 2311

This software release maps to software version number **10.2311.0.26**. This release supports new deployments and updates from 2310.

Release notes for this version include the  issues fixed in this release,  known issues in this release, and release noted issues carried over from previous versions.

### Fixed issues

Here are the issues fixed in this release:

|Feature|Issue|
|------|------|
| Networking |Use of proxy isn't supported in this release. |
| Security <!--25420275--> |When using the `Get-AzsSyslogForwarder` cmdlet with `-PerNode` parameter, an exception is thrown. You aren't able to retrieve the `SyslogForwarder` configuration information of multiple nodes. |
| Deployment <!--25710482--> |During the deployment, Microsoft Open Cloud (MOC) Arc resource bridge installation fails with this error: Unable to find a resource that satisfies the requirement Size [0] Location [MocLocation].: OutOfCapacity\"\n". |
| Deployment <!--25624270-->|Entering an incorrect DNS updates the DNS configuration in hosts during the validation and the hosts can lose internet connectivity. |
| Deployment |Password for deployment user (also referred to as `AzureStackLCMUserCredential` during Active Directory prep) and local administrator can't include a `:`(colon).| 
| Azure Local VM management <!--25778815-->| Detaching a disk via the Azure CLI results in an error in this release. |
| Azure Local VM management <!--25628443/25635316-->| A resource group with multiple clusters only shows storage paths of one cluster.|
| Azure Local VM management <!--25527606--> | When you create the Azure Marketplace image on Azure Local , sometimes the download provisioning state doesn't match the download percentage on Azure Local instance. The provisioning state is returned as succeeded while the download percentage is reported as less than 100.|
| Azure Local VM management <!--25661776--> |In this release, depending on your environment, the VM deployments on Azure Local system can take 30 to 45 minutes. |
| Azure Local VM management <!--25675277--> | While creating Azure Local VMs via the Azure CLI on Azure Local , if you provide the friendly name of marketplace image, an incorrect Azure Resource Manager ID is built and the VM creation errors out.|


### Known issues in this release

Here are the known issues in this release:

|Feature|Issue|Workaround/Comments|
|------|------|----------|
| Deployment <!--25963746--> |Before you update 2310 to 2311 software, make sure to run the following cmdlets on one of your Azure Local  nodes: <br>`Import-module C:\CloudDeployment\CloudDeployment.psd1`<br>`Import-module C:\CloudDeployment\ECEngine\EnterpriseCloudEngine.psd1`</br><br>`$Parameters = Get-EceInterfaceParameters -RolePath 'MocArb' -InterfaceName 'DeployPreRequisites'`</br><br>`$cloudRole = $Parameters.Roles["Cloud"].PublicConfiguration`</br><br>`$domainRole = $Parameters.Roles["Domain"].PublicConfiguration`</br><br>`$securityInfo = $cloudRole.PublicInfo.SecurityInfo`</br><br>`$cloudSpUser = $securityInfo.AADUsers.User` \| `Where-Object Role -EQ "DefaultARBApplication"`</br><br>`$cloudSpCred = $Parameters.GetCredential($cloudSpUser.Credential)`</br><br>`Set-ECEServiceSecret -ContainerName "DefaultARBApplication" -Credential $cloudSpCred`|This script helps migrate the service principal.  |
| Deployment <!--26039020--> |There's a sporadic heartbeat reliability issue in this release due to which the registration encounters the error: HCI registration failed. Error: Arc integration failed. |This issue is intermittent. Try rerunning the deployment. For more information, see [Rerun the deployment](../deploy//deploy-via-portal.md#resume-deployment).   |
| Deployment <!--26088401--> |There's an intermittent issue in this release where the Arc integration validation fails with this error: Validator failed. Can't retrieve the dynamic parameters for the cmdlet. PowerShell Gallery is currently unavailable.  Please try again later. |This issue is intermittent. Try rerunning the deployment. For more information, see [Rerun the deployment](../deploy/deploy-via-portal.md#resume-deployment).   |
|Deployment <!--27183567--> |The AzureEdgeRemoteSupport extension shows as "Failed" in the cluster view and "Succeeded" in the node view. Additionally, the node view displays an incorrect extension name, "AzureEdgeRemoteSupport". | This issue is cosmetic and doesn't impact extension functionality. You may want to follow these steps to manually mitigate the issue: </br><br> 1. In the Azure portal, navigate to the resource group for your nodes.</br><br> 2. Go to each Arc node and uninstall the Remote Support extension. </br><br> 3. Allow up to 12 hours for the Azure Local  Resource Provider to update the extensions. </br><br> This procedure enables the reinstallation of the extension, ensuring it displays the correct name, AzureEdgeRemoteSupport, and resolves any failures observed in the cluster view. </br><br> Optionally, you can use the cmdlet `sync-azurestackhci` to force a sync on any of the cluster nodes.|
| Update <!--26176875--> | When you try to change your AzureStackLCMUserPassword using command: `Set-AzureStackLCMUserPassword`, you might encounter this error: </br></br> *Cannot find an object with identity: 'object id'*.| There's no known workaround in this release. |
|Update <!----> |In this release, there's a health check issue preventing a single server running Azure Local  from being updated via the Azure portal. | Use PowerShell to perform your update. For more information, see [Update your Azure Local via PowerShell](../update/update-via-powershell-23h2.md). |
|Update <!--26426548--> | When you update from the 2311 build to Azure Local, the update health checks stop reporting in the Azure portal after the update reaches the Install step. | Microsoft is actively working to resolve this issue, and there's no action required on your part. Although the health checks aren't visible in the portal, they're still running and completing as expected.|
| Add server and repair server <!--26154450--> | In this release, add server and repair server scenarios might fail with the following error: </br></br> *CloudEngine.Actions.InterfaceInvocationFailedException: Type 'AddNewNodeConfiguration' of Role 'BareMetal' raised an exception: The term 'Trace-Execution' isn't recognized as the name of a cmdlet, function, script file, or operable program*. | Follow these steps to work around this error: </br></br> 1. Create a copy of the required PowerShell modules on the new node. </br></br> 2. Connect to a node on your Azure Local system. </br></br> 3. Run the following PowerShell cmdlet: </br></br> Copy-Item "C:\Program Files\WindowsPowerShell\Modules\CloudCommon" "\\newserver\c$\\Program Files\WindowsPowerShell\Modules\CloudCommon" -recursive </br></br> For more information, see [Prerequisite for add and repair server scenarios](../manage/add-server.md#software-prerequisites). |


### Known issues from previous releases

Here are the known issues from previous releases:

|Feature  |Issue  |Workaround  |
|---------|---------|---------|
| Azure portal <!--25741164--> |In some instances, the Azure portal might take a while to update and the view might not be current.| You might need to wait for 30 minutes or more to see the updated view. |
| Azure Local VM management| When you create a disk or a network interface in this release with underscore in the name, the operation fails.  |Make sure to not use underscore in the names for disks or network interfaces. |
| Deployment <!--25717459-->|On server hardware, a USB network adapter is created to access the Baseboard Management Controller (BMC). This adapter can cause the cluster validation to fail during the deployment.| Make sure to disable the BMC network adapter before you begin cloud deployment.|
| Deployment |A new storage account is created for each run of the deployment. Existing storage accounts aren't supported in this release.| |
| Deployment |A new key vault is created for each run of the deployment. Existing key vaults aren't supported in this release.| |
| Deployment |In some instances, running the [Arc registration script](../deploy/deployment-arc-register-server-permissions.md) doesn't install the mandatory extensions, Azure Edge device Management or Azure Edge Lifecycle Manager. |The workaround is to run the script again and make sure that all the mandatory extensions are installed before you [Deploy via Azure portal](../deploy/deploy-via-portal.md). |
| Deployment |The first deployment step: **Before Cloud Deployment** when [Deploying via Azure portal](../deploy/deploy-via-portal.md) can take from 45 minutes to an hour to complete.| |
| Deployment |The network direct intent overrides defined on the template aren't working in this release.|Use the Azure Resource Manager template to override this parameter and disable RDMA for the intents. |
| Deployment |If you select **Review + Create** and you haven't filled out all the tabs, the deployment begins and then eventually fails.|There's no known workaround in this release. |
| Deployment | This issue is seen if an incorrect subscription or resource group was used during registration. When you register the server a second time with Arc, the **Azure Edge Lifecycle Manager** extension fails during the registration, but the extension state is reported as **Ready**. | Before you run the registration the second time:<br><br>Make sure to delete the following folders from your server(s): `C:\ecestore`, `C:\CloudDeployment`, and `C:\nugetstore`.<br>Delete the registry key using the  PowerShell cmdlet:<br>`Remove-Item HKLM:\Software\Microsoft\LCMAzureStackStampInformation` |

## Next steps

- Read the [Deployment overview](../deploy/deployment-introduction.md).