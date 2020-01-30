---
title: How to deploy F5 across two Azure Stack Hub instances 
description: Learn how to deploy F5 across two Azure Stack Hub instances.
author: mattbriggs

ms.topic: how-to
ms.date: 11/06/2019
ms.author: mabrigg
ms.reviewer: sijuman
ms.lastreviewed: 11/06/2019

# keywords:  X
# Intent: As an Azure Stack Hub Operator, I want < what? > so that < why? >
---

# Deploy foundational patterns overview

Learn how to leverage foundational patterns and solution examples in your app development. Azure and Azure Stack enable development of hybrid applications, built on a suite of intelligent cloud and intelligent edge services.

## Networking patterns

|  VNet peering  |  VPN  |  F5  |
| --- | --- | --- |
| [VNet peering with VMs](azure-stack-network-howto-vnet-peering.md) | [Setup VPN to on-prem](azure-stack-network-howto-vnet-to-onprem.md) | [F5 load balancer](network-howto-f5.md) |
| [VNet peering with FortiGate](azure-stack-network-howto-vnet-to-vnet.md) | [VNET to VNET connection](azure-stack-network-howto-vnet-to-vnet-stacks.md) |  |
|  | [Create a VPN tunnel (GRE)](network-howto-vpn-tunnel-gre.md) | |
|  | [Set up a multiple site-to-site VPN](network-howto-vpn-tunnel.md) | |
|  | [Create a VPN tunnel (IPSEC)](network-howto-vpn-tunnel-ipsec.md)| |


## Connect to external storage

| iSCSI storage | Extend |
| --- | --- |
| [Connect to iSCSI storage](azure-stack-network-howto-iscsi-storage.md) | [Extend the datacenter](azure-stack-network-howto-extend-datacenter.md) |

## Backup and recovery

|  Back up  |  Copy  |
| --- | --- | --- |
| [Back up your VM on Azure Stack Hub with Commvault](azure-stack-network-howto-backup-commvault.md) | [Copy subscription resources](azure-stack-network-howto-backup-replicator.md) |
|  | [Back up your storage accounts on Azure Stack Hub](azure-stack-network-howto-backup-storage.md)  |  |

## Next steps

[Azure hybrid patterns and solutions documentation](https://docs.microsoft.com/azure-stack/hybrid/)
