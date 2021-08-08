---
title: Install and offer the Azure Kubernetes Service on Azure Stack Hub
description: Learn how to install and offer the Azure Kubernetes Service on Azure Stack Hub.
author: mattbriggs
ms.topic: how-to
ms.date: 07/20/2021
ms.author: mabrigg
ms.reviewer: waltero
ms.lastreviewed: 07/01/2021

# Intent: As an Azure Stack operator, I want to install and offer Azure Kubernetes Service on Azure Stack Hub so my supported user can offer containerized solutions.
# Keyword: Kubernetes AKS

---

# Install and offer the Azure Kubernetes Service on Azure Stack Hub

Azure Kubernetes Service (AKS) enables your users to deploy Kubernetes clusters in Azure Stack Hub. AKS reduces the complexity and operational overhead of managing Kubernetes clusters. As a hosted Kubernetes service, Azure Stack Hub handles critical tasks like health monitoring and facilitates maintenance of clusters. The Azure Stack team manages the image used for maintaining the clusters. The cluster tenant administrator will only need to apply the updates as needed. The services come at no extra cost. AKSis free: you only pay to use the VMs (master and agent nodes) within your clusters. You can install the Azure Kubernetes Service (AKS) resource provider for the users of your Azure Stack Hub. 

> [!IMPORTANT]
> Azure Kubernetes Service on Azure Stack Hub is currently in PREVIEW.
> See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

## Download AKS base image

The AKS Service needs a special VM image referred to the "AKS base Image". The AKS service will not work without the correct image version available in the local ASH marketplace. The image is meant to be used by the AKS service, not to be used by tenants to create individual VMs. The image will not be visible to tenants in the Marketplace. This is a task that needs to be done alongside every Azure Stack Hub Update. Every time there is a new update there will be a new AKS base image associated with the AKS Service. Here are the steps:

1.  Using the administrator portal, go the Marketplace management blade and select "Add from Azure", type "AKS" in the search box, locate, and download Linux "AKS Base Ubuntu Image version 2021.xx.xx" and Windows AKS base image select version `"xxxx.xxxx.xxxxxx" \ <update version and image>`

    ![Add the AKS Base Image](media/aks-add-on/add-the-aks-base-image.jpg)

1.  If your instance is disconnected, follow the instructions in the article "[Download Marketplace items to Azure Stack Hub](/azure-stack/operator/azure-stack-download-azure-marketplace-item)" to download the two items mentioned from the marketplace in Azure and upload them to your Azure Stack Hub instance.

## Create plans and offers

To allow tenant users to use the AKS Service the operator needs to make it available through a plan and an offer.

1.  creates a plan with the `Microsoft.Container` service. There are no specific quotas for this service, it uses the quotas available for the Compute, Network, and Storage services:

    ![Create a plan](media/aks-add-on/aks-create-a-plan.png)

2.  Again use the Azure Stack Hub administration portal to create an offer that contains the plan created in the prior step:

    ![Create an offer](media/aks-add-on/aks-create-an-offer.png)

## Monitor and act on alerts

1.  Using the Admin Portal you can access the **Azure Kubernetes Service** under the **Administration** group.
2.  Select the "**Alerts**" blade. Review the alerts:

    ![AKS - Admin](media/aks-add-on/aks-admin.png)

1.  Alerts will show in the **Alerts** blade, you will be able to take action on them if need to:

![AKS - Alerts](media/aks-add-on/aks-alerts.png)

## Next steps

[Learn more about the AKS on Azure Stack Hub](../user/aks-overview.md)