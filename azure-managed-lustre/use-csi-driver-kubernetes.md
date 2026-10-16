---
title: Use the Azure Managed Lustre CSI Driver with Azure Kubernetes Service
description: Learn how to use an Azure Managed Lustre storage system with your Kubernetes containers in Azure Kubernetes Service (AKS).
ms.topic: overview
ms.date: 10/16/2026
author: pauljewellmsft
ms.author: akashdubey
ms.reviewer: brianl
ms.custom: sfi-image-nochange

# Intent: As an IT pro, I want to be able to use a Lustre file system with the apps I've deployed on Kubernetes.
# Keyword: 

---

# Use the Azure Managed Lustre CSI driver with Azure Kubernetes Service

By using the [Azure Lustre CSI Driver for Kubernetes](https://github.com/kubernetes-sigs/azurelustre-csi-driver), you can use [Azure Managed Lustre](/azure/azure-managed-lustre) as persistent storage for workloads running in [Azure Kubernetes Service (AKS)](/azure/aks/). This driver is based on the Container Storage Interface (CSI) specification.

You can use the Azure Lustre CSI Driver for Kubernetes to access Azure Managed Lustre storage as persistent storage volumes from Kubernetes containers deployed in AKS.

## Supported Kubernetes and AKS versions

The Azure Lustre CSI Driver for Kubernetes is compatible with [AKS](/azure/aks/). Other Kubernetes installations aren't currently supported.

AKS Kubernetes versions 1.21 and later are supported. This support includes all versions currently available when you're creating a new AKS cluster.

> [!IMPORTANT]
> The Azure Lustre CSI Driver for Kubernetes currently works only with the Ubuntu Linux OS SKU for node pools of AKS.

The Azure Lustre CSI Driver for Kubernetes is compatible with [Azure Managed Lustre](/azure/azure-managed-lustre). Other Lustre installations aren't currently supported.

### Azure Lustre CSI Driver versions

The following driver versions are supported:

| Driver version  | Image                                                         | Supported k8s version | Lustre client version | Dynamic Provisioning |
|-----------------|---------------------------------------------------------------|-----------------------|-----------------------|-----------------------|
| main branch     | mcr.microsoft.com/oss/v2/kubernetes-csi/azurelustre-csi:latest   | 1.21+                 | 2.15.5                | ✅                    |
| v0.3.0          | mcr.microsoft.com/oss/v2/kubernetes-csi/azurelustre-csi:v0.3.0   | 1.21+                 | 2.15.5                | ✅                    |
| v0.2.0          | mcr.microsoft.com/oss/v2/kubernetes-csi/azurelustre-csi:v0.2.0 | 1.21+                 | 2.15.5                | ❌                    |
| v0.1.18         | mcr.microsoft.com/oss/v2/kubernetes-csi/azurelustre-csi:v0.1.18  | 1.21+                 | 2.15.5                | ❌                    |
| v0.1.17         | mcr.microsoft.com/oss/v2/kubernetes-csi/azurelustre-csi:v0.1.17  | 1.21+                 | 2.15.5                | ❌                    |
| v0.1.15         | mcr.microsoft.com/oss/v2/kubernetes-csi/azurelustre-csi:v0.1.15  | 1.21+                 | 2.15.4                | ❌                    |
| v0.1.14         | mcr.microsoft.com/oss/v2/kubernetes-csi/azurelustre-csi:v0.1.14  | 1.21+                 | 2.15.3                | ❌                    |
| v0.1.13         | mcr.microsoft.com/oss/v2/kubernetes-csi/azurelustre-csi:v0.1.13  | 1.21+                 | 2.15.4                | ❌                    |
| v0.1.12         | mcr.microsoft.com/oss/v2/kubernetes-csi/azurelustre-csi:v0.1.12  | 1.21+                 | 2.15.3                | ❌                    |
| v0.1.11         | mcr.microsoft.com/oss/v2/kubernetes-csi/azurelustre-csi:v0.1.11  | 1.21+                 | 2.15.1                | ❌                    |
| v0.1.10         | mcr.microsoft.com/oss/v2/kubernetes-csi/azurelustre-csi:v0.1.10  | 1.21+                 | 2.15.2                | ❌                    |

For a complete list of all driver releases and their changelog, see the [Azure Lustre CSI driver releases page](https://github.com/kubernetes-sigs/azurelustre-csi-driver/releases).

## Prerequisites

- An Azure account with an active subscription. [Create an account for free](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).
- A terminal environment with the Azure CLI tools installed. See [Get started with the Azure CLI](/cli/azure/get-started-with-azure-cli).
- [kubectl](https://kubernetes.io/docs/reference/kubectl), the Kubernetes management tool, installed in your terminal environment. See [Quickstart: Deploy an Azure Kubernetes Service (AKS) cluster by using the Azure CLI](/azure/aks/learn/quick-kubernetes-deploy-cli#connect-to-the-cluster).
- An Azure Managed Lustre deployment. See the [Azure Managed Lustre documentation](/azure/azure-managed-lustre).
- **Network connectivity** between your AKS cluster and Azure Managed Lustre virtual network. See [Plan network architecture for AKS with Azure Managed Lustre](use-container-storage-interface-driver-network-planning.md) for configuration options.

## Provisioning methods

The Azure Lustre CSI Driver supports two provisioning methods:

### Dynamic provisioning (available in v0.3.0+)

Dynamic provisioning allows the CSI driver to automatically create Azure Managed Lustre file systems on demand when persistent volume claims are created.

> [!NOTE]
> Dynamic provisioning is available starting with Azure Lustre CSI Driver version 0.3.0. For more information, see the [v0.3.0 release notes](https://github.com/kubernetes-sigs/azurelustre-csi-driver/releases/tag/v0.3.0).

For full step-by-step instructions, see [Use dynamic provisioning with the Azure Managed Lustre CSI driver](use-container-storage-interface-driver-dynamic-provisioning.md).

### Static provisioning

Static provisioning uses an existing Azure Managed Lustre file system. This method involves:
- Creating storage classes that reference existing Lustre clusters
- Manually specifying the Lustre file system name and MGS IP address
- Suitable for scenarios where you have preexisting Lustre infrastructure

For full step-by-step instructions, see [Use static provisioning with the Azure Managed Lustre CSI driver](use-container-storage-interface-driver-static-provisioning.md).

## Related content

- [Plan network architecture for AKS with Azure Managed Lustre](use-container-storage-interface-driver-network-planning.md).
- [Use dynamic provisioning with the Azure Managed Lustre CSI driver](use-container-storage-interface-driver-dynamic-provisioning.md)
- [Use static provisioning with the Azure Managed Lustre CSI driver](use-container-storage-interface-driver-static-provisioning.md)
- [Validate CSI driver image security](use-container-storage-interface-driver-image-security.md).
- [Azure Lustre CSI Driver GitHub repository](https://github.com/kubernetes-sigs/azurelustre-csi-driver)
