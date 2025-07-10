---
title: Retirement of AKS architecture on Windows Server 2019 and Windows Server 2022
description: Learn about retirement of AKS on Windows Server 2019 and Windows Server 2022.
ms.topic: how-to
ms.custom: linux-related-content
author: sethmanheim
ms.author: sethm
ms.date: 03/26/2025

# Intent: As an IT Pro, I want to move my workloads from AKS on Windows Server to the latest version of AKS on Azure Local.
# Keyword: retirement
---

# Announcing the 3-year retirement of AKS on Windows Server current architecture

AKS enabled by Azure Arc uses Azure Arc to create new Kubernetes clusters on Azure Local directly from Azure. It enables you to use familiar tools such as the Azure portal, Azure CLI, Azure Resource Manager, and Bicep and Terraform templates to create and manage your Kubernetes clusters running on Azure Local. Microsoft continues to focus on delivering consistent user experience for all your AKS clusters. To continue ensuring Azure remains the best possible experience with the highest standards of safety and reliability, **we are retiring the current architecture of AKS on Windows Server 2019 and AKS on Windows Server 2022 in 3 years, on March 27, 2028**.

## What is AKS on Azure Local?

AKS on Azure Local uses Azure Arc to create new Kubernetes clusters on Azure Local directly from Azure. Since clusters are automatically connected to Azure Arc when they're created, you can use your Microsoft Entra ID for connecting to your clusters from anywhere. This ensures your developers and application operators can provision and configure Kubernetes clusters in accordance with company policies.

The following Kubernetes cluster deployment and management capabilities are available:

- **Pricing**: AKS is now included in Azure Local pricing, effective January 2025. This means that you only need to pay for Azure Local.
- **Simplified infrastructure deployment on Azure Local**. Infrastructure components of AKS Arc like Arc Resource Bridge, Custom Location and the Kubernetes Extension for the AKS Arc operator, are all deployed as part of the Azure Local. The whole lifecycle management of AKS Arc infrastructure follows the same approach as the other components on Azure Local.
- **Cloud-based management**: Create and manage Kubernetes clusters on Azure Local with familiar tools such as the Azure portal, Azure CLI, Azure Resource Manager, and Bicep and Terraform templates.
- **Arc Gateway integration**: Deploy AKS Arc clusters with pod-level Arc Proxy and communicate with the Arc gateway, reducing the list of outbound URLs to configure in an isolated network environment.
- **Integration with Entra ID and Azure RBAC**: Enable Azure RBAC for Kubernetes while creating AKS Arc clusters. Deploy AKS Arc clusters with workload identity enabled and deploy application pods with the workload identity label to access Microsoft Entra ID protected resources, such as Azure Key Vault.
- **Support for NVIDIA T4**: Create Linux node pools in new VM sizes with GPU NVIDIA T4.
- **K8s Audit Logs**: Export audit logs and other control plane logs to one or more destinations.
- **Improved certificate management**: Shut down AKS Arc clusters for up to 7 days without any certificate expiration issues. Automatically repair certificates, managed by cert-tattoo, that expired when the cluster was shut down.

## If you're using Azure Kubernetes Service on Windows Server 2019 or Windows Server 2022

The Azure Kubernetes Service current architecture on Windows Server 2019 and Windows Server 2022 will be retired on 27 March 2028. Starting on March 27 2028, you no longer get support, security and quality updates for your existing Azure Kubernetes Service clusters. Additionally, you won't be able to deploy, upgrade or scale the current architecture of Azure Kubernetes Service on Windows Server 2019 and Windows Server 2022.

## If you're using Azure Kubernetes Service on Azure Local, version 22H2

If you're using AKS on Azure Local, version 22H2, be aware that Azure Local, version 22H2 will reach end of service on May 31 2025. After that, you won't receive monthly security and quality updates that provide protection from the latest security threats. To continue receiving updates, we recommend updating to the latest version of Azure Local.

## Deploy AKS on Azure Local

### [From Windows Server 2019, 2022](#tab/ws)

AKS on Azure Local has a dependency on deploying a supported version of Azure Local. This means that local, PowerShell, or Windows Admin Center commands such as `Update-AksHciCluster` that worked on Windows Server don't work on Azure Local, since AKS deployments on Azure Local are managed via Azure Resource Manager (Azure CLI, Azure portal, etc.).

#### Evaluate if Azure Local is right for you

[Compare Windows Server](/azure/azure-local/concepts/compare-windows-server) explains key differences between Azure Local and Windows Server and provides guidance on when to use each. Both products are actively supported and maintained by Microsoft. Many organizations choose to deploy both, as they are intended for different and complementary purposes.

#### Uninstall AKS on Windows Server

Before you move to Azure Local, follow these steps to disconnect AKS workload clusters from Azure Arc and then uninstall AKS:

- Identify all your Arc-connected AKS workload clusters, and then [disconnect your AKS workload clusters from Azure Arc](connect-to-arc.md#disconnect-your-aks-cluster-from-azure-arc)
- Uninstall AKS using [`Uninstall-AksHci`](/azure/aks/aksarc/reference/ps/uninstall-akshci). This removes all AKS-related configuration from Windows Server.

#### Deploy a supported version of Azure Local

[Deploy Azure Local from Azure portal or an Azure Resource Manager template](/azure/azure-local/deploy/deployment-introduction).

#### Deploy an AKS cluster on Azure Local

- [Review the networking pre-requisites](aks-hci-network-system-requirements.md) for deploying AKS on Azure Local.
- [Deploy an AKS cluster on Azure Local using Az CLI, Azure portal and ARM templates, etc.](aks-create-clusters-cli.md).

### [From Azure Local, version 22H2](#tab/22H2)

AKS on Azure Local has a dependency on deploying a supported version of Azure Local. This means that local, PowerShell, or Windows Admin Center commands such as `Update-AksHciCluster` that worked on Azure Local, version 22H2 don't work on Azure Local, since AKS deployments on Azure Local are managed via Azure Resource Manager (Az CLI, Azure portal, etc).

#### Uninstall AKS on Azure Local, version 22H2

Before you upgrade to a supported version of Azure Local, follow these steps to disconnect AKS workload clusters from Azure Arc and then uninstall AKS:

- Identify all your Arc-connected AKS workload clusters, and then [disconnect your AKS workload clusters from Azure Arc](connect-to-arc.md#disconnect-your-aks-cluster-from-azure-arc)
- Uninstall AKS using [`Uninstall-AksHci`](/azure/aks/aksarc/reference/ps/uninstall-akshci). This removes all AKS-related configuration from Windows Server.

#### Upgrade to a supported version of Azure Local

[Upgrade Azure Local 22H2 to a supported version of Azure Local](/azure/azure-local/upgrade/about-upgrades-23h2).

#### Deploy an AKS cluster on Azure Local

- [Review the networking pre-requisites](aks-hci-network-system-requirements.md) for deploying AKS on Azure Local.
- [Deploy an AKS cluster on Azure Local using Az CLI, Azure portal and ARM templates, etc.](aks-create-clusters-cli.md).

---

## Next steps

- [Compare AKS deployment options](https://techcommunity.microsoft.com/blog/azurearcblog/comparing-feature-sets-for-aks-enabled-by-azure-arc-deployment-options/4188163).
- [Compare Windows Server with Azure Local](/azure/azure-local/concepts/compare-windows-server)
