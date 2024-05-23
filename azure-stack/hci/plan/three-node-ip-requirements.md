---
title: Review three-node storage reference pattern IP requirements for Azure Stack HCI
description: Review three-node storage reference pattern IP requirements for Azure Stack HCI
ms.topic: conceptual
author: alkohli
ms.author: alkohli
ms.reviewer: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 05/15/2024
---

# Review three-node storage reference pattern IP requirements for Azure Stack HCI

[!INCLUDE [includes](../../includes/hci-applies-to-23h2-22h2.md)]

In this article, learn about the IP address requirements for deploying a three-node network reference pattern in your environment.

## Deployments without microsegmentation and QoS enabled

|Network|IP component|Network ATC intent|Network routing|Subnet properties|Required IPs|
|--|--|--|--|--|--|
|Storage 1|1 IP for each host|Storage|No defined gateway.<br>IP-less L2 VLAN.|Network ATC managed subnet.<br>Default VLAN tag 711.|3|
|Storage 2|1 IP for each host|Storage|No defined gateway.<br>IP-less L2 VLAN.|Network ATC managed subnet.<br>Default VLAN tag 712.|3|
|Management|1 IP for each host,<br>1 IP for Failover Cluster,<br>3 IPs for Azure Resource Bridge (ARB) management stack,<br>1 IP for VM update role,<br>1 IP for OEM VM (optional)|Management|Connected, [outbound access to required URLs](/azure-stack/hci/concepts/firewall-requirements#required-firewall-urls).|Customer-defined management VLAN.<br>(Native VLAN preferred but trunk mode supported).|8 required<br>1 optional|
|**Total**|||||14 IPs minimum.<br><br>15 IPs if using optional OEM VM.|

## Deployments with microsegmentation and QoS enabled

|Network|IP component|Network ATC intent|Network routing|Subnet properties|Required IPs|
|--|--|--|--|--|--|
|Storage 1|1 IP for each host|Storage|No defined gateway.<br>IP-less L2 VLAN.|Network ATC managed subnet.<br>Default VLAN tag 711.|3|
|Storage 2|1 IP for each host|Storage|No defined gateway.<br>IP-less L2 VLAN.|Network ATC managed subnet.<br>Default VLAN tag 712.|3|
|Management|1 IP for each host,<br>1 IP for Failover Cluster,<br>1 IP for Network Controller REST API,<br>3 IPs for Azure Resource Bridge (ARB) management stack,<br>1 IP for VM update role,<br>1 IP for OEM VM (optional)|Management|Connected, [outbound access to required URLs](/azure-stack/hci/concepts/firewall-requirements#required-firewall-urls).|Customer-defined management VLAN.<br>(Native VLAN preferred but trunk mode supported).|9 required<br>1 optional|
|**Total**|||||15 IPs minimum.<br><br>16 IPs if using optional OEM VM.|

## Deployments with SDN optional services

|Network|IP component|Network ATC intent|Network routing|Subnet properties|Required IPs|
|--|--|--|--|--|--|
|Storage 1|1 IP for each host|Storage|No defined gateway.<br>IP-less L2 VLAN.|Network ATC managed subnet.<br>Default VLAN tag 711.|3|
|Storage 2|1 IP for each host|Storage|No defined gateway.<br>IP-less L2 VLAN.|Network ATC managed subnet.<br>Default VLAN tag 712.|3|
|Tenant compute|Tenant VM IPs connected to corresponding VLANs|Compute|Tenant VLAN routing/access customer-managed.<br>VLAN trunk configuration on the physical switches required.|Customer-defined||
|Management|1 IP for each host,<br>1 IP for Failover Cluster,<br>1 IP for Network Controller REST API,<br>3 IPs for Azure Resource Bridge (ARB) management stack,<br>1 IP for VM update role,<br>1 IP for OEM VM (optional)<br><br>**Three-node**:<br>1 IP for Network Controller VM,<br>1 IP for Software Load Balancer (SLB) VM, <br>1 IP for Gateway VM|Management|Connected, [outbound access to required URLs](/azure-stack/hci/concepts/firewall-requirements#required-firewall-urls).|Customer-defined management VLAN.<br>(Native VLAN preferred but trunk mode supported).|14 required<br>1 optional|
|HNV|2 IPs for each host<br><br>**Three-node**:<br>1 IP for SLB VM<br>1 IP for Gateway VM|N/A|Requires default gateway to route the packets externally.|Provider Address Network VLAN<br>Subnet size needs to allocate hosts and SLB VMs<br>Potential subnet growth to be considered|6 required (_NC-managed IPs_)|
|Public VIPs|SLB and gateway public VIPs|N/A|Advertised through BGP||Network Controller-managed IPs|
|Private VIPs|SLB private VIPs|N/A|Advertised through BGP||Network Controller-managed IPs|
|GRE VIPs|GRE connections for gateway VIPs|N/A|Advertised through BGP||Network Controller-managed IPs|
|L3 Forwarding||N/A|Separate physical network subnet to communicate with virtual network|||
|**Total**|||||26 IPs minimum.<br><br>27 IPs if using optional OEM VM.|

## Next steps

Learn about [Three-node reference pattern components](three-node-components.md).
