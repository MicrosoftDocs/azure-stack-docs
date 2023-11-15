---
title: Set up prerequisites for AKS engine on Azure Stack Hub 
description: Establish the requirements for running AKS engine on your Azure Stack Hub.
author: sethmanheim

ms.topic: article
ms.date: 12/21/2022
ms.author: sethm
ms.reviewer: waltero
ms.lastreviewed: 04/27/2022

# Intent: Notdone: As a < type of user >, I want < what? > so that < why? >
# Keyword: Notdone: keyword noun phrase

---

# Set up the prerequisites for AKS engine on Azure Stack Hub

You can install AKS engine on a virtual machines (VMs) in your environment, or any client machine with access to your Azure Stack Hub Resource Manager endpoint. Have the following things in place before you run the engine: an AKS Base Ubuntu server and Linux custom script extension available in your subscription, a service principal identity that has been assigned to a contributor role, and a private/public key pair for SSH access to your Ubuntu server. In addition, if you're using the Azure Stack Development Kit, you need to have your machine trust the appropriate certificates.

If you have your prerequisites, you can begin to [define your cluster](azure-stack-kubernetes-aks-engine-deploy-cluster.md).

If you're the cloud operator for Azure Stack Hub and would like to offer AKS engine, follow the instructions in [Add AKS engine to the Azure Stack Hub Marketplace](../operator/azure-stack-aks-engine.md).

## Prerequisites for AKS engine

To use AKS engine, you need to have the following resources available. Keep in mind that AKS engine is meant to be used by tenants of Azure Stack Hub to deploy Kubernetes clusters into their tenant subscription. The only part where involvement of the Azure Stack Hub operator may be required is for downloading Marketplace items and the creation of a service principal identity. You can find details in the following table.

Your cloud operator will need to have the following items in place.

| Prerequisite | Description | Required | Instructions |
| --- | --- | --- | --- |
| Azure Stack Hub 1910 or greater | AKS engine requires Azure Stack Hub 1910 or greater. | Required | If you're unsure of your version of Azure Stack Hub, contact your cloud operator. |
| Linux custom script extension | Linux Custom Script extension 2.0<br>Offer: Custom Script for Linux 2.0<br>Version: 2.0.6 (or latest version)<br>Publisher: Microsoft Corp | Required | If you don't have this item in your subscription, contact your cloud operator. |
| AKS Base images | AKS Base Ubuntu and Windows Image<br>See more information on the version dependency see [Matching engine to base image version](#matching-engine-to-base-image-version) | Required | If you don't have this item in your subscription, contact your cloud operator.<br> If you are the cloud operator for Azure Stack Hub and would like to offer AKS engine, follow the instructions at [Add AKS engine to the Azure Stack Hub Marketplace](../operator/azure-stack-aks-engine.md). |
| Service principal identity (SPN) |  An application that needs to deploy or configure resources through Azure Resource Manager, must be represented by a service principal. | Required | You may need to contact your Azure Stack Hub cloud operator to get an SPN and a current secret.<br>If a Microsoft Entra service principal identity is used, internet access is required from the VMs in the Kubernetes cluster so that the service principal can authenticate with Microsoft Entra ID. You also need an active secret. When your secret expires, your cluster **will not** be functional. If your environment doesn't have internet access, the Kubernetes cluster **will not** be functional.<br>For instructions see [Use an app identity to access resources](../operator/give-app-access-to-resources.md) |
| (SPN) assigned **Contributor** role | To allow an application to access resources in your subscription using its service principal, you must assign the service principal to a role for a specific resource. | Required | For instructions, see [Assign a role](../operator/give-app-access-to-resources.md#assign-a-role) |


You can set the following items.

| Prerequisite | Description | Required | Instructions |
| --- | --- | --- | --- |
| Azure Stack Hub subscription | You access offers in your Azure Stack Hub through subscriptions. The offer contains the services that are available to you. | Required | To be able to deploy any tenant workloads in Azure Stack Hub, you need to first get an [Azure Stack Hub Subscription](./azure-stack-subscribe-services.md). |
| Resource group | A resource group is a container that holds related resources for an Azure solution. If you don't specify an existing resource group the tool will create one for you. | Optional | [Manage Azure Resource Manager resource groups by using the Azure portal](/azure/azure-resource-manager/manage-resource-groups-portal) |
| Private Public key | To use an open SSH connection from your development machine to the server VM in your Azure Stack Hub instance that hosts your web app, you need to create a Secure Shell (SSH) public and private key pair. | Required | For instructions on generating a key, see [SSH Key Generation](./azure-stack-dev-start-howto-ssh-public-key.md).|


> [!Note]  
> You can also create the prerequisites for AKS engine with [Azure CLI for Azure Stack Hub](./azure-stack-version-profiles-azurecli2.md) or [Azure Stack Hub PowerShell](../operator/powershell-install-az-module.md).

## Matching engine to base image version

AKS engine deploys a customized Ubuntu Server OS to each cluster node image, the **AKS Base Ubuntu and Windows Image Distro**. Any AKS engine version is dependent on a specific image version made available in your Azure Stack Hub by your Azure Stack Hub operator. You can find a table listing the AKS engine versions and corresponding supported Kubernetes versions at [Supported Kubernetes Versions](kubernetes-aks-engine-release-notes.md#aks-engine-and-azure-stack-version-mapping). For example, AKS engine version `v0.55.0` depends on version `2020.08.24` of the AKS Base Ubuntu and Windows Image Distro. Ask your Azure Stack Hub operator to download the specific image version from the Azure Marketplace to the Azure Stack Hub Marketplace.

You'll trigger an error if the image isn't available in your Azure Stack Hub Marketplace. For example, if you're currently using AKS engine version v0.55.0 and AKS Base Ubuntu, and Windows Image Distro version `2020.08.24` isn't available, you'll see the following error when running AKS engine: 

```Text  
The platform image 'microsoft-aks:aks:aks-ubuntu-1604-202003:2020.08.24' is not available. 
Verify that all fields in the storage profile are correct.
```

You can check the current version of your AKS engine by running the following command:

> [!Note]
> For AKSe version 0.75.3 and above, the command to check the current version of your AKS engine is `aks-engine-azurestack version`.

```bash  
$ aks-engine version
Version: v0.55.0
GitCommit: 44a35c00c
GitTreeState: clean
```

## Next steps

> [!div class="nextstepaction"]
> [Deploy AKS engine on Windows in Azure Stack Hub](azure-stack-kubernetes-aks-engine-deploy-windows.md)  
> [Deploy AKS engine on Linux in Azure Stack Hub](azure-stack-kubernetes-aks-engine-deploy-linux.md)
