---
title: Azure Kubernetes Service on Azure Stack Hub support
description: Learn about support options for Azure Kubernetes Service (ASK) on Azure Stack Hub.
author: mattbriggs
ms.topic: article
ms.date: 07/01/2021
ms.author: mabrigg
ms.reviewer: waltero
ms.lastreviewed: 07/01/2021

# Intent: As an Azure Stack Hub operator, I want to install and offer Azure Kubernetes Service on Azure Stack Hub so my supported user can offer containerized solutions.
# Keyword: Kubernetes AKS difference
---

# Azure Kubernetes Service on Azure Stack Hub support

Azure Kubernetes Service (AKS) for Azure Stack Hub is is a subset of AKS on Azure, you will see that some commands are not available. Provide feedback about your experiencing using AKS on Azure Stack Hub. This article provides guidance on how to provide feedback and resolve issues with the AKS while the service is in preview.

## Things to note

Take advantage of the **User Voice** provided to communicate with the AKS service team. In the situation where an issue can't be resolved in **User Voice**, you can raise a non-production [Support Case](../operator/azure-stack-help-and-support-overview.md).

When providing feedback and notes, take not of:

1.  Missing functionality.
2.  Potential bugs that could affect your Kubernetes clusters, Container registries, the overall functionality of the Azure Kubernetes Service or Azure Container Registry Resource Providers or even the Azure Stack Hub platform.
3.  Potential security vulnerabilities.
4.  Global Azure Kubernetes Service or Azure Container Registry guidance that works on Azure but does not on Azure Stack Hub.
5.  Support for public preview bits is done through a best effort from the Product Group and Customer Support teams.
6.  Support cases of preview services cannot be created and addressed as production support cases.

## Report bugs

1.  Go to **User Voice** to report the bug.
2.  Provide description, repro steps, and description of expected behavior.
3.  In some cases, we may ask you to collect Azure Stack Hub logs (a [support case](../operator/azure-stack-help-and-support-overview.md) with the Microsoft Support team would be needed).
4.  In some cases, we may ask you to collect Kubernetes logs ([instructions to collect logs](azure-stack-kubernetes-aks-engine-troubleshoot.md#collect-kubernetes-logs)).

## Provide feedback

Use the links below to submit your feedback:

1.  To report a security vulnerability, go to [https://msrc.**microsoft**.com/create-**report**](https://msrc.microsoft.com/create-report).
2.  To send a suggestion, go to **User Voice**.
3.  To add documentation feedback, select **Feeback** on the document page.

## Not included in the preview

If you are familiar with the AKS service in global Azure, you may note the following things aren't included:

1.  AKS on Azure Stack Hub is a subset of AKS on Azure. You can learn my by reviewing the following articles: the [set of supported features](aks-overview.md#feature-comparison) and [commands](aks-commands.md).
2.  You cannot manage node pools. Only one worker node pool and one master node pool are deployed by default in an Azure Kubernetes Service cluster. Azure Kubernetes Service CLI and APIs that reference node pools directly are not supported.
3.  Hidden master nodes are not supported. Master nodes are exposed to you in your subscription.
4.  Backup and disaster recovery for AKS Service and Kubernetes clusters functions are not included. There isn't functionality in place to backup and recover the AKS Service and/or AKS tenant clusters.
5.  There are no automatic remediation actions at the moment for raised alerts raised by your monitors.
6.  Standard Load Balancer Functionality.
7.  Attaching Azure Container Registry option when creating clusters.
8.  Private Azure Kubernetes Service clusters.
9.  Support for Calico.
10. Support for AKS on Azure Stack Development Kit (ASDK).
11. Support for Azure Arc.

## Service updates

Updates to the AKS service on Azure Stack Hub are made available through the standard Azure Stack Hub Patch and Update (PNU) process outlined in the [Manage updates in Azure Stack Hub](../operator/azure-stack-updates.md). In addition to the components that provide the service in the Azure Stack Hub, you will also need to update the  Azure Kubernetes Service base image. The image requires [downloading the image](../operator/azure-stack-aks-engine.md) from the marketplace.

You can keep on top of the updates by monitoring the [Teams channel](https://teams.microsoft.com/l/team/19%3ac9c4faafab2247c993268db91792e2da%40thread.tacv2/conversations?groupId=cbe0f09a-8855-4e9d-ae54-fc6d54a91677&tenantId=72f988bf-86f1-41af-91ab-2d7cd011db47).

As participants in the public preview, you may also need to need to:

1.  Redeploy Kubernetes to access certain operations.
2.  Perform manual steps on individual infrastructure-as-a-service (IaaS) components such as masters and nodes.
3. You may need to contact your cloud operator and Microsoft support so that technicians can directly work with the service components in Azure Stack Hub directly.

## Next steps

[Learn about AKS on Azure Stack Hub](aks-overview.md)
