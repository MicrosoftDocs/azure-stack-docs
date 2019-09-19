---
title: Add the Azure Kubernetes Services (AKS) Engine to the Azure Stack Marketplace | Microsoft Docs
description: Learn how to add AKS Engine to the Azure Stack Marketplace.
services: azure-stack
documentationcenter: ''
author: mattbriggs
manager: femila
editor: ''

ms.service: azure-stack
ms.workload: na
pms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 09/18/2019
ms.author: mabrigg
ms.reviewer: waltero
ms.lastreviewed: 09/18/2019

---

# Add the Azure Kubernetes Services (AKS) Engine to the Azure Stack Marketplace

*Applies to: Azure Stack integrated systems and Azure Stack Development Kit*

You can enable your users to set up the Azure Kubernetes Services (AKS) Engine by adding the items describes in this article to your Azure Stack. Your users can then deploy a Kubernetes cluster in a single, coordinated operation. This article walks you through the steps you need to make the AKS Engine available to your users in both connected and disconnected environments. The AKS Engine depends a service principle and in offered in the marketplace, a custom script and the AKS Base Image.

The [AKS Engine](https://github.com/Azure/aks-engine) uses a built image, the AKS Base Image. Any AKS Engine version depends on a specific image version that you can make available in your Azure Stack. Check the table listing the AKS Engine versions and corresponding Kubernetes version at [Supported Kubernetes Versions](https://github.com/Azure/aks-engine/blob/master/docs/topics/azure-stack.md#supported-kubernetes-versions).

> [!IMPORTANT]
> The AKS Engine is currently in public preview.
> This preview version is provided without a service level agreement, and it's not recommended for production workloads. Certain features might not be supported or might have constrained capabilities. 
> For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

## Check your user service offering

Your users will need your users to already have a plan, offer, and subscription to Azure Stack.

Users will often want to deploy clusters of up to six virtual machines, made of three masters and three worker nodes. You will want to make sure they have enough space in their quota.

If you need more information about planning and setting up a service offering, see [Overview of offering services in Azure Stack](azure-stack-offer-services-overview.md)

## Create a service principal and credentials

The Kubernetes cluster will need service principal (SPN) and role-based permissions in Azure Stack.

### Create an SPN in Azure AD

If you use Azure Active Directory (Azure AD) for your identity management service, you will need to create a service principal for users deploying a Kubernetes cluster. Create a service principal using a client secret. For instructions, see [Create a service principal that uses a client secret credential](azure-stack-create-service-principals.md#create-a-service-principal-that-uses-a-client-secret-credential).

### Create an SPN in AD FS

If you use Active Directory Federated Services (AD FS) for your identity management service, you will need to create a service principal for users deploying a Kubernetes cluster. Create a service principal using a client secret. For instructions, see [Create a service principal using a client secret](azure-stack-create-service-principals.md#create-a-service-principal-that-uses-client-secret-credentials).

## Add the AKS Base Image

You can add the AKS Base Image to the marketplace by getting the item from Azure. However, if your Azure Stack is disconnected, use these instructions [Download marketplace items from Azure](https://docs.microsoft.com/azure-stack/operator/azure-stack-download-azure-marketplace-item?view=azs-1908#disconnected-or-a-partially-connected-scenario) to add the item. Add the item specified in step five.

Add the following item to the marketplace:

1. Sign in to the [Administration portal](https://adminportal.local.azurestack.external).

1. Select **All services**, and then under the **ADMINISTRATION** category, select **Marketplace management**.

1. Select **+ Add from Azure**.

1. Enter `AKS Base Image`.

1. Select the image version that matches the version of the AKS Engine. You can find listing of AKS Base Image to AKS Engine version at [Supported Kubernetes Versions](https://github.com/Azure/aks-engine/blob/master/docs/topics/azure-stack.md#supported-kubernetes-versions). 

    In the list, select:
    - **Publisher**: microsoft-aks
    - **Offer**: aks
    - **Version**: 2019.07.30 (or version that maps to AKS Engine)
    - **SKU**: aks-ubuntu-1604-201907

1. Select **Download.**

## Add a custom script for Linux

You can add the custom script to the marketplace by getting the item from Azure. However, if your Azure Stack is disconnected, use the instructions [Download marketplace items from Azure](https://docs.microsoft.com/en-us/azure-stack/operator/azure-stack-download-azure-marketplace-item?view=azs-1908#disconnected-or-a-partially-connected-scenario) to add the item.  Add the item specified in step five.

1. Open the [Administration portal](https://adminportal.local.azurestack.external).

1. Select **ALL services** and then under the **ADMINISTRATION** category, select **Marketplace Management**.

1. Select **+ Add from Azure**.

1. Enter `Custom Script for Linux`.

1. Select the script with the following profile:
   - **Offer**: Custom Script for Linux 2.0
   - **Version**: 2.0.6 (or latest version)
   - **Publisher**: Microsoft Corp

     > [!Note]  
     > More than one version of the Custom Script for Linux may be listed. You will need to add the last version of the item.

1. Select **Download.**

## Next steps

[What is the AKS Engine on Azure Stack?](../user/azure-stack-kubernetes-aks-engine-overview.md)

[Overview of offering services in Azure Stack](azure-stack-offer-services-overview.md)
