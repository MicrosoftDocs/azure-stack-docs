---
title: Review single-server storage reference pattern IP requirements for Azure Stack HCI
description: Review single-server storage reference pattern IP requirements for Azure Stack HCI
ms.topic: conceptual
author: dansisson
ms.author: v-dansisson
ms.reviewer: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 07/20/2023
---

# Review single-server storage reference pattern IP requirements for Azure Stack HCI

[!INCLUDE [includes](../../includes/hci-applies-to-22h2-21h2.md)]

In this article, learn about the IP requirements for deploying a single-server network reference pattern in your environment.

## Deployments without microsegmentation and QoS enabled

The following table lists network attributes for deployments without microsegmentation and Quality of Service (QoS) enabled. This is the default scenario and is deployed automatically.

|Network|IP component|Network ATC intent|Network routing|Subnet properties|Required IPs|
|--|--|--|--|--|--|
|Storage 1|1 IP for each host|Storage|No defined gateway.<br>IP-less L2 VLAN.|Network ATC managed subnet.<br>Default VLAN tag 711.|1 optional if connected to switch.|
|Storage 2|1 IP for each host|Storage|No defined gateway.<br>IP-less L2 VLAN.|Network ATC managed subnet.<br>Default VLAN tag 712.|1 optional if connected to switch.|
|Management|1 IP for each host,<br>1 IP for Failover Cluster,<br>1 IP for OEM VM (optional)|Management|Outbound connected (internet access required).<br>Disconnected (Arc autonomous controller).|Customer-defined management VLAN.<br>(Native VLAN preferred but trunk mode supported).|2 required,<br>1 optional.|
|**Total**|||||2 required.<br>2 optional for storage,<br>1 optional for OEM VM.|

## (Optional) Deployments with microsegmentation and QoS enabled

The following table lists network attributes for deployments with microsegmentation and QoS enabled. This scenario is optional and deployed only with Network Controller.

|Network|IP component|Network ATC intent|Network routing|Subnet properties|Required IPs|
|--|--|--|--|--|--|
|Storage 1|1 IP for each host|Storage|No defined GW.<br>IP-less L2 VLAN.|Network ATC managed subnet.<br>Default VLAN tag 711.|1 optional if connected to switch.|
|Storage 2|1 IP for each host|Storage|No defined GW.<br>IP-less L2 VLAN.|Network ATC managed subnet.<br>Default VLAN tag 712.|1 optional if connected to switch.|
|Management|1 IP for each host,<br>1 IP for Failover Cluster,<br>1 IP for Network Controller VM,<br>1 IP for Arc VM management stack VM,<br>1 IP for OEM VM (new)|Management|Outbound connected (internet access required).<br>Disconnected (Arc autonomous controller).|Customer-defined management VLAN.<br>(Native VLAN preferred but trunk mode supported).|4 required,<br>1 optional|
|**Total**|||||4 Required.<br>2 optional for storage,<br>1 optional for OEM VM.|

## Deployments with SDN optional services

The following table lists network attributes for deployments SDN optional services:

|Network|IP component|Network ATC intent|Network routing|Subnet properties|Required IPs|
|--|--|--|--|--|--|
|Storage 1|1 IP for each host|Storage|No defined GW.<br>IP-less L2 VLAN.|Network ATC managed subnet.<br>Default VLAN tag 711.|1 optional if connected to switch.|
|Storage 2|1 IP for each host|Storage|No defined GW.<br>IP-less L2 VLAN.|Network ATC managed subnet.<br>Default VLAN tag 712.|1 optional if connected to switch.|
|Tenant compute|Tenant VM IPs connected to corresponding VLANs|Compute|Tenant VLAN routing/access customer-managed.<br>VLAN trunk configuration on physical switches required.|Customer-defined||
|Management|1 IP for each host,<br>1 IP for Failover Cluster,<br>1 IP for Network Controller VM,<br>1 IP for Arc VM management stack VM,<br>1 IP for OEM VM (new)<br><br>**Single node**:<br>1 Network Controller VM IP<br>1 Software Load Balancer (SLB) VM IP<br>1 gateway VM IP|Management|Connected Outbound (internet access required).<br>Disconnected (Arc autonomous controller).|Customer-defined management VLAN.<br>(Native VLAN preferred but trunk mode supported).|6 required<br>1 optional|
|HNV (AKA PA network)|2 IPs for each host<br><br>**Single node**:<br>1 SLB VM IP<br>1 gateway VM IP|N/A|Requires default gateway to route packets externally.|Provider Address Network VLAN.<br>Subnet needs to allocate hosts and SLB VMs.<br>Potential subnet growth consideration.|IPs automatically assigned out of the subnet by Network Controller|
|Public VIPs|LB and GWs, Public VIPs|N/A|Advertised through BGP||Network Controller-managed IPs|
|Private VIPs|LB Private VIPs|N/A|Advertised through BGP||Network Controller-managed IPs|
|GRE VIPs|GRE connections, gateway VIPs|N/A|Advertised through BGP||Network Controller-managed IPs|
|L3 Forwarding||N/A|Separate physical subnet to communicate with virtual network|||
|**Total**|||||6 required.<br>2 optional for storage,<br>1 optional for OEM VM.|

## Next steps

- [Download Azure Stack HCI](../deploy/download-azure-stack-hci-software.md)