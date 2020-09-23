---
title: Add Fortinet FortiGate to Azure Stack Hub Marketplace
description: Learn how to add Fortinet FortiGate to your Azure Stack Hub Marketplace, enabling users to create network solutions.
author: mattbriggs
ms.topic: how-to
ms.date: 5/27/2020
ms.author: mabrigg
ms.reviewer: sijuman
ms.lastreviewed: 09/30/2019

# Intent: As an Azure Stack Hub operator, I want to add Fortinet FortiGate to Azure Stack Hub Marketplace so my users can create network solutions.
# Keyword: fortinet fortigate azure stack hub network solutions

---

# Offer a network solution in Azure Stack Hub with Fortinet FortiGate

You can add FortiGate Next-Generation Firewall (NGFW) to your Azure Stack Hub Marketplace. FortiGate lets your users create network solutions such as a virtual private network (VPN) to Azure Stack Hub and VNET peering. A network virtual appliance (NVA) controls the flow of network traffic from a perimeter network to other networks or subnets.

For more information on FortiGate in Azure Marketplace, see [Fortinet FortiGate Next-Generation Firewall Single VM Solution](https://azuremarketplace.microsoft.com/marketplace/apps/fortinet.fortinet-FortiGate-singlevm).

## Download the required Azure Stack Hub Marketplace items

1. Open the Azure Stack Hub administrator portal.

2. Select **Marketplace management** and select **Add from Azure**.

3. Type `Forti` in the search box, and double-click > select **Download** to get the latest available versions of the following items:
    - Fortinet FortiGate-VM For Azure BYOL
    - FortiGate NGFW - Single VM Deployment (BYOL)

    ![Screenshot that shows the available downloaded items.](./media/azure-stack-network-solutions-enable/azure-stack-marketplace-FortiGate-fortinet.png)

4. Wait until your marketplace items have a status of **Downloaded**. The items may take several minutes to download.

    ![Azure Stack Hub FortiGate Fortinet](./media/azure-stack-network-solutions-enable/image4.png)

## Next steps

- [Setup VPN for Azure Stack Hub using FortiGate NVA](../user/azure-stack-network-howto-vnet-to-onprem.md)  
- [How to connect two VNETs through peering](../user/azure-stack-network-howto-vnet-to-vnet.md)  
- [How to establish a VNET to VNET connection with Fortinet FortiGate NVA](../user/azure-stack-network-howto-vnet-to-vnet-stacks.md)  
