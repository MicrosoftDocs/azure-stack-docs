---
title: Offer a network solution in Azure Stack Hub with Fortinet FortiGate | Microsoft Docs
description: Learn how enable network solution in Azure Stack Hub with Fortinet FortiGate
services: azure-stack
author: mattbriggs

ms.service: azure-stack
ms.topic: how-to
ms.date: 1/22/2020
ms.author: mabrigg
ms.reviewer: sijuman
ms.lastreviewed: 09/30/2019

# keywords:  X
# Intent: As an Azure Stack Hub Operator, I want < what? > so that < why? >
---

# Offer a network solution in Azure Stack Hub with Fortinet FortiGate

You can add FortiGate Next-Generation Firewall to your Azure Stack Hub Marketplace. FortiGate enables your users to create network solutions such as virtual private network (VPN) to Azure Stack Hub and VNET peering. A network virtual appliance (NVA) controls the flow of network traffic from a perimeter network to other networks or subnets. 

For more information about FortiGate in the Azure Marketplace, see [Fortinet FortiGate Next-Generation Firewall Single VM Solution](https://azuremarketplace.microsoft.com/marketplace/apps/fortinet.fortinet-FortiGate-singlevm).

## Download the Required Azure Stack Hub Marketplace items

1.  Open the Azure Stack Hub administrator portal.

2.  Select **Marketplace management** and select **Add from Azure**.

3. Type `Forti` in the search box, and double-click > select **Download** to get the latest available versions of the following items: 
    - Fortinet FortiGate-VM For Azure BYOL
    - FortiGate NGFW - Single VM Deployment (BYOL)

    ![Azure Stack Hub FortiGate Fortinet](./media/azure-stack-network-solutions-enable/azure-stack-marketplace-FortiGate-fortinet.png)

2.  Wait until your Marketplace items have a status of **Downloaded**. The items may take several minutes to download.

    ![Azure Stack Hub FortiGate Fortinet](./media/azure-stack-network-solutions-enable/image4.png)

## Next steps

[Setup VPN for Azure Stack Hub using FortiGate NVA](../user/azure-stack-network-howto-vnet-to-onprem.md)  
[How to connect two VNETs through peering](../user/azure-stack-network-howto-vnet-to-vnet.md)  
[How to establish a VNET to VNET connection with Fortinet FortiGate NVA](../user/azure-stack-network-howto-vnet-to-vnet-stacks.md)  
