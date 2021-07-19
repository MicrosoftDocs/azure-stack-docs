---
title: Azure Kubernetes Service on Azure Stack Hub overview
description: Learn about Azure Kubernetes Service (ASK) on Azure Stack Hub.
author: mattbriggs
ms.topic: article
ms.date: 07/20/2021
ms.author: mabrigg
ms.reviewer: waltero
ms.lastreviewed: 07/01/2021

# Intent: As an Azure Stack operator, I want to install and offer Azure Kubernetes Service on Azure Stack Hub so my supported user can offer containerized solutions.
# Keyword: Kubernetes AKS difference
---

# Azure Kubernetes Service on Azure Stack Hub overview

Azure Kubernetes Service (AKS) enables your users to deploy Kubernetes clusters in Azure Stack Hub. AKS reduces the complexity and operational overhead of managing Kubernetes clusters. As a hosted Kubernetes service, Azure Stack Hub handles critical tasks like health monitoring and facilitates maintenance of clusters. The Azure Stack team manages the image used for maintaining the clusters. The cluster tenant administrator will only need to apply the updates as needed. The services come at no extra cost. AKSis free: you only pay to use the VMs (master and agent nodes) within your clusters.

> [!IMPORTANT]
> Azure Kubernetes Service on Azure Stack Hub is currently in PREVIEW.
> See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

## What is AKS on Azure Stack Hub?

To make AKS available to your users, you will need to:

1.  Download the AKS base images from Azure.
2.  Create Plans and Offers for tenants to create subscriptions with the AKS.
3.  Monitor the AKS and act on alerts.

## Pre-Requisites

1.  Azure Stack Hub version 2008 is required.
2.  You must register your Azure Stack Hub instance to be able to download Marketplace items regardless of having a connected or disconnected environment. You can find instructions on registering your Azure Stack Hub with Azure in the article "[Register Azure Stack Hub with Azure](azure-stack-registration.md)."

## Cloud operator responsibilities

The following tasks fall on the **Azure Stack Hub Operator**:

1.  Make sure that the AKS base images are available in the stamp, this includes downloading them from Azure.
2.  Make sure that the AKS is available for customers plans and user subscriptions, as is the case with any other service in Azure Stack Hub.
3.  Monitor the AKS and act on any alert and associated remediation.
4.  For details on the Operator tasks see [Install and offer the Azure Kubernetes Service on Azure Stack Hub](aks-add-on.md)

## Next steps

[Install and offer the Azure Kubernetes Service on Azure Stack Hub](aks-add-on.md)