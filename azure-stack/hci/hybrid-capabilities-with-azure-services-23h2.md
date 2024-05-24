---
title: Hybrid capabilities with Azure services in Azure Stack HCI, version 23H2
description: This article describes the cloud service components of Azure Stack HCI, version 23H2.
ms.topic: overview
author: ManikaDhiman
ms.author: v-manidhiman
ms.date: 05/21/2024
ms.custom: e2e-hybrid
---

# Hybrid capabilities with Azure services in Azure Stack HCI, version 23H2

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

Your on-premises Azure Stack HCI solution integrates with Azure cloud via several cloud service components, such as Azure Stack HCI cloud service, Azure Arc, and other Azure hybrid services. This article describes the functionality provided by these cloud service components, and how they help provide hybrid capabilities to your Azure Stack HCI deployment.

:::image type="content" source="media/hybrid-capabilities-with-azure-services-23h2/azure-stack-hci-solution.png" alt-text="The architecture diagram of the Azure Stack HCI solution, which shows the integration points between the on-premises Azure Stack HCI solution and Azure cloud." border="false" lightbox="media/hybrid-capabilities-with-azure-services-23h2/azure-stack-hci-solution.png":::

## Azure Stack HCI cloud service

The Azure Stack HCI cloud service in Azure is a key part of the Azure Stack HCI product offering. It includes standard Azure components, such as a resource provider in Azure Resource Manager and a UI extension in the Azure portal. These components enable access to Azure Stack HCI functionality via familiar Azure tools and UX, such as [Azure portal](manage/azure-portal.md), [Azure PowerShell](/powershell/module/az.stackhci/?view=azps-7.2.0&preserve-view=true), and [Azure CLI](/cli/azure/stack-hci?view=azure-cli-latest&preserve-view=true). The Azure Stack HCI cloud service also enables contextual navigation from an Azure Stack HCI cluster resource to its Arc machines and Arc virtual machines (VMs).

The Azure Stack HCI cloud service extends the hybrid capabilities for Azure Stack HCI by enabling the following cloud-based functionalities:

- **Registration.** To enable hybrid capabilities, you must register every Azure Stack HCI server that you intend to cluster with Azure Arc. For more information, see [Register your servers and assign permissions for Azure Stack HCI, version 23H2 deployment](deploy/deployment-arc-register-server-permissions.md).

- **Deployment and security.** Azure Stack HCI supports cloud-based deployment through the Azure portal or an Azure Resource Manager deployment template. For more information, see [Deploy Azure Stack HCI cluster using the Azure portal](deploy/deploy-via-portal.md) and [Deploy Azure Stack HCI via the Azure Resource Manager deployment template](deploy/deployment-azure-resource-manager-template.md).

    The Azure Stack HCI deployment follows a secure-by-default strategy, including a tailored security baseline, a security drift control mechanism, and default security features. Post-deployment, you can view the security settings for Azure Stack HCI via the Azure portal. For more information, see [About security features](concepts/security-features.md).

- **Updates.** You can keep your Azure Stack HCI solution up-to-date with security fixes and feature improvements. The latest updates are identified and applied from the cloud through the Azure Update Manager tool. For more information, see [About updates for Azure Stack HCI, version 23H2](update/about-updates-23h2.md).

- **Monitoring.** You can perform basic monitoring of all Azure Stack HCI cluster resources and confirm the deployment via the Azure portal. For more information, see [Verify a successful deployment](deploy/deploy-via-portal.md#verify-a-successful-deployment). Advanced monitoring utilizes Azure Monitor tools, such as Insights, Metrics, Logs, Workbooks, and Alerts. For information about monitoring Azure Stack HCI, see [What is Azure Stack HCI monitoring?](concepts/monitoring-overview.md).

- **Observability and support.** Azure Stack HCI observability feature collects telemetry and diagnostic data, which helps Microsoft in system analysis and issue resolution. Observability and remote support are integral to the Azure Stack HCI deployment process. For more information, see [Azure Stack HCI observability](concepts/observability.md) and [Get remote support for Azure Stack HCI](manage/get-remote-support.md).

- **Billing.** The Azure Stack HCI cloud service sends usage data to Azure Commerce to calculate the monthly bill for the registered subscription. You can pay for Azure Stack HCI through your Azure subscription. For more information, see [Azure Stack HCI billing and payment](concepts/billing.md).

- **Licensing.** An Azure Stack HCI cluster requires cloud connectivity to keep its license up to date. The Azure Stack HCI cloud service validates proper registrations and distributes new licenses. To learn more about how licensing impacts functionality, see [Azure Stack HCI FAQ - What happens if the 30-day limit is exceeded?](faq.yml#what-happens-if-the-30-day-limit-is-exceeded)

   Azure verification for VMs makes it possible for supported Azure-exclusive workloads to work outside of the cloud. This feature is a built-in platform attestation service that is enabled by default on Azure Stack HCI clusters. For more information, see [Azure verification for VMs](deploy/azure-verification.md?tabs=azureportal).

- **Diagnostics.** Azure Stack HCI diagnostic data helps Microsoft detect, diagnose, and fix problems to restore service health and improve products. To collect diagnostic data for a registered and connected cluster, see [Collect diagnostic logs for Azure Stack HCI](manage/collect-logs.md). To collect diagnostics data in scenarios where observability components aren't deployed or during issues with the cluster registration process, see [Perform standalone log collection](manage/get-support-for-deployment-issues.md#perform-standalone-log-collection).

- **Enhanced management.** You can perform enhanced management of your Azure Stack HCI cluster from Azure. This feature is enabled by the Managed Identity created for your Azure Stack HCI cluster resource that serves as the identity for the various components of your cluster. For more information, see [Enhanced management of Azure Stack HCI from Azure](manage/azure-enhanced-management-managed-identity.md).

## Azure Arc on Azure Stack HCI

Azure Arc simplifies governance and management by delivering a consistent management plane from Azure. To learn more about Azure Arc, see [Azure Arc overview](/azure/azure-arc/overview). For additional guidance regarding the different services Azure Arc offers, see [Choosing the right Azure Arc service for machines](/azure/azure-arc/choose-service).

Azure Stack HCI delivers hybrid value through the following Azure Arc technologies:

- [**Arc machines.**](/azure/azure-arc/servers/overview) As part of the Azure Stack HCI deployment process, you must register every Azure Stack HCI server that you intend to cluster with Azure Arc. For more information, see [Register your servers and assign permissions for Azure Stack HCI, version 23H2 deployment](deploy/deployment-arc-register-server-permissions.md)

    You can install, upgrade, and manage Azure Arc extensions on Azure Stack HCI server machines to run hybrid services like monitoring and Windows Admin Center in the Azure portal. For more information, see [Azure Arc extension management on Azure Stack HCI](manage/arc-extension-management.md).

- **Arc VMs.** Azure Arc VM management lets you provision and manage Windows and Linux VMs hosted in an on-premises Azure Stack HCI environment. Administrators can manage Arc VMs on their Azure Stack HCI clusters by using Azure management tools, including Azure portal, Azure CLI, Azure PowerShell, and Azure Resource Manager (ARM) templates. For more information, see [What is Azure Arc VM management?](manage/azure-arc-vm-management-overview.md).

- [**Azure Kubernetes Service (AKS) enabled by Arc.**](/azure/aks/hybrid/) AKS on Azure Stack HCI, version 23H2 uses Azure Arc to create new Kubernetes clusters on Azure Stack HCI directly from Azure. It enables you to use familiar tools like the Azure portal, Azure CLI, and Azure Resource Manager templates to create and manage your Kubernetes clusters running on Azure Stack HCI. For more information, see [What's new in AKS on Azure Stack HCI version 23H2](/azure/aks/hybrid/aks-whats-new-23h2).

## Other Azure hybrid services

In addition to hybrid functionality provided through Azure Arc, you can enable the following Azure services for other hybrid capabilities on Azure Stack HCI:

- **Azure Backup.** With Microsoft Azure Backup Server (MABS) v3 UR2, you can back up Azure Stack HCI host (System State/BMR) and virtual machines (VMs) running on the Azure Stack HCI cluster. To learn more about Azure Backup, see [Back up Azure Stack HCI virtual machines with MABS](/azure/backup/back-up-azure-stack-hyperconverged-infrastructure-virtual-machines).

- **Azure Site Recovery.** With Azure Site Recovery support, you can continuously replicate VMs from Azure Stack HCI to Azure, as well as fail over and fail back. To learn more about Azure Site Recovery, see [Protect your Hyper-V Virtual Machines with Azure Site Recovery and Windows Admin Center](manage/azure-site-recovery.md).

- **Azure Update Manager.** Azure Update Manager is an Azure service that allows you to apply, view, and manage updates for each of your Azure Stack HCI cluster's nodes. You can view Azure Stack HCI clusters across your entire infrastructure, or in remote or branch offices and update at scale. For more information, see [Use Azure Update Manager to update your Azure Stack HCI, version 23H2](update/azure-update-manager-23h2.md).

## Next steps

- [Azure Stack HCI overview](overview.md)
- [Azure Stack HCI FAQ](faq.yml)
