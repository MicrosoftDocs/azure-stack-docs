---
title: Network reference patterns overview for Azure Local
description: Learn about the different supported network reference patterns for Azure Local.
ms.topic: concept-article
author: alkohli
ms.author: alkohli
ms.reviewer: alkohli
ms.service: azure-local
ms.date: 02/14/2025
---

# Network reference patterns overview for Azure Local

[!INCLUDE [includes](../includes/hci-applies-to-23h2-22h2.md)]

[!INCLUDE [azure-local-banner-23h2](../includes/azure-local-banner-23h2.md)]

In this article, gain an overview understanding for deploying network reference patterns on Azure Local.

A deployment consists of single-node or multiple node systems (up to 16 machines per system) that connect to one or two Top of Rack (TOR) switches. Those environments have the following characteristics:

- At least two network adapter ports dedicated for storage traffic intent. The only exception to this rule is single-node deployments, where network adapters for storage aren't required if you aren't planning to scale out the system in the future.

- One or two network adapter ports dedicated to management and compute traffic intents.

## Storage switchless connectivity considerations

The following highlights some considerations of using switchless configurations:

- Storage switchless deployments in Azure Local only support 1,2,3 or 4 nodes.

- Scale out operations on storage switchless deployments from Azure portal or ARM aren't supported in Azure Local systems.  

- No switch is necessary for in-system (East-West) traffic; however, a physical switch is required for traffic outside the system (North-South).

- Network ATC doesn't support storage network autoIP on 3 nodes switchless deployments. Planning is required for IP and subnet addressing schemes.

- Storage adapters are single-purpose interfaces. Management, compute, stretched cluster, and other traffic requiring North-South communication can't use the storage network adapters.

- As the number of nodes in the system grows beyond two nodes, the cost of network adapters could exceed the cost of using network switches.

- Beyond a four-node system, cable management complexity grows.

For more information, see [Physical network requirements for Azure Local](../concepts/physical-network-requirements.md).

## Firewall requirements

Azure Local requires periodic connectivity to Azure. If your organization's outbound firewall is restricted, you would need to include firewall requirements for outbound endpoints and internal rules and ports. There are required and recommended endpoints for the Azure Local core components, which include system creation, registration and billing, Microsoft Update, and cloud witness.

See the [firewall requirements](/azure-stack/hci/concepts/firewall-requirements?tabs=allow-table) for a complete list of endpoints. Make sure to include these required URLS in your allowed list. Proper network ports need to be opened between all machines both within a site and between sites (for stretched clusters).

Azure Local connectivity validator of the [Environment Checker](https://www.powershellgallery.com/packages/AzStackHci.EnvironmentChecker/0.2.3-preview) tool, checks for the outbound connectivity requirement by default during deployment. Additionally, you can run the Environment Checker tool standalone before, during, or after deployment to evaluate the outbound connectivity of your environment.

A best practice is to have all relevant endpoints in a data file that can be accessed by the environment checker tool. The same file can also be shared with your firewall administrator to open up the necessary ports and URLs.

For more information, see [Firewall requirements](/azure-stack/hci/concepts/firewall-requirements?tabs=allow-table).

## Next steps

- [Choose a network pattern ](choose-network-pattern.md) to review.
