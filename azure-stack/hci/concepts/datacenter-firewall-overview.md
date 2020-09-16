---
title: Overview of Datacenter Firewall in Azure Stack HCI
description: Use this topic to learn about Datacenter Firewall in Azure Stack HCI.
author: khdownie
ms.author: v-kedow
ms.topic: overview
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 09/16/2020
---

# What is Datacenter Firewall?

> Applies to: Azure Stack HCI, version 20H2; Windows Server 2019

Datacenter Firewall is a network layer, 5-tuple (protocol, source and destination port numbers, source and destination IP addresses), stateful, multitenant Software Defined Networking (SDN) firewall. The Datacenter Firewall protects east-west and north-south traffic flows across the network layer of virtual networks.

## How Datacenter Firewall works

You enable and configure Datacenter Firewall by creating access control lists (ACLs) that get applied to a virtual subnet or a network interface. Firewall policies are enforced at the vSwitch port of each tenant virtual machine (VM). The policies are pushed through the tenant portal, and the Network Controller distributes them to all applicable hosts.

When deployed and offered as a service by a Cloud Service Provider (CSP), tenant administrators can install and configure firewall policies to help protect their virtual networks from unwanted traffic originating from Internet and intranet networks.

:::image type="content" source="media/datacenter-firewall/azure-stack-hci-solution.png" alt-text="Datacenter Firewall in the network stack" border="false":::

The service provider administrator or the tenant administrator can manage Datacenter Firewall policies via the Network Controller and the northbound APIs.

## Advantages for Cloud Service Providers

The Datacenter Firewall offers the following advantages for CSPs:

- A highly scalable, manageable, and diagnosable software-based firewall solution that can be offered to tenants

- Freedom to move tenant VMs to different compute hosts without breaking tenant firewall policies

    - Deployed as a vSwitch port host agent firewall

    - Tenant VMs get the policies assigned to their vSwitch host agent firewall

    - Firewall rules are configured in each vSwitch port, independent of the actual host running the VM

- Offers protection to tenant VMs independent of the tenant guest operating system

## Advantages for tenants

The Datacenter Firewall offers the following advantages for tenants:

- Ability to define firewall rules to help protect Internet facing workloads on virtual networks

- Ability to define firewall rules to help protect traffic between VMs on the same Layer 2 (L2) virtual subnet as well as between VMs on different L2 virtual subnets

- Ability to define firewall rules to help protect and isolate network traffic between tenant on-premises networks and their virtual networks at the service provider

## Next steps

For related information, see also:

- [Use access control lists (ACLs) to manage datacenter network traffic flow](/windows-server/networking/sdn/manage/use-acls-for-traffic-flow)
- [SDN in Azure Stack HCI](software-defined-networking.md)