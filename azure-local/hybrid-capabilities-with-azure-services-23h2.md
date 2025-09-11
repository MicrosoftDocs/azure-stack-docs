---
title: Hybrid capabilities with Azure services in Azure Local
description: This article describes the cloud service components of Azure Local.
ms.topic: overview
author: alkohli
ms.author: alkohli
ms.date: 09/09/2025
ms.custom: e2e-hybrid
---

# Hybrid capabilities with Azure services in Azure Local

This article outlines the hybrid capabilties available in Azure Local and describes the distinct ways Azure Arc enables these cababilities.

## Hybrid integration of Azure services with Azure Local

Azure Local allows you to take advantage of both cloud and on-premises resources working together. Through integration with Azure services, you can natively monitor, secure, and back up your local environment to Azure. [Azure Arc](/azure/azure-arc/overview) plays a cental role in this integration by extending the Azure control plane to your existing infrastructure. This integration allows you to run Azure-native workloads on Azure Local, and use Arc-enabled Azure services to manage both Azure Local infrastructure and VMs.

The following diagram shows how Azure Arc provides hybrid integration between Azure services and Azure Local and extends Azure control pane to your Azure Local environment:

:::image type="content" source="media/hybrid-capabilities-with-azure-services-23h2/azure-stack-hci-solution.png" alt-text="The architecture diagram of the Azure Local solution, which shows the integration points between the on-premises Azure Local solution and Azure cloud." border="false" lightbox="media/hybrid-capabilities-with-azure-services-23h2/azure-stack-hci-solution.png":::

## Hybrid capabilities in Azure Local

The hybrid capabilities in Azure Local help extend Azure’s control plane to your on-premises infrastructure. These capabilities are enabled by the Azure Local cloud service and Azure Arc, allowing you to manage, monitor, secure, and update your local environment using familiar Azure tools, such as the [Azure portal](manage/azure-portal.md), [Azure PowerShell](/powershell/module/az.stackhci/?view=azps-7.2.0&preserve-view=true), and [Azure CLI](/cli/azure/stack-hci?view=azure-cli-latest&preserve-view=true).

The hybrid integration supports the following capabilities:

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

## Workloads enabled by Azure Arc that run on Azure Local

Azure Arc enables you to deploy and run many Azure-native workloads directly within your Azure local environments.

Here's a list of the workloads enabled by Azure Arc that are supported on Azure Local:

- **Azure Kubernetes Service (AKS) on Azure Local.** AKS on Azure Local uses Azure Arc to create new Kubernetes clusters on Azure Local directly from Azure. It enables you to use familiar tools like the Azure portal, Azure CLI, and Azure Resource Manager templates to create and manage your Kubernetes clusters running on Azure Local. For more information, see [What's new in AKS on Azure Local](/azure/aks/hybrid/aks-whats-new-23h2).

- **Azure Virtual Desktop (AVD) on Azure Local.** You can deploy Azure Virtual Desktop on Azure Local by using the Azure portal, the Azure CLI, or Azure PowerShell. For more information, see [Deploy Azure Virtual Desktop](/azure/virtual-desktop/deploy-azure-virtual-desktop).

- **Azure Local VMs enabled by Azure Arc.** Azure Local VMs are Windows and Linux VMs hosted outside Azure, on your corporate network, running on Azure Local. For more information, see [Create Azure Local virtual machines enabled by Azure Arc](./manage/create-arc-virtual-machines.md).

- **SQL Server enabled by Azure Arc.** Azure Local provides a highly available, cost efficient, flexible platform to run SQL Server and Storage Spaces Direct. For more information, see [Deploy SQL Server on Azure Local](./deploy/sql-server-23h2.md).

- **SQL Managed Instance enabled by Azure Arc.** 
- PostgreSQL enabled by Azure Arc
- Video Indexer
- Machine Learning
- Azure IoT Operations
- Container Apps
- Logic Apps

<!--I don't see Azure Site Recovery and Azure Backup in the list.-->

For a complete list of Arc-enabled workloads supported on Azure Local, see [Azure Services support spreadsheet](link to the spreadsheet).

## Services enabled by Azure Arc to manage Azure Local infrastructure

Azure Arc simplifies governance and management of Azure Local infrastructure by delivering a consistent management plane from Azure. There are many Arc-enabled services that you can use to monitor system health, enforce policies, automate updates, secure workloads, and ensure compliance.

Here's a list of Azure services for managing Azure Local infrastructure:

- **Azure Update Manager.** Azure Update Manager is an Azure service that allows you to apply, view, and manage updates for each of your Azure Local instances. You can view each Azure Local across your entire infrastructure, or in remote or branch offices and update at scale. For more information, see [Use Azure Update Manager to update your Azure Local](update/azure-update-manager-23h2.md).

- **Azure Monitor.** Azure Local utilizes Azure Monitor tools, such as Insights, Metrics, Logs, Workbooks, and Alerts. These tools help collect data, analyze, and proactively respond to consistent or trending variances from your established baseline. See [Overview of Azure Local monitoring](./concepts/monitoring-overview.md).

- **Microsoft Defender for Cloud (Preview).** Microsoft Defender for Cloud protects Azure Local from various cyber threats and vulnerabilities. It helps improve the security posture of Azure Local, and can protect against existing and evolving threats. With the paid Defender for Servers plan, you get enhanced security features including security alerts for individual machines and Arc VMs. For more information, see [Manage system security with Microsoft Defender for Cloud (preview)](./manage/manage-security-with-defender-for-cloud.md).

- Microsoft Defender for Endpoints <!--Couldn't find reference in docs.-->

- **Azure Policy.** Azure Policy helps to enforce organizational standards and to assess compliance at-scale. For more information, see [Azure Policy](/azure/governance/policy/overview).

- **Azure Machine Configuration.** [Azure Machine configuration](/azure/governance/machine-configuration) (formerly Azure Policy Guest Configuration) is provided by the Azure Instance Metadata Service (IMDS). It's available at no cost and enables auditing and configuring OS settings as code for machines and VMs.

- **Configuration management.** Adjust vCPU, memory, disks, NICs <!--Couldn't find reference in docs.-->

<!--The following two services are not listed in the spreadsheet-->

- **Azure Backup.** With Microsoft Azure Backup Server (MABS) v3 UR2, you can back up Azure Local host (System State/BMR) and virtual machines (VMs) running on your Azure Local. To learn more about Azure Backup, see [Back up Azure Local virtual machines with MABS](/azure/backup/back-up-azure-stack-hyperconverged-infrastructure-virtual-machines).

- **Azure Site Recovery.** With Azure Site Recovery support, you can continuously replicate VMs from Azure Local to Azure, as well as fail over and fail back. To learn more about Azure Site Recovery, see [Protect your Hyper-V Virtual Machines with Azure Site Recovery and Windows Admin Center](manage/azure-site-recovery.md).

- Azure Key Vault
- Azure File Sync
- 
## Services enabled by Azure Arc to manage Azure Local VMs

Administrators can manage Azure Local VMs enabled by Azure Arc on their Azure Local instances by using Azure management tools, including the Azure portal, the Azure CLI, Azure PowerShell, and [Azure Resource Manager](/azure/azure-resource-manager/management/overview) templates. For more information, see [What is Azure Local VM management?](./manage/azure-arc-vm-management-overview.md)

For a complete list of Arc-enabled services to manage Azure Local VMs, see the table under [Comparison of VM management capabilities](./concepts/compare-vm-management-capabilities.md#comparison-of-vm-management-capabilities).

<!--## Azure Arc on Azure Local

Azure Arc simplifies governance and management by delivering a consistent management plane from Azure. To learn more about Azure Arc, see [Azure Arc overview](/azure/azure-arc/overview). For additional guidance regarding the different services Azure Arc offers, see [Choosing the right Azure Arc service for machines](/azure/azure-arc/choose-service).

Azure Local delivers hybrid value through the following Azure Arc technologies:

- [**Arc-enabled servers.**](/azure/azure-arc/servers/overview) As part of the Azure Local deployment process, you must register every Azure Local that you intend to join with Azure Arc. For more information, see [Register your machines and assign permissions for Azure Local deployment](deploy/deployment-arc-register-server-permissions.md).

    You can install, upgrade, and manage Azure Arc extensions on Azure Local to run hybrid services like monitoring and Windows Admin Center in the Azure portal. For more information, see [Azure Arc extension management on Azure Local](manage/arc-extension-management.md).

- **Azure Local VMs.** Azure Local VM management lets you provision and manage Windows and Linux VMs hosted in an on-premises Azure Local environment. Administrators can manage VMs on their Azure Local by using Azure management tools, including Azure portal, Azure CLI, Azure PowerShell, and Azure Resource Manager (ARM) templates. For more information, see [What is Azure Arc VM management?](manage/azure-arc-vm-management-overview.md).

- [**Azure Kubernetes Service (AKS) enabled by Arc.**](/azure/aks/hybrid/) AKS on Azure Local uses Azure Arc to create new Kubernetes clusters on Azure Local directly from Azure. It enables you to use familiar tools like the Azure portal, Azure CLI, and Azure Resource Manager templates to create and manage your Kubernetes clusters running on Azure Local. For more information, see [What's new in AKS on Azure Local](/azure/aks/hybrid/aks-whats-new-23h2).

## Other Azure hybrid services

In addition to hybrid functionality provided through Azure Arc, you can enable the following Azure services for other hybrid capabilities on Azure Local:

- **Azure Backup.** With Microsoft Azure Backup Server (MABS) v3 UR2, you can back up Azure Local host (System State/BMR) and virtual machines (VMs) running on your Azure Local. To learn more about Azure Backup, see [Back up Azure Local virtual machines with MABS](/azure/backup/back-up-azure-stack-hyperconverged-infrastructure-virtual-machines).

- **Azure Site Recovery.** With Azure Site Recovery support, you can continuously replicate VMs from Azure Local to Azure, as well as fail over and fail back. To learn more about Azure Site Recovery, see [Protect your Hyper-V Virtual Machines with Azure Site Recovery and Windows Admin Center](manage/azure-site-recovery.md).

- **Azure Update Manager.** Azure Update Manager is an Azure service that allows you to apply, view, and manage updates for each of your Azure Local instances. You can view each Azure Local across your entire infrastructure, or in remote or branch offices and update at scale. For more information, see [Use Azure Update Manager to update your Azure Local](update/azure-update-manager-23h2.md).

## Next steps

- [Azure Local overview](overview.md).
- [Azure Local FAQ](faq.yml).
