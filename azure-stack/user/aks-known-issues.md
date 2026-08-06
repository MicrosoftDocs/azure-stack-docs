---
title: Known issues for the Azure Kubernetes Service on Azure Stack Hub
description: Explore known issues and FAQs for Azure Kubernetes Service on Azure Stack Hub. Get answers about preview support, node limits, and cluster management best practices.
author: sethmanheim
ms.topic: troubleshooting-known-issue
ms.date: 07/08/2026
ms.author: sethm
ms.reviewer: waltero
ms.lastreviewed: 12/8/2021

# Intent: As an Azure Stack operator, I want to install and offer Azure Kubernetes Service on Azure Stack Hub so my supported user can offer containerized solutions.
# Keyword: Kubernetes AKS difference
---

# Common questions and known issues for the Azure Kubernetes Service on Azure Stack Hub

This article addresses common questions and known issues about the preview of AKS on Azure Stack Hub.

## Common questions about AKS

### Can I use AKS to deploy applications in production environments?

AKS on Azure Stack Hub is in preview, and Microsoft doesn't offer production support for this feature. If you're testing your application and encounter an issue, create a support ticket. To provide feedback about your experience using AKS on Azure Stack Hub, use the [Azure Stack Hub Azure Kubernetes Service Feedback Form](https://aka.ms/aks-ash-feedback).

### Why can't I run some of the AKS commands I use in Azure?

AKS on Azure Stack Hub doesn't support all Azure Kubernetes Service features, APIs, and Azure CLI commands. For more information, see [the overview article](aks-overview.md) and the table of [supported commands](aks-commands.md). You can use the Azure documentation, but be mindful of the limitations on Azure Stack Hub.

<a name='can-i-use-azure-ad-or-ad-fs-integrated-with-my-aks-clusters'></a>

### Can I use Microsoft Entra ID or AD FS integrated with my AKS clusters?

The preview doesn't support Microsoft Entra ID (Entra ID) and Active Directory Federated Services (AD FS) Kubernetes authorization and RBAC integration. 

### Can I use AKS cluster Autoscaler in AKS on Azure Stack Hub?

The preview doesn't support cluster Autoscaler.

### Do I need to uninstall the preview of AKS and Azure Container Registry (ACR) before installing the Azure Stack Hub 2108 Update?

Yes, you must uninstall the preview for AKS and ACR before installing Azure Stack Hub.

### After installing Azure Stack Hub Update 2108, do I need to uninstall AKS or ACR for any Azure Stack Hub Update?

No, you don't need to uninstall AKS or ACR. These two services are integrated into the infrastructure of Azure Stack Hub. The infrastructure updates, maintains, and monitors these services along with all other infrastructure services.

### Is the service principal automatically created?

No. The service principal (SPN) isn't automatically created as in Azure (no MSI).

### Are the Container Registry (ACR) and Azure Kubernetes Service (AKS) previews available on the Azure Stack Development Kit (ASDK)?

The Container Registry (ACR) and Azure Kubernetes Service (AKS) aren't available for the Azure Stack Development Kit (ASDK). You must use a multinode Azure Stack Hub to use the ACR and AKS while in preview.

## Known issues

 - The AKS service is limited to 50 nodes per subscription in the preview.
 
 - [Azure Kubernetes Service (AKS) PowerShell](/powershell/module/az.aks) isn't supported in the preview.

 - For the preview, you can create only one node pool per AKS cluster. Windows clusters are limited to a single node pool, and you can't add a Linux pool. This limitation means that you can deploy only Windows containers to these clusters, and you can't deploy Linux containers. For example, a Linux based Ingress Controller doesn't work in Windows clusters.

 - For the preview, there's no rotation of the AKS cluster SPN credential assigned at creation time.

 - In the Azure Stack Hub Administrative portal, the cloud operator sees that multiple AKS Base images are available from Azure Marketplace, but not all of them work with the particular version of Azure Stack Hub AKS. Refer to the Azure Stack Hub release notes for the specific version of the image that works with AKS.

 - A user subscription with AKS clusters associated to it can be deleted by the user, which leaves the AKS clusters in an orphaned state. As a result, the Azure Stack Hub Administrative portal displays a sad cloud in the AKS blade. The only way to fix it is by contacting Microsoft Support.

  - If you try to create a cluster through the Azure Stack Hub user portal by using a subscription without the AKS enabled by the cloud operator, the portal displays the following error: `containers namespace not found error`.

 - If you name a cluster in the portal by using uppercase letters, the portal accepts the request and returns the following error: `invalid DNS name error`.

 - You can't create clusters that use Windows containers in the portal.

[!INCLUDE [Applications deployed to AKS clusters fail to access persistent volumes](../includes/known-issue-aks-1.md)]



## Next steps

[Learn about AKS on Azure Stack Hub](aks-overview.md)
