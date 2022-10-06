---
title: Azure Kubernetes Service on Azure Stack Hub support
description: Learn about support options for Azure Kubernetes Service (ASK) on Azure Stack Hub.
author: sethmanheim
ms.topic: article
ms.date: 10/26/2021
ms.author: sethm
ms.reviewer: waltero
ms.lastreviewed: 10/26/2021

# Intent: As an Azure Stack Hub operator, I want to install and offer Azure Kubernetes Service on Azure Stack Hub so my supported user can offer containerized solutions.
# Keyword: Kubernetes AKS difference
---

# Azure Kubernetes Service on Azure Stack Hub support

Azure Kubernetes Service (AKS) for Azure Stack Hub is in public preview. AKS is available for non-production workloads. The goal for the preview is to allow you to test applications on AKS and gather customer feedback. Provide [feedback](https://aka.ms/aks-ash-feedback).

Take advantage of the feedback page above to communicate questions, issues, and suggestions to the AKS on Azure Stack Hub team. The product team monitors the [feedback](https://aka.ms/aks-ash-feedback) posts and reply on a best effort basis. When the feedback page can't resolve the issue or if your application test is blocked by an issue, you can raise a non-production [support case](../operator/azure-stack-help-and-support-overview.md). When creating a support case with Microsoft Support team note that the scope of what Support Engineers can do is defined by what is documented in the AKS on Azure Stack Hub [documentation](aks-overview.md).

During the public preview of AKS on Azure Stack Hub, note:

 - **Missing functionality**.  
   See the [overview documents](aks-overview.md) for a feature area comparison with global Azure AKS.
 - **Potential bugs**  
   Bug could affect your Kubernetes clusters, container registries, and the overall functionality of the AKS, Azure Container Registry, or even the Azure Stack Hub platform.
 - **Differences in guidance**  
   Global Azure AKS or global Azure Container Registry guidance may work on global Azure but doesn't work in Azure Stack Hub.
 - **Support for the public preview**  
   Support for the public preview is done through a best effort from the Microsoft Support and Product Group teams.
 - **Support cases**  
   Support cases of services in preview mode can't be created and addressed as production support cases.

## Reporting bugs

 - Go to [feedback](https://aka.ms/aks-ash-feedback) to report the bug.
 - Provide description, reproductive steps, and description of expected behavior.
 - In some cases, we may ask you to collect Azure Stack Hub logs. Microsoft Support will need to open a [support case](../operator/azure-stack-help-and-support-overview.md).
 - In some cases, you may need to collect [Kubernetes logs](aks-troubleshoot.md).

## Providing feedback

Use the links below to submit your feedback.

 - Report a security vulnerability, go to [https://msrc.microsoft.com/create-report](https://msrc.microsoft.com/create-report).
 - Suggest an improvement, go to [feedback](https://aka.ms/aks-ash-feedback).
 - Update documentation, go to [feedback](https://aka.ms/aks-ash-feedback).

## Service updates

Public review updates will be made available following the standard Azure Stack Patch and Update (PNU) process outlined in the article [Manage updates in Azure Stack Hub](../operator/azure-stack-updates.md). Besides the service, which updates through the Azure Stack Hub Patch and Update process, you may also need to update the AKS base image. If such is the case the extra step of [downloading the image](../operator/azure-stack-download-azure-marketplace-item.md) from the Azure Stack Hub Marketplace will be required.

As participants in the public preview, you may also need to:

 - Kubernetes cluster might need to be redeployed if certain operations are desired.
 - Manual steps that act on individual infrastructure-as-a-service (IaaS) elements such as masters and nodes might be required.
 - In an extreme situation, a support case might be required to break glass and operate on the service components directly.

### Azure AKS version

 AKS on Azure Stack Hub is the actual AKS service code, therefore the AKS API is supported on Azure Stack Hub, it is maintained through Azure Stack Hub updates. However, you should expect that the version of the API on Azure will always be newer than the version available in Azure Stack Hub. This is because Azure can update their service with a higher frequency than Azure Stack Hub. For the public preview, the supported API is version "2020-11-01".

### Kubernetes version

As is the case for the AKS API, Kubernetes versions are maintained through Azure Stack Hub updates. The specific versions of Azure Stack Hub updates provide support for specific versions of Kubernetes, this is done through upgrading the stamp and also downloading the new version of the AKS base images (Linux and Windows). Kubernetes versions on Azure Stack Hub will often be lower than the Kubernetes versions available on Azure. For the private preview, the highest Kubernetes version supported is 1.20.7.

## Next steps

[Learn about AKS on Azure Stack Hub](aks-overview.md)
