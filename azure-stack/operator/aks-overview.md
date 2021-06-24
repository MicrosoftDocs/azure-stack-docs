---
title: Azure Kubernetes Service on Azure Stack Hub overview
description: Learn about Azure Kubernetes Service (ASK) on Azure Stack Hub.
author: mattbriggs
ms.topic: article
ms.date: 07/01/2021
ms.author: mabrigg
ms.reviewer: waltero
ms.lastreviewed: 07/01/2021

# Intent: As an Azure Stack operator, I want to install and offer Azure Kubernetes Service on Azure Stack Hub so my supported user can offer containerized solutions.
# Keyword: Kubernetes AKS difference
---

# Azure Kubernetes Service on Azure Stack Hub overview

Azure Kubernetes Service (AKS) enables your users to deploy Kubernetes clusters in Azure Stack Hub. AKSreduces the complexity and operational overhead of managing Kubernetes clusters. As a hosted Kubernetes service, Azure Stack Hub handles critical tasks like health monitoring and facilitates maintenance of clusters. The Azure Stack team manages the image used for maintaining the clusters. The cluster tenant administrator will only need to apply the updates as needed. The services come at no extra cost. AKSis free: you only pay to use the VMs (master and agent nodes) within your clusters.

> [!IMPORTANT]
> Azure Kubernetes Service on Azure Stack Hub is currently in PREVIEW.
> See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

## What is Azure Kubernetes Service on Azure Stack Hub?

To make AKS available to your users, you will need to:

1.  Download the AKS base images from Azure.
2.  Create Plans and Offers for tenants to create subscriptions with the AKS Service.
3.  Monitor the AKSand act on alerts.

## Pre-Requisites

1.  Azure Stack Hub version 2008 is required.
2.  You must register your Azure Stack Hub instance to be able to download Marketplace items regardless of having a connected or disconnected environment. You can find instructions on registering your Azure Stack Hub with Azure in the article "[Register Azure Stack Hub with Azure](azure-stack-registration.md)."

## Next steps

[Install and offer the Azure Kubernetes Service on Azure Stack Hub](C:\git\ms\azure-stack-docs-pr\azure-stack\operator\aks-add-on.md)