---
title: Review single-node storage reference pattern IP requirements for Azure Stack HCI
description: Review single-node storage reference pattern IP requirements for Azure Stack HCI
ms.topic: conceptual
author: dansisson
ms.author: v-dansisson
ms.reviewer: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 09/19/2022
---

# Review single-node storage reference pattern IP requirements for Azure Stack HCI

> Applies to: Azure Stack HCI, version 21H2, Azure Stack HCI, version 22H2 (preview)

In this article, learn about the IP requirements for deploying a single-node network reference pattern in your environment.

## Deployments with microsegmentation and QoS enabled

|Network|IP component|Network ATC intent|Network routing|Subnet properties|Single-node required IPs|
|--|--|--|--|--|--|
|Storage 1|1 IP for each host|Storage|No defined GW.<br>IP-less L2 VLAN.|Network ATC managed subnet.<br>Default VLAN tag 711.|1 optional if connected to switch.|
|Storage 2|1 IP for each host|Storage|No defined GW.<br>IP-less L2 VLAN.|Network ATC managed subnet.<br>Default VLAN tag 712.|1 optional if connected to switch.|
|Management|1 IP for each host,<br>1 IP for Failover Cluster,<br>1 IP for NC VM,<br>1 IP for MOC VM,<br>1 IP for OEM VM (new)|Management|Connected Outbound (internet access required).<br>Disconnected (Arc autonomous controller).|Customer-defined management VLAN.<br>(Native VLAN preferred but trunk mode supported).|4 required<br>1 optional|
|**Total**|||||4 Required.<br>2 optional for storage,<br>1 optional for OEM VM.|

## Deployments without microsegmentation and QoS enabled

|Network|IP component|Network ATC intent|Network routing|Subnet properties|Single-node required IPs|
|--|--|--|--|--|--|
|Storage 1|1 IP for each host|Storage|No defined GW.<br>IP-less L2 VLAN.|Network ATC managed subnet.<br>Default VLAN tag 711.|1 optional if connected to switch.|
|Storage 2|1 IP for each host|Storage|No defined GW.<br>IP-less L2 VLAN.|Network ATC managed subnet.<br>Default VLAN tag 712.|1 optional if connected to switch.|
|Management|1 IP for each host,<br>1 IP for Failover Cluster,<br>1 IP for NC VM,<br>1 IP for MOC VM,<br>1 IP for OEM VM (new)|Management|Connected Outbound (internet access required).<br>Disconnected (Arc autonomous controller).|Customer-defined management VLAN.<br>(Native VLAN preferred but trunk mode supported).|3 required<br>1 optional|
|**Total**|||||3 Required.<br>2 optional for storage,<br>1 optional for OEM VM.|

## Deployments with SDN optional services

|Network|IP component|Network ATC intent|Network routing|Subnet properties|Single-node required IPs|
|--|--|--|--|--|--|
|Storage 1|1 IP for each host|Storage|No defined GW.<br>IP-less L2 VLAN.|Network ATC managed subnet.<br>Default VLAN tag 711.|1 optional if connected to switch.|
|Storage 2|1 IP for each host|Storage|No defined GW.<br>IP-less L2 VLAN.|Network ATC managed subnet.<br>Default VLAN tag 712.|1 optional if connected to switch.|
|Tenant compute||||||
|Management|1 IP for each host,<br>1 IP for Failover Cluster,<br>1 IP for NC VM,<br>1 IP for MOC VM,<br>1 IP for OEM VM (new)<br><br>**Single node**:<br>1 NC VM IP<br>1 SLB VM IP<br>1 GW VM IP|Management|Connected Outbound (internet access required).<br>Disconnected (Arc autonomous controller).|Customer-defined management VLAN.<br>(Native VLAN preferred but trunk mode supported).|6 required<br>1 optional|
|HNV (AKA PA network)|2 IPs for each host<br><br>**Single node**:<br>1 SLB VM IP<br>1 GW VM IP|N/A|Requires default gateway to route the packets externally.|Provider Address Network VLAN<br>Subnet size needs to allocate hosts and SLB VMs<br>Potential subnet growth to be considered|NC-managed IPs|
|Public VIPs|LB and GWs Public VIPs|N/A|Advertised through BGP||NC-managed IPs|
|Private VIPs|LB Private VIPs|N/A|Advertised through BGP||NC-managed IPs|
|GRE VIPs|GRE Connections GW VIPs|N/A|Advertised through BGP||NC-managed IPs|
|L3 Forwarding||N/A|Separate physical network subnet to communicate with virtual network|||
|**Total**|||||6 Required.<br>2 optional for storage,<br>1 optional for OEM VM.|

## Next steps

- [Download Azure Stack HCI](https://azure.microsoft.com/products/azure-stack/hci/hci-download/)