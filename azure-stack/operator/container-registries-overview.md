---
title: Azure Container Registry on Azure Stack Hub overview 
description: Learn the differences between Azure Container Registry on Azure and Azure Container Registry on Azure Stack Hub
author: sethmanheim
ms.topic: article
ms.date: 10/26/2021
ms.author: sethm
ms.reviewer: chasat
ms.lastreviewed: 10/26/2021

# Intent: As an Azure Stack user, I want to XXX so I can XXX.
# Keyword: XXX

---

# Azure Container Registry on Azure Stack Hub overview

Azure Container Registry (ACR) on Azure Stack Hub provides your users with the ability to store and manage container images and artifacts. With the Public Preview release, your users can create and manage container registries by using the Azure Stack Hub user portal as well as commands in PowerShell, Azure CLI, and the Docker CLI.

ACR on Azure Stack Hub allows users to store and retrieve OCI images, assign role-based access control (RBAC) permissions, and create webhooks.

> [!IMPORTANT]
> Azure Container Registry on Azure Stack Hub is currently in PREVIEW.
> See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

While a public preview, the Azure Container Registry on Azure Stack Hub can be used without charge.

## Why offer ACR on Azure Stack Hub?

A local container registry enables users to manage a local repository of images as part of a continuous integration, continuous delivery (CI/CD) pipeline for deployment to AKS or other supported container orchestrators on Azure Stack Hub.

Features included with ACR on Azure Stack Hub include:

-   OCI artifact repository for adding Helm charts, Singularity support, and new OCI artifact-supported formats.
-   Integrated security with Microsoft Entra authentication or Microsoft Entra ID Federated Services (AD FS), and role-based access control.
-   Webhooks for triggering events when actions occur in one of your registry repositories.

## ACR on Azure and ACR on Azure Stack Hub

Azure Stack Hub support for ACR compared to ACR on Azure:

| Feature                     | Azure Container Registry          | Azure Container Registry on Azure Stack Hub |
|-----------------------------|-----------------------------------|---------------------------------------------|
| SKUs                        | 3 skus (Basic, Standard, Premium) | A single sku is available                   |
| Azure portal UX             | Available                         | Available                                   |
| PS/CLI                      | Available                         | Available                                   |
| Webhooks                    | Available                         | Available                                   |
| Geo-replication             | Available w/ Premium              | Not available                               |
| Additional Storage          | Available for additional charge   | Not available                               |
| Tasks                       | Available                         | Not available                               |
| Security Center integration | Available                         | Not available                               |
| Content Trust               | Available                         | Not available                               |
| Private Networks            | Available                         | Not available                               |

The ACR service is an optional service that requires operators provide an additional certificate to enable the service. For more information, see [Install Azure Container Registry](container-registries-install.md) on Azure Stack Hub

## Next steps

[Add items to the Azure Stack Hub Marketplace](azure-stack-marketplace.md)
