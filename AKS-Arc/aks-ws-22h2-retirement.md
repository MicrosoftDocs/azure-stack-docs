---
title: Retirement of AKS' architecture on Windows Server 2019, Windows Server 2022 and Azure Local, version 22H2
description: Learn about retirement of AKS on Windows Server 2019, Windows Server 2022 and Azure Local, version 22H2
ms.topic: how-to
ms.custom: linux-related-content
author: sethmanheim
ms.author: abha 
ms.date: 03/26/2025

# Intent: As an IT Pro, I want to move my workloads from AKS on Windows Server to the latest version of AKS on Azure Local.
# Keyword: retirement
---

# Announcing the 3-year retirement of AKS on Windows Server and Azure Local, version 22H2

[!INCLUDE [aks-hybrid-applies-to-azure-stack-hci-windows-server-sku](includes/aks-hci-applies-to-skus/aks-hybrid-applies-to-azure-stack-hci-windows-server-sku.md)]).

AKS enabled by Azure Arc uses Azure Arc to create new Kubernetes clusters on Azure Local directly from Azure. It enables you to use familiar tools like the Azure portal, Azure CLI, Azure Resource Manager, Bicep and Terraform templates to create and manage your Kubernetes clusters running on Azure Local. Microsoft continues to focus on delivering consistent user experience for all your AKS clusters. To continue ensuring Azure remains the best possible experience with the highest standards of safety and reliability, **we will be retiring the current architecture of AKS on Windows Server 2019 and AKS on Windows Server 2022 in 3-years time, on March 27, 2028**

## What is AKS on Azure Local? 
AKS on Azure Local uses Azure Arc to create new Kubernetes clusters on Azure Local directly from Azure. Since clusters are automatically connected to Azure Arc when they’re created, you can use your Microsoft Entra ID for connecting to your clusters from anywhere. This ensures your developers and application operators can provision and configure Kubernetes clusters in accordance with company policies.

The following Kubernetes cluster deployment and management capabilities are available:
- Pricing: AKS is now included in Azure Local pricing, effective January 2025. This means that you only need to pay for Azure Local. There are no separate costs for running AKS clusters, including Linux and Windows node pools.
- Simplified infrastructure deployment on Azure Local. Infrastructure components of AKS Arc like Arc Resource Bridge, Custom Location and the Kubernetes Extension for the AKS Arc operator, are all deployed as part of the Azure Local. 
- Integrated infrastructure upgrade on Azure Local. The whole lifecycle management of AKS Arc infrastructure follows the same approach as the other components on Azure Local.
- Cloud-based management: Create and manage Kubernetes clusters on Azure Local with familiar tools such as the Azure portal, Azure CLI, Azure Resource Manager, Bicep and Terraform templates.
- Arc Gateway integration. Deploy AKS Arc clusters with pod-level Arc Proxy and communicate with the Arc gateway, reducing the list of outbound URLs to configure in an isolated network environment.
- Integration with Entra ID and Azure RBAC: Enable Azure RBAC for Kubernetes while creating AKS Arc clusters.  Deploy AKS Arc clusters with workload identity enabled and deploy application pods with the workload identity label to access Microsoft Entra ID protected resources, such as Azure Key Vault. 
- Support for NVIDIA T4. Create Linux node pools in new VM sizes with GPU NVIDIA T4.
- K8S Audit Logs: Export audit logs and other control plane logs to one or more destinations.
- Improved certificate management: Shut down AKS Arc clusters for up to 7 days without any certificate expiration issues. Automatically repair certificates, managed by cert-tattoo, that expired when the cluster was shut down.
- Pricing: AKS is now included in Azure Local pricing, effective January 2025. This means that you only need to pay for Azure Local. There are no separate costs for running AKS clusters, including Linux and Windows node pools.

## If you're using Azure Kubernetes Service on Windows Server 2019 or Windows Server 2022:
Azure Kubernetes Service's current architecture on Windows Server 2019 and Windows Server 2022 will be retired on 27 March 2028. Starting March 27 2028, you'll no longer get support, security and quality updates for your existing Azure Kubernetes Service clusters. Additionally, you will not be able to deploy, upgrade or scale the current architecture of Azure Kubernetes Service on Windows Server 2019 and Windows Server 2022.

## If you're using Azure Kubernetes Service on Azure Local, version 22H2:
If you're using AKS on Azure Local, version 22H2, be aware that Azure Local, version 22H2 will reach end of service on May 31 2025. After that, you won't receive monthly security and quality updates that provide protection from the latest security threats. To continue receiving updates, we recommend updating to the latest version of Azure Local.

## Deploying AKS on Azure Local, version 23H2 or later

## Next steps

- [Review requirements](./system-requirements.md)
- [Set upAKS on Azure Local and Windows Server using Windows Admin Center](./create-kubernetes-cluster.md)
- [Set up an Azure Kubernetes Service host on Azure Local and deploy a workload cluster using PowerShell](./kubernetes-walkthrough-powershell.md)
