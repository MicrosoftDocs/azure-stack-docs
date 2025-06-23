---
title: What's new in Azure Local latest release
description: Find out what are the new features and enhancements in the latest Azure Local release.
ms.topic: overview
author: alkohli
ms.author: alkohli
ms.service: azure-local
ms.date: 06/19/2025
---

# What's new in Azure Local?

[!INCLUDE [azure-local-banner-23h2](./includes/azure-local-banner-23h2.md)]

[!INCLUDE [azure-local-end-of-support-banner-23h2](./includes/azure-local-end-of-support-banner-23h2.md)]

This article lists the various features and improvements that are available in Azure Local. The latest version of Azure Local solution focuses on cloud-based deployment and updates, cloud-based monitoring, new and simplified experience for Azure Local virtual machine (VM) management, security, and more.


::: moniker range="=azloc-2506"

There are two 2506 releases for June. Here are the details of each release:

|Solution version  |OS version |Deployment  |
|---------|---------|---------|
|12.2506.1001.23 |  26100.4349        | New deployments only.        |
|11.2506.1001.22  | 25398.1665        | Existing deployments only.        |

For more information, see [Release information summary](./release-information-23h2.md).

## Features and improvements in 2506

This release has the following features and improvements:

- **OS version changes**:

    - In 2504 release, a new operating system was introduced for Azure Local deployments. For 2506, all the new deployments of Azure Local will run the new OS version **26100.4349**. You can download the 2506 OS image from the Azure portal.
    
        You also need to get the driver compatible with OS version **26100.4349** or Windows Server 2025. If a compatible driver is not available, you can use the 2503 image.

        Existing deployments of Azure Local will continue to use OS version **25398.1665**. For more information, see [Release information summary](./release-information-23h2.md).

    - If you've purchased Integrated System or Premier solution hardware from the [Azure Local Catalog](https://aka.ms/AzureStackHCICatalog) through your preferred Microsoft hardware partner, the OS should be preinstalled. Work with your Original Equipment Manufacturer (OEM) to get the OS image compatible with **12.2506** and driver compatible with OS version **26100.4349** or Windows Server 2025.

- **.NET updates**: This build uses .NET version **8.0.17** for both .NETRuntime and ASP.NET Core. For more details, see [Download .NET 8.0](https://dotnet.microsoft.com/download/dotnet/8.0).

- **Software-Defined Networking (SDN) enabled by Azure Arc**: Azure Local now supports Software-Defined Networking (SDN) enabled by Azure Arc. This feature allows you to manage your network resources using Azure Arc, providing a consistent networking experience across your hybrid and multi-cloud environments. For more information, see [Software-Defined Networking (SDN) enabled by Azure Arc](./concepts/sdn-overview.md).

- **New security baseline**: The 2506 release introduces a security baseline with 407 evaluated rules, a 25% increase from the previous 324. Key improvements include:
  - Over 90% alignment with CIS Azure Compute Windows Baseline and Defense Information Systems Agency (DISA) Security Technical Implementation Guide (STIG) benchmark.
  - Enhanced Microsoft Defender Antivirus settings, including Potentially Unwanted Apps (PUA), network inspection, and attack surface reduction rules.
  - Additional adjustments tailored for Azure Local.

  This release also has improved conflict resolution with existing security policies. Instead of disabling drift control system-wide, you can now fine-tune individual settings while maintaining drift control. For more information, see [View and download security settings in Azure Local](./manage/manage-secure-baseline.md#view-and-download-security-settings).

- **Archival of Azure Local, version 22H2 documentation**: [Azure Local, version 22H2 documentation](/previous-versions/azure/azure-local/release-information) is now archived and available in the [Azure previous versions documentation](/previous-versions/azure/) for reference. The archived documentation isn't updated and isn't supported.


::: moniker-end

::: moniker range="=azloc-2505"

There are two 2505 releases for May. Here are the details of each release:

|Solution version  |OS version |Deployment  |
|---------|---------|---------|
|12.2505.1001.23 |  26100.4061        | New deployments only.        |
|11.2505.1001.22  | 25398.1611        | Existing deployments only.        |

For more information, see [Release information summary](./release-information-23h2.md).

## Features and improvements in 2505

This release has the following features and improvements:

- **OS version changes**:

    - In the last release (2504), a new operating system was introduced for Azure Local deployments. For 2505, all the new deployments of Azure Local will run new OS version **26100.4061**. You can download the 2505 OS image from the Azure portal.
    
        You also need to get the driver compatible with Azure Local 12.2505 or Windows Server 2025. If a compatible driver is not available, you can use the 2503 image.

        Existing deployments of Azure Local will continue to use OS version **25398.1611**. For more information, see [Release information summary](./release-information-23h2.md).

    - If you've purchased Integrated System or Premier solution hardware from the [Azure Local Catalog](https://aka.ms/AzureStackHCICatalog) through your preferred Microsoft hardware partner, the OS should be preinstalled. Work with your Original Equipment Manufacturer (OEM) to get the OS image compatible with **12.2505** and driver compatible with Azure Local 12.2505 or Windows Server 2025.

- **.NET updates**: This build uses .NET version **8.0.16** for both .NET Runtime and ASP.NET Core. For more details, see [Download .NET 8.0](https://dotnet.microsoft.com/download/dotnet/8.0).

- **Update changes**: This release includes reliability improvements to the update process. For more information, see [Fixed issues in 2505](./known-issues.md?view=azloc-2505&preserve-view=true#fixed-issues).

- **Ability to upload logs**: You can now upload a Support log package that includes all relevant logs to help Microsoft Support troubleshoot machine issues, directly from the Configurator app. For details, see [Upload the Support log package](./deploy/deployment-arc-register-configurator-app.md#upload-the-support-log-package).

- **Archival of Azure Local, version 22H2 documentation**: The archival of Azure Local, version 22H2 documentation is currently in progress and will be completed soon. Once archived, the articles will be available in the [Azure previous versions documentation](/previous-versions/azure/) for reference. The archived documentation isn't updated and isn't supported.

::: moniker-end


::: moniker range="=azloc-2504"

Starting with 2504 release, Microsoft introduced a new versioning schema. There are two 2504 releases for April. Here are the details of each release:

|Solution version  |OS version |Deployment  |
|---------|---------|---------|
|12.2504.1001.20 | 26100.3775        | New deployments only.        |
|11.2504.1001.19  | 25398.1551        | Existing deployments only.        |

For more information, see [Release information summary](./release-information-23h2.md).

## Features and improvements in 2504

This release has the following features and improvements:

- **OS version changes**:
    - Starting 2504, all new Azure Local deployments use a new operating system (OS) version **26100.3775**. You can download the 2504 OS image from the Azure portal. You also need to get the driver compatible with Azure Local 12.2504 or Windows Server 2025. Existing deployments continue to use the OS version **25398.1551**. For more information, see [Release information summary](./release-information-23h2.md).
    - If you've purchased Integrated System or Premier solution hardware from the [Azure Local Catalog](https://aka.ms/AzureStackHCICatalog) through your preferred Microsoft hardware partner, the OS should be preinstalled. Work with your Original Equipment Manufacturer (OEM) to get the OS image compatible with **12.2504** and driver compatible with Azure Local 12.2504 or Windows Server 2025.

- **.NET update installations improvements**:
  - Increased reliability of .NET security update installations.

- **Registration and deployment changes**:
    - Starting with this release, you can download a specific version of Azure Local software instead of just the latest version. For each upcoming release, you can choose from up to last six supported versions. For more information, see [Download Azure Local software](./deploy/download-23h2-software.md).
    - The error logging in the registration script is enhanced.
    - Proxy bypass list is now mandatory if a proxy configuration is specified.

- **Security changes**: The Dynamic Root of Trust for Measurement (DRTM) is enabled by default for all new 2504 deployments running OS version **26100.3775**. For more information, see [Security features for Azure Local](./concepts/security-features.md#security-features-for-azure-local).

- **Azure Local VM changes**:
    - **Data disk expansion**: With this release, you can expand the size of a data disk attached to an Azure Local VM. For more information, see [Expand the size of a data disk attached to an Azure Local VM](./manage/manage-arc-virtual-machine-resources.md).
    - **Live VM migration with GPU partitioning (GPU-P)**: You can now live migrate VMs with GPU-P. These VMs must be on the latest NVIDIA virtual GPU v18 drivers to enable live migration with GPU-P. For more information, see [Microsoft Azure Local - NVIDIA Docs](https://docs.nvidia.com/vgpu/18.0/grid-vgpu-release-notes-microsoft-azure-stack-hci/index.html).
    - **Documentation changes**: An article describing a [Comparison of the management capabilities of VMs on Azure](./concepts/compare-vm-management-capabilities.md) was released recently.

- **Update improvements**:
    - Improved reliability when downloading updates.
    - Added a health check to ensure failover cluster nodes are healthy before starting the update.
    - Simplified the Azure portal experience for viewing the progress and history of update runs.

- **Add and repair node changes**:
    - For Microsoft images, download the OS image matching the solution version of your existing cluster. See the [Release table](https://github.com/Azure-Samples/AzureLocal/blob/main/os-image/os-image-tracking-table.md) for the correct version. For OEM images, contact your OEM.

- **OEM license changes**:
    
    - **OEM license renamed**: Azure Stack HCI OEM license is now known as OEM license for Azure Local. For more information, see [OEM license overview](./oem-license.md) and [OEM license and billing FAQ](./license-billing.yml).
    - **OEM license with Windows Server 2025 guest VMs**: With the release of 2504, OEM license for Azure Local will be available with Windows Server 2025 guest VMs. This integrates essential services for your cloud infrastructure: Azure Local, and Windows Server Datacenter 2025 Guest rights.

- **Solution extension improvements**:
    - Improved error message to fix firewall blocking access to solution extension manifest endpoints.
    - Improved reliability of copying solution extension content locally to each machine.
    - Added specification of plug-in name in the solution extension.

- **Billing changes**: For deployments running solution version 12.2504.1001.20 and later, the usage record originates from the Azure Local resource in Azure directly. For more information, see [Billing and payment](./concepts/billing.md#billing-changes-for-122504100120-and-later).

- **Archival of Azure Local, version 22H2 documentation**: The documentation for version 22H2 will be archived by May 31, 2025 and will be available in the [Azure previous versions documentation](/previous-versions/azure/) for reference. The archived documentation isn't updated and isn't supported.

- **Observability changes**: You can now automatically collect, analyze, and debug Azure services crashes with the crash dump collection feature in Azure Local. For more information, see [Crash dump collection](./concepts/observability.md#crash-dump-collection).

::: moniker-end

::: moniker range="=azloc-2503"

## Features and improvements in 2503


This release has the following features and improvements:

- **Preview availability of Azure Government cloud** - Azure Local is now available in the US Government regions in preview. Download the latest Azure Stack HCI OS image for Azure Government from [OS image](https://aka.ms/hcireleaseimage). For more information on where Azure Government is supported, see [Azure Local supported regions](./concepts/system-requirements-23h2.md#azure-requirements).

    The following preview features aren't supported for Azure Local in Azure Government cloud:

  - [Azure Arc Gateway](./deploy/deployment-azure-arc-gateway-overview.md).
  - [Deploy using local identity with Key Vault](./deploy/deployment-local-identity-with-key-vault.md).
  - [Azure Site Recovery](./manage/azure-site-recovery.md).
  - [Windows Admin Center in Azure portal](/windows-server/manage/windows-admin-center/azure/manage-vm).

- **Registration and deployment changes**
  - **Extension installation**: Extensions are no longer installed during the registration of Azure Local machines. Instead, the extensions are installed in the machine validation step during the Azure Local instance deployment. For more information, see [Register with Azure Arc via console](./deploy/deployment-arc-register-server-permissions.md) and [Deploy via Azure portal](./deploy/deploy-via-portal.md).
  - **Register via app**: You can bootstrap your Azure Local machines using the Configurator app. The local UI is now deprecated. For more information, see [Register Azure Local machines using Configurator app](./deploy/deployment-arc-register-configurator-app.md).
    - Composed image is now supported for Original Equipment Manufacturers (OEMs).
    - Several security enhancements were done for the Bootstrap service.
    - Service Principal Name (SPN) is deprecated for Arc registration.

  - **Deployment of current version and previous versions**: Starting with this release, you can deploy the current version of Azure Local using the Azure portal. To deploy a previous version, use an Azure Resource Manager template that matches the version you wish to deploy. For more information, see [Deploy via ARM template](./deploy/deployment-azure-resource-manager-template.md).

- **Environment checker related changes**
  - Environment checker is now integrated for connectivity tests.
  - Environment checker validates the composed image used for bootstrap.
  - Environment checker validates PowerShell modules as per the validated solution recipe in the Pre-Update checks.

- **Updates and upgrade improvements**
  - The Solution Builder Extension update now supports both supported and nonsupported SKUs for a given model.
  - A tag is added to indicate whether an update is the latest or is superseded.
  - HTTP content is now downloaded using a more resilient service (Download Service).
  - OS content is packaged with the release, rather than determining applicable content on the device at runtime. This change is aimed to minimize failure points and support [Importing content](update/update-via-powershell-23h2.md#step-3-import-and-rediscover-updates).
  - OS content is installed using the CAU plug-ins that are shipped with OS.
  - Azure Local rebranding changes were made for this update.
  - OS update components for Azure Local are distributed as a static payload, so you can import and discover update packages with limited connectivity to Azure. For more information, see [Import and discover updates with limited connectivity](./update/import-discover-updates-offline-23h2.md).

- **Azure Local VM changes**: You can now connect to an Azure Local VM using the SSH/RDP protocol without the need for line of sight (inside the host network). For more information, see [Connect to an Azure Local VM using SSH](./manage/connect-arc-vm-using-ssh.md).

- **Add and repair node changes**: Starting with this release, you must use the OS image of the same solution version as that running on the existing cluster. For more information on the OS image, see [Add a node](./manage/add-server.md) and [Repair a node](./manage/repair-server.md). 

- **What's new for migration**: Documentation for improvements and features for VM migration to Azure Local is now available. For more information, see [What's new in migration](./migrate/migrate-whats-new.md).


::: moniker-end

::: moniker range="=azloc-24113"

## Features and improvements in 2411.3

This release has the following features and improvements:

- **Quality updates** - This build contains the latest quality updates and is based off the Operating system version 25398.1425.
- **Updated .NET version** - This build has an updated .NET version 8.0.13.
- **New Lifecycle Manager version** - Lifecycle Manager version 30.2503.0.854 is released to deploy the 2411.3 build. This new version moves the content download from extension installation to a visible step in validation. This reduces the overall content download size from a per machine to a one-time download.

For more information on improvements in this release, see the [Fixed issues in 2411.3](./known-issues.md?view=azloc-24113&preserve-view=true#fixed-issues).

::: moniker-end

::: moniker range="=azloc-24112"

## Features and improvements in 2411.2

This is a baseline release with the following features and improvements:

- **Azure Local VMs** - Here are the improvements made to VMs in this release:
    - **Azure Marketplace images**: Three new Azure Marketplace images are available in addition to the existing images. For more information, see the [List of Azure Marketplace images supported for VMs](./manage/virtual-machine-image-azure-marketplace.md#create-azure-local-vm-image-using-azure-marketplace-images).
    - **Live migration**: Live migration is available for Azure Local VMs via on-premises tools. For more information, see [Live migration of Azure Local VMs](./manage/manage-arc-virtual-machines.md#conduct-live-migration-of-azure-local-vms).

- **4-node switchless support documentation** - Documentation for 4-node switchless is now available. For more information, see [4-node switchless support](./plan/four-node-switchless-two-switches-two-links.md).

For more information on improvements in this release, see the [Fixed issues in 2411.2](./known-issues.md?view=azloc-24112&preserve-view=true#fixed-issues).

::: moniker-end

::: moniker range="=azloc-previous"

## Features and improvements in 2411.1

This release has the following features and improvements:

- **Azure Local VMs** - Starting this release, the deletion for attached resources (network interface, disk) is blocked while the associated Azure Local VM is in creation. For more information, see [Delete a network interface](./manage/manage-arc-virtual-machine-resources.md#delete-a-network-interface) and [Delete a data disk](./manage/manage-arc-virtual-machine-resources.md#delete-a-data-disk).

- **Updates** - In this release, an update precheck is added to ensure that the solution extension content is copied correctly.

- **4-node switchless support** - Starting this release, 4-node switchless is supported for Azure Local.

For more information on improvements in this release, see the [Fixed issues in 2411.1](./known-issues.md?view=azloc-24111&preserve-view=true#fixed-issues-1).

## Features and improvements in 2411

This release has the following features and improvements:

- **Renaming of Azure Stack HCI to Azure Local** - Azure Stack HCI is now a part of Azure Local. Microsoft renamed Azure Stack HCI to Azure Local to communicate a single brand that unifies the entire distributed infrastructure portfolio.

    For more information, see [Renaming Azure Stack HCI to Azure Local](./rename-to-azure-local.md).
- **Azure Local for Small Form Factor (Preview)**- Beginning this release, Azure Local supports a new class of *small* devices with reduced hardware requirements. These low cost devices are suitable for edge scenarios across the industry horizontals. The devices must meet the Windows Server certification requirements and relaxed requirements from Software Defined Data Center (SDDC) and Windows Server Software-Defined (WSSD) program.

    For more information about this Preview feature, see [System requirements for Azure Local for small form factor (Preview)](./concepts/system-requirements-small-23h2.md).
- **Azure Local for disconnected operations (Preview)** - Azure Local is now available for disconnected operations. Disconnected operations for Azure Local enable the deployment and management of Azure Local instances without a connection to the Azure public cloud.

    This feature allows you to build, deploy, and manage virtual machines (VMs) and containerized applications using select Azure Arc-enabled services from a local control plane, providing a familiar Azure portal and CLI experience.

    For more information about this Preview feature, see [Azure Local for Disconnected Operations (Preview)](./manage/disconnected-operations-overview.md).
- **Deploy Azure Local with Local Identity (Preview)** - Starting this release, you can deploy Azure Local using Local identity with Azure Key Vault. By integrating with Key Vault and using certificate-based authentication, security posture is enhanced and operations continuity is ensured. This approach offers minimal edge infrastructure, a secure secret store, and simplified management by consolidating secrets in a single vault. Additionally, it streamlines deployment by eliminating dependencies on Active Directory systems and simplifying firewall configurations.

    For more information about this Preview feature, see [Deploy Azure Local with Local Identity and Azure Key Vault (Preview)](./deploy/deployment-local-identity-with-key-vault.md).

- **Azure Local VM changes**: The following changes were made to Azure Local VM management:
    - **Terraform templates for Azure Local VM** - Starting this release, you can create logical networks and Azure Local VMs using Terraform templates.
    
        For more information, see [Template to create logical networks](https://registry.terraform.io/modules/Azure/avm-res-azurestackhci-logicalnetwork/azurerm/0.4.0) and [Template to create Azure Local VMs](https://registry.terraform.io/modules/Azure/avm-res-azurestackhci-virtualmachineinstance/azurerm/0.1.2).
    - **Add network interface on static logical network** - After the Azure Local VMs are provisioned, you can now add a network interface on a static logical network. To add this network interface, you're required to configure the desired static IP from within the VM.
        
        For more information, see [Add a network interface on your Azure Local](./manage/manage-arc-virtual-machine-resources.md#add-a-network-interface).

    - **Download data disks** - Beginning this release, you can download an Azure managed disk from Azure to your Azure Local instance. You use this disk to create an Azure Local VM image or attach the image to your VMs as needed.
  
        For more information, see [Download data disks from Azure to Azure Local](./manage/manage-data-disks.md).

- **Security improvements** - Starting this release, the security posture of Azure Local is enhanced with the following improvements:

  - **Security posture following Azure Stack HCI, version 22H2 to Azure Local upgrade** - Warnings and guardrails were added in the upgrade flow. Documentation was also updated to reflect the security posture of Azure Local after upgrading from version 22H2.
  
    For more information, see [Manage security after upgrading Azure Local from version 22H2](./manage/manage-security-post-upgrade.md).

  - **Improved security baseline compliance** - Starting this release, the security settings on the Azure Local nodes are compared against the security baseline with full accuracy. On the right secured-core hardware, you achieve a 99% compliance score, which you can view in the Azure portal.
  
    For more information, see [View security baseline compliance in the Azure portal](./manage/manage-secure-baseline.md#view-security-baseline-compliance-in-the-azure-portal).

- **Error-Correcting Code (ECC) memory requirements** - Beginning this release, the ECC memory requirements are enforced. If you can't meet the memory and ECC requirements, you can opt for a virtual deployment.

    For more information, see [System requirements for Azure Local](./concepts/system-requirements-23h2.md).

- **AKS on Azure Local** - This release has several new features and enhancements for AKS on Azure Local. For more information, see [What's new in AKS on Azure Local](/azure/aks/hybrid/aks-whats-new-23h2).

## Features and improvements in 2408.2

This release has the following features and improvements:

- **Azure Local VM management improvements**: Starting with this release, following improvements were made to the Azure Local VM management experience:

  - You can set a proxy configuration for Azure VMs on the Portal.
  - You can set a SQL Server configuration for Azure VMs on Portal.
  - You can now create an image from an Azure VM's OS disk.
  - You can now select the virtual switch of a logical network from a dropdown menu.

## Features and improvements in 2408.1

This release has the following features and improvements:

- **Environment checker improvements**: Starting in this release, a new validator was added in the environment checker that checks all storage adapters in each of the nodes.
- **Install module version numbers**: Starting in this release, the install module version numbers for *Az.Accounts*, *Az. Resources*, and *Az.ConnectedMachine* were changed. For more information, see [Register machines with Azure Arc](./deploy/deployment-arc-register-server-permissions.md#register-machines-with-azure-arc).
- **Azure Local VM Management**: Starting in this release, you can attach or detach GPUs to an Azure Local VM via CLI for GPU-P (preview) and DDA (preview). For more information, see:
  - [Prepare GPUs for Azure Local (preview)](./manage/gpu-preparation.md)
  - [Manage GPUs using partitioning for Azure Local (preview)](./manage/gpu-manage-via-partitioning.md)
  - [Manage GPUs via Discrete Device Assignment for Azure Local (preview)](./manage/gpu-manage-via-device.md)
- **Improved CLI error messages** for deletion of VM network interfaces, data disks, and storage paths that are in use.
- **Improved reliability** when installing open ssh client during solution deployment.

## Features and improvements in 2408

This is a baseline release with the following features and improvements:

### Upgrade from Azure Stack HCI, version 22H2 to Azure Local 

This release introduces the ability to upgrade your Azure Stack HCI from version 22H2 to Azure Local. The upgrade process is supported for clusters running version 22H2 with the latest updates and is a two-step process. While the OS upgrade is generally available, the solution upgrade has a phased rollout.

For more information, see [Upgrade Azure Local from version 22H2](./upgrade/about-upgrades-23h2.md).

### Updates changes

This release contains the following changes for updates:

- Revised the names and descriptions of update steps. 
- Introduced a health fault alert that is raised when there are available updates on the system. 

### Azure Local VM management changes

This release contains the following changes for Azure Local VM management:

- 12 new Azure Marketplace images went live. For more information, see [Create Azure Local VM from Azure Marketplace images via Azure CLI](./manage/virtual-machine-image-azure-marketplace.md#create-vm-image-from-marketplace-image).
- Creation of logical networks is blocked if trying to create with overlapping IP pools.
- Logical network properties are properly updated. Previously, the logical network sometimes wouldn't have its properties (vLAN, IP Pools, etc.) filled.
- The vLAN field on a logical network defaults to '0' if not specified.
- Either (not both) *-image* or *-os-disk-name* can be used to create a VM from a VHD. Previously, Azure CLI enforced *-image* to be required for `az stack-hci-vm create` command.

For more information, see the [Fixed issues list in 2408](./known-issues.md?view=azloc-2408&preserve-view=true#fixed-issues-5).

### SBE changes

This release contains the following changes for SBE:

- **Reduced deployment times**: Starting in this release, SBE extension interfaces are executed more efficiently leading to reduced Azure Local deployment times.
- **CAU plugin**: Starting in this release, SBE extensions use an updated CAU plugin that enhances support for host OS driver updates, addressing issues with drivers newer than those in the SBE. This plugin update provides hardware vendors more flexibility for driver version updates in support cases. Microsoft recommends installing host OS driver updates only through your hardware vendor's SBE.
- **Improved error details**: Starting in this release, hardware vendor SBE failures or exceptions include the SBE publisher, family, and version at the beginning of the exception string. Provide this information to your hardware vendor to streamline the failure analysis.

## Features and improvements in 2405.3

This is primarily a bug fix release. See the [Fixed issues list](./known-issues.md?view=azloc-previous&preserve-view=true) to understand the bug fixes.

## Features and improvements in 2405.2

This is primarily a bug fix release with a few improvements.

- Azure Local VM management improvements: Starting this release, following improvements were made to the Azure Local VM management experience:

  - You can now view and delete VM network interfaces from the Azure portal.
  - You can view **Connected devices** for logical networks. In the Azure portal, you can go to the logical network and then go to **Settings > Connected devices** to view the connected devices.
  - Deletion of logical networks is blocked if connected devices are present. When you try to delete a logical network from the Azure portal that has connected devices, you see a warning message: *Can't delete logical network because it's currently in use*. Delete all the resources under **Connected Devices** setting before you delete the logical network.
  - From this release onwards, a new URL needs to be added to the allowlist for `stack-hci-vm` Azure CLI installation. The URL has changed from: `https://hciarcvmsstorage.blob.core.windows.net/cli-extension/stack_hci_vm-{version}-py3-none-any.whl` to: `https://hciarcvmsstorage.z13.web.core.windows.net/cli-extensions/stack_hci_vm-{version}-py3-none-any.whl`. For more information, see [Azure Local firewall requirements](./concepts/firewall-requirements.md).
  
- **Update health checks**: Starting this release, a new health check was added and the update service was improved. Additionally, the update service now supports the ability to view or start new updates when the service crashes on machines. Also, multiple issues for health checks related to Azure Update Manager and Solution Builder Extension Update were fixed.

  For more information, see [Fixed issues in 2405.2](./known-issues.md?view=azloc-previous&preserve-view=true).

- **Azure Stack HCI OEM license**: Starting this release, we are introducing the Azure Stack HCI OEM license designed for Azure Local hardware including the Azure Local Premier Solutions, Integrated systems, and Validated Nodes. This license remains valid for the lifetime of the hardware, covers up to 16 cores, and includes three essential services for your cloud infrastructure.

  For more information, see [Azure Stack HCI OEM license overview](./oem-license.md) and [Azure Stack HCI OEM license and billing FAQ](./license-billing.yml).

## Features and improvements in 2405.1

This is primarily a bug fix release with a few improvements.

- **Custom storage IPs for add and repair server scenarios**: Starting this release, it's possible to add machines or repair machines to the Azure Local instance using custom IPs for the storage intent network adapters.
- **Improved outbound connectivity check**: Starting this release, improvements were made to the outbound connectivity requirement validation in the environment checker.
- **Reliability improvements** were made in this release for partner health checks implemented in their Solution Builder Extensions.
- **Rotation of Arc Resource Bridge service principal credentials**: Starting this release, you can rotate the service principal credentials used by Azure Arc resource bridge.
- **Multiple bug fixes related to Updates** were made in this release.

For more information on bug fixes, see the [Fixed issues list](./known-issues.md?view=azloc-previous&preserve-view=true).

## Features and improvements in 2405

Here are the features and improvements in this release.

### Deployment changes


- **Active Directory integration** - In this release, an issue related to the use of a large Active Directory that results in timeouts when adding users to the local administrator group, is fixed. <!--27022398-->

- **New Azure Resource Manager (ARM) template** - This release has a new ARM template for deployment that simplifies the resource creation dependencies. The new template creation also includes multiple fixes around the missing mandatory fields. <!--26376120-->

- **Secret rotation improvements** - In this release, improvements were made to the secret rotation flow.
  - The secret rotation PowerShell command `Set-AzureStackLCMUserPassword` now supports a new parameter to skip the confirmation message. This parameter is useful when automating secret rotation. <!--27101544-->
  - Reliability improvements were made around the services not restarting in a timely manner. <!--27837538-->

- **Solution Builder Extension (SBE) improvements** include:
  - A new PowerShell command to update the Solution Builder Extension partner property values is provided at the time of deployment. <!--25093172-->
  - Fixing an issue that prevents the update service to respond to requests after a Solution Builder Extension only update run. <!--27940543-->

- **Add server and Repair server fixes** include:
  - An issue that prevents a node from joining Active Directory during the add server operation. <!--27101597-->
  - Enabling deployment when a disjoint namespace is used.

- **Reliability enhancements** include:
  - Changes for Network ATC when setting up the host networking configuration with certain network adapter types. <!--27285196-->
  - Changes when detecting the firmware versions for disk drives. <!--27395303-->

- This release contains a fix for a deployment issue that is encountered when setting the diagnostic level in Azure and the device. <!--26737110-->

For more information, see the [Fixed issues list in 2405](./known-issues.md?view=azloc-previous&preserve-view=true).

### Updates changes

This release contains the following changes for updates:

- Starting this release, an adjusted naming schema is introduced for updates. This schema allows for the identification of feature versus cumulative updates. <!--26952963-->

- This release contains reliability improvements:
  - For the update notifications for health check results sent from the device to Azure Update Manager. In certain instances, the message size was too large and results weren't shown in the Update Manager. <!--27230554-->
  - For reporting the cluster update progress to the orchestrator.

- This release has bug fixes for various issues including:

  - A file lock issue that could cause update failures for the trusted launch VM agent (IGVM). <!--27689489-->
  - An issue that prevented the orchestrator agent from restarting during an update run. <!--27726586-->
  - A rare condition where the update service took a long time to discover or start an update. <!--27745420-->
  - An issue for Cluster-Aware Updating (CAU) interaction with the orchestrator when an update in progress is reported by CAU. <!--26805746-->

For more information, see the [Fixed issues list in 2405](./known-issues.md?view=azloc-previous&preserve-view=true).

### Environment checker changes

In this release, changes to the environment checker include several new checks:

- A new check is added to ensure the inbox drivers on the physical network adapters aren't in use. The provided OEM or manufacturer latest drivers must be installed before deployment.
- A new check is added to ensure the link speed across physical network adapters on the same intent is identical.
- A new check is added to ensure RDMA is operational on the storage network adapters before deployment.
- A new check is added to validate the infrastructure IP addresses defined during deployment have outbound connectivity and can resolve the DNS.
- A new check is added to ensure the DNS server value isn't empty on the management IP address.
- A new check is added to make sure that there's only one IP address on the management network adapter.
- A new check is added to ensure that the minimum bandwidth required for RDMA storage adapters is at least 10 Gb.
- Check that the uplink connectivity in any physical network adapters assigned to Network ATC intents is up.
- Improved the ability to handle adapters that don't expose the VLAN ID field correctly.

### Observability changes

This release contains the following improvements to observability:

- When starting a log collection, a warning message now advises you to limit the log collection to 24 hours.
- Deployment logs are automatically collected by default.
- The newly added `Test-observability` feature validates whether the telemetry and diagnostic data can be successfully sent to Microsoft.

### Azure Local VM management changes

- This release contains new documentation that provides guidance on VM image creation starting with a CentOS image or a Red Hat Enterprise Linux (RHEL) image. For more information, see:
  - [Prepare CentOS Linux image for Azure Local virtual machines (preview)](./manage/virtual-machine-image-centos.md).
  - [Prepare Red Hat Enterprise image for Azure Local virtual machines (preview)](./manage/virtual-machine-image-red-hat-enterprise.md).

### Azure portal, extensions, and resource provider changes

Here are the changes related to the Azure portal, extensions, and resource providers:

- In this release, an issue was fixed that prevented from showing a failed deployment in the Cluster overview when the deployment was canceled.
- The **Retry** button in Azure portal is renamed to **Resume** as the deployment continues from the step that it failed.
- The new clusters deployed in this release have resource locks enabled to protect against accidental deletion.
- This release changes the behavior to not delete the Arc-enabled server resources when the Azure Local resource is deleted.

### Security changes

This release includes the following updates to the security documentation:

- The compliance score for Azure Local machine is 281 out of 288 rules even when all the hardware requirements for Secured-core are met. The [View security baseline compliance in the Azure portal](./manage/manage-secure-baseline.md#view-security-baseline-compliance-in-the-azure-portal) section now explains the noncompliant rules and the reasons for the current gap.
- The Security Baselines settings have been updated to 315 settings, including six removals and 1 addition. To view and download the complete list of security settings, see [Security Baseline](https://github.com/Azure-Samples/AzureStackHCI/blob/main/security/SecurityBaseline_2405.csv).
- Updated the [Application Control](./concepts/security-features.md#application-control) section in the [Security features for Azure Local](./concepts/security-features.md) article.

### Azure Kubernetes Service on Azure Local

For a list of the changes and improvements in AKS on Azure Local, see [What's new in Azure Kubernetes on Azure Local?](/azure/aks/hybrid/aks-whats-new-23h2).



## Features and improvements in 2402.4

This is primarily a bug fix release. See the [Fixed issues list](./known-issues.md?view=azloc-previous&preserve-view=true) to understand the bug fixes.

## Features and improvements in 2402.3

This is primarily a bug fix release. See the [Fixed issues list](./known-issues.md?view=azloc-previous&preserve-view=true) to understand the bug fixes.

## Features and improvements in 2402.2

This is primarily a bug fix release with a few enhancements. See the [Fixed issues list](./known-issues.md?view=azloc-previous&preserve-view=true) to understand the bug fixes. Here's the list of enhancements:

- **Region expansion** - The following new regions are now supported on your Azure Local instance: Southeast Asia, India Central, Canada Central, Japan East, and South Central US. For more information, see [Azure Local supported regions](./concepts/system-requirements-23h2.md#azure-requirements).
- **Deployment changes** - A permission check was added to the Azure portal deployment experience to check for sufficient permissions. For more information, see [Deploy via Azure portal](./deploy/deploy-via-portal.md).
- **Update changes** - A notification banner was included in the update experience that informs you when the new updates are available. For more information, see [Update your Azure Local instance via the Azure Update Manager](./update/azure-update-manager-23h2.md).

## Features and improvements in 2402.1

This is primarily a bug fix release. See the [Fixed issues list](./known-issues.md?view=azloc-previous&preserve-view=true) to understand the bug fixes.

## Features and improvements in 2402

This section lists the new features and improvements in the 2402 release of Azure Local.

### New built in security role

This release introduces a new Azure built-in role called Azure Resource Bridge Deployment Role, to harden the security posture for Azure Local. If you provisioned a cluster before January 2024, then you must assign the **Azure Resource Bridge Deployment User** role to the Azure Resource Bridge principal.

The role applies the concept of least amount of privilege and must be assigned to the service principal: *clustername.arb* before you update the cluster.

To take advantage of the constraint permissions, remove the permissions that were applied before. Follow the steps to [Assign an Azure RBAC role via the portal](/azure/role-based-access-control/role-assignments-portal?tabs=delegate-condition). Search for and assign the Azure Resource Bridge Deployment role to the member: `<deployment-cluster-name>-cl.arb`.

An update health check is also included in this release that confirms that the new role is assigned before you apply the update.

### Changes to Active Directory preparation

Beginning this release, the Active Directory preparation process is simplified. You can use your own existing process to create an Organizational Unit (OU), a user account with appropriate permissions, and with Group policy inheritance blocked for the Group Policy Object (GPO). You can also use the Microsoft provided script to create the OU. For more information, see [Prepare Active Directory](./deploy/deployment-prep-active-directory.md).

### Region expansion

Azure Local solution is now supported in Australia. For more information, see [Azure Local supported regions](./concepts/system-requirements-23h2.md#azure-requirements).

### New documentation for network considerations

We're also releasing new documentation that provides guidance on network considerations for the cloud deployment of Azure Local. For more information, see [Network considerations for Azure Local](./plan/cloud-deployment-network-considerations.md).

### Security changes

This release includes the following updates to the security documentation:

- Updated the documentation for [Manage system security with Microsoft Defender for Cloud (preview)](./manage/manage-security-with-defender-for-cloud.md).
- Updated the Security Baselines settings to 320 settings, including one removal, three additions, and one change about disabling Dynamic Root of Measurement (DRTM) for new deployments. To view and download the complete list of security settings, see [Security Baseline](https://github.com/Azure-Samples/AzureStackHCI/blob/main/security/SecurityBaseline_2402.csv).
- Published the [Azure Local security book](https://assetsprod.microsoft.com/mpn/azure-stack-hci-security-book.pdf).


## Features and improvements in 2311.5

This is primarily a bug fix release. See the [Fixed issues list](./known-issues.md?view=azloc-previous&preserve-view=true) to understand the bug fixes.

## Features and improvements in 2311.4

This is primarily a bug fix release. See the [Fixed issues list](./known-issues.md?view=azloc-previous&preserve-view=true) to understand the bug fixes.

## Features and improvements in 2311.3

A new Azure built-in role called **Azure Resource Bridge Deployment Role** is available to harden the security posture for Azure Local. If you provisioned a cluster before January 2024, then you must assign the Azure Resource Bridge Deployment User role to the Arc Resource Bridge service principal.

The role applies the concept of the least amount of privilege and must be assigned to the Arc Resource Bridge service principal, `clustername.arb`, before you update the cluster.

You must remove the previously assigned permissions to take advantage of the constraint permission. Follow the steps to [Assign an Azure RBAC role via the portal](/azure/role-based-access-control/role-assignments-portal?tabs=delegate-condition). Search for and assign the Azure Resource Bridge Deployment role to the member: `<deployment-cluster-name>-cl.arb`.

Additionally, this release includes an update health check that confirms the assignment of the new role before applying the update.

## Features and improvements in 2311.2 GA

This section lists the new features and improvements in the 2311.2 General Availability (GA) release for Azure Local.

> [!IMPORTANT]
> The production workloads are only supported on the Azure Local systems running the generally available 2311.2 release. To run the GA version, start with a new 2311 deployment and then update to 2311.2.

In this generally available release of the Azure Local, all the features that were available with the [2311](#features-and-improvements-in-2311) preview releases are also now generally available. In addition, the following improvements and enhancements are available:

### Deployment changes

With this release:

- Deployment is supported using existing storage accounts.
- A failed deployment can be run using the **Rerun deployment** option that becomes available in the cluster **Overview** page.
- Network settings such as storage traffic priority, cluster traffic priority, storage traffic bandwidth reservation, jumbo frames, and RDMA protocol can all be customized.
- Validation must be started explicitly via the **Start validation** button.

For more information, see [Deploy via Azure portal](./deploy/deploy-via-portal.md).

### Add server and repair server changes

- Bug fixes in the Add server and Repair server scenarios. For more information, see the [Fixed issues in 2311.2](./known-issues.md?view=azloc-previous&preserve-view=true).

### Azure Local VM management changes

In this release:

- Guest management is available via Azure CLI. For more information, see [Enable guest management](./manage/manage-arc-virtual-machines.md).
- Proxy is supported for Azure Local VMs. For more information, see [Set up proxy for Azure Local VMs](./manage/create-arc-virtual-machines.md#create-a-vm-with-proxy-configured).
- Storage path selection is available during the Azure Local VM image creation via the Azure portal. For more information, see [Create an Azure Local VM image from Azure Marketplace via the Azure portal](./manage/virtual-machine-image-azure-marketplace.md).

### Migration of Hyper-V VMs to Azure Local (preview)

You can now migrate Hyper-V VMs to Azure Local using Azure Migrate. This feature is currently in Preview. For more information, see [Migration of Hyper-V VMs using Azure Migrate to Azure Local (preview)](./migrate/migration-azure-migrate-overview.md).

### Monitoring changes

In the Azure portal, you can now monitor platform metrics of your cluster by navigating to the **Monitoring** tab on your cluster's **Overview** page. This tab offers a quick way to view graphs for different platform metrics. You can select any graph to open it in Metrics Explorer for a more in-depth analysis. For more information, see [Monitor Azure Local through the Monitoring tab](./manage/monitor-cluster-with-metrics.md#monitor-azure-local-through-the-monitoring-tab).

### Security via Microsoft Defender for Cloud (preview)

You can now use Microsoft Defender for Cloud to help improve the security posture of your Azure Local environment and protect against existing and evolving threats. This feature is currently in Preview. For more information, see [Microsoft Defender on Cloud for Azure Local (Preview)](./manage/manage-security-with-defender-for-cloud.md).

### Supported workloads

Starting with this release, the following workloads are generally available on Azure Local:

- Azure Kubernetes Service (AKS) on Azure Local. For more information, see [Create Kubernetes clusters](/azure/aks/hybrid/aks-create-clusters-cli).

    In addition, AKS on HCI has a new CLI extension and Azure portal experience, [Support for logical networks](/azure/aks/hybrid/aks-networks), [Support for taints and labels](/azure/aks/hybrid/cluster-labels), [Support for upgrade via Azure CLI](/azure/aks/hybrid/cluster-upgrade), [Support for Nvidia A2](/azure/aks/hybrid/deploy-gpu-node-pool?pivots=aks-23h2) and more. For details, see [What's new in AKS on Azure Local?](/azure/aks/hybrid/aks-whats-new-23h2).

- Azure Virtual Desktops (AVD) on Azure Local. For more information, see [Deploy AVD on Azure Local](/azure/virtual-desktop/azure-stack-hci-overview).

## Features and improvements in 2311

This section lists the new features and improvements in the 2311 release of Azure Local. Additionally, this section includes features and improvements that were originally released for 2310 starting with cloud-based deployment.


### Cloud-based deployment

For machines running Azure Local, release 2311.2, you can perform new deployments via the cloud. You can deploy an Azure Local instance in one of the two ways - via the Azure portal or via an Azure Resource Manager deployment template.

For more information, see [Deploy Azure Local instance using the Azure portal](./deploy/deploy-via-portal.md) and [Deploy Azure Local via the Azure Resource Manager deployment template](./deploy/deployment-azure-resource-manager-template.md).

### Cloud-based updates

This new release has the infrastructure to consolidate all the relevant updates for the OS, software agents, Azure Arc infrastructure, and OEM drivers and firmware into a unified monthly update package. This comprehensive update package is identified and applied from the cloud through the Azure Update Manager tool. Alternatively, you can apply the updates using the PowerShell.

For more information, see [Update your Azure Local instance via the Azure Update Manager](./update/azure-update-manager-23h2.md) and [Update your Azure Local via the PowerShell](./update/update-via-powershell-23h2.md).​

### Cloud-based monitoring

#### Respond to health alerts

This release integrates the Azure Monitor alerts with Azure Local so that any health alerts generated within your on-premises Azure Local system are automatically forwarded to Azure Monitor alerts. You can link these alerts with your automated incident management systems, ensuring timely and efficient response.

For more information, see [Respond to Azure Local health alerts using Azure Monitor alerts](./manage/health-alerts-via-azure-monitor-alerts.md).

#### Monitor metrics

This release also integrates the Azure Monitor metrics with Azure Local so that you can monitor the health of your Azure Local system via the metrics collected for compute, storage, and network resources. This integration enables you to store cluster data in a dedicated time-series database that you can use to analyze data from your Azure Local system.

For more information, see [Monitor Azure Local with Azure Monitor metrics](./manage/monitor-cluster-with-metrics.md).

#### Enhanced monitoring capabilities with Insights

With Insights for Azure Local, you can now monitor and analyze performance, savings, and usage insights about key Azure Local features, such as ReFS deduplication and compression. To use these enhanced monitoring capabilities, ensure that your cluster is deployed, registered, and connected to Azure, and enrolled in monitoring. For more information, see [Monitor Azure Local features with Insights](./manage/monitor-features.md).

### Azure Local VM management

Beginning this release, the following Azure Local VM management capabilities are available:

- **Simplified Azure Arc resource bridge deployment**. The Azure Arc resource bridge is now deployed as part of the Azure Local deployment.
    For more information, see [Deploy Azure Local instance using the Azure portal](./deploy/deploy-via-portal.md).
- **New RBAC roles for Azure Local VMs**. This release introduces new RBAC roles for Azure Local VMs.
    For more information, see [Manage RBAC roles for Azure Local VMs](./manage/assign-vm-rbac-roles.md).
- **New Azure consistent CLI**. Beginning this preview release, a new consistent command line experience is available to create VM and VM resources such as VM images, storage paths, logical networks, and network interfaces. 
    For more information, see [Create Azure Local VMs on Azure Local](./manage/create-arc-virtual-machines.md).
- **Support for static IPs**. This release has the support for static IPs. 
    For more information, see [Create static logical networks on Azure Local](./manage/create-logical-networks.md#create-a-static-logical-network-via-portal).
- **Support for storage paths**. While default storage paths are created during the deployment, you can also specify custom storage paths for your Azure Local VMs.
    For more information, see [Create storage paths on Azure Local](./manage/create-storage-path.md).
- **Support for Azure VM extensions on Azure Local VMs**. Starting with this preview release, you can also enable and manage the Azure VM extensions that are supported on Azure Arc, on Azure Local VMs created via the Azure CLI. You can manage these VM extensions using the Azure CLI or the Azure portal. 
    For more information, see [Manage VM extensions for Azure Local VMs](./manage/virtual-machine-manage-extension.md).
- **Trusted launch for Azure Local VMs**. Azure Trusted Launch protects VMs against boot kits, rootkits, and kernel-level malware. Starting this preview release, some of those Trusted Launch capabilities are available for Azure Local VMs.
    For more information, see [Trusted launch for Azure Local VMs](./manage/trusted-launch-vm-overview.md).

### AKS on Azure Local

Starting with this release, you can run Azure Kubernetes Service (AKS) workloads on your Azure Local system. AKS on Azure Local uses Azure Arc to create new Kubernetes clusters on Azure Local directly from Azure. For more information, see [What's new in AKS on Azure Local?](/azure/aks/hybrid/aks-whats-new-23h2).

The following Azure Kubernetes cluster deployment and management capabilities are available:

- **Simplified infrastructure deployment on Azure Local**. In this release, the infrastructure components of Azure Kubernetes on Azure Local including the Azure Arc resource bridge, custom location, and the Azure Kubernetes Extension for the Azure Kubernetes operator, are all deployed as part of the Azure Local deployment. For more information, see [Deploy Azure Local instance using the Azure portal (preview)](./deploy/deploy-via-portal.md).
- **Integrated infrastructure upgrade on Azure Local**. The whole lifecycle management of Azure Kubernetes infrastructure follows the same approach as the other components on Azure Local. For more information, see [Infrastructure component updates for AKS on Azure Local (preview)](/azure/aks/hybrid/infrastructure-components).
- **New Azure consistent CLI**. Starting with this preview release, a new consistent command line experience is available to create and manage Kubernetes clusters. <!--For more information, see [Azure CLI extension az akshybrid reference](https://learn.microsoft.com/cli/azure/akshybrid).-->
- **Cloud-based management**. You can now create and manage Kubernetes clusters on Azure Local with familiar tools such as Azure portal and Azure CLI. For more information, see [Create Kubernetes clusters using Azure CLI](/azure/aks/hybrid/aks-create-clusters-cli).
- **Support for upgrading a Kubernetes cluster using Azure CLI**. You can use Azure CLI to upgrade the Kubernetes cluster to a newer version and apply the OS version updates. For more information, see [Upgrade an Azure Kubernetes Service (AKS) cluster (preview)](/azure/aks/hybrid/cluster-upgrade).
- **Support for Azure Container Registry to deploy container images**. In this release, you can deploy container images from a private container registry using Azure Container Registry to your Kubernetes clusters running on Azure Local. For more information, see [Deploy from private container registry to on-premises Kubernetes using Azure Container Registry and Azure Kubernetes](/azure/aks/hybrid/deploy-container-registry).
- **Support for managing and scaling the node pools**. For more information, see [Manage multiple node pools in Azure Kubernetes](/azure/aks/hybrid/manage-node-pools).
- **Support for Linux and Windows Server containers**. For more information, see [Create Windows Server containers](/azure/aks/hybrid/aks-create-containers).

### Security capabilities

The new installations with this release of Azure Local start with a *secure-by-default* strategy. The new version has a tailored security baseline coupled with a security drift control mechanism and a set of well-known security features enabled by default. This release provides:

- A tailored security baseline with over 300 security settings configured and enforced with a security drift control mechanism. For more information, see [Security baseline settings for Azure Local](./concepts/secure-baseline.md).
- Out-of-box protection for data and network with SMB signing and BitLocker encryption for OS and Cluster Shared Volumes. For more information, see [BitLocker encryption for Azure Local](./concepts/security-bitlocker.md).
- Reduced attack surface as Windows Defender Application Control is enabled by default and limits the applications and the code that you can run on the core platform. For more information, see [Windows Defender Application Control for Azure Local](./concepts/security-windows-defender-application-control.md).

### Support for web proxy

This release supports configuring a web proxy for your Azure Local system. You perform this optional configuration if your network uses a proxy server for internet access. For more information, see [Configure web proxy for Azure Local](./manage/configure-proxy-settings-23h2.md).

### Removal of GMSA accounts

In this release, the Group Managed Service Accounts (gMSA) created during the Active Directory preparation are removed. For more information, see [Prepare Active Directory](./deploy/deployment-prep-active-directory.md).

<!--### Guest management operations via Azure CLI

In this release, you can perform an extended set of guest management operations via the Azure CLI.-->

### Capacity management

In this release, you can add and remove machines, or repair machines from your Azure Local system via the PowerShell.

For more information, see [Add server](./manage/add-server.md) and [Repair server](./manage/repair-server.md).

### ReFS deduplication and compression

This release introduces the Resilient File System (ReFS) deduplication and compression feature designed specifically for active workloads, such as Azure Virtual Desktop (AVD) on Azure Local. Enable this feature using Windows Admin Center or PowerShell to optimize storage usage and reduce cost.

For more information, see [Optimize storage with ReFS deduplication and compression in Azure Local](./manage/refs-deduplication-and-compression.md).

::: moniker-end

## Next steps

- [Read the blog about What's new for Azure Local at Microsoft Ignite 2024](https://techcommunity.microsoft.com/blog/azurearcblog/introducing-azure-local-cloud-infrastructure-for-distributed-locations-enabled-b/4296017).
- Read the [blog announcing the general availability of Azure Local](https://techcommunity.microsoft.com/t5/azure-stack-blog/azure-stack-hci-version-23h2-is-generally-available/ba-p/4046110).
- For Azure Local deployments:
  - Read the [Deployment overview](./deploy/deployment-introduction.md).
  - Learn how to [Deploy Azure Local via the Azure portal](./deploy/deploy-via-portal.md).