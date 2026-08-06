---
title: Azure Container Registry on Azure Stack Hub operator overview
description: Learn the differences between Azure Container Registry on Azure and Azure Container Registry on Azure Stack Hub
author: sethmanheim
ms.topic: concept-article
ms.date: 07/08/2026
ms.author: sethm
ms.reviewer: chasat
ms.lastreviewed: 10/26/2021

# Intent: As an Azure Stack user, I want to XXX so I can XXX.
# Keyword: XXX

---

# Azure Container Registry operator overview

By using Container Registry on Azure Stack Hub, your users can store and manage container images and artifacts. You can create and manage container registries by using the Azure Stack Hub user portal as well as commands in PowerShell, Azure CLI, and the Docker CLI.

By using Container Registry on Azure Stack Hub, users can store and retrieve OCI images, assign role-based access control (RBAC) permissions, and create webhooks.

## Why offer Container Registry on Azure Stack Hub?

A local container registry enables users to manage a local repository of images as part of a continuous integration, continuous delivery (CI/CD) pipeline for deployment to AKS or other supported container orchestrators on Azure Stack Hub.

Container Registry on Azure Stack Hub includes these features:

- OCI artifact repository for adding Helm charts, Singularity support, and new OCI artifact-supported formats.
- Integrated security with Microsoft Entra authentication or Microsoft Entra ID Federated Services (AD FS), and role-based access control.
- Webhooks for triggering events when actions occur in one of your registry repositories.

## Container Registry on Azure and Container Registry on Azure Stack Hub

Azure Stack Hub support for Container Registry compared to Container Registry on Azure Stack Hub:

| Feature                     | Container Registry          | Container Registry on Azure Stack Hub |
|-----------------------------|-----------------------------------|---------------------------------------------|
| SKUs                        | 3 versions (Basic, Standard, Premium) | A single version is available                   |
| Azure portal UX             | Available                         | Available                                   |
| PowerShell/CLI              | Available                         | Available                                   |
| Webhooks                    | Available                         | Available                                   |
| Geo-replication             | Available with Premium            | Not available                               |
| Additional Storage          | Available for additional charge   | Not available                               |
| Tasks                       | Available                         | Not available                               |
| Security Center integration | Available                         | Not available                               |
| Content Trust               | Available                         | Not available                               |
| Private Networks            | Available                         | Not available                               |

The Container Registry service is an optional service that requires operators to provide an additional certificate to enable the service. For more information, see [Install Azure Container Registry](container-registries-install.md) on Azure Stack Hub.

## Next steps

- [Add items to the Azure Stack Hub Marketplace](azure-stack-marketplace.md)
