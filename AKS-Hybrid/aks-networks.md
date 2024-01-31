---
title: Create logical networks for Kubernetes clusters on Azure Stack HCI 23H2
description: Learn how to create Arc-enabled logical networks for AKS.
ms.topic: how-to
author: sethmanheim
ms.date: 01/31/2024
ms.author: sethm 
ms.lastreviewed: 01/31/2024
ms.reviewer: abha
---

# Create logical networks for Kubernetes clusters on Azure Stack HCI 23H2

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

After you install and configure Azure Stack HCI 23H2, you must create Arc VM logical networks. AKS on Azure Stack HCI uses these logical networks to provide IP addresses to the underlying VMs of the AKS clusters. While both DHCP and static IP-based networking are supported, we strongly recommend using static IP addresses for production deployments.

## Before you begin

Before you begin, make sure you have the following prerequisites:

- Install and configure Azure Stack HCI 23H2. Make sure you have the custom location Azure Resource Manager ID, as this ID is a required parameter for creating a logical network.
- Download the **stack-hci-vm** Az CLI extension to create the logical network.
- Make sure that the network you create contains enough usable IP addresses to avoid IP address exhaustion. IP address exhaustion can lead to Kubernetes cluster deployment failures. For more information, see [Networking concepts in AKS on Azure Stack HCI 23H2](aks-hci-network-system-requirements.md).

## Create Arc VM logical networks

Follow this article to [create Arc VM logical networks](/azure-stack/hci/manage/create-logical-networks?tabs=azureportal#create-the-logical-network). Adding IP pools is a required parameter for using Arc VM logical networks for your Kubernetes clusters.

## Next steps

[Create and manage Kubernetes clusters on-premises using Azure CLI](aks-create-clusters-cli.md)
