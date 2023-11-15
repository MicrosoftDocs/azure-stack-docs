---
title: Azure Container Registries on Azure Stack Hub overview 
description: Learn about the differences between Azure and Azure Stack Hub with Azure Container Registries.
author: sethmanheim
ms.topic: article
ms.date: 10/26/2021
ms.author: sethm
ms.reviewer: chasat
ms.lastreviewed: 10/26/2021

# Intent: As an Azure Stack user, I want to XXX so I can XXX.
# Keyword: XXX

---

# Azure Container Registries on Azure Stack Hub overview

You can use the Azure Container Registry (ACR) on Azure Stack Hub to 
store and manage container images and artifacts. With the Public Preview release, you can 
create and manage container registries by using the Azure Stack Hub user portal 
or by using commands in PowerShell, Azure CLI, and the Docker CLI.

ACR on Azure Stack Hub allows users to store and retrieve OCI images, assign role-based 
access control (RBAC) permissions, and create webhooks

> [!IMPORTANT]
> Azure Container Registry on Azure Stack Hub is currently in PREVIEW.
> See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) 
for legal terms that apply to Azure features that are in beta, preview, or otherwise not 
yet released into general availability.

## Features of ACR on Azure Stack Hub

Azure Stack Hub support for ACR compared to ACR on Azure:

| Feature                      | ACR in Azure | ACR in Azure Stack Hub Public Preview |
|------------------------------|--------------|---------------------------|
| Portal                       | Yes          | Yes                       |
| Multi-tenant Hosted service  | Yes          | Yes                       |
| Docker registry              | Yes          | Yes                       |
| Helm support                 | Yes          | Yes                       |
| OCI support                  | Yes          | Yes                       |
| Identity & Access Management | Microsoft Entra ID     | Microsoft Entra / AD FS            |
| RBAC                         | Registry     | Registry                  |
| Remote Repository (Mirror)   | No           | No                        |
| OSS Vulnerability Scanning   | Yes          | No                        |
| Retention                    | Yes          | No                        |
| Content Trust                | Yes          | No                        |
| Replication                  | Yes          | No                        |
| Webhooks                     | Yes          | Yes                       |
| Private Networks             | Yes          | No                        |

## ACR on Azure and ACR on Azure Stack Hub

Azure Stack Hub key differences for ACR compared to ACR on Azure:

| Aspect | Container Registry on Azure | Container Registry and Azure Stack Hub |
| --- | --- | --- |
| Service Tiers (SKUs) | [Registry service tiers and features - Azure Container Registry \| Microsoft Docs](/azure/container-registry/container-registry-skus) | By default a single service tier (SKU) is available to create on Azure Stack Hub with a maximum of 100 GB of storage and 10 webhooks. Azure Stack Hub operators may customize that storage limit lower based on needs. |
| Login Server | `<registry-name>.azurecr.io`<br>(All lower case)<br> | `<registry-name>.azsacr.<regionname>.<fqdn>` <br> (All lower case) <br> Example: `myregistry.azsacr.azurestack.contoso.com`|

## Service tier features and limits

The following table details the features and registry limits of the Azure Stack Hub service tier.

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

<sup>1.</sup> Storage included in the rate for each tier.

<sup>2.</sup> Maximum storage allowed for a registry. Operators may offer less storage through quotas.

<sup>3.</sup> *ReadOps*, *WriteOps*, and *Bandwidth* will vary based on Azure Stack Hub configuration and user workloads.

<sup>4.</sup> [docker pull](https://docs.docker.com/registry/spec/api/#pulling-an-image) translates to multiple read operations based on the number of layers in the image, plus the manifest retrieval.

<sup>5.</sup> [docker push](https://docs.docker.com/registry/spec/api/#pushing-an-image) translates to multiple write operations, based on the number of layers that must be pushed. A docker push includes *ReadOps* to retrieve a manifest for an existing image.

## Supported Commands
A subset of CLI and PowerShell commands are supported for Azure Container Registry on Azure Stack Hub. The full list is available here: 
[Supported Commands](container-registry-commands.md).

## Pricing
Similar to most public previews, the public preview of Azure Container Registry on Azure Stack Hub is free.  Details of pricing will be shared prior to the GA release of the service.

## Next steps

[Learn about Kubernetes on Azure Stack Hub](azure-stack-kubernetes-aks-engine-overview.md)
