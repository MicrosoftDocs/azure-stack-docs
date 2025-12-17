---
title: Azure Operator Nexus Access Control Lists Overview
description: Get an overview of access control lists for Azure Operator Nexus.
author: scottsteinbrueck
ms.author: ssteinbrueck
ms.service: azure-operator-nexus
ms.topic: conceptual
ms.date: 02/09/2024
ms.custom: template-concept
---

# Access control lists in Azure Operator Nexus network fabric

Access control lists (ACLs) are a set of rules that regulate inbound and outbound packet flow within a network. Azure Nexus Operator network fabric offers an API-based mechanism to configure ACLs for network-to-network interconnects (NNIs) and layer 3 isolation domain (ISD) external networks. These APIs enable the specification of traffic classes and performance actions based on defined rules and actions within the ACLs. ACL rules define the data against which packet contents are compared for filtering purposes.

## Objective

The primary objective of ACLs is to secure and regulate incoming and outgoing tenant traffic flowing through Azure Nexus Operator network fabric via NNIs or layer 3 ISD external networks. ACL APIs empower administrators to control data rates for specific traffic classes and take action when traffic exceeds configured thresholds. These capabilities safeguard tenants from network threats by applying ingress ACLs and protect the network from tenant activities through egress ACLs. ACL implementation simplifies network management by securing networks and facilitating the configuration of bulk rules and actions via APIs.

## Functionality

ACLs use match criteria and actions tailored for different types of network resources, such as NNIs and external networks. You can apply ACLs in two primary forms:

- **Ingress ACL**: Controls inbound packet flow.
- **Egress ACL**: Regulates outbound packet flow.

You can apply both types of ACLs to NNIs or external network resources to filter and manipulate traffic based on various match criteria and actions.

### Supported network resources

| Resource name                  | Supported | Product         |
|--------------------------------|-----------|-------------|
| NNI                            | Yes       | All         |
| ISD external network | Yes, on external network with option A | All         |

## Match configuration

Match criteria are conditions used to match packets based on attributes such as IP address, protocol, port, virtual local area network (VLAN), DSCP, ethertype, fragment, and time to live (TTL). Each match criterion has a name, a sequence number, an IP address type, and a list of match conditions. Match conditions are evaluated by using the logical `AND` operator.

- **dot1q**: Matches packets based on the VLAN ID in the 802.1Q tag.
- **Fragment**: Matches packets based on whether they're IP fragments or not.
- **IP**: Matches packets based on IP header fields such as source/destination IP address, protocol, and DSCP.
- **Protocol**: Matches packets based on the protocol type.
- **Source/Destination**: Matches packets based on the port number or range.
- **TTL**: Matches packets based on the TTL value in the IP header.
- **DSCP**: Matches packets based on the DSCP value in the IP header.

## Action property of an ACL

The action property of an ACL statement can have one of the following types:

- **Permit**: Allows packets that match specified conditions.
- **Drop**: Discards packets that match specified conditions.
- **Count**: Counts the number of packets that match specified conditions.

## Control plane traffic policy (CP-TP)

In addition to adding another layer of control plane protection for enhancing network security, you can also configure and modify control plane traffic policies (CP-TPs) on supported devices via APIs.

• A traffic policy solution can secure the network fabric device control plane (packets destined to or originating from the network fabric device) of the supported devices in Azure Operator Nexus.
• The device control plane (which includes policing/rate limiting) can be implemented as traffic policies based on source/destination IP, source/destination ports, and protocols.
• APIs can support create, update, and delete for the traffic policy entries/rules/policing/rate limiting.

To implement the functionality for CP-TP ACL:

• For existing deployments, you must create a CP-TP ACL resource, associate it with the network fabric, and perform a patch operation.
• For new deployments, create the CP-TP ACL resource either during fabric creation or after the fabric is provisioned. Then patch it to the network fabric resource. Because the CP-TP ACL resource isn't created by default, you must create it manually before you attach it to the network fabric resource.

## Related content

- [Create ACL management for NNI and layer 3 isolation domain external networks](howto-create-access-control-list-for-network-to-network-interconnects.md)
