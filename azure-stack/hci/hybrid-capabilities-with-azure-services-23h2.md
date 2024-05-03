---
title: Hybrid capabilities with Azure services in Azure Stack HCI, version 23H2
description: This article describes the cloud service components of Azure Stack HCI, version 23H2.
ms.topic: overview
author: sethmanheim
ms.author: sethm
ms.date: 05/01/2024
ms.custom: e2e-hybrid
---

# Azure Stack HCI, version 23H2 hybrid capabilities with Azure services

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2-22h2.md)]

Your on-premises Azure Stack HCI solution integrates with Azure cloud via several cloud service components, such as Azure Stack HCI cloud service, Azure Arc, and other Azure hybrid services. This article describes the functionality provided by these cloud service components, and how they help provide hybrid capabilities to your Azure Stack HCI deployment.

:::image type="content" source="media/hybrid-capabilities-with-azure-services-23h2/azure-stack-hci-solution.png" alt-text="The architecture diagram of the Azure Stack HCI solution, which shows the integration points between the on-premises Azure Stack HCI solution and Azure cloud" border="false" lightbox="media/hybrid-capabilities-with-azure-services-23h2/azure-stack-hci-solution.png":::

## Azure Stack HCI cloud service

The Azure Stack HCI cloud service in Azure is an integral part of the Azure Stack HCI product offering. In your Azure Stack HCI cluster, the Azure Stack HCI operating system (OS) has an always-running system service called HciSvc. This OS service initiates communications to the Azure Stack HCI cloud service to deliver the following core functionality:

- **Registration.** <!--please confirm if the first sentence is still accurate-->The Azure Stack HCI cloud service processes registration requests initiated from Azure Stack HCI OS deployments. You must register every Azure Stack HCI server that you intend to cluster with Azure Arc to enable other hybrid capabilities. To learn more about registration, see [Register your servers and assign permissions for Azure Stack HCI, version 23H2 deployment](deploy/deployment-arc-register-server-permissions.md).

- **Monitoring.** View all of your Azure Stack HCI clusters in a single, global view where you can group them by resource group and tag them. The Azure Stack HCI cloud service enables access to a projected view of your Azure Stack HCI clusters in the Azure portal and other Azure tools. To learn more about basic monitoring, see [Use the Azure portal with Azure Stack HCI](manage/azure-portal.md). For advanced monitoring, Azure Stack HCI utilizes Azure Monitor tools, such as Insights, Metrics, Logs, Workbooks, and Alerts. These tools help collect data, analyze, and proactively respond to consistent or trending variances from your established baseline. For information about monitoring Azure Stack HCI, see [What is Azure Stack HCI monitoring?](concepts/monitoring-overview.md).

- **Support.** Azure Stack HCI follows the same support process as Azure. The Azure Stack HCI cloud service, through its projected view of your Azure Stack HCI cluster in the Azure portal, enables you to create and support requests. To learn more about support, see [Get support for Azure Stack HCI](manage/get-support.md). To address deployment issues with Azure Stack HCI deployment issues, including log collection and remote support, see [Get support for Azure Stack HCI deployment issues](manage/get-support-for-deployment-issues.md). To get remote support for your Azure Stack HCI operating system, see [Get remote support for Azure Stack HCI](manage/get-remote-support.md).

<!--need to update 'Billing'-->
- **Billing.** Pay for Azure Stack HCI through your Azure subscription. The Azure Stack HCI cloud service sends usage data to Azure Commerce to calculate the monthly bill for the registered subscription. To learn more about billing, see [Azure Stack HCI billing and payment](concepts/billing.md).

<!--need to update 'Licensing'-->
- **Licensing.** An Azure Stack HCI cluster requires cloud connectivity to keep its license up to date. The Azure Stack HCI cloud service validates proper registrations and distributes new licenses. To learn more about how licensing impacts functionality, see [Azure Stack HCI FAQ - What happens if the 30-day limit is exceeded?](faq.yml#what-happens-if-the-30-day-limit-is-exceeded)

    The Azure Stack HCI cloud service also distributes certificates to the Azure Stack HCI clusters that have the Azure Benefits service enabled. To learn more about Azure Benefits, see [Azure Benefits on Azure Stack HCI](manage/azure-benefits.md).

<!--check with Shireen if https://learn.microsoft.com/en-us/azure-stack/hci/release-information article is still applicable to 23H2.-->
- **Diagnostics.** We collect required diagnostic data to keep Azure Stack HCI secure, up to date, and working as expected. The Azure Stack HCI cloud service processes this data for diagnostic purposes. To learn more about diagnostics, see [Collect diagnostic logs for Azure Stack HCI](manage/collect-logs.md).
<!--should we add 'Observability' instead of 'Monitoring', 'Support', and 'Diagnostics'-->
<!--Should we add **Management** also as another functionality and link out to the 'Enhanced management of Azure Stack HCI from Azure' article?-->

<!--is the following para still accurate for version 23H2-->
In the Azure Stack HCI cloud service, standard Azure components exist, including a resource provider in Azure Resource Manager and a UI extension in the Azure portal. These Azure components enable access to Azure Stack HCI functionality via standard Azure tools and UX, such as [Azure portal](manage/azure-portal.md), [Azure PowerShell](/powershell/module/az.stackhci/?view=azps-7.2.0&preserve-view=true), and [Azure CLI](/cli/azure/stack-hci?view=azure-cli-latest&preserve-view=true). The Azure Stack HCI cloud service also enables contextual navigation from an Azure Stack HCI cluster resource to its Azure Arc-enabled node resources, and Azure Arc-enabled virtual machine (VM) resources.

## Azure Arc on Azure Stack HCI

Azure Arc simplifies governance and management by delivering a consistent management plane from Azure. To learn more about Azure Arc, see [Azure Arc overview](/azure/azure-arc/overview).

Azure Stack HCI delivers hybrid value through the following Azure Arc technologies:

- [**Azure Arc-enabled servers.**](/azure/azure-arc/servers/overview) As part of the Azure Stack HCI deployment process, you must register every Azure Stack HCI server that you intend to cluster with Azure Arc. For more information, see [Register your servers and assign permissions for Azure Stack HCI, version 23H2 deployment](deploy/deployment-arc-register-server-permissions.md)

    You can install, upgrade, and manage Azure Arc extensions on Azure Stack HCI server machines to run hybrid services like monitoring and Windows Admin Center in the Azure portal. For more information, see [Azure Arc extension management on Azure Stack HCI](manage/arc-extension-management.md).

- **Azure Arc VMs.** Azure Arc VM management lets you provision and manage Windows and Linux VMs hosted in an on-premises Azure Stack HCI environment. Administrators can manage Arc VMs on their Azure Stack HCI clusters by using Azure management tools, including Azure portal, Azure CLI, Azure PowerShell, and Azure Resource Manager (ARM) templates. For more information, see [What is Azure Arc VM management?](manage/azure-arc-vm-management-overview.md).

- [**Azure Kubernetes Service (AKS) enabled by Arc.**](/azure/aks/hybrid/) AKS on Azure Stack HCI, version 23H2 uses Azure Arc to create new Kubernetes clusters on Azure Stack HCI directly from Azure. It enables you to use familiar tools like the Azure portal, Azure CLI, and Azure Resource Manager templates to create and manage your Kubernetes clusters running on Azure Stack HCI. For more information, see [What's new in AKS on Azure Stack HCI version 23H2](/azure/aks/hybrid/aks-whats-new-23h2).

## Other Azure hybrid services

<!--should we include other hybrid services that are depicted in the overview diagram, such as Azure Key Vault, Azure Update Manager, Microsoft Defender for Cloud, Azure Policy, Azure File Sync, Azure Monitor?-->

In addition to hybrid functionality provided through Azure Arc, you can enable the following Azure services for other hybrid capabilities on Azure Stack HCI:

- **Azure Backup.** With Microsoft Azure Backup Server (MABS) v3 UR2, you can back up Azure Stack HCI host (System State/BMR) and virtual machines (VMs) running on the Azure Stack HCI cluster. To learn more about Azure Backup, see [Back up Azure Stack HCI virtual machines with MABS](/azure/backup/back-up-azure-stack-hyperconverged-infrastructure-virtual-machines).

- **Azure Site Recovery.** With Azure Site Recovery support, you can continuously replicate VMs from Azure Stack HCI to Azure, as well as fail over and fail back. To learn more about Azure Site Recovery, see [Protect your Hyper-V Virtual Machines with Azure Site Recovery and Windows Admin Center](manage/azure-site-recovery.md).

## Next steps

- [Azure Stack HCI overview](overview.md)
- [Azure Stack HCI FAQ](faq.yml)