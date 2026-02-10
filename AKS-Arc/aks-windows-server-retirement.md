---
title: Retirement of AKS architecture on Windows Server
description: Learn about the retirement of AKS on Windows Server.
ms.topic: how-to
ms.custom: linux-related-content
author: davidsmatlak
ms.author: davidsmatlak
ms.date: 11/19/2025
ms.lastreviewed: 01/28/2026

# Intent: As an IT Pro, I want to move my workloads from AKS on Windows Server to the latest version of AKS on Azure Local.
# Keyword: retirement
---

# Announcing the retirement of AKS enabled by Azure Arc on Windows Server

Azure Kubernetes Service enabled by Azure Arc (AKS Arc) is a managed Kubernetes service that you can use to deploy and manage containerized applications on-premises, in datacenters, or at edge locations. You can use familiar Azure tools to create and manage your Kubernetes clusters. Microsoft remains committed to supporting AKS Arc on Windows Server platforms through March 2028. To ensure Azure continues to deliver a secure, reliable, and consistent experience, AKS enabled by Azure Arc architecture on Windows Server is being retired in stages between March 2026 and March 2028:

- Windows Server 2019 node pools are being deprecated in March 2026.
- Windows Server 2022 node pools are being deprecated in March 2027.
- Windows Server 2019, 2022, and 2025 as the host operating system are being deprecated in March 2028.

> [!IMPORTANT]
> AKS enabled by Azure Arc on Windows Server is supported through March 2028, when the Windows Server–based AKS Arc architecture is being retired. Windows Server 2019 and 2022 node pools are deprecated in March 2026 and March 2027, respectively; these changes affect only the Windows OS used for Kubernetes worker nodes and don't impact AKS Arc architecture or deployment support on Windows Server before March 2028. AKS Arc on Azure Local remains fully supported and provides a Windows Server–based, cloud-managed platform for AKS Arc clusters.

## If you're using Windows Server 2019 nodepools

Windows Server 2019 node pools in AKS Arc clusters are being deprecated in March 2026. After this date, new Windows Server 2019 node pools can't be created, and existing ones no longer receive security or quality updates. To prepare, migrate workloads to Windows Server 2022 node pools. You should also evaluate Azure Local as a long-term platform for AKS Arc, as it provides the most robust support experience and continued feature innovation. This change affects only Windows worker nodes and doesn't impact AKS Arc cluster support or operations.

## Deploy AKS Arc on Azure Local from Windows Server 2019, 2022

You now manage AKS Arc deployments on modern Azure Local entirely through Azure Resource Manager (ARM). This change means administrators must use cloud-based tools such as the Azure CLI (az commands), the Azure portal web interface, or Azure Resource Manager templates to perform cluster operations. This architectural shift aligns AKS Arc management with Microsoft's broader cloud-first strategy and ensures consistency across different deployment scenarios. However, it requires administrators to adapt their operational procedures and tooling to work with Azure-based management interfaces rather than local ones. This change means that local, PowerShell, or Windows Admin Center commands such as `Update-AksHciCluster` that worked on Windows Server, don't work on Azure Local.

Also, AKS Arc functionality is tightly coupled with having a current, supported version of Azure Local as the underlying infrastructure. This dependency means that organizations can't upgrade AKS Arc independently. They must ensure their Azure Local platform itself is running a supported version to enable proper AKS Arc functionality.

#### Evaluate if Azure Local is right for you

[Compare Windows Server](/azure/azure-local/concepts/compare-windows-server) explains key differences between Azure Local and Windows Server and provides guidance on when to use each. Microsoft actively supports and maintains both products. Many organizations choose to deploy both, as they're intended for different and complementary purposes.

#### Uninstall AKS Arc on Windows Server

Before you move to Azure Local, follow these steps to disconnect AKS Arc workload clusters from Azure Arc and then uninstall AKS Arc:

- Identify all your Arc-connected AKS Arc workload clusters, and then [disconnect your AKS workload clusters from Azure Arc](connect-to-arc.md#disconnect-your-aks-cluster-from-azure-arc)
- Uninstall AKS Arc using [`Uninstall-AksHci`](/azure/aks/aksarc/reference/ps/uninstall-akshci). This step removes all AKS-related configuration from Windows Server.

#### Deploy a supported version of Azure Local

[Deploy Azure Local from Azure portal or an Azure Resource Manager template](/azure/azure-local/deploy/deployment-introduction).

#### Deploy an AKS cluster on Azure Local

- [Review the networking prerequisites](aks-hci-network-system-requirements.md) for deploying AKS Arc on Azure Local.
- [Deploy an AKS Arc cluster on Azure Local using Az CLI, Azure portal, and ARM templates, etc.](aks-create-clusters-cli.md)

## Next steps

- [Compare AKS Arc Platforms](aks-platforms-compare.md).
- [Compare Windows Server with Azure Local](/azure/azure-local/concepts/compare-windows-server).