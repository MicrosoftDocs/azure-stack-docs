---
title: Azure Container Registry on Azure Stack Hub user overview 
description: Learn about the differences between Azure and Azure Stack Hub with Azure Container Registry.
author: sethmanheim
ms.topic: article
ms.date: 07/23/2024
ms.author: sethm
ms.reviewer: dgarrity
ms.lastreviewed: 04/10/2024

# Intent: As an Azure Stack Hub user, I want to know about the differences between Azure and Azure Stack Hub with Azure Container Registry so that I can understand the limitations and capabilities of the service.

---

# Azure Container Registry user overview

You can use Azure Container Registry on Azure Stack Hub to store and manage container images and artifacts. With Azure Container Registry on Azure Stack Hub, you can create and manage container registries by using the Azure Stack Hub user portal or by using commands in PowerShell, Azure CLI, and the Docker CLI.

Azure Container Registry on Azure Stack Hub allows users to store and retrieve OCI images, assign role-based access control (RBAC) permissions, and create webhooks.

## Features of Azure Container Registry on Azure Stack Hub

The following table shows Azure Stack Hub support for Azure Container Registry compared to Azure Container Registry on Azure:

| Feature                      | Azure Container Registry in Azure | Azure Container Registry in Azure Stack Hub |
|------------------------------|--------------|---------------------------|
| Portal                       | Yes          | Yes                       |
| Multi-tenant hosted service  | Yes          | Yes                       |
| Docker registry              | Yes          | Yes                       |
| Helm support                 | Yes          | Yes                       |
| OCI support                  | Yes          | Yes                       |
| Identity and access management | Microsoft Entra ID     | Microsoft Entra / AD FS            |
| RBAC                         | Registry     | Registry                  |
| Remote repository (mirror)   | No           | No                        |
| OSS vulnerability scanning   | Yes          | No                        |
| Retention                    | Yes          | No                        |
| Content trust                | Yes          | No                        |
| Replication                  | Yes          | No                        |
| Webhooks                     | Yes          | Yes                       |
| Private networks             | Yes          | No                        |

## Azure Container Registry on Azure and Azure Container Registry on Azure Stack Hub

The following table shows Azure Stack Hub key differences for Azure Container Registry compared to Azure Container Registry on Azure:

| Aspect | Container Registry on Azure | Container Registry and Azure Stack Hub |
| --- | --- | --- |
| Service tiers (SKUs) | [Registry service tiers and features - Azure Container Registry](/azure/container-registry/container-registry-skus) | By default, a single service tier (SKU) is available to create on Azure Stack Hub with a maximum of 100 GB of storage and 10 webhooks. Azure Stack Hub operators can lower that storage limit based on needs. |
| Login server | `<registry-name>.azurecr.io`<br>(All lower case)<br> | `<registry-name>.azsacr.<regionname>.<fqdn>` <br> (All lower case) <br> Example: `myregistry.azsacr.azurestack.contoso.com`|

## Service tier features and limits

The following table shows the features and registry limits of the Azure Stack Hub service tier:

| Resource                            | Azure Stack Hub |
|-------------------------------------|-----------------|
| Included storage<sup>1</sup> (GB)             | 100             |
| Storage limit<sup>2</sup> (GB)                | 100             |
| Maximum image layer size (GB)      | 100             |
| ReadOps per minute<sup>3, 4</sup>              | N/A             |
| WriteOps per minute<sup>3, 5</sup>            | N/A             |
| Download bandwidth<sup>3</sup> (MBPS)          | N/A             |
| Upload bandwidth<sup>3</sup> (MBPS)           | N/A             |
| Webhooks                            | 10              |
| Geo-replication                     | N/A             |
| Availability zones                  | N/A             |
| Content trust                       | N/A             |
| Private link with private endpoints | N/A             |
|  - Private endpoints                 | N/A             |
| Public IP network rules             | N/A             |
| Service endpoint VNet access        | N/A             |
| Customer-managed keys               | N/A             |
| Repository-scoped permissions       | N/A             |
|  - Tokens                            | N/A             |
|  - Scope maps                        | N/A             |
|  - Repositories per scope map        | N/A             |

<sup>1</sup> Storage included in the rate for each tier.

<sup>2</sup> Maximum storage allowed for a registry. Operators can offer less storage through quotas.

<sup>3</sup> **ReadOps**, **WriteOps**, and **Bandwidth** vary based on Azure Stack Hub configuration and user workloads.

<sup>4</sup> [docker pull](https://docs.docker.com/registry/spec/api/#pulling-an-image) translates to multiple read operations based on the number of layers in the image, plus the manifest retrieval.

<sup>5</sup> [docker push](https://docs.docker.com/registry/spec/api/#pushing-an-image) translates to multiple write operations, based on the number of layers that must be pushed. A docker push includes *ReadOps* to retrieve a manifest for an existing image.

## Supported commands

A subset of CLI and PowerShell commands are supported for Azure Container Registry on Azure Stack Hub. The full list is available here: [Supported Commands](container-registry-commands.md).

## Next steps

[Learn about Kubernetes on Azure Stack Hub](azure-stack-kubernetes-aks-engine-overview.md)
