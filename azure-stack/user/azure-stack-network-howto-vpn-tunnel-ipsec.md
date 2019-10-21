---
title: How to create a VPN Tunnel using IPSEC | Microsoft Docs
description: Learn how to create a VPN Tunnel using IPSEC.
services: azure-stack
author: mattbriggs

ms.service: azure-stack
ms.topic: how-to
ms.date: 09/19/2019
ms.author: mabrigg
ms.reviewer: sijuman
ms.lastreviewed: 09/19/2019

# keywords:  X
# Intent: As an Azure Stack Operator, I want < what? > so that < why? >
---

# How to create a VPN Tunnel using IPSEC

*Applies to: Azure Stack integrated systems and Azure Stack Development Kit*

You can use the Azure Stack Resource Manager template in this solution to connect two Azure Stack VNets within the same Azure Stack environment. You [can't connect Azure Stack VNets](https://docs.microsoft.com/azure-stack/user/azure-stack-network-differences) using the built-in Virtual Network Gateway. For now, you must use network virtual appliances (NVA)s to create a VPN tunnel between two Azure Stack VNets. The solution template deploys two Windows Server 2016 VMs with RRAS installed. The solution configures the two RRAS servers to use a S2SVPN IKEv2 tunnel between the two VNETs. The appropriate NSG and UDR rules are created to allow routing between the subnets on each VNET designated as **internal** 

This solution is the foundation that will allow VPN Tunnels to be created not only within an Azure Stack instance but also between Azure Stack Instances and to other resources such as on-premises networks with the use of the Windows RRAS S2S VPN Tunnels.

![alt text](./media/azure-stack-network-howto-vpn-tunnel-ipsec/overview.png)

## Requirements

- ASDK or Azure Stack Integrated System with latest updates applied. 
- Required Azure Stack Marketplace items:
    -  Windows Server 2016 Datacenter or Windows Server 2019 Datacenter (latest build recommended)
	-  Custom Script Extension

## Things to consider

- A Network Security Group is applied to the template Tunnel Subnet.  It is recommended to secure the internal subnet in each VNet with an additional NSG.
- An RDP Deny rule is applied to the Tunnel NSG and will need to be set to allow if you intend to access the VMs via the Public IP address
- This solution does not take into account DNS resolution
- The combination of VNet name and vmName must be fewer than 15 characters
- This template is designed to have the VNet names customized for VNet1 and VNet2
- This template is using BYOL windows
- When deleting the resource group, currently on (1907) you have to manually detach the NSGs from the tunnel subnet to ensure the delete resource group completes
- This template is using a DS3v2 vm.  The RRAS service installs and run Windows internal SQL Server.  This can cause memory issues if your VM size is too small.  Validate performance before reducing the VM size.
- This is not a highly available solution.  If you require a more HA style solution you can add a second VM, you would have to manually Change the route in the route table to the internal IP of the secondary interface.  You would also need to configure the multiple Tunnels to cross connect.

## Optional

- You can use your own Blob storage account and SAS token using the _artifactsLocation and _artifactsLocationSasToken parameters
- There are two outputs on this template INTERNALSUBNETREFVNET1 and INTERNALSUBNETREFVNET2, which is the Resource IDs for the internal subnets, if you want to use this in a pipeline style deployment pattern.

This template provides default values for VNet naming and IP addressing.  It requires a password for the administrator (rrasadmin) and also offers the ability to use your own storage blob with SAS token.  Be careful to keep these values within legal ranges as deployment may fail.  The powershell DSC package is executed on each RRAS VM and installing routing and all required dependent services and features.  This DSC can be customized further if needed.  The custom script extension run the following script and Add-Site2SiteIKE.ps1 configures the VPNS2S tunnel between the two RRAS servers with a shared key.  You can view the detailed output from the custom script extension to see the results of the VPN tunnel configuration

![alt text](./media/azure-stack-network-howto-vpn-tunnel-ipsec/s2svpntunnel.png)

## Next steps

[Differences and considerations for Azure Stack networking](azure-stack-network-differences.md)  
[How to set up a multiple site-to-site VPN tunnel](azure-stack-network-howto-vpn-tunnel.md)  
[How to create a VPN Tunnel using GRE](azure-stack-network-howto-vpn-tunnel-gre.md)