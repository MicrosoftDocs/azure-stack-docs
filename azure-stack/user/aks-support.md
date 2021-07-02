---
title: Azure Kubernetes Service on Azure Stack Hub support
description: Learn about support options for Azure Kubernetes Service (ASK) on Azure Stack Hub.
author: mattbriggs
ms.topic: article
ms.date: 07/01/2021
ms.author: mabrigg
ms.reviewer: waltero
ms.lastreviewed: 07/01/2021

# Intent: As an Azure Stack operator, I want to install and offer Azure Kubernetes Service on Azure Stack Hub so my supported user can offer containerized solutions.
# Keyword: Kubernetes AKS difference
---

# Azure Kubernetes Service on Azure Stack Hub support

Azure Kubernetes Service for Azure Stack Hub is in private preview, that is, they are available only to customers that have agreed to use it for non-production workloads. Since AKS on Azure Stack Hub is a subset of AKS on Azure, you will see that some commands are not available. We are interested in hearing your feedback about any missing functionality to adjust our priorities for the upcoming updates.

The goal for the preview is to gather customer feedback and use it to influence future releases of the service. This feedback may come in the form of bugs, functionality suggestions, issues, how to tasks, installation, workflow questions, etc. See below for instructions on how to provide feedback.

We encourage customers to take advantage of the UserVoice \<TODO:link\> provided to communicate with the AKS service team. In the situation that the issue cannot be resolved via UserVoice, customers could raise a non-production [Support Case](/azure-stack/operator/azure-stack-help-and-support-overview?view=azs-2102#:~:text=You%20can%20select%20Help%20(question,preselect%20Azure%20Stack%20Hub%20service.) (the Customer support team will be involved in the public preview). The product team will monitor the UserVoice posts and reply accordingly. There will also be periodic calls between the product team and customers during the preview to gather feedback and provide answers.

Customers should be aware that since this is preview code users may note:

1.  Missing functionality.
2.  Potential bugs that could affect your Kubernetes clusters, Container registries, the overall functionality of the Azure Kubernetes Service or Azure Container Registry Resource Providers or even the Azure Stack Hub platform.
3.  Potential security vulnerabilities.
4.  Public Azure Kubernetes Service or Azure Container Registry guidance that works on Azure but does not on Azure Stack Hub.
5.  Support for public preview bits is done through a best effort from the Product Group and Customer Support teams.
6.  Support cases of preview services cannot be created and addressed as production support cases.

## Reporting Bugs

1.  Go to \<TODO:UserVoice\> to report the bug.
2.  Provide description, repro steps, and description of expected behavior.
3.  In some cases, we may ask you to collect Azure Stack Hub logs (a [support case](/azure-stack/operator/azure-stack-help-and-support-overview?view=azs-2102#:~:text=You%20can%20select%20Help%20(question,preselect%20Azure%20Stack%20Hub%20service.) with the Microsoft Support team would be needed).
4.  In some cases we may ask you to collect Kubernetes logs ([instructions to collect logs](/azure-stack/user/azure-stack-kubernetes-aks-engine-troubleshoot#collect-kubernetes-logs)).

## Providing feedback

Please use the links below to submit your feedback:

1.  For reporting a security vulnerability, go to [https://msrc.**microsoft**.com/create-**report**](https://msrc.microsoft.com/create-report).
2.  For improvement suggestions go to \<TODO:UserVoice\>.
3.  For documentation feedback use the "Feeback" button on the document page.

## Not included in the Preview

1.  AKS on ASH is a subset of AKS on Azure, this can be see reflected by the set of supported feature areas here\<TODO: add link to feature table\> and commands listed here \<TODO: add link to commands list\>.
2.  Management of node pools, only one worker node pool and one master node pool are deployed by default in an Azure Kubernetes Service cluster. Azure Kubernetes Service CLI and APIs that reference node pools directly are not currently supported.
3.  Hidden master nodes, masters are exposed to customers in their subscriptions.
4.  Backup and disaster recovery for AKS Service and Kubernetes clusters. There is no functionality in place that will backup and/or recover the AKS Service and/or AKS tenant clusters.
5.  Monitoring: remediations. There are no automatic remediations actions at the moment for raised alerts.
6.  Standard Load Balancer Functionality.
7.  Attaching Azure Container Registry option when creating clusters.
8.  Private Azure Kubernetes Service clusters.
9.  Support for Calico.
10. Support for AKS on ASDK.
11. Support for Azure Arc.

## Service Updates

As we make progress on the preview bits, we may have an opportunity to push a new update to customers. This will be made available following the standard Azure Stack Patch and Update (PNU) process outlined in the article "[Manage updates in Azure Stack Hub](/azure-stack/operator/azure-stack-update)". Besides the actual Resource Provider bits which are updated via the Azure Stack Hub Patch and Update process, there may be a need to also update the Azure Kubernetes Service base image mentioned above. If such is the case the extra step of [downloading the image](/azure-stack/operator/azure-stack-aks-engine) from the Marketplace will be required. We will announce updates through the [Teams channel](https://teams.microsoft.com/l/team/19%3ac9c4faafab2247c993268db91792e2da%40thread.tacv2/conversations?groupId=cbe0f09a-8855-4e9d-ae54-fc6d54a91677&tenantId=72f988bf-86f1-41af-91ab-2d7cd011db47).

Given that these are early bits, there might be a need for following extra steps beyond the one outlined above. For example:

1.  Kubernetes might need to be redeployed if certain operations are desired.
2.  Manual steps that act on individual infrastructure-as-a-service (IaaS) elements such as masters and nodes might be required.
3.  In an extreme situation, a support case might be required to break glass and operate on the service RP components directly.

## Next steps

[Learn about AKS on Azure Stack Hub](aks-overview.md)
