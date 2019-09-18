---
title: Add Azure Kubernetes Services (AKS) Engine to the Azure Stack Marketplace | Microsoft Docs
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
ms.date: 06/18/2019
ms.author: mabrigg
ms.reviewer: waltero
ms.lastreviewed: 06/18/2019

---

# Add Azure Kubernetes Services (AKS) Engine to the Azure Stack Marketplace

*Applies to: Azure Stack integrated systems and Azure Stack Development Kit*

You can offer the Azure Kubernetes Services (AKS) Engine as a Marketplace item to your users. Your users can deploy a Kubernetes cluster in a single, coordinated operation.

The AKS Engine uses a built image, the AKS Base Image. Any AKS Engine version is dependent on a specific image version that you can make available in your Azure Stack. You can find a table listing the AKS Engine versions and corresponding supported Kubernetes versions at [Supported Kubernetes Versions](https://github.com/Azure/aks-engine/blob/master/docs/topics/azure-stack.md#supported-kubernetes-versions).

The following article walks you through the items you need to add your Azure Stack to make the AKS Engine available to your users in both connected and disconnected scenarios. The AKS Engine depends on a custom script, and the AKS Base Image offered in the marketplace.

> [!IMPORTANT]
> The AKS Engine is currently in public preview.
> This preview version is provided without a service level agreement, and it's not recommended for production workloads. Certain features might not be supported or might have constrained capabilities. 
> For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

## Create a plan, an offer, and a subscription

Create a plan, an offer, and a subscription for the Kubernetes Marketplace item. You can also use an existing plan and offer.

1. Sign in to the [Administration portal.](https://adminportal.local.azurestack.external)

1. Create a plan as the base plan. For instructions, see [Create a plan in Azure Stack](azure-stack-create-plan.md).

1. Create an offer. For instructions, see [Create an offer in Azure Stack](azure-stack-create-offer.md).

1. Select **Offers**, and find the offer you created.

1. Select **Overview** in the Offer blade.

1. Select **Change state**. Select **Public**.

1. Select **+ Create a resource** > **Offers and Plans** > **Subscription** to create a subscription.

    a. Enter a **Display Name**.

    b. Enter a **User**. Use the Azure AD account associated with your tenant.

    c. **Provider Description**

    d. Set the **Directory tenant** to the Azure AD tenant for your Azure Stack. 

    e. Select **Offer**. Select the name of the offer that you created. Make note of the Subscription ID.

## Create a service principal and credentials in AD FS

If you use Active Directory Federated Services (AD FS) for your identity management service, you will need to create a service principal for users deploying a Kubernetes cluster. Create service principal using a client secret. For instructions, see [Create a service principal using a client secret](azure-stack-create-service-principals.md#create-a-service-principal-that-uses-client-secret-credentials).

## Add the AKS Base Image

You can add the AKS Base Image to the marketplace but getting the item from Azure. However, if you are your Azure Stack is disconnected, use the instructions to [Download marketplace items from Azure](https://docs.microsoft.com/en-us/azure-stack/operator/azure-stack-download-azure-marketplace-item?view=azs-1908#disconnected-or-a-partially-connected-scenario) to add the item.

Add the following item to the Marketplace:

1. Sign in to the [Administration portal](https://adminportal.local.azurestack.external).

1. Select **All services**, and then under the **ADMINISTRATION** category, select **Marketplace management**.

1. Select **+ Add from Azure**.

1. Enter `AKS Base Image`.

1. Select the newest version of the server. Check the full version and ensure that you have the newest version:
    - **Publisher**: microsoft-aks
    - **Offer**: aks
    - **Version**: 2019.07.30 (or newer version)
    - **SKU**: aks-ubuntu-1604-201907

1. Select **Download.**

## Add a custom script for Linux

You can add the custom script to the marketplace but getting the item from Azure. However, if you are your Azure Stack is disconnected, use the instructions to [Download marketplace items from Azure](https://docs.microsoft.com/en-us/azure-stack/operator/azure-stack-download-azure-marketplace-item?view=azs-1908#disconnected-or-a-partially-connected-scenario) to add the item.

1. Open the [Administration portal](https://adminportal.local.azurestack.external).

1. Select **ALL services** and then under the **ADMINISTRATION** category, select **Marketplace Management**.

1. Select **+ Add from Azure**.

1. Enter `Custom Script for Linux`.

1. Select the script with the following profile:
   - **Offer**: Custom Script for Linux 2.0
   - **Version**: 2.0.6 (or latest version)
   - **Publisher**: Microsoft Corp

     > [!Note]  
     > More than one version of Custom Script for Linux may be listed. You will need to add the last version of the item.

1. Select **Download.**

## Next steps

[What is the AKS Engine on Azure Stack?](../user/azure-stack-kubernetes-aks-engine-overview.md)

[Overview of offering services in Azure Stack](azure-stack-offer-services-overview.md)
