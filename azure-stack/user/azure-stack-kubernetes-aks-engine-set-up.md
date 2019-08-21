---
title: Set up the prerequisites for the AKS Engine | Microsoft Docs
description: Establish the requirements for running the ASK Engine on your Azure Stack.
services: azure-stack
documentationcenter: ''
author: mattbriggs
manager: femila
editor: ''

ms.service: azure-stack
ms.workload: na
pms.tgt_pltfrm: na (Kubernetes)
ms.devlang: nav
ms.topic: article
ms.date: 08/22/2019
ms.author: mabrigg
ms.reviewer: waltero
ms.lastreviewed: 08/22/2019

---

# Set up the prerequisites for the AKS Engine

*Applies to: Azure Stack integrated systems and Azure Stack Development Kit*

You can install the AKS Engine on a VM in your environment. You will need the following things in place before you install the engine: an Ubuntu server and Linux custom script extension available in your subscription, a service principal identity that has been assigned to a contributor role, and a private public key for SSH access to your Ubuntu server. In addition, if you are using the Azure Stack Development Kit, you will need the appropriate certificates. Finally, you may need to install the Azure CLI for Azure Stack.

If you have your prerequisites, you can begin to [define your cluster](azure-stack-kubernetes-aks-engine-deploy-cluster.md).

## Prerequisites for the AKS Engine

To use the AKS Engine you need to have the following resources available.

| Prerequisite | Description | Required | Instructions |
| --- | --- | --- | --- |
| Ubuntu server | Ubuntu 1.16.latest<br>Publisher: Canonical<br>Offer: UbuntuServer<br>Version: 16.04.201806120 (or latest version)<br>SKU: 16.04-LTS | Required | If you do not have this item in your subscription, contact your cloud operator. |
| Linux custom script extension | Linux Custom Script extension 2.0<br>Offer: Custom Script for Linux 2.0<br>Version: 2.0.6 (or latest version)<br>Publisher: Microsoft Corp | Required | If you do not have this item in your subscription, contact your cloud operator. |
| AKS Base Image | AKS Base Image<br>Offer: aks<br>Version: 2019.07.30 (or newer version)<br>Publisher: microsoft-aks<br>SKU: aks-ubuntu-1604-201907 | Required | If you do not have this item in your subscription, contact your cloud operator. |
| Azure Stack subscription | You access offers in your Azure Stack through subscriptions. The offer contains the services that are available to you. | Required | To be able to deploy any tenant workloads in Azure Stack, you need to first get an [Azure Stack Subscription](https://docs.microsoft.com/azure-stack/user/azure-stack-subscribe-services). |
| Service principal identity (SPN) |  An application that needs to deploy or configure resources through Azure Resource Manager, must be represented by a service principal. | Required | For instructions see [se an app identity to access resources](https://docs.microsoft.com/azure-stack/operator/azure-stack-create-service-principals) |
| (SPN) assigned **Contributor** role | To allow an application to access resources in your subscription using its service principal, you must assign the service principal to a role for a specific resource.  | Required | For instructions, see [Assign a role](https://docs.microsoft.com/azure-stack/operator/azure-stack-create-service-principals#assign-a-role) |
| Resource group | A resource group is a container that holds related resources for an Azure solution. | Optional | [Manage Azure Resource Manager resource groups by using the Azure portal](https://docs.microsoft.com/azure/azure-resource-manager/manage-resource-groups-portal) |
| Private Public key | To use an open SSH connection from your development machine to the server VM in your Azure Stack instance that hosts your web app, you might need to create a Secure Shell (SSH) public and private key pair. | Required | For instructions on generating a key, see [SSH Key Generation](https://docs.microsoft.com/azure-stack/user/azure-stack-dev-start-howto-ssh-public-key).|
| Certificates | | Optional | In the case that you want to use and manage your own certificates you can, [here is more information](https://github.com/Azure/aks-engine/blob/e250a6c5065cc941bcc9cb9feb6461a1449b2a47/examples/keyvault-params/README.md). |

## Installing Azure CLI

The Azure command-line interface (CLI) is Microsoft's cross-platform command-line experience for managing Azure resources. 

### Install the Azure CLI for Azure Stack on integrated system

To install the Azure CLI on Azure Stack, you can follow the instructions at [Manage and deploy resources to Azure Stack with Azure CLI](https://docs.microsoft.com/azure-stack/user/azure-stack-version-profiles-azurecli2).

You can also install the CLI with the following command:

```bash  
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

### Install the Azure CLI for Azure Stack on ASDK

1.  If you are using the ASDK, you will need to trust the Azure Stack root certificate on your machine. You will not need to do this with the integrated systems. Follow the [instructions to trust the certificate](https://docs.microsoft.com/azure-stack/user/azure-stack-version-profiles-azurecli2#linux-azure-ad)

2.  To connect to Azure Stack follow this [instructions](https://docs.microsoft.com/azure-stack/user/azure-stack-version-profiles-azurecli2#connect-to-azure-stack).

## Next steps

> [!div class="nextstepaction"]
> [Deploy the AKS Engine on Windows in Azure Stack](azure-stack-kubernetes-aks-engine-deploy-windows.md)
> [Deploy the AKS Engine on Linux in Azure Stack](azure-stack-kubernetes-aks-engine-deploy-linux.md)