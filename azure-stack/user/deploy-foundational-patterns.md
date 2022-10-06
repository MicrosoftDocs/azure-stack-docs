---
title: Deploy foundational patterns on Azure Stack Hub
description: Learn how to Deploy foundational patterns with Azure Stack Hub.
author: sethmanheim

ms.topic: how-to
ms.date: 9/8/2021
ms.author: sethm
ms.reviewer: thoroet
ms.lastreviewed: 9/8/2021

# Intent: Notdone: As a < type of user >, I want < what? > so that < why? >
# Keyword: Notdone: keyword noun phrase

---


# Deploy foundational patterns overview


Each of these patterns contains guidance, Azure Resource Manager templates, and tutorials. You can use these patterns along with third-party apps to create offerings not yet supported by Azure Stack. For example, operators often deal with the complexities involved in setting up a virtual private network (VPN) to a single Azure Stack Hub instance, much less creating a VPN that spans two or more environments. Operators can come across issues when trying to create a load balancer in front of an Azure Stack Hub to manage workloads. With the following guidance, you can speed up the deployment time for releasing your production ready workloads.

## Networking

Use the networking patterns to find instructions to connect Azure Stack Hub virtual networks with either, on-prem, Azure or other virtual networks withing the Azure Stack Hub instance. Site-to-site connectivity and load balancing solutions can be accomplished with native VPN capabilities or with 3rd party solutions.

Each article addresses common consideration such as: 
- Scale
- Bandwidth
- Security
- Business continuity

|  Virtual network peering  |  VPN  |  Load balancer  |
| --- | --- | --- |
| ![Virtual network peering with VMs](media/deploy-foundational-patterns/icon-networking-61-virtual-networks.svg)<br> [Hub & Spoke Network pattern using native Azure Stack Hub virtual network peering](virtual-network-peering.md) | ![Set up VPN to on-prem](media/deploy-foundational-patterns/icon-networking-63-virtual-network-gateways.svg)<br>[VPN to on-prem or Azure using Azure Stack Hub native gateways](azure-stack-vpn-gateway-about-vpn-gateways.md) | ![F5 load balancer](media/deploy-foundational-patterns/icon-networking-62-load-balancers.svg)<br>[F5 load balancer](network-howto-f5.md) |
|  | ![Virtual Private Network](media/deploy-foundational-patterns/icon-networking-63-virtual-network-gateways.svg)<br>[Multi-Site Azure Stack Hub instances virtual network to virtual network connection](azure-stack-network-howto-vnet-to-vnet-stacks.md) |  |
|  | ![Create a VPN tunnel (GRE)](media/deploy-foundational-patterns/icon-networking-63-virtual-network-gateways.svg) <br>[VPN to on-prem using FortiGate NVA](azure-stack-network-howto-vnet-to-onprem.md) |  |

## Storage

Use the storage patterns to increase your storage options with Azure Stack Hub. In Azure Stack Hub storage is finite. Connect to resources in your existing datacenter. Find instructions for creating a Windows VM in Azure Stack Hub to connect to an external iSCSI target. You can learn how to enable key features such as Multipath I/O (MPIO), to optimize performance and connectivity between the VM and external storage.

| iSCSI storage | Extend storage |
| --- | --- |
| ![Connect to iSCSI storage](media/deploy-foundational-patterns/icon-storage-87-storage-accounts-classic.svg)<br>[Connect to iSCSI storage](azure-stack-network-howto-iscsi-storage.md) | ![Extend the datacenter](media/deploy-foundational-patterns/icon-storage-88-recovery-services-vaults.svg)<br>[Extend the datacenter](azure-stack-network-howto-extend-datacenter.md) |

## Backup

You can use the backup and disaster recovery patterns to copy all the resources in a subscription to Azure or another Azure Stack Hub instance. These patterns look at using Commvault live-sync to replicate information stored on the inside of the VMs to another environment. You can find scripts to create a storage account and a backup storage account to send the data. With the module Azure subscription replicator you can orchestrate resource replication, and you can customize the processor to handle a variety of resources. 



|  Back up  |  Copy  |
| --- | --- |
| ![Back up your VM on Azure Stack Hub with Commvault](media/deploy-foundational-patterns/icon-storage-100-import-export-jobs.svg)<br>[Back up your VM on Azure Stack Hub with Commvault](azure-stack-network-howto-backup-commvault.md) | ![Copy subscription resources](media/deploy-foundational-patterns/icon-storage-94-data-box.svg)<br>[Copy subscription resources](azure-stack-network-howto-backup-replicator.md) |
|  ![Back up your storage accounts on Azure Stack Hub](media/deploy-foundational-patterns/icon-storage-93-storage-sync-services.svg)<br>[Back up your storage accounts on Azure Stack Hub](azure-stack-network-howto-backup-storage.md)  | |

## GitHub samples

You can find the templates in the [Azure Intelligent Edge Patterns GitHub](https://github.com/Azure-Samples/azure-intelligent-edge-patterns) repository.

## Next steps

[Azure hybrid patterns and solutions documentation](/hybrid/app-solutions)
