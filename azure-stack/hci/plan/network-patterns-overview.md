---
title: Network reference patterns overview for Azure Stack HCI
description: Learn about the different supported network reference patterns for Azure Stack HCI.
ms.topic: conceptual
author: dansisson
ms.author: v-dansisson
ms.reviewer: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 11/10/2022
---

# Network reference patterns overview for Azure Stack HCI

[!INCLUDE [includes](../../includes/hci-applies-to-22h2-21h2.md)]

In this article, you'll gain an overview understanding for deploying network reference patterns on Azure Stack HCI.

A deployment consists of single-server or two-node systems that connect to one or two Top of Rack (TOR) switches. This environment has the following characteristics:

- Two storage ports dedicated for storage traffic intent. The RDMA NIC is optional for single-server deployments.

- One or two ports dedicated to management and compute traffic intents.

- One optional Baseboard Management Controller (BMC) for OOB management.

A single-server deployment features a single TOR switch for northbound/southbound (internal-external) traffic. Two-node deployments consist of either a storage switchless configuration using one or two TOR switches; or a storage switched configuration using two TOR switches with either non-converged or fully converged host network adapters.

## Switchless advantages and disadvantages

The following highlights some advantages and disadvantages of using switchless configurations:

- No switch is necessary for in-cluster (East-West) traffic; however, a switch is required for traffic outside the cluster (North-South). This may result in lower capital expenditure (CAPEX) costs, but is dependent on the number of nodes in the cluster.

- If switchless is used, configuration is limited to the host, which may reduce the potential number of configuration steps needed. However, this value diminishes as the cluster size increases.

- Switchless has the lowest level of resiliency, and it comes with extra complexity and planning if after the initial deployment it needs to be scaled up. Storage connectivity needs to be enabled when adding the second node, which will require to define what physical connectivity between nodes is needed.

- More planning is required for IP and subnet addressing schemes.

- Storage adapters are single-purpose interfaces. Management, compute, stretched cluster, and other traffic requiring North-South communication can't use these adapters.

- As the number of nodes in the cluster grows beyond two nodes, the cost of network adapters could exceed the cost of using network switches.

- Beyond a three-node cluster, cable management complexity grows.

- Cluster expansion beyond two-nodes is complex, potentially requiring per-node hardware and software configuration changes.

For more information, see [Physical network requirements for Azure Stack HCI](../concepts/physical-network-requirements.md).

## Firewall requirements

Azure Stack HCI requires periodic connectivity to Azure. If your organization's outbound firewall is restricted, you would need to include firewall requirements for outbound endpoints and internal rules and ports. There are required and recommended endpoints for the Azure Stack HCI core components, which include cluster creation, registration and billing, Microsoft Update, and cloud cluster witness.

See the [firewall requirements](/azure-stack/hci/concepts/firewall-requirements?tabs=allow-table) for a complete list of endpoints. Make sure to include these URLS in your allowed list. Proper network ports need to be opened between all server nodes both within a site and between sites (for stretched clusters).

With Azure Stack HCI the connectivity validator of the [Environment Checker](https://www.powershellgallery.com/packages/AzStackHci.EnvironmentChecker/0.2.3-preview) tool will check for the outbound connectivity requirement by default during deployment. Additionally, you can run the Environment Checker tool standalone before, during, or after deployment to evaluate the outbound connectivity of your environment.

A best practice is to have all relevant endpoints in a data file that can be accessed by the environment checker tool. The same file can also be shared with your firewall administrator to open up the necessary ports and URLs.

For more information, see [Firewall requirements](/azure-stack/hci/concepts/firewall-requirements?tabs=allow-table).

## Next steps

- [Choose a network pattern ](choose-network-pattern.md) to review.