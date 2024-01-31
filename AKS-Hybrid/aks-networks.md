---
title: Create networks for AKS
description: Learn how to create Arc-enabled networks for AKS
ms.topic: how-to
author: sethmanheim
ms.date: 12/11/2023
ms.author: sethm 
ms.lastreviewed: 11/27/2023
ms.reviewer: abha
---

# Create logical networks for AKS clusters on Azure Stack HCI 23H2
[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

After you install and configure Azure Stack HCI 23H2, you need to create Arc VM logical networks. AKS on Azure Stack HCI uses these logical networks to provide IP addresses to the underlying VMs of the AKS clusters. While both DHCP and static IP-based networking is supported, we highly recommend using static IP addresses for production deployments.

## Before you begin
Before you begin, make sure you have the following:
- Install and configure Azure Stack HCI 23H2. Make sure you have the custom location ARM ID, as this is a required parameter for creating a logical network.
- Download the **stack-hci-vm** Az CLI extension to create the logical network.
- Make sure that the network you create contains enough usable IP addresses to avoid IP address exhaustion. IP address exhaustion can lead to Kubernetes cluster deployment failures. For more information, read [networking concepts in AKS on Azure Stack HCI 23H2](/aks/hybrid/aks-hci-network-system-requirements).

## Create Arc VM logical networks
Follow this document for [creating Arc VM logical networks](/azure-stack/hci/manage/create-logical-networks?tabs=azureportal#create-the-logical-network). Note that adding IP pools is a required parameter for using Arc VM logical networks for your AKS clusters.

## Next steps
[Create and manage Kubernetes clusters on-premises using Azure CLI](aks-create-clusters-cli.md)
