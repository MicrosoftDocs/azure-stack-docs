---
title: Azure Local, version 23H2 deployment overview 
description: Learn about the deployment methods for Azure Local, version 23H2.
author: alkohli
ms.topic: overview
ms.date: 10/02/2025
ms.author: alkohli
ms.reviewer: alkohli
ms.service: azure-local
---

# About Azure Local deployment

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article is the first in the series of deployment articles that describe how to deploy Azure Local. This article applies to both single and multi-node deployments. The target audience for this article is IT administrators who are responsible for deploying Azure Local in their organization.

## About deployment methods

In this release, you can deploy Azure Local using one of the following methods:

- **Deploy from Azure portal**: Select this option to deploy an Azure Local instance using Azure portal. You can choose from three deployment methods: New configuration, Template spec, and QuickStart template. The deployment flow guides you through the steps to deploy your Azure Local instance.

    For more information, see [Deploy via Azure portal](deploy-via-portal.md).

- **Deploy from an Azure Resource Manager template**: Select this option to deploy an Azure Local instance using an Azure Resource Manager deployment template and the corresponding parameters file. A Resource Manager template is a JSON file containing customized template expressions where you can define dynamic values and logic that determine the Azure resources to deploy.

    For more information, see [Deploy via Resource Manager template](deployment-azure-resource-manager-template.md).

## Deployment sequence

Follow this sequence to deploy Azure Local in your environment:

| Step # | Description |
|--|--|
| [Select validated network topology](#validated-network-topologies) | Identify the network reference pattern that corresponds to the way your machines are cabled. You will define the network settings based on this topology. |
| [Read the requirements and complete the prerequisites](./deployment-prerequisites.md) | Review the requirements and complete all the prerequisites and a deployment checklist before you begin the deployment. |
| Step 1: [Prepare Active Directory](./deployment-prep-active-directory.md) | Prepare your Active Directory (AD) environment for Azure Local deployment. |
| Step 2: [Download the operating system](./download-23h2-software.md) | Download Azure Stack HCI Operating System from the Azure portal. |
| Step 3: [Install OS](./deployment-install-os.md) | Install Azure Stack HCI OS locally on each machine in your system. |
| (Optional) [Configure the proxy](../manage/configure-proxy-settings.md) | Optionally configure proxy settings for Azure Local if your network uses a proxy server for internet access. |
| Step 4: [Set up subscription permissions](./deployment-arc-register-server-permissions.md) | Assign required permissions for the deployment. |
| Step 5A: [Register Azure Local machines with Azure Arc, without using the Arc gateway](./deployment-without-azure-arc-gateway.md) | Depending on whether your deployment environment uses a proxy or not, register your Azure Local machines directly with Azure Arc, without using the Arc gateway. |
| Step 5B: [Register Azure Local machines with Azure Arc using Arc gateway](./deployment-with-azure-arc-gateway.md) | Depending on whether your deployment environment uses a proxy or not, register your Azure Local machines with Azure Arc through the centralized Arc gateway. |
| Step 6A: [Deploy the system via Azure portal](./deploy-via-portal.md) | Use the Azure portal to select Arc servers to deploy an Azure Local instance. |
| Step 6B: [Deploy the system via Resource Manager template](deployment-azure-resource-manager-template.md) | Use the Azure Resource Manager deployment template and the parameter file to deploy an Azure Local instance. |

> [!NOTE]
> As part of Azure Local, an Arc resource bridge appliance VM is automatically deployed during setup. The resource bridge is what enables Azure Arc capabilities and hybrid connectivity to Azure.  

## Validated network topologies

When you deploy Azure Local from Azure portal, the network configuration options vary depending on the number of machines and the type of storage connectivity. Azure portal guides you through the supported options for each configuration.

Before starting the deployment, we recommend you check the following table that shows the supported and available options.

#### Supported network topologies

|Network topology|Azure portal|Resource Manager template|
|---|---|---|
|One machine - no switch for storage|By default|Supported|
|One machine - with network switch for storage|Not applicable|Supported|
|Two machines - no switch for storage|Supported|Supported|
|Two machines - with network switch for storage|Supported|Supported|
|Three machines - with network switch for storage|Supported|Supported|
|Three machines - with no network switch for storage|Not supported|Supported|
|Four to 16 machines - with no network switch for storage|Not supported|Not supported|
|Four to 16 machines - with network switch for storage|Supported|Supported|

The two storage network options are:

- **No switch for storage**. When you select this option, your Azure Local system uses crossover network cables directly connected to your network interfaces for storage communication. The current supported switchless deployments from the portal are one or two machines.

- **Network switch for storage**. When you select this option, your Azure Local system uses network switches connected to your network interfaces for storage communication. You can deploy up to 16 machines using this configuration.

You can then select the [network reference pattern](../plan/choose-network-pattern.md) corresponding to a validated network topology that you intend to deploy.

## Next steps

- Read the [prerequisites](./deployment-prerequisites.md) for Azure Local.
