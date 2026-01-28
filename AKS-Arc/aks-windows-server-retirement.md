---
title: Retirement of AKS architecture on Windows Server
description: Learn about the retirement of AKS on Windows Server.
ms.topic: how-to
ms.custom: linux-related-content
author: davidsmatlak
ms.author: davidsmatlak
ms.date: 11/19/2025
ms.reviewer: srikantsarwa
ms.lastreviewed: 07/21/2025

# Intent: As an IT Pro, I want to move my workloads from AKS on Windows Server to the latest version of AKS on Azure Local.
# Keyword: retirement
---

# Announcing the retirement of AKS enabled by Azure Arc on Windows Server

Azure Kubernetes Service enabled by Azure Arc (AKS Arc) is a managed Kubernetes service that you can use to deploy and manage containerized applications on-premises, in datacenters, or at edge locations. It enables you to use familiar tools such as the Azure portal, Azure CLI, Azure Resource Manager and Bicep templates to create and manage your Kubernetes clusters running on different infrastructure platforms. Microsoft continues to focus on delivering consistent user experience for all your AKS Arc clusters. To continue ensuring Azure remains the best possible experience with the highest standards of safety and reliability, **we are retiring the current architecture of AKS enabled by Azure Arc deployed directly on Windows Server 2019 in March 2026, and on Windows Server 2022 in March 2027**.

> [!IMPORTANT] This retirement applies specifically to AKS Arc deployed directly on Windows Server as the deployment platform. After March 2026, you cannot deploy AKS Arc clusters directly on standalone Windows Server 2019. After March 2027, you cannot deploy AKS Arc clusters directly on standalone Windows Server 2022. However, Microsoft continues to fully support AKS Arc on Azure Local, which is a Windows Server-based hyperconverged infrastructure solution. Azure Local runs on Windows Server and provides a fully supported platform for deploying AKS Arc clusters.
>
> Migration path: Plan your migration from AKS Arc on standalone Windows Server to AKS Arc on Azure Local to ensure continued support and updates. Azure Local provides an enhanced, fully supported platform for running AKS Arc workloads.

## If you're using Azure Kubernetes Service on Windows Server 2019 or Windows Server 2022

The AKS Arc current architecture deployed directly on standalone Windows Server  2019 will be retired in March 2026, and on Windows Server 2022 in March 2027. After these retirement dates:

- You no longer get support, security, and quality updates for your existing AKS Arc clusters deployed on these standalone Windows Server platforms
- You won't be able to deploy, upgrade, or scale AKS Arc on standalone Windows Server 2019 or 2022

## Deploy AKS Arc on Azure Local from Windows Server 2019, 2022

You now manage AKS Arc deployments on modern Azure Local entirely through Azure Resource Manager (ARM). This change means administrators must use cloud-based tools such as the Azure CLI (az commands), the Azure portal web interface, or Azure Resource Manager templates to perform cluster operations. This architectural shift aligns AKS Arc management with Microsoft's broader cloud-first strategy and ensures consistency across different deployment scenarios. However, it requires administrators to adapt their operational procedures and tooling to work with Azure-based management interfaces rather than local ones. This change means that local, PowerShell, or Windows Admin Center commands such as `Update-AksHciCluster` that worked on Windows Server, don't work on Azure Local.

Also, AKS Arc functionality is tightly coupled with having a current, supported version of Azure Local as the underlying infrastructure. This dependency means that organizations can't simply upgrade AKS Arc independently. They must ensure their Azure Local platform itself is running a supported version to enable proper AKS Arc functionality.

#### Evaluate if Azure Local is right for you

[Compare Windows Server](/azure/azure-local/concepts/compare-windows-server) explains key differences between Azure Local and Windows Server and provides guidance on when to use each. Microsoft actively supports and maintains both products. Many organizations choose to deploy both, as they're intended for different and complementary purposes.

#### Uninstall AKS Arc on Windows Server

Before you move to Azure Local, follow these steps to disconnect AKS Arc workload clusters from Azure Arc and then uninstall AKS Arc:

- Identify all your Arc-connected AKS Arc workload clusters, and then [disconnect your AKS workload clusters from Azure Arc](connect-to-arc.md#disconnect-your-aks-cluster-from-azure-arc)
- Uninstall AKS Arc using [`Uninstall-AksHci`](/azure/aks/aksarc/reference/ps/uninstall-akshci). This step removes all AKS-related configuration from Windows Server.

#### Deploy a supported version of Azure Local

[Deploy Azure Local from Azure portal or an Azure Resource Manager template](/azure/azure-local/deploy/deployment-introduction).

#### Deploy an AKS cluster on Azure Local

- [Review the networking pre-requisites](aks-hci-network-system-requirements.md) for deploying AKS Arc on Azure Local.
- [Deploy an AKS Arc cluster on Azure Local using Az CLI, Azure portal and ARM templates, etc.](aks-create-clusters-cli.md).


## Next steps

- [Compare AKS Arc Platforms](aks-platforms-compare.md).
- [Compare Windows Server with Azure Local](/azure/azure-local/concepts/compare-windows-server).
