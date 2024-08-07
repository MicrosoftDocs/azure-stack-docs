---
title: Azure Container Registry on Azure Stack Hub operator overview 
description: Learn the differences between Azure Container Registry on Azure and Azure Container Registry on Azure Stack Hub
author: sethmanheim
ms.topic: article
ms.date: 07/25/2024
ms.author: sethm
ms.reviewer: chasat
ms.lastreviewed: 10/26/2021

# Intent: As an Azure Stack user, I want to XXX so I can XXX.
# Keyword: XXX

---

# Azure Container Registry operator overview

Azure Container Registry on Azure Stack Hub provides your users with the ability to store and manage container images and artifacts. You can create and manage container registries by using the Azure Stack Hub user portal as well as commands in PowerShell, Azure CLI, and the Docker CLI.

Azure Container Registry on Azure Stack Hub allows users to store and retrieve OCI images, assign role-based access control (RBAC) permissions, and create webhooks.

## Why offer Azure Container Registry on Azure Stack Hub?

A local container registry enables users to manage a local repository of images as part of a continuous integration, continuous delivery (CI/CD) pipeline for deployment to AKS or other supported container orchestrators on Azure Stack Hub.

Features included with Azure Container Registry on Azure Stack Hub include:

- OCI artifact repository for adding Helm charts, Singularity support, and new OCI artifact-supported formats.
- Integrated security with Microsoft Entra authentication or Microsoft Entra ID Federated Services (AD FS), and role-based access control.
- Webhooks for triggering events when actions occur in one of your registry repositories.

## Azure Container Registry on Azure and Azure Container Registry on Azure Stack Hub

Azure Stack Hub support for Azure Container Registry compared to Azure Container Registry on Azure:

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

The Azure Container Registry service is an optional service that requires operators provide an additional certificate to enable the service. For more information, see [Install Azure Container Registry](container-registries-install.md) on Azure Stack Hub

## Next steps

[Add items to the Azure Stack Hub Marketplace](azure-stack-marketplace.md)
