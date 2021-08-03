---
title: Azure Kubernetes Service on Azure Stack Hub support
description: Learn about support options for Azure Kubernetes Service (ASK) on Azure Stack Hub.
author: mattbriggs
ms.topic: article
ms.date: 08/15/2021
ms.author: mabrigg
ms.reviewer: waltero
ms.lastreviewed: 08/15/2021

# Intent: As an Azure Stack Hub operator, I want to install and offer Azure Kubernetes Service on Azure Stack Hub so my supported user can offer containerized solutions.
# Keyword: Kubernetes AKS difference
---

# Azure Kubernetes Service on Azure Stack Hub support

Azure Kubernetes Service (AKS) for Azure Stack Hub is in public preview. AKS is available only to customers that have agreed to use it for non-production workloads. The goal for the preview is to allow customers to test their applications on AKS and gather customer feedback. Provide feedback with the [Azure Kubernetes Service Feedback Form](https://aka.ms/aks-ash-feedback).

We encourage customers to take advantage of the feedback page above to communicate questions, issues, and suggestions to the AKS on Azure Stack Hub team. If your issue can't be resolved through the feedback page, you could raise a non-production [Support Case](/azure-stack/operator/azure-stack-help-and-support-overview). The product team will monitor the [Azure Kubernetes Service Feedback Form](https://aka.ms/aks-ash-feedback) posts and reply on a best effort basis.

Make note of the following:

1.  Missing functionality. See the overview documents for a feature area comparison with Azure AKS.
2.  Potential bugs that could affect your Kubernetes clusters, Container registries, the overall functionality of the Azure Kubernetes Service or Azure Container Registry or even the Azure Stack Hub platform.
3.  Global Azure Kubernetes Service or Azure Container Registry guidance that works on Azure but does not on Azure Stack Hub.
4.  Support for public preview is done through a best effort from the Microsoft Support and product group teams.
5.  Support cases of services in preview mode can't be created and addressed as production support cases.

    - Missing functionality.
    - Potential bugs that could affect your Kubernetes clusters, Container registries, the overall functionality of the Azure Kubernetes Service or Azure Container Registry Resource Providers or even the Azure Stack Hub platform.
    - Potential security vulnerabilities.
    - Global Azure Kubernetes Service or Azure Container Registry guidance that works on Azure but does not on Azure Stack Hub.
    - Support for public preview bits is done through a best effort from the Product Group and Customer Support teams.
    - Support cases of preview services cannot be created and addressed as production support cases.

1.  Go to the [Azure Kubernetes Service Feedback Form](https://aka.ms/aks-ash-feedback) to report the bug.
2.  Provide description, repro steps, and description of expected behavior.
3.  In some cases, we may ask you to collect Azure Stack Hub logs (a [support case](/azure-stack/operator/azure-stack-help-and-support-overview) with the Microsoft Support team would be needed).
4.  In some cases, we may ask you to collect Kubernetes logs. For more information and setting up logs, see [Troubleshoot the Azure Kubernetes Service on Azure Stack Hub](https://microsoft-my.sharepoint.com/personal/mabrigg_microsoft_com/Documents/Review_in/2021_07/1845670%20AKS/aks-troubleshoot.md).

## Providing feedback

Use the links below to submit your feedback:

1.  For reporting a security vulnerability, go to [MSRC Researcher Portal - Report an Issue](https://msrc.microsoft.com/create-report).
2.  For improvement suggestions go to [Azure Kubernetes Service Feedback Form](https://aka.ms/aks-ash-feedback).
3.  For documentation feedback, go to [Azure Kubernetes Service Feedback Form](https://aka.ms/aks-ash-feedback).

## Service Updates

Updates to the public preview will be made available following the standard Azure Stack Patch and Update (PNU) process outlined in the article "[Manage updates in Azure Stack Hub](/azure-stack/operator/azure-stack-update)". In addition to the service updated through the Azure Stack Hub Patch and Update process, the cloud operator may also need to update the Azure Kubernetes Service base image. To update the base image, the cloud operator will need [download the image](/azure-stack/operator/azure-stack-download-azure-marketplace-item) from the Marketplace.

As participants in the public preview, you may also need to:

1.  Kubernetes cluster might need to be redeployed to make more operations available.
2.  Manual steps that act on individual infrastructure-as-a-service (IaaS) elements such as masters and nodes might be required.
3.  In an extreme situation, the Microsoft Support team may need to directly work on the service components.
## Next steps

[Learn about AKS on Azure Stack Hub](aks-overview.md)
