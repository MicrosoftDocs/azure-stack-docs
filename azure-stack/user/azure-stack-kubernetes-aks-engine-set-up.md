---
title: Set up the prerequisites for the AKS Engine on Azure Stack | Microsoft Docs
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
ms.date: 09/14/2019
ms.author: mabrigg
ms.reviewer: waltero
ms.lastreviewed: 09/14/2019

---

# Set up the prerequisites for the AKS Engine on Azure Stack

*Applies to: Azure Stack integrated systems and Azure Stack Development Kit*

You can install the AKS Engine on a VM in your environment, or any client machine with access to your Azure Stack Resource Manager endpoint. You will need the following things in place before you run the engine: an AKS Base Ubuntu server and Linux custom script extension available in your subscription, a service principal identity that has been assigned to a contributor role, and a private/public key pair for SSH access to your Ubuntu server. In addition, if you are using the Azure Stack Development Kit, you will need to have your machine trust the appropriate certificates.

If you have your prerequisites, you can begin to [define your cluster](azure-stack-kubernetes-aks-engine-deploy-cluster.md).

If you are the cloud operator for Azure Stack and would like to offer the AKS Engine, follow the instructions at [Add the AKS Engine to the Azure Stack Marketplace](../operator/azure-stack-aks-engine.md).

## Prerequisites for the AKS Engine

To use the AKS Engine you need to have the following resources available. Keep in mind that the AKS Engine is meant to be used by tenants of Azure Stack to deploy Kubernetes clusters into their tenant subscription. The only part where involvement of the Azure Stack operator may be required is for downloading marketplace items and the creation of a service principal identity. You can find details in the following table.

| Prerequisite | Description | Required | Instructions |
| --- | --- | --- | --- |
| Linux custom script extension | Linux Custom Script extension 2.0<br>Offer: Custom Script for Linux 2.0<br>Version: 2.0.6 (or latest version)<br>Publisher: Microsoft Corp | Required | If you do not have this item in your subscription, contact your cloud operator. |
| AKS Base Ubuntu Image | AKS Base Image<br>Offer: aks<br>Version: 2019.07.30 (or newer version)<br>Publisher: microsoft-aks<br>SKU: aks-ubuntu-1604-201907 | Required | If you don't have this item in your subscription, contact your cloud operator. See more information on the version dependency see [Matching engine to base image version](#matching-engine-to-base-image-version). |
| Azure Stack subscription | You access offers in your Azure Stack through subscriptions. The offer contains the services that are available to you. | Required | To be able to deploy any tenant workloads in Azure Stack, you need to first get an [Azure Stack Subscription](https://docs.microsoft.com/azure-stack/user/azure-stack-subscribe-services). |
| Service principal identity (SPN) |  An application that needs to deploy or configure resources through Azure Resource Manager, must be represented by a service principal. | Required | You may need to contact your Azure Stack operator for this item.  For instructions see [Use an app identity to access resources](https://docs.microsoft.com/azure-stack/operator/azure-stack-create-service-principals) |
| (SPN) assigned **Contributor** role | To allow an application to access resources in your subscription using its service principal, you must assign the service principal to a role for a specific resource. | Required | For instructions, see [Assign a role](https://docs.microsoft.com/azure-stack/operator/azure-stack-create-service-principals#assign-a-role) |
| Resource group | A resource group is a container that holds related resources for an Azure solution. If you don't specify an existing resource group the tool will create one for you. | Optional | [Manage Azure Resource Manager resource groups by using the Azure portal](https://docs.microsoft.com/azure/azure-resource-manager/manage-resource-groups-portal) |
| Private Public key | To use an open SSH connection from your development machine to the server VM in your Azure Stack instance that hosts your web app, you need to create a Secure Shell (SSH) public and private key pair. | Required | For instructions on generating a key, see [SSH Key Generation](https://docs.microsoft.com/azure-stack/user/azure-stack-dev-start-howto-ssh-public-key).|

> [!Note]  
> You can also create the prerequisites for the AKS Engine with [Azure CLI for Azure Stack](https://docs.microsoft.com/azure-stack/user/azure-stack-version-profiles-azurecli2) or [Azure Stack PowerShell](https://docs.microsoft.com/azure-stack/operator/azure-stack-powershell-install).

## Matching engine to base image version

The AKS Engine uses a built image, the **AKS Base Image**. Any AKS Engine version is dependent on a specific image version made available in your Azure Stack by your Azure Stack operator. You can find a table listing the AKS Engine versions and corresponding supported Kubernetes versions at [Supported Kubernetes Versions](https://github.com/Azure/aks-engine/blob/master/docs/topics/azure-stack.md#supported-kubernetes-versions). For example, AKS Engine version `v0.40.0` depends on version `2019.08.21` of the AKS Base Image. Ask your Azure Stack operator to download the specific image version from the Azure Marketplace to the Azure Stack Marketplace.

You will trigger and error if the image is not available in your Azure Stack Marketplace. For example, if you're currently using AKS Engine version v0.39.1 and AKS Base image version `2019.08.09` isn't available, you will see the following error when running the AKS Engine: 

```Text  
The platform image 'microsoft-aks:aks:aks-ubuntu-1604-201908:2019.08.09' is not available. 
Verify that all fields in the storage profile are correct.
```

You can check the current version of your AKS Engine by running the following command:

```bash  
$ aks-engine version
Version: v0.39.1
GitCommit: 6fff62731
GitTreeState: clean
```

## Next steps

> [!div class="nextstepaction"]
> [Deploy the AKS Engine on Windows in Azure Stack](azure-stack-kubernetes-aks-engine-deploy-windows.md)  
> [Deploy the AKS Engine on Linux in Azure Stack](azure-stack-kubernetes-aks-engine-deploy-linux.md)