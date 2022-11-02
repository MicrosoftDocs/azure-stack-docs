---
title: Review two-node storage reference pattern IP requirements for Azure Stack HCI
description: Review two-node storage reference pattern IP requirements for Azure Stack HCI
ms.topic: conceptual
author: dansisson
ms.author: v-dansisson
ms.reviewer: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 11/02/2022
---

# Review two-node storage reference pattern IP requirements for Azure Stack HCI

> Applies to: Applies to: Azure Stack HCI, versions 22H2 and 21H2

In this article, learn about the IP requirements for deploying a two-node network reference pattern in your environment.

## Deployments with microsegmentation and QoS enabled

|Network|IP component|Network ATC intent|Network routing|Subnet properties|Required IPs|
|--|--|--|--|--|--|
|Storage 1|1 IP for each host|Storage|No defined gateway.<br>IP-less L2 VLAN.|Network ATC managed subnet.<br>Default VLAN tag 711.|2|
|Storage 2|1 IP for each host|Storage|No defined gateway.<br>IP-less L2 VLAN.|Network ATC managed subnet.<br>Default VLAN tag 712.|2|
|Management|1 IP for each host,<br>1 IP for Failover Cluster,<br>1 IP for Network Controller VM,<br>1 IP for Arc VM management stack VM,<br>1 IP for OEM VM (new)|Management|Connected (outbound internet access required).<br>Disconnected (Arc autonomous controller).|Customer-defined management VLAN.<br>(Native VLAN preferred but trunk mode supported).|5 required<br>1 optional|
|**Total**|||||9 minimum.<br>10 maximum.|

## Deployments without microsegmentation and QoS enabled

|Network|IP component|Network ATC intent|Network routing|Subnet properties|Required IPs|
|--|--|--|--|--|--|
|Storage 1|1 IP for each host|Storage|No defined gateway.<br>IP-less L2 VLAN.|Network ATC managed subnet.<br>Default VLAN tag 711.|2|
|Storage 2|1 IP for each host|Storage|No defined gateway.<br>IP-less L2 VLAN.|Network ATC managed subnet.<br>Default VLAN tag 712.|2|
|Management|1 IP for each host,<br>1 IP for Failover Cluster,<br>1 IP for Network Controller VM,<br>1 IP for Arc VM management stack VM,<br>1 IP for OEM VM (new)|Management|Connected (outbound internet access required).<br>Disconnected (Arc autonomous controller).|Customer-defined management VLAN.<br>(Native VLAN preferred but trunk mode supported).|4 required<br>1 optional|
|**Total**|||||8 minimum<br>9 maximum|

## Deployments with SDN optional services

|Network|IP component|Network ATC intent|Network routing|Subnet properties|Required IPs|
|--|--|--|--|--|--|
|Storage 1|1 IP for each host|Storage|No defined gateway.<br>IP-less L2 VLAN.|Network ATC managed subnet.<br>Default VLAN tag 711.|2|
|Storage 2|1 IP for each host|Storage|No defined gateway.<br>IP-less L2 VLAN.|Network ATC managed subnet.<br>Default VLAN tag 712.|2|
|Tenant compute|Tenant VM IPs connected to corresponding VLANs|Compute|Tenant VLAN routing/access customer-managed.<br>VLAN trunk configuration on the physical switches required.|Customer-defined||
|Management|1 IP for each host,<br>1 IP for Failover Cluster,<br>1 IP for Network Controller VM,<br>1 IP for Arc VM management stack VM,<br>1 IP for OEM VM (new)<br><br>**Two-node**:<br>1 Network Controller VM IP<br>1 Software Load Balancer (SLB) VM IP<br>1 gateway VM IP|Management|Connected (outbound internet access required).<br>Disconnected (Arc autonomous controller).|Customer-defined management VLAN.<br>(Native VLAN preferred but trunk mode supported).|7 required<br>1 optional|
|HNV|2 IPs for each host<br><br>**Two-node**:<br>1 SLB VM IP<br>1 gateway VM IP|N/A|Requires default gateway to route the packets externally.|Provider Address Network VLAN<br>Subnet size needs to allocate hosts and SLB VMs<br>Potential subnet growth to be considered|NC-managed IPs|
|Public VIPs|SLB and gateway public VIPs|N/A|Advertised through BGP||Network Controller-managed IPs|
|Private VIPs|SLB private VIPs|N/A|Advertised through BGP||Network Controller-managed IPs|
|GRE VIPs|GRE connections for gateway VIPs|N/A|Advertised through BGP||Network Controller-managed IPs|
|L3 Forwarding||N/A|Separate physical network subnet to communicate with virtual network|||
|**Total**|||||11 minimum<br>12 maximum|

## Next steps

[Choose a reference pattern](two-node-decision-matrix.md).