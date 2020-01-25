---
title: Set up the prerequisites for the AKS engine on Azure Stack Hub | Microsoft Docs
description: Establish the requirements for running the ASK Engine on your Azure Stack Hub.
author: mattbriggs

ms.service: azure-stack
ms.topic: article
ms.date: 1/10/2020
ms.author: mabrigg
ms.reviewer: waltero
ms.lastreviewed: 1/10/2020

---

# Set up the prerequisites for the AKS engine on Azure Stack Hub

You can install the AKS engine on a VM in your environment, or any client machine with access to your Azure Stack Hub Resource Manager endpoint. You will need the following things in place before you run the engine: an AKS Base Ubuntu server and Linux custom script extension available in your subscription, a service principal identity that has been assigned to a contributor role, and a private/public key pair for SSH access to your Ubuntu server. In addition, if you are using the Azure Stack Development Kit, you will need to have your machine trust the appropriate certificates.

If you have your prerequisites, you can begin to [define your cluster](azure-stack-kubernetes-aks-engine-deploy-cluster.md).

If you are the cloud operator for Azure Stack Hub and would like to offer the AKS engine, follow the instructions at [Add the AKS engine to the Azure Stack Hub Marketplace](../operator/azure-stack-aks-engine.md).

## Prerequisites for the AKS engine

To use the AKS engine, you need to have the following resources available. Keep in mind that the AKS engine is meant to be used by tenants of Azure Stack Hub to deploy Kubernetes clusters into their tenant subscription. The only part where involvement of the Azure Stack Hub operator may be required is for downloading Marketplace items and the creation of a service principal identity. You can find details in the following table.

Your cloud operator will need to have the following items in place.

| Prerequisite | Description | Required | Instructions |
| --- | --- | --- | --- | --- |
| Linux custom script extension | Linux Custom Script extension 2.0<br>Offer: Custom Script for Linux 2.0<br>Version: 2.0.6 (or latest version)<br>Publisher: Microsoft Corp | Required | If you do not have this item in your subscription, contact your cloud operator. |
| AKS Base Ubuntu Image | AKS Base Image<br>Offer: aks<br> 2019.10.24 (or newer version)<br>Publisher: microsoft-aks<br>SKU: aks-ubuntu-1604-201910 | Required | If you don't have this item in your subscription, contact your cloud operator. See more information on the version dependency see [Matching engine to base image version](#matching-engine-to-base-image-version).<br> If you are the cloud operator for Azure Stack Hub and would like to offer the AKS engine, follow the instructions at [Add the AKS engine to the Azure Stack Hub Marketplace](../operator/azure-stack-aks-engine.md). |
| Service principal identity (SPN) |  An application that needs to deploy or configure resources through Azure Resource Manager, must be represented by a service principal. | Required | You may need to contact your Azure Stack Hub operator for this item.  For instructions see [Use an app identity to access resources](https://docs.microsoft.com/azure-stack/operator/azure-stack-create-service-principals) |
| (SPN) assigned **Contributor** role | To allow an application to access resources in your subscription using its service principal, you must assign the service principal to a role for a specific resource. | Required | For instructions, see [Assign a role](https://docs.microsoft.com/azure-stack/operator/azure-stack-create-service-principals#assign-a-role) |

You can set the following items.

| Prerequisite | Description | Required | Instructions |
| --- | --- | --- | --- |
| Azure Stack Hub subscription | You access offers in your Azure Stack Hub through subscriptions. The offer contains the services that are available to you. | Required | To be able to deploy any tenant workloads in Azure Stack Hub, you need to first get an [Azure Stack Hub Subscription](https://docs.microsoft.com/azure-stack/user/azure-stack-subscribe-services). |
| Resource group | A resource group is a container that holds related resources for an Azure solution. If you don't specify an existing resource group the tool will create one for you. | Optional | [Manage Azure Resource Manager resource groups by using the Azure portal](https://docs.microsoft.com/azure/azure-resource-manager/manage-resource-groups-portal) |
| Private Public key | To use an open SSH connection from your development machine to the server VM in your Azure Stack Hub instance that hosts your web app, you need to create a Secure Shell (SSH) public and private key pair. | Required | For instructions on generating a key, see [SSH Key Generation](https://docs.microsoft.com/azure-stack/user/azure-stack-dev-start-howto-ssh-public-key).|


> [!Note]  
> You can also create the prerequisites for the AKS engine with [Azure CLI for Azure Stack Hub](https://docs.microsoft.com/azure-stack/user/azure-stack-version-profiles-azurecli2) or [Azure Stack Hub PowerShell](https://docs.microsoft.com/azure-stack/operator/azure-stack-powershell-install).

## Matching engine to base image version

The AKS engine uses a built image, the **AKS Base Image**. Any AKS engine version is dependent on a specific image version made available in your Azure Stack Hub by your Azure Stack Hub operator. You can find a table listing the AKS engine versions and corresponding supported Kubernetes versions at [Supported Kubernetes Versions](https://github.com/Azure/aks-engine/blob/master/docs/topics/azure-stack.md#supported-kubernetes-versions). For example, AKS engine version `v0.43.0` depends on version `2019.10.24` of the AKS Base Image. Ask your Azure Stack Hub operator to download the specific image version from the Azure Marketplace to the Azure Stack Hub Marketplace.

You will trigger and error if the image is not available in your Azure Stack Hub Marketplace. For example, if you're currently using AKS engine version v0.43.0 and AKS Base image version `2019.10.24` isn't available, you will see the following error when running the AKS engine: 

```Text  
The platform image 'microsoft-aks:aks:aks-ubuntu-1604-201908:2019.08.09' is not available. 
Verify that all fields in the storage profile are correct.
```

You can check the current version of your AKS engine by running the following command:

```bash  
$ aks-engine version
Version: v0.39.1
GitCommit: 6fff62731
GitTreeState: clean
```

## Next steps

> [!div class="nextstepaction"]
> [Deploy the AKS engine on Windows in Azure Stack Hub](azure-stack-kubernetes-aks-engine-deploy-windows.md)  
> [Deploy the AKS engine on Linux in Azure Stack Hub](azure-stack-kubernetes-aks-engine-deploy-linux.md)