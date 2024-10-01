---
title: Azure Stack HCI, version 23H2 deployment overview 
description: Learn about the deployment methods for Azure Stack HCI, version 23H2.
author: alkohli
ms.topic: overview
ms.date: 05/02/2024
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# About Azure Stack HCI, version 23H2 deployment

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article is the first in the series of deployment articles that describe how to deploy Azure Stack HCI, version 23H2. This article applies to both single and multi-node deployments. The target audience for this article is IT administrators who are responsible for deploying Azure Stack HCI in their organization.

## About deployment methods

In this release, you can deploy Azure Stack HCI using one of the following methods:

- **Deploy from Azure portal**: Select this option to deploy an Azure Stack HCI cluster using Azure portal. You can choose from three deployment methods: New configuration, Template spec, and QuickStart template. The deployment flow guides you through the steps to deploy your Azure Stack HCI cluster.

    For more information, see [Deploy via Azure portal](deploy-via-portal.md).

- **Deploy from an Azure Resource Manager template**: Select this option to deploy an Azure Stack HCI cluster using an Azure Resource Manager deployment template and the corresponding parameters file. A Resource Manager template is a JSON file containing customized template expressions where you can define dynamic values and logic that determine the Azure resources to deploy.

    For more information, see [Deploy via Resource Manager template](deployment-azure-resource-manager-template.md).

- **Deploy with assistance from FastTrack for Azure**: For guided assistance with Azure Stack HCI deployment projects, consult your Microsoft account team to use the FastTrack for Azure deployment acceleration program. This program is available for select customers who deploy Azure Stack HCI. 

    For more information about this program, see https://aka.ms/fasttrackforazure

## Deployment sequence

Follow this sequence to deploy Azure Stack HCI in your environment:

| Step # | Description |
|--|--|
| [Select validated network topology](#validated-network-topologies) | Identify the network reference pattern that corresponds to the way your servers are cabled. You will define the network settings based on this topology. |
| [Read the requirements and complete the prerequisites](./deployment-prerequisites.md) | Review the requirements and complete all the prerequisites and a deployment checklist before you begin the deployment. |
| Step 1: [Prepare Active Directory](./deployment-prep-active-directory.md) | Prepare your Active Directory (AD) environment for Azure Stack HCI deployment. |
| Step 2: [Download Azure Stack HCI, version 23H2 OS](./download-azure-stack-hci-23h2-software.md) | Download Azure Stack HCI, version 23H2 OS ISO from Azure portal |
| Step 3: [Install OS](./deployment-install-os.md) | Install Azure Stack HCI operating system locally on each server in your cluster. |
| (Optional) [Configure the proxy](../manage/configure-proxy-settings.md) | Optionally configure proxy settings for Azure Stack HCI if your network uses a proxy server for internet access. |
| Step 4: [Register servers with Arc and assign permissions](./deployment-arc-register-server-permissions.md) | Install and run the Azure Arc registration script on each of the servers that you intend to cluster.<br> Assign required permissions for the deployment. |
| Step 5A: [Deploy the cluster via Azure portal](./deploy-via-portal.md) | Use the Azure portal to select Arc servers to create Azure Stack HCI cluster. |
| Step 5B: [Deploy the cluster via Resource Manager template](deployment-azure-resource-manager-template.md) | Use the Resource Manager deployment template and the parameter file to deploy an Azure Stack HCI cluster. |

## Validated network topologies

When you deploy Azure Stack HCI from Azure portal, the network configuration options vary depending on the number of servers and the type of storage connectivity. Azure portal guides you through the supported options for each configuration.

Before starting the deployment, we recommend you check the following table that shows the supported and available options.

#### Supported network topologies

|Network topology|Azure portal|Resource Manager template|
|---|---|---|
|One node - no switch for storage|By default|Supported|
|One node - with network switch for storage|Not applicable|Supported|
|Two nodes - no switch for storage|Supported|Supported|
|Two nodes - with network switch for storage|Supported|Supported|
|Three nodes - with network switch for storage|Supported|Supported|
|Three nodes - with no network switch for storage|Not supported|Supported|
|Four to 16 nodes - with no network switch for storage|Not supported|Not supported|
|Four to 16 nodes - with network switch for storage|Supported|Supported|

The two storage network options are:

- **No switch for storage**. When you select this option, your Azure Stack HCI system uses crossover network cables directly connected to your network interfaces for storage communication. The current supported switchless deployments from the portal are one or two nodes.

- **Network switch for storage**. When you select this option, your Azure Stack HCI system uses network switches connected to your network interfaces for storage communication. You can deploy up to 16 nodes using this configuration.

You can then select the [network reference pattern](../plan/choose-network-pattern.md) corresponding to a validated network topology that you intend to deploy.

## Next steps

- Read the [prerequisites](./deployment-prerequisites.md) for Azure Stack HCI.
