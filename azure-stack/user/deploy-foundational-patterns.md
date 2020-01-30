---
title: Deploy foundational patterns on Azure Stack Hub.
description: Learn how to Deploy foundational patterns with Azure Stack Hub.
author: mattbriggs

ms.topic: how-to
ms.date: 11/06/2019
ms.author: mabrigg
ms.reviewer: sijuman
ms.lastreviewed: 11/06/2019

# keywords:  networking, storage, backup
# Intent: As an Azure Stack Hub user, I want develop a solution that requires complex connectivity between networks.
---

# Deploy foundational patterns overview

Learn how to leverage foundational patterns and solution examples in your app development. Azure and Azure Stack enable development of hybrid applications, built on a suite of intelligent cloud and intelligent edge services.

Describe why foundational patterns are necessary, the ability to be hybrid of both Azure and Azure Stack Hub.

## Networking

|  VNet peering  |  VPN  |  Load balancer  |
| --- | --- | --- |
| ![VNet peering with VMs](media/deploy-foundational-patterns/icon-networking-61-virtual-networks.svg)<br>[VNet peering with VMs](azure-stack-network-howto-vnet-peering.md) | ![Setup VPN to on-prem](media/deploy-foundational-patterns/icon-networking-63-virtual-network-gateways.svg)<br>[Setup VPN to on-prem](azure-stack-network-howto-vnet-to-onprem.md) | ![F5 load balancer](media/deploy-foundational-patterns/icon-networking-62-load-balancers.svg)<br>[F5 load balancer](network-howto-f5.md) |
| ![VNet peering with FortiGate](media/deploy-foundational-patterns/icon-networking-61-virtual-networks.svg)<br>[VNet peering with FortiGate](azure-stack-network-howto-vnet-to-vnet.md) | ![Virtual Private Network](media/deploy-foundational-patterns/icon-networking-63-virtual-network-gateways.svg)<br>[VNET to VNET connection](azure-stack-network-howto-vnet-to-vnet-stacks.md) |  |
|  | ![Create a VPN tunnel (GRE)](media/deploy-foundational-patterns/icon-networking-63-virtual-network-gateways.svg)<br>[Create a VPN tunnel (GRE)](network-howto-vpn-tunnel-gre.md) | |
|  | ![Set up a multiple site-to-site VPN](media/deploy-foundational-patterns/icon-networking-63-virtual-network-gateways.svg)<br>[Set up a multiple site-to-site VPN](network-howto-vpn-tunnel.md) | |
|  | ![Create a VPN tunnel (IPSEC)](media/deploy-foundational-patterns/icon-networking-63-virtual-network-gateways.svg)<br>[Create a VPN tunnel (IPSEC)](network-howto-vpn-tunnel-ipsec.md)| |


## Storage

| iSCSI storage | Extend storage |
| --- | --- | --- |
| ![Connect to iSCSI storage](media/deploy-foundational-patterns/icon-storage-87-storage-accounts-(classic).svg)<br>[Connect to iSCSI storage](azure-stack-network-howto-iscsi-storage.md) | ![xtend the datacenter](media/deploy-foundational-patterns/icon-storage-88-recovery-services-vaults.svg)<br>[Extend the datacenter](azure-stack-network-howto-extend-datacenter.md) |

## Backup

|  Back up  |  Copy  |
| --- | --- | --- |
| ![Back up your VM on Azure Stack Hub with Commvault](media/deploy-foundational-patterns/icon-storage-100-import-export-jobs.svg)<br>[Back up your VM on Azure Stack Hub with Commvault](azure-stack-network-howto-backup-commvault.md) | ![Copy subscription resources](media/deploy-foundational-patterns/icon-storage-94-data-box.svg)<br>[Copy subscription resources](azure-stack-network-howto-backup-replicator.md) |
|  | ![Back up your storage accounts on Azure Stack Hub](media/deploy-foundational-patterns/icon-storage-93-storage-sync-services.svg)<br>[Back up your storage accounts on Azure Stack Hub](azure-stack-network-howto-backup-storage.md)  |

## GitHub samples

You can find the templates in the [Azure Intelligent Edge Patterns GitHub](https://github.com/Azure-Samples/azure-intelligent-edge-patterns) repository.

## Next steps

[Azure hybrid patterns and solutions documentation](https://docs.microsoft.com/azure-stack/hybrid/)
