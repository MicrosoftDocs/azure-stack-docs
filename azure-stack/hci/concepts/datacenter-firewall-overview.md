---
title: Overview of Datacenter Firewall in Azure Stack HCI and Windows Server
description: Use this topic to learn about Datacenter Firewall in Azure Stack HCI and Windows Server.
author: khdownie
ms.author: v-kedow
ms.topic: overview
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 02/02/2021
---

# What is Datacenter Firewall?

> Applies to: Azure Stack HCI, version 20H2; Windows Server 2019; Windows Server 2016

Datacenter Firewall is a network layer, 5-tuple (protocol, source and destination port numbers, source and destination IP addresses), stateful, multitenant Software Defined Networking (SDN) firewall. The Datacenter Firewall protects east-west and north-south traffic flows across the network layer of virtual networks and traditional VLAN networks.

## How Datacenter Firewall works

You enable and configure Datacenter Firewall by creating access control lists (ACLs) that get applied to a subnet or a network interface. Firewall policies are enforced at the vSwitch port of each tenant virtual machine (VM). The policies are pushed through the tenant portal, and [Network Controller](network-controller-overview.md) distributes them to all applicable hosts.

Tenant administrators can install and configure firewall policies to help protect their networks from unwanted traffic originating from internet and intranet networks.

:::image type="content" source="media/datacenter-firewall/multitenant-firewall-overview.png" alt-text="Datacenter Firewall in the network stack" border="false":::

The service provider administrator or the tenant administrator can manage Datacenter Firewall policies via Network Controller and the northbound APIs. You can also configure and manage Datacenter Firewall policies using Windows Admin Center.

## Advantages for cloud service providers

Datacenter Firewall offers the following advantages for CSPs:

- A highly scalable, manageable, and diagnosable software-based firewall solution that can be offered to tenants

- Freedom to move tenant VMs to different compute hosts without breaking tenant firewall policies

    - Deployed as a vSwitch port host agent firewall

    - Tenant VMs get the policies assigned to their vSwitch host agent firewall

    - Firewall rules are configured in each vSwitch port, independent of the actual host running the VM

- Offers protection to tenant VMs independent of the tenant guest operating system

## Advantages for tenants

The Datacenter Firewall offers the following advantages for tenants:

- Ability to define firewall rules to help protect internet-facing workloads and internal workloads on networks

- Ability to define firewall rules to help protect traffic between VMs on the same Layer 2 (L2) subnet as well as between VMs on different L2 subnets

- Ability to define firewall rules to help protect and isolate network traffic between tenant on-premises networks and their virtual networks at the service provider

- Ability to apply firewall policies to traditional VLAN networks and overlay-based virtual networks

## Next steps

For related information, see also:

- [Use Datacenter Firewall for Software-Defined Networking in Azure Stack HCI and Windows Server](../manage/use-datacenter-firewall.md)
- [SDN in Azure Stack HCI and Windows Server](software-defined-networking.md)