---
title: Manage Azure Local Small Form Factor Network Interfaces (preview)
description: Learn how to manage network interface resources in Azure Local small form factor (preview).
author: sipastak
ms.topic: how-to
ms.date: 08/17/2026
ms.author: sipastak
ms.service: azure-local
ms.subservice: small-form-factor
---

# Network interface resource management for small form factor deployments of Azure Local (preview)

This article explains how to manage the network interface resources on your Azure Local small form factor device. Use this interface to change the networking configuration for the primary interface and configure additional interfaces for multihomed networking. 

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Prerequisites

- A completed small form factor deployment of Azure Local.
- Network connectivity between the Azure public cloud and the Azure Local deployment.
- Network parameters to set on the Ethernet networking interface (DHCP or IP address, netmask, gateway, and DNS servers).

    > [!NOTE]
    > If network access to the public cloud is interrupted, you must use the Configurator app to restore management connectivity.

## Network interfaces

Small form factor deployments enable you to manage your Ethernet network interfaces from the Azure portal.  

You can find the Ethernet network adapter management under **Resources** in the left navigation list for your Azure Local provisioned machine. 

### Modify network interfaces

When you view the network interfaces, select an interface and select **Edit** in the Azure portal to modify the network parameters. 

Azure Local supports two modes for Ethernet interfaces: DHCP and static. 

> [!NOTE]
> After a networking configuration change, it can take up to five minutes to refresh the portal view for 2607 preview. 

#### DHCP

When you use DHCP:
- The DHCP service supplies the IP address information, so you can't modify it. 
- You can change the network adapter to use static assignment. 
- You can provide up to 16 DNS servers to supplement or override the addresses that DHCP provides. 

#### Static
When you use static IP addressing, you must provide the netmask for your IP network as well as any required gateway and DNS settings. 

|Parameter       | Description                                                                                                         |
| -------------- | ------------------------------------------------------------------------------------------------------------------- |
|IP Address      | The IP address to assign to this host                                                                              |
|Netmask         | The mask applied to the IP address segment for this host to define the network size and broadcast domain           |
|Default Gateway | The IP address of the host that serves as the gateway to external networks. This address is usually a router address|
|DNS             | Domain Name Servers (up to 16) to use for resolving hostnames to IP addresses for this host                         |

### Configuration change detection

Azure Local tracks the last known good configuration of your network interfaces and compares it to the current running configuration on your edge device. 
If it detects a discrepancy, the Azure portal shows an alert that your interface is out of sync. 

You must decide if this change is expected and wanted or if it's a deviation that you must correct by updating the edge device with the last-known good values. 
An example of a desired change that is flagged a deviation is an Azure Local deployment that is located at a site where the local network has changed. An admin might use the local shell or Configurator App to update the deployed machine's IP addresses to restore connectivity to the cloud and then accept that change as permanent by using the Azure portal.  

> [!NOTE]
> Azure Local considers the portal configuration as authoritative. You can make local changes by using the Configurator App or Linux command line with proper permissions.

### Management interface protection

Azure Local notes the interfaces that can be the management link back to Azure. When you make a networking configuration change, the Azure Local system ensures that the networking change doesn't disconnect the device from the Azure Public Cloud. This disconnection would prevent further management of the provisioned device. If a networking change disconnects from the Azure Public Cloud, Azure Local restores the prior configuration.
