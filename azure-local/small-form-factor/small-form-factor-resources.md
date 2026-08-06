---
title: Manage Azure Local Small Form Factor Resources (preview)
description: Learn how to manage device resources in Azure Local small form factor (preview).
author: sipastak
ms.topic: how-to
ms.date: 08/06/2026
ms.author: sipastak
ms.service: azure-local
ms.subservice: small-form-factor
---

# Resource Management

This page will explain how to manage the internal resources on your Azure Local small form factor device.
This interface allows you to change the networking configuration for the primary interface as well as configure additional interfaces for multi-homed networking. 

## Prerequisites

- A completed small form factor deployment of Azure Local.
- Network access from the Azure Public Cloud to the Azure Local deployment.
- Network parameters to be set on the ethernet networking interface. (DHCP or IP Address, Netmask, Gateway, and DNS servers)

    > [!NOTE]
    > If network access to the public cloud is interrupted, you must use the Configurator App to restore management connectivity

## Network Interfaces
Azure Local small form factor allows for management of your Ethernet network interfaces from the Azure portal. 
You can find the Ethernet network adapter management under "Resources" on the left navigation list for your Azure Local provisioned machine. 
<image of list view>
### Modify network interfaces
When viewing the network interfaces, you can select an interface and click the "Edit" button in the portal to modify the network parameters. 
Two modes are supported for Ethernet interfaces in Azure Local, DHCP and Static. 

    > [!NOTE]
    > Following a networking configuration change, it can take up to 5 minutes to refresh the portal view for 2607 preview. 

#### DHCP
When using DHCP, IP address information is supplied by the DHCP service and is not availeble for modification. 
When DHCP is selected, you may chage the network adapter to use static assignment. 
When in DHCP you may provide DNS server(s), up to 16, to supplement or override the addresses DHCP has provided. 
<image>
#### Static
When using Static IP addressing, you must provide the netmask for your IP network as well as any required gateway and DNS settings. 

|Parameter       | Description                                                                                                         |
| -------------- | ------------------------------------------------------------------------------------------------------------------- |
|IP Address      | The IP Address to be assigned to this host                                                                          |
|Netmask         | The mask applied to the IP Address segment for this host in order to define the network size and broascast domain   |
|Default Gateway | The IP Address of the host which is the gateway to external networks. This is usually a router address              |
|DNS             | Domain Name Servers (up to 16) to be used to resolve hostnames to IP addresses for this host                        |

<image>

### Proxy Configuration
Proxy configuration is a global setting and can be modified by selecting the Proxy button from the Network Interface list view. 
<image of proxy button circled>
<image of proxy dialog>

### Configuration Change Detection
Azure Local tracks the last known good configuration of your network interfaces and compares this to the current running configuration on your edge device. 
Should a discrepency be detected, the Azure portal will show an alert that your interface is out of sync. 
<image of drift detected in net int list>
You must decide if this change is expected and wanted or if this is a deviation that must be corrected by updating the edge device with the last-known good values. 
Any change made locally using the Configurator App or Linux cli may be accepted if it is made in order to restore network connectivity to the Azure Local system following a networking change at the remote location. 
<image of dialog to select drift correction> 

    > [!NOTE]
    > Azure Local considers the portal configuration as authoratative. Local changes can be made using the Configurator App or Linux command line with proper permisions.

### Management interface protection
Azure Local notes the interfaces that have the opportunity to be the management link back to Azure. When making a networking configuration change the Azure Local system will ensure that the networking change does not disconnect the device from the Azure Public Cloud. This disconnection would prevent further management of the provisioned device. If a networking change is detected to disconnect from the Azure Public Cloud, the prior configuraiton will be restored.
