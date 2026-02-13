---
title: What's new in Hyperconverged Deployments of Azure Local 24xx releases
description: Find out about the new features and enhancements in the Azure Local 24xx releases.
ms.topic: overview
author: alkohli
ms.author: alkohli
ms.service: azure-local
ms.date: 02/11/2026
ms.subservice: hyperconverged
---

# What's new in hyperconverged deployments of Azure Local 24xx releases?

This article lists the features and improvements that are available in hyperconverged deployments of Azure Local (*formerly Azure Stack HCI*) 24xx releases.

> [!NOTE]
> Azure Local 24xx releases are not in a supported state. For more information, see [Azure Local release information](../release-information-23h2.md).

## Features and improvements in 2411.3

This release includes the following features and improvements:

- **Quality updates** - This build contains the latest quality updates and is based on the operating system version 25398.1425.
- **Updated .NET version** - This build has an updated .NET version 8.0.13.
- **New Lifecycle Manager version** - Lifecycle Manager version 30.2503.0.854 is released to deploy the 2411.3 build. This new version moves the content download from extension installation to a visible step in validation. This change reduces the overall content download size from a per machine to a one-time download.

For more information on improvements in this release, see the [Fixed issues in 2411.3](../known-issues.md?view=azloc-previous&preserve-view=true#fixed-issues).

## Features and improvements in 2411.2

This baseline release has the following features and improvements:

- **Azure Local VMs** - The following improvements are made to VMs in this release:
    - **Azure Marketplace images**: Three new Azure Marketplace images are available in addition to the existing images. For more information, see the [List of Azure Marketplace images supported for VMs](../manage/virtual-machine-image-azure-marketplace.md#create-azure-local-vm-image-using-azure-marketplace-images).
    - **Live migration**: You can use on-premises tools to live migrate Azure Local VMs. For more information, see [Live migration of Azure Local VMs](../manage/manage-arc-virtual-machines.md#conduct-live-migration-of-azure-local-vms).

- **4-node switchless support documentation** - Documentation for 4-node switchless is now available. For more information, see [4-node switchless support](../plan/four-node-switchless-two-switches-two-links.md).

For more information on improvements in this release, see the [Fixed issues in 2411.2](../known-issues.md?view=azloc-previous&preserve-view=true#fixed-issues).

## Features and improvements in 2411.1

This release includes the following features and improvements:

- **Azure Local VMs** - Starting with this release, you can't delete attached resources (network interface, disk) while the associated Azure Local VM is being created. For more information, see [Delete a network interface](../manage/manage-arc-virtual-machine-resources.md#delete-a-network-interface) and [Delete a data disk](../manage/manage-arc-virtual-machine-resources.md#delete-a-data-disk).

- **Updates** - This release adds an update precheck to ensure that the solution extension content is copied correctly.

- **4-node switchless support** - Starting with this release, 4-node switchless support is available for Azure Local.

For more information on improvements in this release, see the [Fixed issues in 2411.1](../known-issues.md?view=azloc-previous&preserve-view=true#fixed-issues-1).

## Features and improvements in 2411

This release includes the following features and improvements:

- **Renaming of Azure Stack HCI to Azure Local** - Azure Stack HCI is now a part of Azure Local. Microsoft renamed Azure Stack HCI to Azure Local to communicate a single brand that unifies the entire distributed infrastructure portfolio.

    For more information, see [Renaming Azure Stack HCI to Azure Local](../rename-to-azure-local.md).
- **Azure Local for Small Form Factor (Preview)**- Beginning this release, Azure Local supports a new class of *small* devices with reduced hardware requirements. These low cost devices are suitable for edge scenarios across the industry horizontals. The devices must meet the Windows Server certification requirements and relaxed requirements from Software Defined Data Center (SDDC) and Windows Server Software-Defined (WSSD) program.

    For more information about this Preview feature, see [System requirements for Azure Local for small form factor (Preview)](../concepts/system-requirements-small-23h2.md).
- **Azure Local for disconnected operations (Preview)** - Azure Local is now available for disconnected operations. Disconnected operations for Azure Local enable the deployment and management of Azure Local instances without a connection to the Azure public cloud.

    This feature allows you to build, deploy, and manage virtual machines (VMs) and containerized applications using select Azure Arc-enabled services from a local control plane, providing a familiar Azure portal and CLI experience.

    For more information about this Preview feature, see [Azure Local for Disconnected Operations (Preview)](../manage/disconnected-operations-overview.md).
- **Deploy Azure Local with Local Identity (Preview)** - Starting with this release, you can deploy Azure Local using Local identity with Azure Key Vault. By integrating with Key Vault and using certificate-based authentication, security posture is enhanced and operations continuity is ensured. This approach offers minimal edge infrastructure, a secure secret store, and simplified management by consolidating secrets in a single vault. Additionally, it streamlines deployment by eliminating dependencies on Active Directory systems and simplifying firewall configurations.

    For more information about this Preview feature, see [Deploy Azure Local with Local Identity and Azure Key Vault (Preview)](../deploy/deployment-local-identity-with-key-vault.md).

- **Azure Local VM changes**: The following changes were made to Azure Local VM management:
    - **Terraform templates for Azure Local VM** - Starting with this release, you can create logical networks and Azure Local VMs using Terraform templates.
    
        For more information, see [Template to create logical networks](https://registry.terraform.io/modules/Azure/avm-res-azurestackhci-logicalnetwork/azurerm/0.4.0) and [Template to create Azure Local VMs](https://registry.terraform.io/modules/Azure/avm-res-azurestackhci-virtualmachineinstance/azurerm/0.1.2).
    - **Add network interface on static logical network** - After the Azure Local VMs are provisioned, you can now add a network interface on a static logical network. To add this network interface, you're required to configure the desired static IP from within the VM.
        
        For more information, see [Add a network interface on your Azure Local](../manage/manage-arc-virtual-machine-resources.md#add-a-network-interface).

    - **Download data disks** - Beginning this release, you can download an Azure managed disk from Azure to your Azure Local instance. You use this disk to create an Azure Local VM image or attach the image to your VMs as needed.
  
        For more information, see [Download data disks from Azure to Azure Local](../manage/manage-data-disks.md).

- **Security improvements** - Starting with this release, the security posture of Azure Local is enhanced with the following improvements:

  - **Security posture following Azure Stack HCI, version 22H2 to Azure Local upgrade** - Warnings and guardrails were added in the upgrade flow. Documentation was also updated to reflect the security posture of Azure Local after upgrading from version 22H2.
  
    For more information, see [Manage security after upgrading Azure Local from version 22H2](../manage/manage-security-post-upgrade.md).

  - **Improved security baseline compliance** - Starting with this release, the security settings on the Azure Local nodes are compared against the security baseline with full accuracy. On the right secured-core hardware, you achieve a 99% compliance score, which you can view in the Azure portal.
  
    For more information, see [View security baseline compliance in the Azure portal](../manage/manage-secure-baseline.md#view-security-baseline-compliance-in-the-azure-portal).

- **Error-Correcting Code (ECC) memory requirements** - Beginning this release, the ECC memory requirements are enforced. If you can't meet the memory and ECC requirements, you can opt for a virtual deployment.

    For more information, see [System requirements for Azure Local](../concepts/system-requirements-23h2.md).

- **AKS on Azure Local** - This release has several new features and enhancements for AKS on Azure Local. For more information, see [What's new in AKS on Azure Local](/azure/aks/hybrid/aks-whats-new-23h2).

## Features and improvements in 2408.2

This release includes the following features and improvements:

- **Azure Local VM management improvements**: Starting with this release, the Azure Local VM management experience provides the following improvements:

  - You can set a proxy configuration for Azure VMs on the portal.
  - You can set a SQL Server configuration for Azure VMs on the portal.
  - You can now create an image from an Azure VM's OS disk.
  - You can now select the virtual switch of a logical network from a dropdown menu.

## Features and improvements in 2408.1

This release includes the following features and improvements:

- **Environment checker improvements**: Starting in this release, the environment checker includes a new validator that checks all storage adapters in each of the nodes.
- **Install module version numbers**: Starting in this release, the install module version numbers change for *Az.Accounts*, *Az.Resources*, and *Az.ConnectedMachine*. For more information, see [Register machines with Azure Arc](../deploy/deployment-arc-register-server-permissions.md).
- **Azure Local VM Management**: Starting in this release, you can attach or detach GPUs to an Azure Local VM via CLI for GPU-P (preview) and DDA (preview). For more information, see:
  - [Prepare GPUs for Azure Local (preview)](../manage/gpu-preparation.md)
  - [Manage GPUs using partitioning for Azure Local (preview)](../manage/gpu-manage-via-partitioning.md)
  - [Manage GPUs via Discrete Device Assignment for Azure Local (preview)](../manage/gpu-manage-via-device.md)
- **Improved CLI error messages** for deletion of VM network interfaces, data disks, and storage paths that are in use.
- **Improved reliability** when installing OpenSSH client during solution deployment.

## Features and improvements in 2408

This baseline release has the following features and improvements:

### Upgrade from Azure Stack HCI, version 22H2 to Azure Local 

This release introduces the ability to upgrade your Azure Stack HCI from version 22H2 to Azure Local. The upgrade process supports clusters running version 22H2 with the latest updates and is a two-step process. While the OS upgrade is generally available, the solution upgrade has a phased rollout.

For more information, see [Upgrade Azure Local from version 22H2](../upgrade/about-upgrades-23h2.md).

### Updates changes

This release contains the following changes for updates:

- Revised the names and descriptions of update steps. 
- Introduced a health fault alert that raises when the system has available updates. 

### Azure Local VM management changes

This release contains the following changes for Azure Local VM management:

- Twelve new Azure Marketplace images are available. For more information, see [Create Azure Local VM from Azure Marketplace images via Azure CLI](../manage/virtual-machine-image-azure-marketplace.md#create-vm-image-from-marketplace-image).
- Creation of logical networks is blocked if you try to create overlapping IP pools.
- Logical network properties are properly updated. Previously, the logical network sometimes didn't have its properties (vLAN, IP Pools, and so on) filled.
- The vLAN field on a logical network defaults to 0 if you don't specify it.
- You can use either *-image* or *-os-disk-name* (but not both) to create a VM from a VHD. Previously, Azure CLI enforced *-image* as required for the `az stack-hci-vm create` command.

For more information, see the [Fixed issues list in 2408](../known-issues.md?view=azloc-2408&preserve-view=true#fixed-issues-5).

### SBE changes

This release includes the following changes for SBE:

- **Reduced deployment times**: Starting in this release, SBE extension interfaces run more efficiently, so Azure Local deployment times are shorter.
- **CAU plugin**: Starting in this release, SBE extensions use an updated CAU plugin that enhances support for host OS driver updates, addressing problems with drivers that are newer than those in the SBE. This plugin update gives hardware vendors more flexibility for driver version updates in support cases. Microsoft recommends that you install host OS driver updates only through your hardware vendor's SBE.
- **Improved error details**: Starting in this release, hardware vendor SBE failures or exceptions include the SBE publisher, family, and version at the beginning of the exception string. Provide this information to your hardware vendor to streamline the failure analysis.

## Features and improvements in 2405.3

This release primarily fixes bugs. See the [Fixed issues list](../known-issues.md?view=azloc-previous&preserve-view=true) to understand the bug fixes.

## Features and improvements in 2405.2

This release primarily includes bug fixes with a few improvements.

- Azure Local VM management improvements: Starting with this release, the following improvements are available for the Azure Local VM management experience:

  - You can now view and delete VM network interfaces from the Azure portal.
  - You can view **Connected devices** for logical networks. In the Azure portal, you can go to the logical network and then go to **Settings > Connected devices** to view the connected devices.
  - Deletion of logical networks is blocked if connected devices are present. When you try to delete a logical network from the Azure portal that has connected devices, you see a warning message: *Can't delete logical network because it's currently in use*. Delete all the resources under **Connected Devices** setting before you delete the logical network.
  - From this release onwards, a new URL needs to be added to the allow list for `stack-hci-vm` Azure CLI installation. The URL changed from `https://hciarcvmsstorage.blob.core.windows.net/cli-extension/stack_hci_vm-{version}-py3-none-any.whl` to `https://hciarcvmsstorage.z13.web.core.windows.net/cli-extensions/stack_hci_vm-{version}-py3-none-any.whl`. For more information, see [Azure Local firewall requirements](../concepts/firewall-requirements.md).
  
- **Update health checks**: Starting with this release, a new health check was added and the update service was improved. Additionally, the update service now supports the ability to view or start new updates when the service crashes on machines. Also, multiple health check problems related to Azure Update Manager and Solution Builder Extension Update were fixed.

  For more information, see [Fixed issues in 2405.2](../known-issues.md?view=azloc-previous&preserve-view=true).

- **Azure Stack HCI OEM license**: Starting with this release, Microsoft is introducing the Azure Stack HCI OEM license designed for Azure Local hardware including the Azure Local Premier Solutions, Integrated systems, and Validated Nodes. This license remains valid for the lifetime of the hardware, covers up to 16 cores, and includes three essential services for your cloud infrastructure.

  For more information, see [Azure Stack HCI OEM license overview](../oem-license.md) and [Azure Stack HCI OEM license and billing FAQ](../license-billing.yml).

## Features and improvements in 2405.1

This release primarily includes bug fixes with a few improvements.

- **Custom storage IPs for add and repair server scenarios**: Starting in this release, you can add machines or repair machines to the Azure Local instance by using custom IPs for the storage intent network adapters.
- **Improved outbound connectivity check**: Starting in this release, the environment checker includes improvements to the outbound connectivity requirement validation.
- **Reliability improvements**: This release includes reliability improvements for partner health checks implemented in their Solution Builder Extensions.
- **Rotation of Arc Resource Bridge service principal credentials**: Starting in this release, you can rotate the service principal credentials used by Azure Arc resource bridge.
- **Multiple bug fixes related to Updates**: This release includes multiple bug fixes related to Updates.

For more information on bug fixes, see the [Fixed issues list](../known-issues.md?view=azloc-previous&preserve-view=true).

## Features and improvements in 2405

Here are the features and improvements in this release.

### Deployment changes


- **Active Directory integration** - This release fixes an issue related to the use of a large Active Directory that results in timeouts when adding users to the local administrator group. <!--27022398-->

- **New Azure Resource Manager (ARM) template** - This release introduces a new ARM template for deployment that simplifies the resource creation dependencies. The new template creation also includes multiple fixes around the missing mandatory fields. <!--26376120-->

- **Secret rotation improvements** - This release includes improvements to the secret rotation flow.
  - The secret rotation PowerShell command `Set-AzureStackLCMUserPassword` now supports a new parameter to skip the confirmation message. This parameter is useful when automating secret rotation. <!--27101544-->
  - Reliability improvements were made around the services not restarting in a timely manner. <!--27837538-->

- **Solution Builder Extension (SBE) improvements** include:
  - A new PowerShell command to update the Solution Builder Extension partner property values is provided at the time of deployment. <!--25093172-->
  - Fixing an issue that prevents the update service to respond to requests after a Solution Builder Extension only update run. <!--27940543-->

- **Add server and Repair server fixes** include:
  - An issue that prevents a node from joining Active Directory during the add-server operation. <!--27101597-->
  - Enabling deployment when a disjoint namespace is used.

- **Reliability enhancements** include:
  - Changes for Network ATC when setting up the host networking configuration with certain network adapter types. <!--27285196-->
  - Changes when detecting the firmware versions for disk drives. <!--27395303-->

- This release contains a fix for a deployment issue that's encountered when setting the diagnostic level in Azure and the device. <!--26737110-->

For more information, see the [Fixed issues list in 2405](../known-issues.md?view=azloc-previous&preserve-view=true).

### Updates changes

This release contains the following changes for updates:

- Starting with this release, updates use an adjusted naming schema. This schema makes it easier to identify feature updates and cumulative updates. <!--26952963-->

- This release contains reliability improvements:
  - For the update notifications for health check results that the device sends to Azure Update Manager. In certain instances, the message size was too large and results weren't shown in the Update Manager. <!--27230554-->
  - For reporting the cluster update progress to the orchestrator.

- This release has bug fixes for various problems, including:

  - A file lock problem that could cause update failures for the trusted launch VM agent (IGVM). <!--27689489-->
  - A problem that prevented the orchestrator agent from restarting during an update run. <!--27726586-->
  - A rare condition where the update service took a long time to discover or start an update. <!--27745420-->
  - A problem for Cluster-Aware Updating (CAU) interaction with the orchestrator when an update is in progress and CAU reports it. <!--26805746-->

For more information, see the [Fixed issues list in 2405](../known-issues.md?view=azloc-previous&preserve-view=true).

### Environment checker changes

In this release, the environment checker includes several new checks:

- It ensures the inbox drivers on the physical network adapters aren't in use. You must install the provided OEM or manufacturer latest drivers before deployment.
- It ensures the link speed across physical network adapters on the same intent is identical.
- It ensures RDMA is operational on the storage network adapters before deployment.
- It validates the infrastructure IP addresses defined during deployment have outbound connectivity and can resolve the DNS.
- It ensures the DNS server value isn't empty on the management IP address.
- It makes sure there's only one IP address on the management network adapter.
- It ensures the minimum bandwidth required for RDMA storage adapters is at least 10 Gb.
- It checks that the uplink connectivity in any physical network adapters assigned to Network ATC intents is up.
- It improves the ability to handle adapters that don't expose the VLAN ID field correctly.

### Observability changes

This release contains the following improvements to observability:

- When starting a log collection, a warning message now advises you to limit the log collection to 24 hours.
- Deployment logs are automatically collected by default.
- The newly added `Test-observability` feature validates whether the telemetry and diagnostic data can be successfully sent to Microsoft.

### Azure Local VM management changes

- This release contains new documentation that provides guidance on VM image creation starting with a CentOS image or a Red Hat Enterprise Linux (RHEL) image. For more information, see:
  - [Prepare CentOS Linux image for Azure Local virtual machines (preview)](../manage/virtual-machine-image-centos.md).
  - [Prepare Red Hat Enterprise image for Azure Local virtual machines (preview)](../manage/virtual-machine-image-red-hat-enterprise.md).

### Azure portal, extensions, and resource provider changes

The following changes relate to the Azure portal, extensions, and resource providers:

- In this release, an issue was fixed that prevented showing a failed deployment in the Cluster overview when the deployment is canceled.
- The **Retry** button in Azure portal is renamed to **Resume** as the deployment continues from the step that it failed.
- The new clusters deployed in this release have resource locks enabled to protect against accidental deletion.
- This release changes the behavior to not delete the Arc-enabled server resources when the Azure Local resource is deleted.

### Security changes

This release includes the following updates to the security documentation:

- The compliance score for Azure Local machine is 281 out of 288 rules even when all the hardware requirements for Secured-core are met. The [View security baseline compliance in the Azure portal](../manage/manage-secure-baseline.md#view-security-baseline-compliance-in-the-azure-portal) section now explains the noncompliant rules and the reasons for the current gap.
- The Security Baselines settings have been updated to 315 settings, including six removals and one addition. To view and download the complete list of security settings, see [Security Baseline](https://github.com/Azure-Samples/AzureStackHCI/blob/main/security/SecurityBaseline_2405.csv).
- Updated the [Application Control](../concepts/security-features.md#application-control) section in the [Security features for Azure Local](../concepts/security-features.md) article.

### Azure Kubernetes Service on Azure Local

For a list of the changes and improvements in AKS on Azure Local, see [What's new in Azure Kubernetes on Azure Local?](/azure/aks/hybrid/aks-whats-new-23h2).



## Features and improvements in 2402.4

This release primarily fixes bugs. See the [Fixed issues list](../known-issues.md?view=azloc-previous&preserve-view=true) to understand the bug fixes.

## Features and improvements in 2402.3

This release primarily fixes bugs. See the [Fixed issues list](../known-issues.md?view=azloc-previous&preserve-view=true) to understand the bug fixes.

## Features and improvements in 2402.2

This release is primarily a bug fix release with a few enhancements. See the [Fixed issues list](../known-issues.md?view=azloc-previous&preserve-view=true) to understand the bug fixes. Here's the list of enhancements:

- **Region expansion** - The following new regions are now supported on your Azure Local instance: Southeast Asia, India Central, Canada Central, Japan East, and South Central US. For more information, see [Azure Local supported regions](../concepts/system-requirements-23h2.md#azure-requirements).
- **Deployment changes** - A permission check was added to the Azure portal deployment experience to check for sufficient permissions. For more information, see [Deploy via Azure portal](../deploy/deploy-via-portal.md).
- **Update changes** - A notification banner was included in the update experience that informs you when the new updates are available. For more information, see [Update your Azure Local instance via the Azure Update Manager](../update/azure-update-manager-23h2.md).

## Features and improvements in 2402.1

This release primarily fixes bugs. See the [Fixed issues list](../known-issues.md?view=azloc-previous&preserve-view=true) to understand the bug fixes.

## Features and improvements in 2402

This section lists the new features and improvements in the 2402 release of Azure Local.

### New built in security role

This release introduces a new Azure built-in role called Azure Resource Bridge Deployment Role, to harden the security posture for Azure Local. If you provisioned a cluster before January 2024, assign the **Azure Resource Bridge Deployment User** role to the Azure Resource Bridge principal.

The role applies the concept of least privilege and must be assigned to the service principal: *clustername.arb* before you update the cluster.

To take advantage of the constraint permissions, remove the permissions that you applied before. Follow the steps to [Assign an Azure RBAC role via the portal](/azure/role-based-access-control/role-assignments-portal?tabs=delegate-condition). Search for and assign the Azure Resource Bridge Deployment role to the member: `<deployment-cluster-name>-cl.arb`.

An update health check is also included in this release that confirms that the new role is assigned before you apply the update.

### Changes to Active Directory preparation

Starting with this release, the Active Directory preparation process is simplified. You can use your own existing process to create an Organizational Unit (OU), a user account with appropriate permissions, and block Group policy inheritance for the Group Policy Object (GPO). You can also use the Microsoft provided script to create the OU. For more information, see [Prepare Active Directory](../deploy/deployment-prep-active-directory.md).

### Region expansion

Azure Local solution is now supported in Australia. For more information, see [Azure Local supported regions](../concepts/system-requirements-23h2.md#azure-requirements).

### New documentation for network considerations

We're also releasing new documentation that provides guidance on network considerations for the cloud deployment of Azure Local. For more information, see [Network considerations for Azure Local](../plan/cloud-deployment-network-considerations.md).

### Security changes

This release includes the following updates to the security documentation:

- Updates to the documentation for [Manage system security with Microsoft Defender for Cloud (preview)](../manage/manage-security-with-defender-for-cloud.md).
- Updates to the Security Baselines settings to 320 settings, including one removal, three additions, and one change about disabling Dynamic Root of Measurement (DRTM) for new deployments. To view and download the complete list of security settings, see [Security Baseline](https://github.com/Azure-Samples/AzureStackHCI/blob/main/security/SecurityBaseline_2402.csv).
- The [Azure Local security book](../security-book/overview.md).

## Next steps

- [Read the Azure Local blog](https://aka.ms/ignite25/blog/azurelocal) post.
- Read the [blog announcing the general availability of Azure Local](https://techcommunity.microsoft.com/t5/azure-stack-blog/azure-stack-hci-version-23h2-is-generally-available/ba-p/4046110).
- Read [About hyperconverged deployment methods](../deploy/deployment-introduction.md).
- Learn how to [Deploy Azure Local via the Azure portal](../deploy/deploy-via-portal.md).
