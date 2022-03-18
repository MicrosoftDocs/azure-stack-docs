---
title: Hybrid capabilities with Azure services
description: This article describes the cloud service components of Azure Stack HCI.
ms.topic: overview
author: ManikaDhiman
ms.author: v-mandhiman
ms.date: 02/23/2022
ms.custom: "e2e-hybrid, contperf-fy22q1"
---

# Azure Stack HCI hybrid capabilities with Azure services

> Applies to: Azure Stack HCI, versions 21H2 and 20H2

Your on-premises Azure Stack HCI solution integrates with Azure cloud via several cloud service components—such as Azure Stack HCI cloud service, Azure Arc, and other Azure hybrid services. This article describes the functionality provided by these cloud service components, and how they help provide hybrid capabilities to your Azure Stack HCI deployment.

:::image type="content" source="media/overview/azure-stack-hci-cloud-services.png" alt-text="Diagram shows the integration points between the on-premises Azure Stack HCI solution and Azure cloud" border="false":::

## Azure Stack HCI cloud service

The Azure Stack HCI cloud service in Azure is an integral part of the Azure Stack HCI product offering. In your Azure Stack HCI cluster, the Azure Stack HCI operating system (OS) has an always-running system service called HciSvc. This OS service initiates communications to the Azure Stack HCI cloud service to deliver the following core functionality:

- **Registration.** The Azure Stack HCI cloud service processes registration requests initiated from Azure Stack HCI OS deployments. You must register your Azure Stack HCI cluster with Azure to enable other hybrid capabilities. To learn more about registration, see [Connect Azure Stack HCI to Azure](deploy/register-with-azure.md).

- **Monitoring.** View all of your Azure Stack HCI clusters in a single, global view where you can group them by resource group and tag them. The Azure Stack HCI cloud service enables access to a projected view of your Azure Stack HCI clusters in the Azure portal and other Azure tools. To learn more about basic monitoring, see [Use the Azure portal with Azure Stack HCI](manage/azure-portal.md). Advanced monitoring can also be optionally enabled via Azure Arc and Azure Monitor. This is covered in the [Azure Arc on Azure Stack HCI](#azure-arc-on-azure-stack-hci) section of this article.

- **Support.** Azure Stack HCI follows the same support process as Azure. The Azure Stack HCI cloud service, through its projected view of your Azure Stack HCI cluster in the Azure portal, enables you to create and support requests. To learn more about support, see [Get support for Azure Stack HCI](manage/get-support.md).

- **Billing.** Pay for Azure Stack HCI through your Azure subscription. The Azure Stack HCI cloud service sends usage data to Azure Commerce to calculate the monthly bill for the registered subscription. To learn more about billing, see [Azure Stack HCI billing and payment](concepts/billing.md).

- **Licensing.** An Azure Stack HCI cluster requires cloud connectivity to keep its license up to date. The Azure Stack HCI cloud service validates proper registrations and distributes new licenses. To learn more about how licensing impacts functionality, see [Azure Stack HCI FAQ - What happens if the 30-day limit is exceeded?](faq.yml#what-happens-if-the-30-day-limit-is-exceeded)

    The Azure Stack HCI cloud service also distributes certificates to the Azure Stack HCI clusters that have the Azure Benefits service enabled. To learn more about Azure Benefits, see [Azure Benefits on Azure Stack HCI](manage/azure-benefits.md).

- **Diagnostics.** We collect required diagnostic data to keep Azure Stack HCI secure, up to date, and working as expected. The Azure Stack HCI cloud service processes this data for diagnostic purposes. To learn more about diagnostics, see [Azure Stack HCI data collection](concepts/data-collection.md).

In the Azure Stack HCI cloud service, standard Azure components exist, including a resource provider in Azure Resource Manager and a UI extension in the Azure portal. These Azure components enable access to Azure Stack HCI functionality via standard Azure tools and UX, such as [Azure portal](manage/azure-portal.md), [Azure PowerShell](/powershell/module/az.stackhci/?view=azps-7.2.0&preserve-view=true), and [Azure CLI](/cli/azure/stack-hci?view=azure-cli-latest&preserve-view=true). The Azure Stack HCI cloud service also enables contextual navigation from an Azure Stack HCI cluster resource to its Azure Arc-enabled node resources, and Azure Arc-enabled virtual machine (VM) resources.

## Azure Arc on Azure Stack HCI

Azure Arc simplifies governance and management by delivering a consistent management plane from Azure. To learn more about Azure Arc, see [Azure Arc overview](/azure/azure-arc/overview).

Azure Stack HCI delivers hybrid value through the following Azure Arc technologies:

- [**Azure Arc-enabled servers.**](/azure/azure-arc/servers/overview) Starting with Azure Stack HCI, version 21H2, registering your cluster also Arc-enables every cluster node by default. To learn more about enabling Azure Arc integration, see [Enable Azure Arc integration](deploy/register-with-azure.md#enable-azure-arc-integration).

    To monitor your Azure Arc-enabled clusters, you can enable Logs and Monitoring capabilities. To learn more about enabling Logs and Monitoring capabilities, see [Configure Azure portal to monitor Azure Stack HCI clusters](manage/monitor-azure-portal.md).

    You can also get insights on health, performance, and usage of your registered Azure Stack HCI, version 21H2 cluster via Azure Stack HCI Insights. To learn more about Azure Stack HCI Insights, see [Monitor multiple clusters with Azure Stack HCI Insights](manage/azure-stack-hci-insights.md).

- [**Azure Arc resource bridge.**](/azure/azure-arc/resource-bridge/overview) Deploying Azure Arc resource bridge enables Azure Arc-enabled VMs on Azure Stack HCI, including self-service VM creation and management. To learn more about VM provisioning through Azure portal on Azure Stack HCI, see [VM provisioning through Azure portal on Azure Stack HCI](manage/azure-arc-enabled-virtual-machines.md).

- [**Azure Arc-enabled Kubernetes.**](/azure/azure-arc/kubernetes/overview) If you run [Azure Kubernetes Service on Azure Stack HCI](../aks-hci/overview.md) , you can project it to Azure via Azure Arc-enabled Kubernetes. To learn more about connecting an Azure Kubernetes Service on Azure Stack HCI cluster, see [Connect an Azure Kubernetes Service on Azure Stack HCI cluster to Azure Arc-enabled Kubernetes](../aks-hci/connect-to-arc.md).

## Other Azure hybrid services

In addition to hybrid functionality provided through Azure Arc, you can enable the following Azure services for other hybrid capabilities on Azure Stack HCI:

- **Azure Backup.** With Microsoft Azure Backup Server (MABS) v3 UR2, you can back up Azure Stack HCI host (System State/BMR) and virtual machines (VMs) running on the Azure Stack HCI cluster. To learn more about Azure Backup, see [Back up Azure Stack HCI virtual machines with MABS](/azure/backup/back-up-azure-stack-hyperconverged-infrastructure-virtual-machines). 

- **Azure Site Recovery.** With Azure Site Recovery support, you can continuously replicate VMs from Azure Stack HCI to Azure, as well as fail over and fail back. To learn more about Azure Site Recovery, see [Protect your Hyper-V Virtual Machines with Azure Site Recovery and Windows Admin Center](manage/azure-site-recovery.md). 

## Next steps

- [Azure Stack HCI overview](overview.md)
- [Azure Stack HCI FAQ](faq.yml)