---
title: Azure Kubernetes Service on Azure Stack Hub support
description: Learn how to get support for Azure Kubernetes Service (AKS) on Azure Stack Hub, including preview limitations and feedback options. Read now.
author: sethmanheim
ms.topic: install-set-up-deploy
ms.date: 07/08/2026
ms.author: sethm
ms.reviewer: waltero
ms.lastreviewed: 10/26/2021

# Intent: As an Azure Stack Hub operator, I want to install and offer Azure Kubernetes Service on Azure Stack Hub so my supported user can offer containerized solutions.
# Keyword: Kubernetes AKS difference
---

# Azure Kubernetes Service on Azure Stack Hub support

Azure Kubernetes Service (AKS) for Azure Stack Hub is in preview. AKS is available for non-production workloads. The goal of the preview is to allow you to test applications on AKS and gather customer feedback. Provide [feedback](https://aka.ms/aks-ash-feedback).

Use the feedback page to communicate questions, issues, and suggestions to the AKS on Azure Stack Hub team. The product team monitors the [feedback](https://aka.ms/aks-ash-feedback) posts and replies on a best effort basis. When the feedback page can't resolve the issue or if your application test is blocked by an issue, you can raise a non-production [support case](../operator/azure-stack-help-and-support-overview.md). When creating a support case with Microsoft Support team, note that the scope of what Support Engineers can do is defined by what is documented in the AKS on Azure Stack Hub [documentation](aks-overview.md).

During the preview of AKS on Azure Stack Hub, note:

 - **Missing functionality**.  
   See the [overview documents](aks-overview.md) for a feature area comparison with global Azure AKS.
 - **Potential bugs**  
   Bugs can affect your Kubernetes clusters, container registries, and the overall functionality of the AKS, Azure Container Registry, or even the Azure Stack Hub platform.
 - **Differences in guidance**  
   Global Azure AKS or global Container Registry guidance might work on global Azure but doesn't work in Azure Stack Hub.
 - **Support for the preview**  
   Microsoft Support and Product Group teams provide best-effort support for the preview.
 - **Support cases**  
   You can't create support cases for services in preview mode. These cases can't be addressed as production support cases.

## Reporting bugs

 - Go to [feedback](https://aka.ms/aks-ash-feedback) to report the bug.
 - Provide description, reproductive steps, and description of expected behavior.
 - In some cases, Microsoft might ask you to collect Azure Stack Hub logs. Microsoft Support needs to open a [support case](../operator/azure-stack-help-and-support-overview.md).
 - In some cases, you might need to collect [Kubernetes logs](aks-troubleshoot.md).

## Providing feedback

Use the following links to submit your feedback:

 - To report a security vulnerability, go to [https://msrc.microsoft.com/create-report](https://msrc.microsoft.com/create-report).
 - To suggest an improvement, go to [feedback](https://aka.ms/aks-ash-feedback).
 - To update documentation, go to [feedback](https://aka.ms/aks-ash-feedback).

## Service updates

Preview updates are available through the standard Azure Stack Patch and Update (PNU) process outlined in the article [Manage updates in Azure Stack Hub](../operator/azure-stack-updates.md). Besides the service, which updates through the Azure Stack Hub Patch and Update process, you might also need to update the AKS base image. If such is the case, you need to [download the image](../operator/azure-stack-download-azure-marketplace-item.md) from the Azure Stack Hub Marketplace.

As participants in the preview, you might also need to:

 - Redeploy the Kubernetes cluster if certain operations are desired.
 - Perform manual steps that act on individual infrastructure-as-a-service (IaaS) elements such as primary nodes and worker nodes.
 - In an extreme situation, create a support case to break glass and operate on the service components directly.

### Azure AKS version

 AKS on Azure Stack Hub is the actual AKS service code. Therefore, the AKS API is supported on Azure Stack Hub and maintained through Azure Stack Hub updates. However, you should expect that the version of the API on Azure is always newer than the version available on Azure Stack Hub. This difference exists because Azure can update their service with a higher frequency than Azure Stack Hub. For the preview, the supported API is version "2020-11-01".

### Kubernetes version

As is the case for the AKS API, Azure Stack Hub updates maintain Kubernetes versions. Specific versions of Azure Stack Hub updates provide support for specific versions of Kubernetes. This support happens through upgrading the stamp and also downloading the new version of the AKS base images (Linux and Windows). Kubernetes versions on Azure Stack Hub are often lower than the Kubernetes versions available on Azure.

## Next steps

[Learn about AKS on Azure Stack Hub](aks-overview.md)
