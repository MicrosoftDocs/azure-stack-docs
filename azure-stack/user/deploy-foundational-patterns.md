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

There is a need for foundational patterns to help guide Azure Stack operators on setting up certain key scenarios for production environments. These foundational patterns are to be prescriptive guidance documents, templates, and tutorials that users can follow using third party applications to solve features that are not yet supported in Azure Stack.  

Azure Stack Hub foundational patterns attempts to resolve real-world customer issues that exist with their deployments. It helps to mitigate that may exist in current Azure Stack Hub functionality that may not be released quiet as yet. For example, operators often deal with the complexities involved in setting up VPN to Azure Stacks, let alone setting it up across two or more environments due to limitations of the product. This can be further seen when trying to create a load balancer in front of an Azure Stack to manage workloads. Tutorials for these scenarios and others currently do not exist. Creating prescriptive guidance for the operators and users of Azure Stack will vastly improve the product experience and decrease the deployment time for getting their device production ready. Azure Stack needs to have a set of articles/playbooks that guide customers in this area. How to documents that include prescriptive guidance on creating specific network implementations. Each scenario will include a summary of a common business problem, the solution implementation using Azure Stack/The Intelligent Cloud, an architectural diagram (a component diagram), step-by-step instructions, and if helpful code collateral in the Azure Code Sample repo including Azure Resource Manager Templates.

Azure Stack needs prescriptive guides for setting up networks, high availability, and disaster recovery scenarios in a connected and a disconnected environment for specific high-level use cases such as:


## Networking

The following networking foundational patterns for Azure Stack Hub focus on mitigating the gap that currently exists as VNET peering functionality is not currently available. VNET peering does not currently exist in Azure Stack, however these scripts allow you to deploy two VNETs across resource groups in one azure stack resource group, across subscriptions, and across two Azure Stack Hub instances. This site to site connectivity across VNETS is accomplished through the Remote and Routing Service (RRAS), which allows for Windows VMs to be treated as if they performed like routers. The scripts also encompass bout IPSEC and GRE tunneling for bettering throughput. The topics below not only have step-by-step guidance on how to deploy these scripts, but also perform a walkthrough of how to accomplish the same task using third party NVAs such as Fortinet Fortigate NVA. Lastly, the external load balancer pattern utilizes F5 BIG IP and an ARM template to allow for applications to be managed across two Azure Stack Hub stamps. All of the networking foundational patterns scripts can be deployed on Azure Stack Hub and on public Azure. This topic will address common consideration such as: scale, bandwidth, security, business continuity, etc.

|  VNet peering  |  VPN  |  Load balancer  |
| --- | --- | --- |
| ![VNet peering with VMs](media/deploy-foundational-patterns/icon-networking-61-virtual-networks.svg)<br>[VNet peering with VMs](azure-stack-network-howto-vnet-peering.md) | ![Setup VPN to on-prem](media/deploy-foundational-patterns/icon-networking-63-virtual-network-gateways.svg)<br>[Setup VPN to on-prem](azure-stack-network-howto-vnet-to-onprem.md) | ![F5 load balancer](media/deploy-foundational-patterns/icon-networking-62-load-balancers.svg)<br>[F5 load balancer](network-howto-f5.md) |
| ![VNet peering with FortiGate](media/deploy-foundational-patterns/icon-networking-61-virtual-networks.svg)<br>[VNet peering with FortiGate](azure-stack-network-howto-vnet-to-vnet.md) | ![Virtual Private Network](media/deploy-foundational-patterns/icon-networking-63-virtual-network-gateways.svg)<br>[VNET to VNET connection](azure-stack-network-howto-vnet-to-vnet-stacks.md) |  |
|  | ![Create a VPN tunnel (GRE)](media/deploy-foundational-patterns/icon-networking-63-virtual-network-gateways.svg)<br>[Create a VPN tunnel (GRE)](network-howto-vpn-tunnel-gre.md) | |
|  | ![Set up a multiple site-to-site VPN](media/deploy-foundational-patterns/icon-networking-63-virtual-network-gateways.svg)<br>[Set up a multiple site-to-site VPN](network-howto-vpn-tunnel.md) | |
|  | ![Create a VPN tunnel (IPSEC)](media/deploy-foundational-patterns/icon-networking-63-virtual-network-gateways.svg)<br>[Create a VPN tunnel (IPSEC)](network-howto-vpn-tunnel-ipsec.md)| |


## Storage

The following storage foundational patterns for Azure Stack Hub focus on extending the storage options for your own environment. It also allows users to connect their existing datacenter options with that of Azure Stack Hub. Azure Stack storage is finite. Which brings us to the scenario that we will cover below. How can we connect Azure Stack systems, specifically virtualized workloads running on the Azure Stack, simply and efficiently, to storage systems outside of the Azure Stack, accessible via the network. In the documents below, we will create a Windows VM on Azure Stack Hub to connect to an external iSCSI Target, which will also be running Windows Server 2019. Where appropriate we will enable key features such as MPIO, to optimize performance and connectivity between the VM and external storage.

| iSCSI storage | Extend storage |
| --- | --- | --- |
| ![Connect to iSCSI storage](media/deploy-foundational-patterns/icon-storage-87-storage-accounts-(classic).svg)<br>[Connect to iSCSI storage](azure-stack-network-howto-iscsi-storage.md) | ![xtend the datacenter](media/deploy-foundational-patterns/icon-storage-88-recovery-services-vaults.svg)<br>[Extend the datacenter](azure-stack-network-howto-extend-datacenter.md) |

## Backup

The following backup and disaster recovery foundational patterns for Azure Stack hub allows users to copy all of the resources in a subscription to Azure or another Azure Stack Hub instance. Users can copy all of the resources in a subscription and replicate them on another environment. Users can then use Commvault live-sync to replicate information stored on the inside of the virtual machines to another environment as well. The scripts available allow you to create a storage account and a backup storage account to send the data to as well. The Azure subscription replicator was designed to be modular. This tool uses a core processor that orchestrates the resource replication. In addition, the tool supports customizable processors that act as templates for copying different types of resources. The scripts as well as the step-by-step guidance can be deployed on Azure Stack Hub and Azure.

|  Back up  |  Copy  |
| --- | --- | --- |
| ![Back up your VM on Azure Stack Hub with Commvault](media/deploy-foundational-patterns/icon-storage-100-import-export-jobs.svg)<br>[Back up your VM on Azure Stack Hub with Commvault](azure-stack-network-howto-backup-commvault.md) | ![Copy subscription resources](media/deploy-foundational-patterns/icon-storage-94-data-box.svg)<br>[Copy subscription resources](azure-stack-network-howto-backup-replicator.md) |
|  | ![Back up your storage accounts on Azure Stack Hub](media/deploy-foundational-patterns/icon-storage-93-storage-sync-services.svg)<br>[Back up your storage accounts on Azure Stack Hub](azure-stack-network-howto-backup-storage.md)  |

## GitHub samples

You can find the templates in the [Azure Intelligent Edge Patterns GitHub](https://github.com/Azure-Samples/azure-intelligent-edge-patterns) repository.

## Next steps

[Azure hybrid patterns and solutions documentation](https://docs.microsoft.com/azure-stack/hybrid/)
