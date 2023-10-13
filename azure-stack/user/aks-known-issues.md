---
title: Known issues for the Azure Kubernetes Service on Azure Stack Hub
description: Learn about working with Azure Kubernetes Service on Azure Stack Hub.
author: sethmanheim
ms.topic: article
ms.date: 02/24/2021
ms.author: sethm
ms.reviewer: waltero
ms.lastreviewed: 12/8/2021

# Intent: As an Azure Stack operator, I want to install and offer Azure Kubernetes Service on Azure Stack Hub so my supported user can offer containerized solutions.
# Keyword: Kubernetes AKS difference
---

# Common questions and known issues for the Azure Kubernetes Service on Azure Stack Hub

This article looks at common questions and a list of known issues about the public preview of Azure Kubernetes Service (AKS) on Azure Stack Hub.

## Common questions about AKS

### Can I use AKS to deploy applications on production environments?

AKS on Hub is on public preview, no production support is offered for this feature. If you are testing your application and run into an issue create a support ticket. You can provide feedback about your experience using AKS on Azure Stack Hub using the [Azure Stack Hub Azure Kubernetes Service Feedback Form](https://aka.ms/aks-ash-feedback).

### Why can't I run some of the AKS commands I use in Azure?

Not all Azure AKS features, APIs, and Azure CLI commands are supported by AKS on Azure Stack Hub, see [the overview article](aks-overview.md). and the table of [supported commands](aks-commands.md). You can use the Azure documentation, but you should be mindful of the limitations on Azure Stack Hub.

<a name='can-i-use-azure-ad-or-ad-fs-integrated-with-my-aks-clusters'></a>

### Can I use Microsoft Entra ID or AD FS integrated with my AKS clusters?

There is no support for Azure Active Director (Microsoft Entra ID) and Active Directory Federated Services (AD FS) Kubernetes authorization and RBAC integration in the public preview. 

### Can I use AKS cluster Autoscaler in AKS on Azure Stack Hub?

There is no support for cluster Autoscaler in the public preview.

### Do I need to uninstall the preview of AKS and ACR before installing the Azure Stack Hub 2108 Update?

Yes, the preview for AKS and Azure Container Registry (ACR) must be uninstalled before installing Azure Stack Hub 2108.

### After installing Azure Stack Hub Update 2108, would I need to uninstall AKS or ACR again for any Azure Stack Hub Update?

No, you will not need to uninstall AKS or ACR again. These two services are integrated into the infrastructure of Azure Stack Hub, they will be updated, maintained, and monitored and all other infrastructure services.

### Is the service principal automatically created?

No. The service principal (SPN) is not automatically created as in Azure (no MSI).

### Are the Azure Container Service (ACR) and Azure Kubernetes Service (AKS) public previews available on the Azure Stack Development Kit (ASDK)?

The Azure Container Service (ACR) and Azure Kubernetes Service (AKS) are not available for the Azure Stack Development Kit (ASDK). You must use a multi-node Azure Stack Hub to use the ACR and AKS while in public preview.

## Known issues

 - The AKS service is limited to 50 nodes per subscription in the public preview.
 
 - [Azure Kubernetes Service (AKS) PowerShell](/powershell/module/az.aks) is not supported in the public preview.

 - For the public preview, no more than one node pool can be created per AKS cluster. Windows clusters are limited to a single node pool, no Linux pool can be added. This means that only Windows containers can be deployed to these clusters, no Linux containers can be deployed. For example, a Linux based Ingress Controller will not work in Windows clusters.

 - For the public preview, there is no rotation of the AKS cluster SPN credential assigned at creation time.

 - In the Azure Stack Hub Administrative portal, the cloud operator will see that multiple AKS Base images are available from Azure Marketplace, not all of them will work with the particular version of Azure Stack Hub AKS, refer to the Azure Stack Hub release notes for the specific version of the image that works with AKS.

 - A user subscription with AKS clusters associated to it could be deleted by the user leaving behind the AKS clusters in an orphaned state. As a result, the Azure Stack Hub Administrative portal to display a sad cloud in the AKS blade. The only way to fix it is by contacting Microsoft Support.

  - If you try to create a cluster through the Azure Stack Hub user portal using a subscription without the AKS enabled by the cloud operator, then the portal will let display the following error: `containers namespace not found error`.

 - If you name a cluster in the portal using upper case letters, then the portal will accept the request, and return the following error: `invalid DNS name error`.

 - You cannot create clusters that use Windows containers in the portal.

[!INCLUDE [Applications deployed to AKS clusters fail to access persistent volumes](../includes/known-issue-aks-1.md)]



## Next steps

[Learn about AKS on Azure Stack Hub](aks-overview.md)
