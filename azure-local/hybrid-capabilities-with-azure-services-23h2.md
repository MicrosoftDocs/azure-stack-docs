---
title: Hybrid capabilities with Azure services in Azure Local
description: Learn about the hybrid capabilities in Azure Local and how Azure services enabled by Azure Arc allow you to deploy workloads on Azure Local and manage infrastructure and VMs.
ms.topic: overview
author: alkohli
ms.author: alkohli
ms.date: 09/11/2025
ms.custom: e2e-hybrid
---

# Hybrid capabilities enabled by Azure Arc in Azure Local

This article outlines the hybrid capabilities available in Azure Local and describes the distinct ways Azure Arc enables them.

## Hybrid integration of Azure services with Azure Local

Azure Local allows you to take advantage of both on-premises and cloud resources working together. By integrating with Azure services, you can natively monitor, secure, and back up your local environment to Azure. [Azure Arc](/azure/azure-arc/overview) plays a key role in this integration by extending the Azure control plane to your existing infrastructure. It enables you to run Azure-native workloads on Azure Local, and use Azure services to manage both infrastructure and VMs consistently.

The following diagram shows how Azure Arc provides hybrid integration between Azure services and Azure Local:

:::image type="content" source="media/hybrid-capabilities-with-azure-services-23h2/azure-stack-hci-solution.png" alt-text="The architecture diagram of the Azure Local solution, which shows the integration points between the on-premises Azure Local solution and Azure cloud." border="false" lightbox="media/hybrid-capabilities-with-azure-services-23h2/azure-stack-hci-solution.png":::

## Hybrid capabilities in Azure Local

With hybrid integration through Azure Arc, you can manage, monitor, secure, and update your on-premises Azure Local environment using familiar Azure tools, such as the [Azure portal](manage/azure-portal.md), [Azure PowerShell](/powershell/module/az.stackhci/?view=azps-7.2.0&preserve-view=true), and [Azure CLI](/cli/azure/stack-hci?view=azure-cli-latest&preserve-view=true).

Hybrid integration supports the following capabilities:

- **Registration.** To enable hybrid capabilities, you must register every Azure Local that you intend to connect with Azure Arc. For more information, see [Register your machines and assign permissions for Azure Local deployment](deploy/deployment-arc-register-server-permissions.md).

- **Deployment and security.** Azure Local supports cloud-based deployment through the Azure portal or an Azure Resource Manager deployment template. For more information, see [Deploy Azure Local using the Azure portal](deploy/deploy-via-portal.md) and [Deploy Azure Local via the Azure Resource Manager deployment template](deploy/deployment-azure-resource-manager-template.md).

    The Azure Local deployment follows a secure-by-default strategy, including a tailored security baseline, a security drift control mechanism, and default security features. Post-deployment, you can view the security settings for Azure Local via the Azure portal. For more information, see [About security features](concepts/security-features.md).

- **Updates.** You can keep your Azure Local solution up-to-date with security fixes and feature improvements. The latest updates are identified and applied from the cloud through the Azure Update Manager tool. For more information, see [About updates for Azure Local](update/about-updates-23h2.md).

- **Monitoring.** You can perform basic monitoring of all Azure Local resources and confirm the deployment via the Azure portal. For more information, see [Verify a successful deployment](deploy/deploy-via-portal.md#verify-a-successful-deployment). Advanced monitoring utilizes Azure Monitor tools, such as Insights, Metrics, Logs, Workbooks, and Alerts. For information about monitoring Azure Local, see [What is Azure Local monitoring?](concepts/monitoring-overview.md).

- **Observability and support.** Azure Local observability feature collects telemetry and diagnostic data, which helps Microsoft in system analysis and issue resolution. Observability and remote support are integral to the Azure Local deployment process. For more information, see [Azure Local observability](concepts/observability.md) and [Get remote support for Azure Local](manage/get-remote-support.md).

- **Billing.** The Azure Local cloud service sends usage data to Azure Commerce to calculate the monthly bill for the registered subscription. You can pay for Azure Local through your Azure subscription. For more information, see [Azure Local billing and payment](concepts/billing.md).

- **Licensing.** An Azure Local requires cloud connectivity to keep its license up to date. The Azure Local cloud service validates proper registrations and distributes new licenses. To learn more about how licensing impacts functionality, see [Azure Local FAQ - What happens if the 30-day limit is exceeded?](faq.yml#what-happens-if-the-30-day-limit-is-exceeded)

   Azure verification for VMs makes it possible for supported Azure-exclusive workloads to work outside of the cloud. This feature is a built-in platform attestation service that is enabled by default on Azure Local. For more information, see [Azure verification for VMs](deploy/azure-verification.md?tabs=azureportal).

- **Diagnostics.** Azure Local diagnostic data helps Microsoft detect, diagnose, and fix problems to restore service health and improve products. To collect diagnostic data for a registered and connected system, see [Collect diagnostic logs for Azure Local](manage/collect-logs.md). To collect diagnostics data in scenarios where observability components aren't deployed or during issues with the system registration process, see [Perform standalone log collection](manage/get-support-for-deployment-issues.md#perform-standalone-log-collection).

- **Enhanced management.** You can perform enhanced management of your Azure Local from Azure. This feature is enabled by the Managed Identity created for your Azure Local resource that serves as the identity for the various components of your system. For more information, see [Enhanced management of Azure Local from Azure](manage/azure-enhanced-management-managed-identity.md).

## Workloads enabled by Azure Arc on Azure Local

Azure Arc enables you to deploy and run many Azure-native workloads directly within your Azure local environments.

The following table describes the workloads enabled by Azure Arc that are supported on Azure Local:

| Service | Description | Learn More |
|--|--|--|
| **Azure Kubernetes Service (AKS)** | AKS on Azure Local uses Azure Arc to create new Kubernetes clusters on Azure Local directly from Azure. It enables you to use familiar tools like the Azure portal, Azure CLI, and Azure Resource Manager templates to create and manage your Kubernetes clusters running on Azure Local. | [What's new in AKS on Azure Local](/azure/aks/hybrid/aks-whats-new-23h2). |
| **Azure Virtual Desktop (AVD)** | Deploy AVD on Azure Local using the Azure portal, CLI, or PowerShell. | [Deploy Azure Virtual Desktop](/azure/virtual-desktop/deploy-azure-virtual-desktop). |
| **Azure Local VMs enabled by Azure Arc** | Windows and Linux VMs hosted outside Azure, on your corporate network, running on Azure Local. | [Create Azure Local virtual machines enabled by Azure Arc](./manage/create-arc-virtual-machines.md). |
| **SQL Server** | Run SQL Server and Storage Spaces Direct on Azure Local for a highly available, cost-efficient, and flexible platform. | [Deploy SQL Server on Azure Local](./deploy/sql-server-23h2.md). |
| **SQL Managed Instance** | Provide description. | Provide a Learn more link. |
| **PostgreSQL** | Provide description. | Provide a Learn more link. |
| **Video Indexer** | Provide description. | Provide a Learn more link. |
| **Machine Learning** | Provide description. | Provide a Learn more link. |
| **Azure IoT Operations** | Provide description. | Provide a Learn more link. |
| **Container Apps** | Provide description. | Provide a Learn more link. |
| **Logic Apps** | Provide description. | Provide a Learn more link. |

## Services enabled by Azure Arc to manage Azure Local infrastructure

Azure Arc simplifies governance and management of Azure Local infrastructure by delivering a consistent management plane from Azure. There are many services enabled by Azure Arc that you can use to monitor system health, enforce policies, automate updates, secure workloads, and ensure compliance.

The following table describes Azure services enabled by Azure Arc that are used for managing Azure Local infrastructure:

| Service | Description | Learn More |
|--|--|--|
| **Azure Update Manager** | Azure Update Manager allows you to apply, view, and manage updates for each Azure Local instance across your infrastructure, including remote or branch offices. | [Use Azure Update Manager to update your Azure Local](update/azure-update-manager-23h2.md). |
| **Azure Monitor** | Azure Local utilizes Azure Monitor tools, such as Insights, Metrics, Logs, Workbooks, and Alerts. These tools help collect data, analyze, and proactively respond to consistent or trending variances from your established baseline. |  [Overview of Azure Local monitoring](./concepts/monitoring-overview.md). |
| **Microsoft Defender for Cloud (Preview)** | Protects Azure Local from cyber threats and vulnerabilities. The **Defender for Servers** plan offers enhanced security features, including alerts for individual machines and Azure Local VMs. | [Manage system security with Microsoft Defender for Cloud (preview)](./manage/manage-security-with-defender-for-cloud.md). |
| **Microsoft Defender for Endpoints** | Provide description. | Provide a learn more link. |
| **Azure Policy** | Enforces organizational standards and assesses compliance at scale. | [Azure Policy](/azure/governance/policy/overview). |
| **Azure Machine Configuration** | Enables auditing and configuring OS settings as code for machines and VMs. Provided by Azure Instance Metadata Service (IMDS) at no cost. | [Azure Machine configuration](/azure/governance/machine-configuration). |
| **Configuration Management** | Adjust vCPU, memory, disks, NICs. Provide content | Provide a learn more link. |
| **Azure Backup** | <!--This service is in the original article but not in the spreadsheet. Confirm if it should be in the article.-->Use Microsoft Azure Backup Server (MABS) v3 UR2 to back up Azure Local host (System State/BMR) and VMs. | [Back up Azure Local virtual machines with MABS](/azure/backup/back-up-azure-stack-hyperconverged-infrastructure-virtual-machines). |
| **Azure Site Recovery** | <!--This service is in the original article but not in the spreadsheet. Confirm if it should be in the article.-->Continuously replicate VMs from Azure Local to Azure, with failover and failback support. | [Protect your Hyper-V Virtual Machines with Azure Site Recovery and Windows Admin Center](manage/azure-site-recovery.md). |
| **Azure Key Vault** | <!--This service shown in the diagram but not listed in the spreadsheet. Confirm if we should include it.-->Provide description.    | Provide a learn more link. |
| **Azure File Sync** |<!--This service shown in the diagram but not listed in the spreadsheet. Confirm if we should include it.--> Provide description.   | Provide a learn more link. |

## Services enabled by Azure Arc to manage Azure Local VMs

Administrators can manage Azure Local VMs enabled by Azure Arc on their Azure Local instances by using Azure management tools, including the Azure portal, the Azure CLI, Azure PowerShell, and [Azure Resource Manager](/azure/azure-resource-manager/management/overview) templates. For more information, see [What is Azure Local VM management?](./manage/azure-arc-vm-management-overview.md)

For a complete list of Azure services enabled by Azure Arc to manage Azure Local VMs, see the table under [Comparison of VM management capabilities](./concepts/compare-vm-management-capabilities.md#comparison-of-vm-management-capabilities).

## Next steps

- [Azure Local overview](overview.md).
- [Azure Local FAQ](faq.yml).
