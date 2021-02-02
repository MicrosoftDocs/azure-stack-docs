---
title: Add Azure Kubernetes Services (AKS) engine prerequisites to Azure Stack Hub Marketplace 
description: Learn how to add AKS engine prerequisites to the Azure Stack Hub Marketplace.
author: mattbriggs

ms.topic: article
ms.date: 2/1/2021
ms.author: mabrigg
ms.reviewer: waltero
ms.lastreviewed: 09/16/2020

# Intent: As a Azure Stack Hub operator, I want to offer the Kubernetes so that users can run the AKS engine.
# Keyword: Kubernetes Azure Stack Hub Marketplace

---


# Add the Azure Kubernetes Services (AKS) engine prerequisites to the Azure Stack Hub Marketplace

You can set up the Azure Kubernetes Services (AKS) Engine for your users. Add the items described in this article to your Azure Stack Hub. Your users can then deploy a Kubernetes cluster in a single, coordinated operation. This article walks you through the steps you need to make the AKS engine available to your users in both connected and disconnected environments. The AKS engine depends on a service principal identity, and in the marketplace, a Custom Script extension and the AKS Base Image. The AKS engine requires that you're running [Azure Stack Hub 1910](release-notes.md?view=azs-1910&preserve-view=true) or greater.

> [!NOTE]  
> You can find the mapping of Azure Stack Hub to AKS engine version number in the [AKS engine release notes](../user/kubernetes-aks-engine-release-notes.md#aks-engine-and-azure-stack-version-mapping).

## Check your user's service offering

Your users will need a plan, offer, and subscription to Azure Stack Hub with enough space. Users will often want to deploy clusters of up to six virtual machines, made of three masters and three worker nodes. You will want to make sure they have a large enough quota.

If you need more information about planning and setting up a service offering, see [Overview of offering services in Azure Stack Hub](service-plan-offer-subscription-overview.md)

## Create a service principal and credentials

The Kubernetes cluster will need service principal (SPN) and role-based permissions in Azure Stack Hub.

### Create an SPN in Azure AD

If you use Azure Active Directory (Azure AD) for your identity management service, you will need to create a service principal for users deploying a Kubernetes cluster. Create a service principal using a client secret. For instructions, see [Create a service principal that uses a client secret credential](azure-stack-create-service-principals.md#create-a-service-principal-that-uses-a-client-secret-credential).

### Create an SPN in AD FS

If you use Active Directory Federated Services (AD FS) for your identity management service, you will need to create a service principal for users deploying a Kubernetes cluster. Create a service principal using a client secret. For instructions, see [Create a service principal using a client secret](azure-stack-create-service-principals.md#create-a-service-principal-that-uses-client-secret-credentials).

## Add the AKS Base Image

You can add the AKS Base Image to the marketplace by getting the item from Azure. However, if your Azure Stack Hub is disconnected, use these instructions [Download marketplace items from Azure](azure-stack-download-azure-marketplace-item.md?pivots=state-disconnected) to add the item. Add the item specified in step 5.

Add the following item to the marketplace:

1. Sign in to the Administration portal `https://adminportal.local.azurestack.external`.

1. Select **All services**, and then under the **ADMINISTRATION** category, select **Marketplace management**.

1. Select **+ Add from Azure**.

1. Enter `AKS Base`.

1. Select the image version that matches the version of the AKS engine. You can find listing of AKS Base Image to AKS engine version at [Supported Kubernetes Versions](https://github.com/Azure/aks-engine/blob/master/docs/topics/azure-stack.md#supported-aks-engine-versions). 

    In the list, select:
    - **Publisher**: Azure Kubernetes Service
    - **Offer**: aks
    - **Name**: AKS Base Ubuntu 16.04-LTS Image Distro, August 2020 (2020.09.14 or version that maps to AKS engine)
    - **Version**: 2020.09.14

1. Select **Download.**

## Add a Custom Script extension

You can add the custom script to the marketplace by getting the item from Azure. However, if your Azure Stack Hub is disconnected, use the instructions [Download marketplace items from Azure](azure-stack-download-azure-marketplace-item.md?pivots=state-disconnected) to add the item.  Add the item specified in step 5.

1. Open the Administration portal `https://adminportal.local.azurestack.external`.

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

[What is the AKS engine on Azure Stack Hub?](../user/azure-stack-kubernetes-aks-engine-overview.md)

[Overview of offering services in Azure Stack Hub](service-plan-offer-subscription-overview.md)
