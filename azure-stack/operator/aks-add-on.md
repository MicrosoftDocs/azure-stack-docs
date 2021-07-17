---
title: Install and offer the Azure Kubernetes Service on Azure Stack Hub
description: Learn how to install and offer the Azure Kubernetes Service on Azure Stack Hub.
author: mattbriggs
ms.topic: how-to
ms.date: 07/01/2021
ms.author: mabrigg
ms.reviewer: waltero
ms.lastreviewed: 07/01/2021

# Intent: As an Azure Stack operator, I want to install and offer Azure Kubernetes Service on Azure Stack Hub so my supported user can offer containerized solutions.
# Keyword: Kubernetes AKS

---

# Install and offer the Azure Kubernetes Service on Azure Stack Hub

This topic walks you through setting up the Azure Kubernetes Service (AKS) resource provider for the users of your Azure Stack Hub. 

## Download AKS base Image

The AKS Service needs a special VM image referred to the "AKS base Image". The AKS service will not work without the correct image version available in the local ASH marketplace. The image is meant to be used by the AKS service, not to be used by tenants to create individual VMs. The image will not be visible to tenants in the Marketplace. This is a task that needs to be done alongside every Azure Stack Hub Update. Every time there is a new update there will be a new AKS base image associated with the AKS Service. Here are the steps:

1.  Using the administrator portal, go the Marketplace management blade and select "Add from Azure", type "AKS" in the search box, locate and download Linux "AKS Base Ubuntu Image version 2021.xx.xx" and Windows AKS base image select version "xxxx.xxxx.xxxxxx" \<TODO: update version and image\>

    ![Text Description automatically generated](media//aks-add-on/d5bbd5522d0077fca0f296afac86d839.jpg)

1.  If your instance is disconnected, please follow the instructions in the article "[Download Marketplace items to Azure Stack Hub](/azure-stack/operator/azure-stack-download-azure-marketplace-item)" to download the two items mentioned from the marketplace in Azure and upload them to your Azure Stack Hub instance.

## Create Plans and Offers

To allow tenant users to use the AKS Service the operator needs to make it available through a plan and an offer.

1.  Using the Admin Portal create a Plan with the "Microsoft.Container" service. Note that there are no specific quota for this service, it uses the quotas available for the Compute, Network, and Storage services:

    ![This is a screen shot of a screen.](media//aks-add-on/8d98666a6a709e06e2232b0fdc60e19d.png)

2.  Again use the Admin portal to create an offer that contains the plan created in the prior step:

    ![Another screen shot of a screen.](media//aks-add-on/a322729043c17463d1403844f0a8a97d.png)

## Monitor the AKS Service and act on Alerts

1.  Using the Admin Portal you can access the Azure Kubernetes Service under the "Administration" group.
2.  Once you open it, you will find the "Alerts" blade, select it to see any alerts:

    ![Yet more, screen shot.](media//aks-add-on/1b76a0d763d35a14a659e0596782dadb.png)

1.  Alerts will show in the "Alerts" blade, you will be able to take action on them if need to:

![Even more screen shot. More and more.](media//aks-add-on/69ae7febfa3386f386864f5c6312bdab.png)

## Next steps

[Learn more about the AKS on Azure Stack Hub](aks-overview.md)