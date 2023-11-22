---
title: Release notes with known issues in Azure Stack HCI 23H2 2310 release (preview)
description: Read about the known issues in Azure Stack HCI 2310 public preview release (preview).
author: alkohli
ms.topic: conceptual
ms.date: 11/17/2023
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# View known issues in Azure Stack HCI, version 23H2 release (preview)

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article identifies the critical known issues and their workarounds in Azure Stack HCI.

The article contains the release notes for all the version 23H2 releases. The release notes are continuously updated, and as critical issues requiring a workaround are discovered, they're added. Before you deploy your Azure Stack HCI, carefully review the information contained in the release notes.


For more information about the new features in this release, see [What's new in 23H2](whats-new.md).

[!INCLUDE [important](../includes/hci-preview.md)]

## Known issues for version 2311

This software release maps to software version number **10.2311.X.XX**. This release supports new deployments and updates from 2310.

Release notes for this version also include the release noted issues carried over from previous versions. Here are the known issues in version 2311 release:

|Release|Feature|Issue|Workaround/Comments|
|-|------|------|----------|
|2311 <br> 10.2311.0.XX <!--25710482-->| Deployment |During the deployment, Microsoft Open Cloud (MOC) Arc Resource Bridge installation fails with this error: Unable to find a resource that satisfies the requirement Size [0] Location [MocLocation].: OutOfCapacity\"\n". |There's no known workaround in this release. |


## Known issues for version 2310

This software release maps to software version number **10.2310.0.30**. This release only supports new deployments.

Here are the known issues in version 2310 release:

|Release|Feature|Issue|Workaround/Comments|
|-|------|------|----------|
|2310 <br> 10.2310.0.30| Networking |Use of proxy isn't supported in this release. |There's no known workaround in this release. |
|2310 <br> 10.2310.0.30 <!--24524483-->| Networking |There is an infrequent DNS client issue in this release that causes the deployment to fail on a two-node cluster with a DNS resolution error: *A WebException occurred while sending a RestRequest. WebException.Status: NameResolutionFailure.* <br>As a result of the bug, the DNS record of the second node is deleted soon after it is created resulting in a DNS error.  |Restart the server. This operation registers the DNS record which prevents it from getting deleted. |
|2310 <br> 10.2310.0.30| Azure portal <!--25741164--> |In some instances, the Azure portal might take a while to update and the view might not be current.| You might need to wait for 30 minutes or more to see the updated view. |
|2310 <br> 10.2310.0.30 <!--25661776-->| Arc VM management |In this release, depending on your environment, the VM deployments on Azure Stack HCI system can take 30 to 45 minutes. |There's no known workaround in this release. |
|2310 <br> 10.2310.0.30 <!--25527606-->| Arc VM management | When you create the Azure Marketplace image on Azure Stack HCI, sometimes the download provisioning state doesn't match the download percentage on Azure Stack HCI cluster. The provisioning state is returned as succeeded while the download percentage is reported as less than 100.| There's no known workaround in this release.|
|2310 <br> 10.2310.0.30 <!--25675277-->| Arc VM management | While creating Arc VMs via the Azure CLI on Azure Stack HCI, if you provide the friendly name of marketplace image, an incorrect Azure Resource Manager ID is built and the VM creation errors out.| Instead of providing the friendly name, always provide the Azure Resource Manager ID of the marketplace image in this release.|
|2310 <br> 10.2310.0.30 | Arc VM management |Deleting a network interface on an Arc VM from Azure portal doesn't work in this release.| Use the Azure CLI to first remove the network interface and then delete it. For more information, see [Remove the network interface](/cli/azure/stack-hci-vm/nic#az-stack-hci-vm-nic-remove) and see [Delete the network interface](/cli/azure/stack-hci-vm/network/nic#az-stack-hci-vm-network-nic-delete).|
|2310 <br> 10.2310.0.30 <!--25628443-->| Arc VM management| A resource group with multiple clusters only shows storage paths of one cluster.| Multiple clusters aren't supported for a single resource group in this release.|
|2310 <br> 10.2310.0.30 <!--25778815-->| Arc VM management| Detaching a disk via the Azure CLI results in an error in this release. |There's no known workaround in this release.  |
|2310 <br> 10.2310.0.30 | Arc VM management| When you create a disk or a network interface in this release with underscore in the name, the operation fails.  |Make sure to not use underscore in the names for disks or network interfaces. |
|2310 <br> 10.2310.0.30 <!--25420275-->|Security |When using the `Get-AzsSyslogForwarder` cmdlet with `-PerNode` parameter, an exception is thrown. You aren't able to retrieve the `SyslogForwarder` configuration information of multiple nodes. |The workaround is to go to each server and check the local configuration state of the Syslog component.|
|2310 <br> 10.2310.0.30| Deployment <!--25624270-->|Entering an incorrect DNS updates the DNS configuration in hosts during the validation and the hosts can lose internet connectivity. |There's no known workaround in this release. |
|2310 <br> 10.2310.0.30| Deployment |Providing the OU name in an incorrect syntax isn't detected in the Azure portal. The incorrect syntax is however detected at a later step during cluster validation. |There's no known workaround in this release. |
|2310 <br> 10.2310.0.30 <!--25717459-->| Deployment |On server hardware, a USB network adapter is created to access the Baseboard Management Controller (BMC). This adapter can cause the cluster validation to fail during the deployment.| Make sure to disable the BMC network adapter before you begin cloud deployment.|
|2310 <br> 10.2310.0.30| Deployment |A new storage account is created for each run of the deployment. Existing storage accounts aren't supported in this release.| |
|2310 <br> 10.2310.0.30| Deployment |A new key vault is created for each run of the deployment. Existing key vaults aren't supported in this release.| |
|2310 <br> 10.2310.0.30| Deployment |Password for deployment user (also referred to as `AzureStackLCMUserCredential` during Active Directory prep) and local administrator can't include a `:`(colon).| |
|2310 <br> 10.2310.0.30| Deployment |In some instances, running the [Arc registration script](./deploy/deployment-arc-register-server-permissions.md#register-servers-with-azure-arc) doesn't install the mandatory extensions, Azure Edge device Management or Azure Edge Lifecycle Manager. |The workaround is to run the script again and make sure that all the mandatory extensions are installed before you [Deploy via Azure portal](./deploy/deploy-via-portal.md). |
|2310 <br> 10.2310.0.30| Deployment |The first deployment step: **Before Cloud Deployment** when [Deploying via Azure portal](./deploy/deploy-via-portal.md) can take from 45 minutes to an hour to complete.| |
|2310 <br> 10.2310.0.30| Deployment |The network direct intent overrides defined on the template aren't working in this release.|Use the ARM template to override this parameter and disable RDMA for the intents. |
|2310 <br> 10.2310.0.30| Deployment |Deployments via Azure Resource Manager time out after 2 hours. Deployments that exceed 2 hours show up as failed in the resource group though the cluster is successfully created.| To monitor the deployment in the Azure portal, go to the Azure Stack HCI cluster resource and then go to new **Deployments** entry. |
|2310 <br> 10.2310.0.30| Deployment |If you select **Review + Create** and you haven't filled out all the tabs, the deployment begins and then eventually fails.|There's no known workaround in this release. |
|2310 <br> 10.2310.0.30 | Deployment | This issue is seen if an incorrect subscription or resource group was used during registration. When you register the server a second time with Arc, the **Azure Edge Lifecycle Manager** extension fails during the registration but the extension state is reported as **Ready**. | Before you run the registration the second time:<br><br>Make sure to delete the following folders from your server(s): `C:\ecestore`, `C:\CloudDeployment`, and `C:\nugetstore`.<br>Delete the registry key using the  PowerShell cmdlet:<br>`Remove-Item HKLM:\Software\Microsoft\LCMAzureStackStampInformation` |
|2310 <br> 10.2310.0.30| Azure Site Recovery |Azure Site Recovery can't be installed on an Azure Stack HCI cluster in this release. |There's no known workaround in this release. |


## Next steps

- Read the [Deployment overview](./deploy/deployment-introduction.md).
