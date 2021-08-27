---
title: Use Azure Key Vault to store secrets with Azure Kubernetes Service on Azure Stack Hub
description: Learn how to use Azure Key Vault to store secrets with Azure Kubernetes Service on Azure Stack Hub
author: mattbriggs
ms.topic: article
ms.date: 08/27/2021
ms.author: mabrigg
ms.reviewer: waltero
ms.lastreviewed: 08/27/2021

# Intent: As an Azure Stack operator, I want to install and offer Azure Kubernetes Service on Azure Stack Hub so my supported user can offer containerized solutions.
# Keyword: Kubernetes AKS difference
---

# Use Azure Key Vault to store secrets with Azure Kubernetes Service on Azure Stack Hub

## Secrets Store CSI driver

Azure Key Vault provider for [Secrets Store CSI driver](https://github.com/kubernetes-sigs/secrets-store-csi-driver) allows you to get secret contents stored in an [Azure Key Vault](/azure/key-vault/general/overview) instance and use the Secrets Store CSI driver interface to mount them into Kubernetes pods.

### Features

- Mounts secrets/keys/certs on pod start using a CSI volume.
- Supports mounting multiple secrets store objects as a single volume.
- Supports pod identity to restrict access with specific identities.
- Supports pod portability with the SecretProviderClass CRD.
- Supports windows containers (Kubernetes version v1.18+).
- Supports sync with Kubernetes Secrets (Secrets Store CSI Driver v0.0.10+).
- Supports multiple secrets stores providers in the same cluster.

### Demo

![Secrets Store CSI Driver Azure Key Vault Provider Demo](media/aks-how-to-store-secrets/demo.gif)

### Getting started

1. Setup the correct [role assignments and access policies](https://azure.github.io/secrets-store-csi-driver-provider-azure/configurations/identity-access-modes/).
2. Install Azure Key Vault Provider for Secrets Store CSI Driver through [Helm](https://azure.github.io/secrets-store-csi-driver-provider-azure/getting-started/installation/#deployment-using-helm) or [YAML deployment files](https://azure.github.io/secrets-store-csi-driver-provider-azure/getting-started/installation/#using-deployment-yamls). 
3. Learn [how to use the Azure Key Vault Provider](https://azure.github.io/secrets-store-csi-driver-provider-azure/getting-started/usage/) and supported [configurations](https://azure.github.io/secrets-store-csi-driver-provider-azure/configurations/).
4. Get up to speed with the application workflow with the [walkthrough](https://azure.github.io/secrets-store-csi-driver-provider-azure/demos/standard-walkthrough/).

### Support

Azure Key Vault Provider for Secrets Store CSI Driver is an open source project that is [**not** covered by the Microsoft Azure support policy](https://support.microsoft.com/help/2941892/support-for-linux-and-open-source-technology-in-azure). [Please search open issues here](https://github.com/Azure/secrets-store-csi-driver-provider-azure/issues), and if your issue isn't already represented please [open a new one](https://github.com/Azure/secrets-store-csi-driver-provider-azure/issues/new/choose). The project maintainers will respond to the best of their abilities.

## Next steps

[Overview of the AKS engine](azure-stack-kubernetes-aks-engine-overview.md)

