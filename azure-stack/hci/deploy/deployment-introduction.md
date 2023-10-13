---
title: Azure Stack HCI, version 23H2 deployment overview (preview)
description: Learn about the deployment methods for Azure Stack HCI, version 23H2 (preview).
author: alkohli
ms.topic: overview
ms.date: 10/13/2023
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Azure Stack HCI, version 23H2 deployment overview (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article is the first in the series of deployment articles that describe how to deploy Azure Stack HCI, version 23H2.

You can deploy Azure Stack HCI using a new or existing *config* file interactively or via PowerShell.

[!INCLUDE [important](../../includes/hci-preview.md)]

## About deployment methods

You can deploy Azure Stack HCI, version 23H2 using one of the following methods from Azure portal:

- **New configuration**: Select this option if this is the first time you deploy an Azure Stack HCI cluster using Azure portal and you don’t have an existing template. Going through the deployment flow steps you define all the parameters manually.

- **Template spec**: Select this option if you already deployed an Azure Stack HCI cluster and you stored a template in your Subscription Library. Once the template is loaded, the parameters are automatically populated with the template values. You are required to create a new Azure Storage Account to store the Cloud Witness Secrets.

- **QuickStart template**: Select this option if you already deployed an Azure Stack HCI cluster and you stored a template in the QuickStart library. Once the template is loaded, the parameters are automatically populated. You are required to create a new Azure Storage Account to store the Cloud Witness Secrets.


## Deployment sequence

Follow this process sequence to deploy Azure Stack HCI in your environment:

- Select one of the [validated network topologies](#validated-network-topologies) to deploy.
- Read the [prerequisites](../index.yml) for Azure Stack HCI.
- Follow the [deployment checklist](deployment-checklist.md).
- Prepare your [Active Directory](deployment-prep-active-directory.md) environment.
- [Install Azure Stack HCI, version 22H2](deployment-install-os.md) on each server.
- Install and run the deployment tool interactively with a [new configuration file](../index.yml) or using an [existing configuration file](../index.yml).
- If preferred, you can [deploy using PowerShell](../index.yml).
- After deployment, [validate deployment](../index.yml).
- If needed, [troubleshoot deployment](../index.yml).

## Validated network topologies

When deploying Azure Stack HCI Cluster from Azure Portal, the network configuration options will vary depending on the number of nodes and the type of storage connectivity. Azure portal guides you through the supported options for each configuration. 

Before starting the network configuration for your cluster, we recommend you check the following table showing the supported and available options.

|Topology|Azure Portal 23H2<br>Public Preview|ARM/CU Template<br>23H2 Public Preview|
|---|---|---|
|1 node - no switch for storage|By default|Supported|
1 node - with network switch for storage|Not applicable|Supported|
2 nodes - no switch for storage|Supported|Supported|
2 nodes - with network switch for storage|Supported|Supported|
3 nodes - with network switch for storage|Supported|Supported|
4 to 16 nodes - with network switch for storage|Supported|Supported|

**No switch for storage**. When selecting this option, your Azure Stack HCI cluster uses crossover network cables directly connected to your network interfaces for storage communication. The current supported switchless deployments from the portal are one or two nodes. Switchless deployments with 3 or more nodes are only possible using templates and are in Private Preview.

**Network switch for storage**. When selecting this option, your Azure HCI cluster uses network switches connected to your network interfaces for storage communication. You can deploy up to 16 nodes using this configuration.

You next select the [network reference pattern](https://learn.microsoft.com/en-us/azure-stack/hci/plan/choose-network-pattern).

## Next steps

- Read the [prerequisites](../index.yml) for Azure Stack HCI.
