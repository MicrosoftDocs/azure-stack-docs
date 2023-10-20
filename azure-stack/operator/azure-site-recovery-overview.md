---
title: Azure Site Recovery overview (preview)
description: Azure Site Recovery on Azure Stack Hub helps ensure business continuity by keeping business apps and workloads running during outages.
author: ronmiab
ms.author: robess
ms.topic: overview
ms.date: 06/19/2023
ms.reviewer: rtiberiu
ms.lastreviewed: 03/07/2023

---

# Azure Site Recovery overview (preview)

Azure Site Recovery on Azure Stack Hub helps ensure business continuity by keeping business apps and workloads running during outages. Azure Site Recovery on Azure Stack Hub replicates virtual machine (VM) workloads from a primary site to a secondary location. When an outage occurs at your primary site, you fail over to a secondary location, and access apps from there. After the primary location is running again, you can fail back to it.

> [!IMPORTANT]
> During the public preview of Azure Site Recovery on Azure Stack Hub, updates might require a complete re-installation (a complete removal and then re-add) of the service.

To enable replication of VMs across two Azure Stack Hub stamps, configure the following environments:

- **Source** environment is the Azure Stack Hub stamp where tenant VMs are running.
  - **Azure Stack Hub Operator**, download the Azure Site Recovery Appliance VM and the Azure Site Recovery VM extensions in the Marketplace Management.
  - **Azure Stack Users**, in the user subscriptions, configure the connection to the target vault in this source environment.

- **Target** environment is where the Azure Site Recovery Resource Provider and dependencies run.
  - **Azure Stack Hub Operator**, download the respective images.
  - **Azure Stack Hub Users**, configure the vault and prepare the prerequisites for your replicated VMs.

    :::image type="content" source="../operator/media/azure-site-recovery/overview/source-and-target.png" alt-text="Screenshot of replication of VMs across two Azure Stack Hub stamps."lightbox="media/azure-site-recovery/overview/source-and-target.png":::

Azure Site Recovery on Azure Stack Hub is available for both Microsoft Entra ID and Active Directory Federation Services (AD FS) type deployments of Azure Stack Hub, which means it can run in disconnected environments.

## What does Site Recovery provide?

Azure Site Recovery provides many features, as described in the following table.

|Feature | Details  |
|--------|----------|
|BCDR solution | Using Site Recovery, you can set up and manage replication, failover, and failback from a single location in the Azure Stack Hub portal.|
|BCDR integration | Site Recovery integrates with other BCDR technologies. For example, you can use Site Recovery to protect the SQL Server backend of corporate workloads, with native support for SQL Server Always On, to manage the failover of availability groups.|
|Azure Automation integration| A rich Azure Automation library provides production-ready, application-specific scripts that can be downloaded and integrated with Site Recovery.|
|RTO and PRO targets | Keep recovery time objectives (RTO) and recovery point objectives (RPO) within organizational limits. Site Recovery provides continuous replication for Azure Stack Hub VMs.|
|Keep apps consistent over failover | You can replicate using recovery points with application-consistent snapshots. These snapshots capture disk data, all data in memory, and all transactions in process.|
|Testing without disruption | You can easily run disaster recovery drills, without affecting ongoing replication.|
|Flexible failovers | You can run planned failovers for expected outages with zero-data loss or unplanned failovers with minimal data loss, depending on replication frequency, for unexpected disasters. You can easily fail back to your primary site when it's available again.|
|Customized recovery plans |**Not currently available in public preview.** Using recovery plans, you can customize and sequence the failover and recovery of multi-tier applications running on multiple VMs. You can group machines together in a recovery plan, and optionally add scripts and manual actions.

## What can I replicate?

Azure Site Recovery on Azure Stack Hub, with a required agent installed on each of the protected VMs, enables the replication of VMs across two instances, or stamps, of Azure Stack Hub. Azure Stack Hub uses a VM extension, available through the Azure Stack Hub Marketplace, to install this agent.

We've tested and validated the following VM OSs and each has respective Azure Stack Hub Marketplace images available for download:

# [Windows](#tab/windows)

| Operating system    | Details   |
|---------------------|-----------|
|Windows Server 2022  | Supported.|
|Windows Server 2019  | Supported for Server Core, Server with Desktop Experience.|
|Windows Server 2016 | Supported Server Core, Server with Desktop Experience.|
|Windows Server 2012 R2 | Supported.|
|Windows Server 2012  | Supported.|
|Windows Server 2008 R2 with SP1/SP2 | Supported. From version [9.30](https://support.microsoft.com/topic/update-rollup-42-for-azure-site-recovery-88be2b2d-fb52-3a36-4af2-785bbd847074) of the Mobility service extension for Azure VMs, you need to install a Windows [servicing stack update (SSU)](https://support.microsoft.com/topic/servicing-stack-update-for-windows-7-sp1-and-windows-server-2008-r2-sp1-march-12-2019-b4dc0cff-d4f2-a408-0cb1-cb8e918feeba) and [SHA-2 update](https://support.microsoft.com/topic/sha-2-code-signing-support-update-for-windows-server-2008-r2-windows-7-and-windows-server-2008-september-23-2019-84a8aad5-d8d9-2d5c-6d78-34f9aa5f8339) on machines running Windows Server 2008 R2 SP1/SP2. **SHA-1 isn't supported from September 2019, and if SHA-2 code signing isn't enabled the agent extension won't install or upgrade as expected**. For more information, see [SHA-2 upgrade and requirements](https://support.microsoft.com/topic/2019-sha-2-code-signing-support-requirement-for-windows-and-wsus-64d1c82d-31ee-c273-3930-69a4cde8e64f).|
|Windows 10 (x64) | Supported.|
|Windows 8.1 (x64) | Supported.|
|Windows 8 (x64) | Supported.|
|Windows 7 (x64) with SP1 onwards | Supported. From version [9.30](https://support.microsoft.com/topic/update-rollup-42-for-azure-site-recovery-88be2b2d-fb52-3a36-4af2-785bbd847074) of the mobility service extension for Azure VMs, install a Windows [servicing stack update (SSU)](https://support.microsoft.com/topic/servicing-stack-update-for-windows-7-sp1-and-windows-server-2008-r2-sp1-march-12-2019-b4dc0cff-d4f2-a408-0cb1-cb8e918feeba) and [SHA-2 update](https://support.microsoft.com/topic/sha-2-code-signing-support-update-for-windows-server-2008-r2-windows-7-and-windows-server-2008-september-23-2019-84a8aad5-d8d9-2d5c-6d78-34f9aa5f8339) on machines running Windows 7 with SP1. **From September 2019, SHA-1 isn't supported, and if SHA-2 code signing isn't enabled the agent extension won't install or upgrade as expected**. For more information, see [SHA-2 upgrade and requirements](https://support.microsoft.com/topic/2019-sha-2-code-signing-support-requirement-for-windows-and-wsus-64d1c82d-31ee-c273-3930-69a4cde8e64f).

# [Linux](#tab/linux)

| Operating system    | Details   |
|---------------------|-----------|
|Red Hat Enterprise Linux | 6.7, 6.8, 6.9, 6.10, 7.0, 7.1, 7.2, 7.3, 7.4, 7.5, 7.6, [7.7](https://support.microsoft.com/topic/update-rollup-41-for-azure-site-recovery-267eebca-ab08-c5ee-5b04-b3be62426191), [7.8](https://support.microsoft.com/topic/update-rollup-46-for-azure-site-recovery-0e938469-3de5-9ed4-d1bf-91fd24e711de), [7.9](https://support.microsoft.com/topic/update-rollup-49-for-azure-site-recovery-e455bd62-ed02-038d-87b4-a257fb4cdbe6), [8.0](https://support.microsoft.com/topic/update-rollup-42-for-azure-site-recovery-88be2b2d-fb52-3a36-4af2-785bbd847074), 8.1, [8.2](https://support.microsoft.com/topic/update-rollup-47-for-azure-site-recovery-8ceb92e2-27c2-8f20-e229-52bdbaa27963), [8.3](https://support.microsoft.com/topic/update-rollup-52-for-azure-site-recovery-c98af2b9-74af-8796-3184-d1d292bf3344), [8.4](https://support.microsoft.com/topic/update-rollup-60-for-azure-site-recovery-kb5011122-883a93a7-57df-4b26-a1c4-847efb34a9e8) (4.18.0-305.30.1.el8_4.x86_64 or higher), [8.5](https://support.microsoft.com/topic/update-rollup-60-for-azure-site-recovery-kb5011122-883a93a7-57df-4b26-a1c4-847efb34a9e8) (4.18.0-348.5.1.el8_5.x86_64 or higher), [8.6](https://support.microsoft.com/topic/update-rollup-62-for-azure-site-recovery-e7aff36f-b6ad-4705-901c-f662c00c402b), and 8.7.|
|CentOS | 6.5, 6.6, 6.7, 6.8, 6.9, 6.10 7.0, 7.1, 7.2, 7.3, 7.4, 7.5, 7.6, 7.7, [7.8](https://support.microsoft.com/topic/update-rollup-46-for-azure-site-recovery-0e938469-3de5-9ed4-d1bf-91fd24e711de), [7.9 pre-GA version](https://support.microsoft.com/topic/update-rollup-49-for-azure-site-recovery-e455bd62-ed02-038d-87b4-a257fb4cdbe6), 7.9 GA version is supported from 9.37 hotfix patch, 8.0, 8.1, [8.2](https://support.microsoft.com/topic/update-rollup-47-for-azure-site-recovery-8ceb92e2-27c2-8f20-e229-52bdbaa27963), [8.3](https://support.microsoft.com/topic/update-rollup-52-for-azure-site-recovery-c98af2b9-74af-8796-3184-d1d292bf3344), 8.4 (4.18.0-305.30.1.el8_4.x86_64 or later), 8.5 (4.18.0-348.5.1.el8_5.x86_64 or later), 8.6, and 8.7.|
|Ubuntu 14.04 LTS Server |Includes support for all 14.04.x versions. [Supported kernel versions](/azure/site-recovery/azure-to-azure-support-matrix#supported-ubuntu-kernel-versions-for-azure-virtual-machines).|
|Ubuntu 16.04 LTS Server | Includes support for all 16.04.x versions. [Supported kernel version](/azure/site-recovery/azure-to-azure-support-matrix#supported-ubuntu-kernel-versions-for-azure-virtual-machines). Ubuntu servers using password-based authentication and sign-in, and the cloud-init package to configure cloud VMs, might have password-based sign-in disabled on failover, depending on the cloud-init configuration. Password-based sign-in, of the failover VM in Azure portal, can be re-enabled on the virtual machine by resetting the password from the **Support > Troubleshooting > Settings** menu.|
|Ubuntu 18.04 LTS Server | Includes support for all 18.04.x versions. [Supported kernel version](/azure/site-recovery/azure-to-azure-support-matrix#supported-ubuntu-kernel-versions-for-azure-virtual-machines). Ubuntu servers using password-based authentication and sign-in, and the cloud-init package to configure cloud VMs, might have password-based sign-in disabled on failover, depending on the cloud-init configuration. Password-based sign-in, of the failover VM in Azure portal, can be re-enabled on the virtual machine by resetting the password from the **Support > Troubleshooting > Settings** menu.|
|Ubuntu 20.04 LTS server | Includes support for all 20.04.x versions. [Supported kernel version](/azure/site-recovery/azure-to-azure-support-matrix#supported-ubuntu-kernel-versions-for-azure-virtual-machines).|
|Debian 7 | Includes support for all 7. x versions. [Supported kernel versions](/azure/site-recovery/azure-to-azure-support-matrix#supported-debian-kernel-versions-for-azure-virtual-machines).|
|Debian 8 | Includes support for all 8. x versions. [Supported kernel versions](/azure/site-recovery/azure-to-azure-support-matrix#supported-debian-kernel-versions-for-azure-virtual-machines).|
|Debian 9 | Includes support for 9.1 to 9.13. Debian 9.0 isn't supported. [Supported kernel versions](/azure/site-recovery/azure-to-azure-support-matrix#supported-debian-kernel-versions-for-azure-virtual-machines).|
|Debian 10 | [Supported kernel versions](/azure/site-recovery/azure-to-azure-support-matrix#supported-debian-kernel-versions-for-azure-virtual-machines).|
|Debian 11 | [Supported kernel versions](/azure/site-recovery/azure-to-azure-support-matrix#supported-debian-kernel-versions-for-azure-virtual-machines).|
|SUSE Linux Enterprise Server 11 | SP3. The upgrade of replicating machines from SP3 to SP4 isn't supported. If a replicated machine has been upgraded, you must disable replication and re-enable replication after the upgrade.|
|SUSE Linux Enterprise Server 11 | SP4 |
|SUSE Linux Enterprise Server 12 | SP1, SP2, SP3, SP4, and SP5. [Supported kernel versions](/azure/site-recovery/azure-to-azure-support-matrix#supported-suse-linux-enterprise-server-12-kernel-versions-for-azure-virtual-machines).|
|SUSE Linux Enterprise Server 15 | 15, SP1, SP2, SP3, and SP4. [Supported kernel versions](/azure/site-recovery/azure-to-azure-support-matrix#supported-suse-linux-enterprise-server-15-kernel-versions-for-azure-virtual-machines).|
|Oracle Linux | 6.4, 6.5, 6.6, 6.7, 6.8, 6.9, 6.10, 7.0, 7.1, 7.2, 7.3, 7.4, 7.5, 7.6, [7.7](https://support.microsoft.com/topic/update-rollup-42-for-azure-site-recovery-88be2b2d-fb52-3a36-4af2-785bbd847074), [7.8](https://support.microsoft.com/topic/update-rollup-48-for-azure-site-recovery-8dc98c92-3a8b-d280-86ac-439881963ee0), [7.9](https://support.microsoft.com/topic/update-rollup-52-for-azure-site-recovery-c98af2b9-74af-8796-3184-d1d292bf3344), [8.0](https://support.microsoft.com/topic/update-rollup-48-for-azure-site-recovery-8dc98c92-3a8b-d280-86ac-439881963ee0), [8.1](https://support.microsoft.com/topic/update-rollup-48-for-azure-site-recovery-8dc98c92-3a8b-d280-86ac-439881963ee0), [8.2](https://support.microsoft.com/topic/update-rollup-55-for-azure-site-recovery-kb5003408-b19c8190-5f88-43ea-85b1-d9e0cc5ca7e8), [8.3](https://support.microsoft.com/topic/update-rollup-55-for-azure-site-recovery-kb5003408-b19c8190-5f88-43ea-85b1-d9e0cc5ca7e8) (running the Red Hat compatible kernel or Unbreakable Enterprise Kernel Release 3, 4, 5, and 6 (UEK3, UEK4, UEK5, UEK6)), and [8.4](https://support.microsoft.com/topic/update-rollup-59-for-azure-site-recovery-kb5008707-66a65377-862b-4a4c-9882-fd74bdc7a81e), 8.5, 8.6, and 8.7. **8.1 (running on all UEK kernels and RedHat kernel greater than or equal to 3.10.0-10620 are supported in [9.35](https://support.microsoft.com/topic/update-rollup-48-for-azure-site-recovery-8dc98c92-3a8b-d280-86ac-439881963ee0)). Support for rest of the RedHat kernels is available in [9.36](https://support.microsoft.com/topic/update-rollup-49-for-azure-site-recovery-e455bd62-ed02-038d-87b4-a257fb4cdbe6)**.|

---

## Next steps

[Azure Site Recovery on Azure Stack Hub capacity planning](azure-site-recovery-capacity-planning.md)
