---
title: Known issues for the Azure Kubernetes Service on Azure Stack Hub
description: Learn about working with Azure Kubernetes Service on Azure Stack Hub.
author: mattbriggs
ms.topic: article
ms.date: 08/15/2021
ms.author: mabrigg
ms.reviewer: waltero
ms.lastreviewed: 08/15/2021

# Intent: As an Azure Stack operator, I want to install and offer Azure Kubernetes Service on Azure Stack Hub so my supported user can offer containerized solutions.
# Keyword: Kubernetes AKS difference
---

# Known issues for the Azure Kubernetes Service on Azure Stack Hub

This article looks at common questions and a list of known issues about the public preview of Azure Kubernetes Service (AKS) on Azure Stack Hub. You can provide feedback about your experience using AKS on Azure Stack Hub using the [Azure Stack Hub Azure Kubernetes Service Feedback Form](https://aka.ms/aks-ash-feedback).

## Common questions about AKS

### Can I use AKS to deploy applications on production environments?

AKS on Hub is on public preview, no production support is offered for this feature. If you are testing your application and run into an issue please create a support ticket.

### Why can't I run some of the AKS commands I use in Azure?

Not all Azure AKS features, APIs, and Azure CLI commands are supported by AKS on Azure Stack Hub, please see [the overview article](aks-overview.md). and the table of [supported commands](aks-commands.md). You can use the Azure documentation, but you should be mindful of the limitations on Azure Stack Hub

### Can I use AAD or ADFS integrated with my AKS clusters?

There is no support for Azure Active Director (Azure AD) and Active Directory Federated Services (AD FS) Kubernetes Auth and RBAC integration in the public preview 

### Can I use AKS cluster Autoscaler in AKS on Azure Stack Hub?

There is no support for cluster Autoscaler in the public preview.

### Do I need to uninstall the private preview of AKS and ACR before installing the Azure Stack Hub 2108 Update?

Yes, the private preview for AKS and Azure Container Registry (ACR) must be uninstalled before installing Azure Stack Hub 2108

### After installing Azure Stack Hub Update 2108, would I need to uninstall AKS or ACR again for any Azure Stack Hub Update?

No, you will not need to uninstall AKS or ACR again. These two services are integrated into the infrastructure of Azure Stack Hub, they will be updated, maintained, and monitored as well as all other infrastructure services.

## Known issues

1. The AKS service is limited to 50 nodes per subscription in the public preview.

2. For the public preview no more than one node pool can be created per AKS cluster. Windows clusters are limited to a single node pool, no Linux pool can be added.

3. For the public preview there is no rotation of the AKS cluster service principal credential assigned at creation time.

4. In the Azure Stack Hub Administrative portal, the cloud operator will see that multiple AKS Base images are available from Azure Marketplace, not all of them will work with the particular version of Azure Stack Hub AKS, please refer to the Azure Stack Hub release notes for the specific version of the image that works with AKS.

5. A user subscription with AKS clusters associated to it could be deleted by the user leaving behind the AKS clusters in an orphaned state. This will cause the Azure Stack Hub Administrative portal to display a sad cloud in the AKS blade. The only way to fix it is by contacting Microsoft Support.


## Next steps

[Learn about AKS on Azure Stack Hub](aks-overview.md)