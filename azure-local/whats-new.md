---
title: What's new in Hyperconverged Deployments of Azure Local latest release
description: Find out about the new features and enhancements in the latest Azure Local release for hyperconverged deployments.
ms.topic: overview
author: alkohli
ms.author: alkohli
ms.service: azure-local
ms.date: 02/17/2026
ms.subservice: hyperconverged
---

# What's new in hyperconverged deployments of Azure Local?

This article lists the features and improvements that are available in hyperconverged deployments of Azure Local (*formerly Azure Stack HCI*). The latest version of Azure Local solution focuses on cloud-based deployment and updates, cloud-based monitoring, a new and simplified experience for Azure Local virtual machine (VM) management, security, and more.

::: moniker range="=azloc-2602"

## Features and improvements in 2602

The February 2026 release of hyperconverged deployments of Azure Local is version **12.2602.1007.7**. For more information, see [Release information summary](./release-information-23h2.md).

This release includes various reliability improvements and other bug fixes.

- **OS changes**:

    - In 2602 release, all the new and existing deployments of Azure Local run the new OS version **26100.32370** (download from the Azure portal).

    - You also need a driver that's compatible with OS version **26100.32370** or Windows Server 2025.

    - For Integrated System or Premier solution hardware from the [Azure Local Catalog](https://aka.ms/AzureStackHCICatalog), the OS is preinstalled. Work with your Original Equipment Manufacturer (OEM) to get a compatible OS image and a compatible driver.

- **.NET updates**: This build uses .NET version **8.0.24** for both .NET Runtime and ASP.NET Core. For more information, see [Download .NET 8.0](https://dotnet.microsoft.com/download/dotnet/8.0).

- **Enhanced update workflow from Azure portal**: The update workflow from the Azure portal now provides richer, more detailed information.

- **End of Windows Server Subscription and ESU purchases for OS version 20349.xxxx (22H2)**: Customers running OS version 20349.xxxx (22H2) can no longer purchase Windows Server Subscription or Extended Security Updates (ESU).


::: moniker-end

::: moniker range="=azloc-2601"

## Features and improvements in 2601

The January 2026 release of hyperconverged deployments of Azure Local is version **12.2601.1002.503**. For more information, see [Release information summary](./release-information-23h2.md).
This release includes various reliability improvements and other bug fixes.

- **OS changes**:

    - In 2601 release, all the new and existing deployments of Azure Local run the new OS version **26100.32230** (download from the Azure portal).

    - You also need a driver that's compatible with OS version **26100.32230** or Windows Server 2025.

    - For Integrated System or Premier solution hardware from the [Azure Local Catalog](https://aka.ms/AzureStackHCICatalog), the OS is preinstalled. Work with your Original Equipment Manufacturer (OEM) to get a compatible OS image and a compatible driver.

- Build **12.2601.1002.503** improves system reliability by addressing several bugs across core workflows. If you already deployed or updated to **12.2601.1002.38**, no further action is needed. Both **12.2601.1002.38** and **12.2601.1002.503** are supported builds.
        
- **.NET updates**: This build uses .NET version **8.0.22** for both .NET Runtime and ASP.NET Core. For more information, see [Download .NET 8.0](https://dotnet.microsoft.com/download/dotnet/8.0).

- **Infrastructure logical network surfaced in Azure portal**: The infrastructure logical network created during Azure Local deployment is now visible in the Azure portal. This visibility allows administrators to review the infrastructure network configuration. This change also acts as a safeguard against accidental workload provisioning on the network reserved for Azure Local infrastructure.

    For more information, see [About infrastructure logical network for Azure Local VMs](./manage/manage-logical-networks.md#about-infrastructure-logical-network).

- **VM Connect for Azure Local VMs (Preview)**: Starting with 2601 release, you can connect to Windows and Linux based Azure Local VMs that don't have network connectivity or have boot failures. 

    For more information, see [VM Connect for Azure Local VMs](./manage/connect-arc-vm-using-ssh.md#connect-to-an-azure-local-vm-using-vm-connect-preview).

- **Unique ID for data disks**: In 2601 release, you can identify data disks on your Azure Local instance with a new property called **Unique ID**. The unique ID matches the `UniqueId` of the data disk (`Get-Disk | Select-Object UniqueId`).

- **Rack aware clustering General Availability (GA)**: Rack aware clustering is now generally available. This feature allows you to define local availability zones based on physical racks in your datacenter, enhancing the resilience of your cluster against rack-level failures.

    For more information, see [Rack aware clustering](concepts/rack-aware-cluster-overview.md).

- **Diagnostics log collection in Azure portal**: You can now collect diagnostics logs directly from the Azure portal to help with support investigations. This eliminates the need to manually gather logs from individual nodes.

- **Drift detection for Azure PowerShell modules and Azure Command-line Interface (CLI)**: This release adds the Drift Detection framework, enabling Azure Local to continuously validate component level state against the baseline of approved component versions and configurations. The system detects version mismatches during both deployment and runtime by comparing installed component metadata to that of the baseline. Administrators can manually trigger validation using the `Invoke-AzStackHciVSRDriftDetectionValidation` cmdlet to generate detailed drift reports for build components.

- **Dynamic Root of Trust for Measurement (DRTM) settings for 2504 deployments**: Starting with 2601 release, DRTM is enabled on Azure Local instances deployed prior to 2504, and those instances transition from Static Root of Trust for Measurement (SRTM) to DRTM to defend against the firmware level attacks. New deployments since 2504 have DRTM enabled by default.

    For more information, see [Defend against firmware level attacks](/windows-server/security/secured-core-server#defend-against-firmware-level-attacks).

- **Enable 26100.XXXX (24H2) security baseline for existing Azure Local deployments**: Starting with 2601 release, customers who perform the solution upgrade on an existing deployment can now match the security posture of newly deployed systems (post-upgrade actions) with new cmdlets to apply 26100.XXXX security baseline.

- **Pre-upgrade CredSSP validation**: To ensure successful upgrades, a new pre-upgrade check is added that validates that CredSSP isn't disabled on existing Azure Local instances.

::: moniker-end

::: moniker range="=azloc-2512"

## Features and improvements in 2512

The December 2025 release of hyperconverged deployments of Azure Local is version **12.2512.1002.16**. For more information, see [Release information summary](./release-information-23h2.md).

This release includes various reliability improvements and other bug fixes.

- **OS changes**:

    - The 2504 release introduced a new operating system for Azure Local deployments. From 2512 onwards, all the new and existing deployments of Azure Local run the new OS version **26100.7462**. You can download the 2512 OS image from the Azure portal.

        - You also need a driver that's compatible with OS version **26100.7462** or Windows Server 2025. If a compatible driver isn't available, you can use the 2503 image.

    - If you purchased Integrated System or Premier solution hardware from the [Azure Local Catalog](https://aka.ms/AzureStackHCICatalog) through your preferred Microsoft hardware partner, the OS is preinstalled. Work with your Original Equipment Manufacturer (OEM) to get the OS image that's compatible with **12.2512.1002.16** and a driver that's compatible with OS version **26100.7462** or Windows Server 2025.

- **.NET updates**: This build uses .NET version **8.0.22** for both .NET Runtime and ASP.NET Core. For more information, see [Download .NET 8.0](https://dotnet.microsoft.com/download/dotnet/8.0).

- **Simplified cluster registration during deployment**: Starting with this release, Azure Local cluster deployments don't use a Service Principal Name (Microsoft Entra ID App) with a self-signed certificate. Instead, the cluster uses system-assigned managed identity (SMI) to authenticate itself with Azure.
    For more information, see [Validate and deploy the system via Azure portal](./deploy/deploy-via-portal.md#verify-a-successful-deployment).

- **Support for NVIDIA L-series GPU on AKS on Azure Local (preview)**: Starting with this release, NVIDIA L-series GPU is supported on Azure Kubernetes Service (AKS) enabled by Azure Arc on Azure Local. This preview feature allows you to run GPU-accelerated workloads on AKS clusters deployed on Azure Local using NVIDIA L-series GPUs.

    For more information, see [Azure Kubernetes Service (AKS) enabled by Azure Arc](/azure/aks/aksarc/aks-overview#about-aks-on-azure-local).

- **Documentation updates**: The noteworthy changes include the following new articles or articles with major updates:
    - [SDN upgrade infrastructure](./manage/upgrade-sdn.md) guidance is released.
    - Azure Stack HCI renaming banners added to the top of the feature overview articles were removed. This change was consistent with Azure portal updates that removed the renaming banners.

::: moniker-end

::: moniker range="=azloc-2511"

## Features and improvements in 2511

The November 2025 release of hyperconverged deployments of Azure Local is version **12.2511.1002.502**. For more information, see [Release information summary](./release-information-23h2.md).

This release includes the following features and improvements:

- **OS changes**:

    - The 2504 release introduced a new operating system for Azure Local deployments. From 2511 onwards, all the new and existing deployments of Azure Local run the new OS version **26100.7171**. You can download the 2511 OS image from the Azure portal.

        - You also need a driver that's compatible with OS version **26100.7171** or Windows Server 2025. If a compatible driver isn't available, use the 2503 image.

    - If you purchased Integrated System or Premier solution hardware from the [Azure Local Catalog](https://aka.ms/AzureStackHCICatalog) through your preferred Microsoft hardware partner, the OS is preinstalled. Work with your Original Equipment Manufacturer (OEM) to get the OS image that's compatible with **12.2511.1002.502** and a driver that's compatible with OS version **26100.7171** or Windows Server 2025.

- Build **12.2511.1002.502** improves the reliability of deploy and update admin actions. If you already deployed or updated to **12.2511.1002.5**, no further action is needed. Both **12.2511.1002.5** and **12.2511.1002.502** are supported builds.

- **.NET updates**: This build uses .NET version **8.0.22** for both .NET Runtime and ASP.NET Core. For more information, see [Download .NET 8.0](https://dotnet.microsoft.com/download/dotnet/8.0).

- This release includes various reliability improvements and other bug fixes.

::: moniker-end

::: moniker range="=azloc-2510"

## Features and improvements in 2510

There are two 2510 releases for October. Here are the details of each release:

|Solution version  | OS version |
|---------|---------|
|12.2510.1002.531 |  26100.6899 |
|11.2510.1002.93  | 25398.1913  |

For more information, see [Release information summary](./release-information-23h2.md).

This release includes the following features and improvements:

- **OS changes**:

    - The 2504 release introduced a new operating system for Azure Local deployments. For 2510, all the new deployments of Azure Local run the new OS version **26100.6899**. You can download the 2510 OS image from the Azure portal.

        - You also need a driver that's compatible with OS version **26100.6899** or Windows Server 2025. If a compatible driver isn't available, you can use the 2503 image.

        - Existing deployments of Azure Local continue to use OS version **25398.1913**. For more information, see [Release information summary](./release-information-23h2.md).

    - If you purchased Integrated System or Premier solution hardware from the [Azure Local Catalog](https://aka.ms/AzureStackHCICatalog) through your preferred Microsoft hardware partner, the OS is preinstalled. Work with your Original Equipment Manufacturer (OEM) to get the OS image that's compatible with **12.2510.1002.531** and a driver that's compatible with OS version **26100.6899** or Windows Server 2025.

- **.NET updates**: This build uses .NET version **8.0.21** for both .NET Runtime and ASP.NET Core. For more information, see [Download .NET 8.0](https://dotnet.microsoft.com/download/dotnet/8.0).
    
- **Azure Local rack aware clustering (Preview)**: Azure Local now supports rack aware clustering. This Preview feature allows you to define local availability zones based on physical racks in your datacenter, enhancing the resilience of your cluster against rack-level failures. For more information, see [Rack aware clustering](concepts/rack-aware-cluster-overview.md).

- **Upgrade**: Starting with this release, solution upgrade from 11.2510 to 12.2510 is available to everyone and no longer requires you to opt in. The reliability of the upgrade orchestration is also improved.
    - If you're already on 11.2510.1002.87, you can apply the OS upgrade to 12.2510.1002.531.
    - If you aren't on 11.2510.1002.87, you can update to 11.2510.1002.93 first before applying the upgrade to 12.2510.1002.531.

<!--- **Deployment**: Starting with this release, you can domain join your machines before deployment. If you choose to domain join machines before deployment, you must add the deployment user to the local Administrators group on each machine. For more information, see [Domain join before deployment](./deploy/deployment-install-os.md#domain-join-before-deployment).-->

- **Azure Local VM updates**:
    - **Software Defined Networking (SDN)**: SDN enabled by Azure Arc on Azure Local is now generally available. This feature allows you to create and manage network security groups (NSGs) and network security rules for your Azure Local VMs, providing enhanced network security and segmentation capabilities.
    
        For more information, see [Software Defined Networking (SDN) enabled by Azure Arc](./concepts/sdn-overview.md).

    - **Trusted Virtual Machine (Trusted VM) guest attestation (Preview)** - Azure Local 2510 release introduces guest attestation (also known as boot integrity verification) for Azure Local virtual machines with Trusted launch.
        
        This Preview feature lets you verify that the virtual machine starts in a well known good state by checking the integrity of the entire boot chain.  This helps detect any unexpected changes to the boot chain (firmware, OS boot loader, and drivers).
        
        For more information, see [Trusted VM guest attestation](manage/trusted-launch-guest-attestation.md).

- **Azure Local deployment using local identity**: This feature moved from Limited Preview to Preview. There were many changes made to the documentation for deploying Azure Local using local identity with Azure Key Vault, including:
    - Revised instructions for updating Azure Key Vault in Azure Local environments.
    - Added a new section on tool compatibility in Azure Local environments configured with Azure Key Vault.
    - Added a new FAQ section to address common questions.
    For more information, see [Deploy Azure Local using local identity with Azure Key Vault](./deploy/deployment-local-identity-with-key-vault.md).

- **VMware migration to Azure Local** - This feature is now generally available. You can migrate your VMware VMs to Azure Local using Azure Migrate. For more information, see [Migrate VMware VMs to Azure Local](./migrate/migration-azure-migrate-vmware-overview.md).

- **OEM image support for registration** - OEM images are now supported for registration of Azure Local machines for both proxy and without proxy scenarios. For more information, see [Register with Arc gateway](./deploy/deployment-with-azure-arc-gateway.md) and [Register without Arc gateway](./deploy/deployment-without-azure-arc-gateway.md).

<!--- **Documentation updates**: The noteworthy changes include the following new articles or articles with major updates:-->

::: moniker-end


::: moniker range="=azloc-2509"

## Features and improvements in 2509

There are two 2509 releases for September. Here are the details of each release:

|Solution version  | OS version |
|---------|---------|
|12.2509.1001.22 |  26100.6584 |
|11.2509.1001.21  | 25398.1849  |

For more information, see [Release information summary](./release-information-23h2.md).

This release includes the following features and improvements:

- **OS changes**:

    - The 2504 release introduced a new operating system for Azure Local deployments. For 2509, all the new deployments of Azure Local run the new OS version **26100.6584**. You can download the 2509 OS image from the Azure portal.

        - You also need a driver that's compatible with OS version **26100.6584** or Windows Server 2025. If a compatible driver isn't available, you can use the 2503 image.

        - Existing deployments of Azure Local continue to use OS version **25398.1849**. For more information, see [Release information summary](./release-information-23h2.md).

    - If you purchased Integrated System or Premier solution hardware from the [Azure Local Catalog](https://aka.ms/AzureStackHCICatalog) through your preferred Microsoft hardware partner, the OS is preinstalled. Work with your Original Equipment Manufacturer (OEM) to get the OS image that's compatible with **12.2509** and a driver that's compatible with OS version **26100.6584** or Windows Server 2025.
    
- **.NET updates**: This build uses .NET version **8.0.20** for both .NET Runtime and ASP.NET Core. For more information, see [Download .NET 8.0](https://dotnet.microsoft.com/download/dotnet/8.0).

- **Update and upgrade changes**: Starting with this release, you can opt in to update the solution version 11.25xx (running OS 25398.xxx) to solution version 12.25xx (running OS 26100.xxxx). For more information, see [Opt in update to Azure Local solution versions 12.25x](./update/update-opt-enable.md).


- **Azure Local VM updates**:
    - **Enhanced storage path deletion workflow** - Starting with this release, you can view all the dependent resources linked to a storage path before deletion. Azure portal lets you delete both the storage path and its dependent resources in a single, streamlined action, making cleanup faster and more intuitive.
    - **Live update memory of an Azure Local VM** - You can now live update (VM remains running) the memory of a VM. A restart might be required only if the guest OS doesn't support live memory updates.

- **AKS enabled by Azure Arc changes**
    - The default OS disk size for the AKS VM is increased from 100 GB to 200 GB. A larger OS disk size offers flexibility on the size of the containerized workloads.
    - Starting with this release, the download of Windows VHD images is disabled by default.
    
    
- **Azure Local deployment using local identity** include zone name for both external and internal DNS servers.

- **Documentation updates**: The noteworthy changes include the following new articles or articles with major updates:

    - **Upgrade and update docs changes** include new articles and major updates to existing articles:
        - [**Opt in update to Azure Local solution versions 12.25x**](./update/update-opt-enable.md) is released.
        - [**Upgrade OS for stretch clusters via PowerShell**](./upgrade/upgrade-stretched-cluster-to-23h2.md) is released.
        - [**Install solution upgrade on Azure Local using Azure Resource Manager template**](./upgrade/install-solution-upgrade-azure-resource-manager-template.md) is released.
        - [**ARM template parameters**](./deploy/deployment-azure-resource-manager-template.md#arm-template-parameters-reference) reference is added.
        - [**Update best practices**](./update/update-best-practices.md) is released.

    - **Azure Local VM doc changes** include:
        - **Disaster recovery for Azure Local VMs**: A new node in TOC **Implementing disaster recovery** is created consisting of four new articles and one updated article. These articles include [Disaster recovery overview](./manage/disaster-recovery-overview.md), [Infrastructure resiliency](./manage/disaster-recovery-infrastructure-resiliency.md), [Virtual machine resiliency overview](./manage/disaster-recovery-vm-resiliency.md), [Use Azure Site Recovery](./manage/azure-site-recovery.md), and [Workloads resiliency](./manage/disaster-recovery-workloads-resiliency.md).
        - **VM images**: For Azure Local VMs, two new articles are released including [Prepare Ubuntu Azure Marketplace image](manage/virtual-machine-azure-marketplace-ubuntu.md) and [Prepare RHEL Azure Marketplace image](manage/virtual-machine-azure-marketplace-red-hat.md).
    - A troubleshooting section is added for issues in [Add-server](./manage/add-server.md) and [Repair-server](./manage/repair-server.md) articles.

::: moniker-end


::: moniker range="=azloc-previous"

## Features and improvements in 2508

There are two 2508 releases for August. Here are the details of each release:

|Solution version  | OS version |
|---------|---------|
|12.2508.1001.52 |  26100.4946 |
|11.2508.1001.51  | 25398.1791  |

For more information, see [Release information summary](./release-information-23h2.md).

This release includes the following features and improvements:

- **OS changes**:

    - In the 2504 release, Microsoft introduced a new operating system for Azure Local deployments. For 2508, all the new deployments of Azure Local run the new OS version **26100.4946**. You can download the 2508 OS image from the Azure portal.

        - You also need to get the driver compatible with OS version **26100.4946** or Windows Server 2025. If a compatible driver isn't available, you can use the 2503 image.

        - Existing deployments of Azure Local continue to use OS version **25398.1791**. For more information, see [Release information summary](./release-information-23h2.md).

    - If you purchased Integrated System or Premier solution hardware from the [Azure Local Catalog](https://aka.ms/AzureStackHCICatalog) through your preferred Microsoft hardware partner, the OS is preinstalled. Work with your Original Equipment Manufacturer (OEM) to get the OS image compatible with **12.2508** and driver compatible with OS version **26100.4946** or Windows Server 2025.
    
- **.NET updates**: This build uses .NET version **8.0.18** for both .NET Runtime and ASP.NET Core. For more information, see [Download .NET 8.0](https://dotnet.microsoft.com/download/dotnet/8.0).

**Trusted Virtual Machine (Trusted VM) guest attestation**: Azure Local 2508 release introduces guest attestation (also known as boot integrity verification) for Azure Local virtual machines with Trusted launch. This feature lets you verify that the virtual machine starts in a known good state by checking the integrity of the entire boot chain. This process helps detect any unexpected changes to the boot chain (firmware, OS boot loader, and drivers) and take action if it's compromised. For more information, see [Trusted VM guest attestation](manage/trusted-launch-guest-attestation.md).

- **Deployment and upgrade changes**:
    - Starting with this release, Azure Resource Manager (ARM) deployment templates are available for previous releases.
    - With this release, preexisting cluster (Brownfield) upgrade scenarios no longer require Service Principal Name (SPN) creation and moved to managed-system identity (MSI).
    - This release includes connectivity validators that ensure that external connectivity is available for Arc registration.

- **Azure Local VM updates**:
    - **Edit DNS servers on logical networks via Azure CLI**: Starting with this release, you can modify DNS servers associated with the logical networks for Azure Local virtual machines. For more information, see [Manage DNS server configuration on logical networks](./manage/manage-arc-virtual-machine-resources.md).
    - **Save and Pause Azure Local VMs**: The ability to save and pause an Azure Local VM is available on the Azure portal. For more information, see [Save and Pause Azure Local VMs](./manage/manage-arc-virtual-machines.md#save-a-vm).
    - **Limit enforcement**: Azure portal now enforces:
        - The correct memory and vCPU limits.
        - The correct disk size limits.

- **Disconnected operations (preview)**: Azure Local now supports disconnected operations, letting you work in environments with limited or no internet connectivity. Build, deploy, and manage virtual machines (VMs) and containerized applications with select Azure Arc-enabled services from a local control plane. You get the familiar Azure portal and Azure Command-Line Interface (CLI) experience.

    For more information, see [About Disconnected operations (preview)](./manage/disconnected-operations-overview.md).


- **Documentation updates**: These changes include:

    - **Azure Arc gateway documentation updates**: Improved guidance on registering with and without Azure Arc gateway and with and without proxy in an easy to use layout. For more information, see [Register with Azure Arc gateway](./deploy/deployment-with-azure-arc-gateway.md) and [Register with Azure Arc](./deploy/deployment-without-azure-arc-gateway.md).
    - **Upgrade documentation updates**: Clarified steps for upgrading from previous versions of Azure Local and an easy to use layout. For more information, see [Upgrade OS for Azure Local](./upgrade/upgrade-22h2-to-23h2-powershell.md).
    - **Azure Local security book**: This book was previously available as a *pdf* and is now available as web content on Learn. For more information, see [Azure Local security book](./security-book/overview.md).

## Features and improvements in 2507

Two 2507 releases are available for July. Here are the details of each release:

|Solution version  | OS version |
|---------|---------|
|12.2507.1001.10 |  26100.4652 |
|11.2507.1001.9  | 25398.1732  |

For more information, see [Release information summary](./release-information-23h2.md).

This release includes the following features and improvements:

- **OS changes**:

    - In the 2504 release, Microsoft introduced a new operating system for Azure Local deployments. For 2507, all the new deployments of Azure Local run the new OS version **26100.4652**. You can download the 2507 OS image from the Azure portal.
    
        - You also need to get the driver compatible with OS version **26100.4652** or Windows Server 2025. If a compatible driver isn't available, you can use the 2503 image.

        - Existing deployments of Azure Local continue to use OS version **25398.1732**. For more information, see [Release information summary](./release-information-23h2.md).

    - If you purchased Integrated System or Premier solution hardware from the [Azure Local Catalog](https://aka.ms/AzureStackHCICatalog) through your preferred Microsoft hardware partner, the OS comes preinstalled. Work with your Original Equipment Manufacturer (OEM) to get the OS image compatible with **12.2507** and driver compatible with OS version **26100.4652** or Windows Server 2025.
    
- **.NET updates**: This build uses .NET version **8.0.18** for both .NET Runtime and ASP.NET Core. For more information, see [Download .NET 8.0](https://dotnet.microsoft.com/download/dotnet/8.0).

 
## Features and improvements in 2506

There are two 2506 releases for June. Here are the details of each release:

|Solution version  | OS version |
|---------|---------|
|12.2506.1001.29 |  26100.4349  |
|11.2506.1001.28  | 25398.1665  |

For more information, see [Release information summary](./release-information-23h2.md).

This release includes the following features and improvements:

- **OS changes**:

    - In the 2504 release, Microsoft introduced a new operating system for Azure Local deployments. For 2506, all the new deployments of Azure Local run the new OS version **26100.4349**. You can download the 2506 OS image from the Azure portal.
    
        You also need to get the driver compatible with OS version **26100.4349** or Windows Server 2025. If a compatible driver isn't available, you can use the 2503 image.

        Existing deployments of Azure Local continue to use OS version **25398.1665**. For more information, see [Release information summary](./release-information-23h2.md).

    - If you purchased Integrated System or Premier solution hardware from the [Azure Local Catalog](https://aka.ms/AzureStackHCICatalog) through your preferred Microsoft hardware partner, the OS is preinstalled. Work with your Original Equipment Manufacturer (OEM) to get the OS image compatible with **12.2506** and driver compatible with OS version **26100.4349** or Windows Server 2025.
    
- **.NET updates**: This build uses .NET version **8.0.17** for both .NET Runtime and ASP.NET Core. For more information, see [Download .NET 8.0](https://dotnet.microsoft.com/download/dotnet/8.0).

- **Software-Defined Networking (SDN) enabled by Azure Arc (Preview)**: Azure Local now supports creating Networking Security Groups (NSGs), configuring Network Security Rules, and assigning them to logical networks and network interfaces. This support provides a consistent networking experience across your cloud and edge environment. For more information, see [Software-Defined Networking (SDN) enabled by Azure Arc](./concepts/sdn-overview.md).

- **Deployment changes**: To ensure consistent validation before you deploy Azure Local, deployment validators for Microsoft On-premises Cloud and Azure resource bridge are now a part of environment checker.

- **Overprovisioning alert**: A warning is shown prior to starting an update if an Azure Local instance is overprovisioned. This alert indicates there's insufficient compute capacity (memory) to live migrate workloads during an update. You must acknowledge this alert before proceeding with an update, as VM workloads are paused due to the lack of available compute or memory capacity.

- **Security improvements**:
    - **New security baseline**: The 2506 release introduces a security baseline with 407 evaluated rules, a 25% increase from the previous 324. Key improvements include:
      - Over 90% alignment with CIS Azure Compute Windows Baseline and Defense Information Systems Agency (DISA) Security Technical Implementation Guide (STIG) benchmark.
      - Enhanced Microsoft Defender Antivirus settings, including Potentially Unwanted Apps (PUA), network inspection, and attack surface reduction rules.
      - Additional adjustments tailored for Azure Local.

      This release also improves conflict resolution with existing security policies. Instead of disabling drift control system-wide, you can now fine-tune individual settings while maintaining drift control. For more information, see [View and download security settings in Azure Local](./manage/manage-secure-baseline.md#view-and-download-security-settings).

    - To comply with National Institute of Standards and Technology (NIST) 2 guidelines, the minimum required password length when deploying Azure Local is changed to 14 characters.

- **Archival of Azure Local, version 22H2 documentation**: [Azure Local, version 22H2 documentation](/previous-versions/azure/azure-local/release-information) is now archived and available in the [Azure previous versions documentation](/previous-versions/azure/) for reference. The archived documentation isn't updated and isn't supported.

- **Azure Government cloud**: The solution update isn't supported for Azure Local instances deployment in Azure Government cloud.

## Features and improvements in 2505

There are two 2505 releases for May. Here are the details of each release:

|Solution version  |OS version |Deployment  |
|---------|---------|---------|
|12.2505.1001.23 |  26100.4061        | New deployments only.        |
|11.2505.1001.22  | 25398.1611        | Existing deployments only.        |

For more information, see [Release information summary](./release-information-23h2.md).

This release includes the following features and improvements:

- **OS version changes**:

    - In the last release (2504), you saw a new operating system for Azure Local deployments. For 2505, all the new deployments of Azure Local run new OS version **26100.4061**. You can download the 2505 OS image from the Azure portal.
    
        You also need to get the driver compatible with Azure Local 12.2505 or Windows Server 2025. If a compatible driver isn't available, you can use the 2503 image.

        Existing deployments of Azure Local continue to use OS version **25398.1611**. For more information, see [Release information summary](./release-information-23h2.md).

    - If you purchased Integrated System or Premier solution hardware from the [Azure Local Catalog](https://aka.ms/AzureStackHCICatalog) through your preferred Microsoft hardware partner, the OS is preinstalled. Work with your Original Equipment Manufacturer (OEM) to get the OS image compatible with **12.2505** and driver compatible with Azure Local 12.2505 or Windows Server 2025.

- **.NET updates**: This build uses .NET version **8.0.16** for both .NET Runtime and ASP.NET Core. For more information, see [Download .NET 8.0](https://dotnet.microsoft.com/download/dotnet/8.0).

- **Update changes**: This release includes reliability improvements to the update process. For more information, see [Fixed issues in 2505](./known-issues.md?view=azloc-previous&preserve-view=true#fixed-issues).

- **Ability to upload logs**: You can now upload a Support log package that includes all relevant logs to help Microsoft Support troubleshoot machine problems, directly from the Configurator app. For details, see [Upload the Support log package](./deploy/deployment-arc-register-configurator-app.md#upload-the-support-log-package).

- **Archival of Azure Local, version 22H2 documentation**: The archival of Azure Local, version 22H2 documentation is currently in progress and will complete soon. Once archived, the articles are available in the [Azure previous versions documentation](/previous-versions/azure/) for reference. The archived documentation isn't updated and isn't supported.

## Features and improvements in 2504

Starting with the 2504 release, Microsoft uses a new versioning schema. There are two 2504 releases for April. Here are the details of each release:

|Solution version  |OS version |Deployment  |
|---------|---------|---------|
|12.2504.1001.20 | 26100.3775        | New deployments only.        |
|11.2504.1001.21  | 25398.1551        | Existing deployments only.        |

For more information, see [Release information summary](./release-information-23h2.md).

This release includes the following features and improvements:

- **OS version changes**:
    - Starting with 2504, all new Azure Local deployments use a new operating system (OS) version **26100.3775**. You can download the 2504 OS image from the Azure portal. You also need to get the driver compatible with Azure Local 12.2504 or Windows Server 2025. Existing deployments continue to use the OS version **25398.1551**. For more information, see [Release information summary](./release-information-23h2.md).
    - If you purchase Integrated System or Premier solution hardware from the [Azure Local Catalog](https://aka.ms/AzureStackHCICatalog) through your preferred Microsoft hardware partner, the OS is preinstalled. Work with your Original Equipment Manufacturer (OEM) to get the OS image compatible with **12.2504** and driver compatible with Azure Local 12.2504 or Windows Server 2025.

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
    - **OEM license with Windows Server 2025 guest VMs**: With the release of 2504, OEM license for Azure Local is available with Windows Server 2025 guest VMs. This license integrates essential services for your cloud infrastructure: Azure Local, and Windows Server Datacenter 2025 Guest rights.

- **Solution extension improvements**:
    - Improved error message to fix firewall blocking access to solution extension manifest endpoints.
    - Improved reliability of copying solution extension content locally to each machine.
    - Added specification of plug-in name in the solution extension.

- **Billing changes**: For deployments running solution version 12.2504.1001.20 and later, the usage record originates from the Azure Local resource in Azure directly. For more information, see [Billing and payment](./concepts/billing.md#billing-changes-for-version-2504-and-later).

- **Archival of Azure Local, version 22H2 documentation**: The documentation for version 22H2 is archived by May 31, 2025 and is available in the [Azure previous versions documentation](/previous-versions/azure/) for reference. The archived documentation isn't updated and isn't supported.

- **Observability changes**: You can now automatically collect, analyze, and debug Azure services crashes with the crash dump collection feature in Azure Local. For more information, see [Crash dump collection](./concepts/observability.md#crash-dump-collection).

## Features and improvements in 2503

This release includes the following features and improvements:

- **Preview availability of Azure Government cloud** - Azure Local is now available in the US Government regions in preview. Download the latest Azure Stack HCI OS image for Azure Government from [OS image](https://aka.ms/hcireleaseimage). For more information on where Azure Government is supported, see [Azure Local supported regions](./concepts/system-requirements-23h2.md#azure-requirements).

    The following preview features aren't supported for Azure Local in Azure Government cloud:

  - [Azure Arc Gateway](./deploy/deployment-azure-arc-gateway-overview.md).
  - [Deploy using local identity with Key Vault](./deploy/deployment-local-identity-with-key-vault.md).
  - [Azure Site Recovery](./manage/azure-site-recovery.md).
  - [Windows Admin Center in Azure portal](/windows-server/manage/windows-admin-center/azure/manage-vm).

- **Registration and deployment changes**
  - **Extension installation**: Extensions are no longer installed during the registration of Azure Local machines. Instead, the machine validation step during the Azure Local instance deployment installs the extensions. For more information, see [Register with Azure Arc via console](./deploy/deployment-arc-register-server-permissions.md) and [Deploy via Azure portal](./deploy/deploy-via-portal.md).
  - **Register via app**: You can bootstrap your Azure Local machines by using the Configurator app. The local UI is now deprecated. For more information, see [Register Azure Local machines using Configurator app](./deploy/deployment-arc-register-configurator-app.md).
    - Composed image is now supported for Original Equipment Manufacturers (OEMs).
    - Several security enhancements were made for the Bootstrap service.
    - Service Principal Name (SPN) is deprecated for Arc registration.

  - **Deployment of current version and previous versions**: Starting with this release, you can deploy the current version of Azure Local by using the Azure portal. To deploy a previous version, use an Azure Resource Manager template that matches the version you want to deploy. For more information, see [Deploy via ARM template](./deploy/deployment-azure-resource-manager-template.md).

- **Environment checker related changes**
  - Environment checker is now integrated for connectivity tests.
  - Environment checker validates the composed image used for bootstrap.
  - Environment checker validates PowerShell modules as per the validated solution recipe in the Pre-Update checks.

- **Updates and upgrade improvements**
  - The Solution Builder Extension update now supports both supported and nonsupported SKUs for a given model.
  - A tag is added to indicate whether an update is the latest or is superseded.
  - HTTP content is now downloaded by using a more resilient service (Download Service).
  - OS content is packaged with the release, rather than determining applicable content on the device at runtime. This change minimizes failure points and supports [Importing content](update/update-via-powershell-23h2.md#step-3-import-and-rediscover-updates).
  - OS content is installed by using the CAU plug-ins that are shipped with OS.
  - Azure Local rebranding changes were made for this update.
  - OS update components for Azure Local are distributed as a static payload, so you can import and discover update packages with limited connectivity to Azure. For more information, see [Import and discover updates with limited connectivity](./update/import-discover-updates-offline-23h2.md).

- **Azure Local VM changes**: You can now connect to an Azure Local VM by using the SSH/RDP protocol without the need for line of sight (inside the host network). For more information, see [Connect to an Azure Local VM using SSH](./manage/connect-arc-vm-using-ssh.md).

- **Add and repair node changes**: Starting with this release, you must use the OS image of the same solution version as the version running on the existing cluster. For more information on the OS image, see [Add a node](./manage/add-server.md) and [Repair a node](./manage/repair-server.md). 

- **What's new for migration**: Documentation for improvements and features for VM migration to Azure Local is now available. For more information, see [What's new in migration](./migrate/migrate-whats-new.md).

::: moniker-end

## Next steps

- [Read the Azure Local blog](https://aka.ms/ignite25/blog/azurelocal) post.
- Read the [blog announcing the general availability of Azure Local](https://techcommunity.microsoft.com/t5/azure-stack-blog/azure-stack-hci-version-23h2-is-generally-available/ba-p/4046110).
- Read [About hyperconverged deployment methods](./deploy/deployment-introduction.md).
- Learn how to [Deploy Azure Local via the Azure portal](./deploy/deploy-via-portal.md).
- For more information about previous releases, see [What's new in Azure Local 23xx releases?](previous-releases/whats-new-23.md) and [What's new in Azure Local 24xx releases?](previous-releases/whats-new-24.md).