---
title: Network reference patterns overview for Azure Local
description: Learn about the different supported network reference patterns for Azure Local.
ms.topic: concept-article
author: alkohli
ms.author: cedward
ms.reviewer: alkohli
ms.service: azure-local
ms.date: 13/04/2026
ms.subservice: hyperconverged
---

# Network reference patterns overview for Azure Local disaggregated deployments

[!INCLUDE [includes](../includes/hci-applies-to-23h2-22h2.md)]

This article provides an overview of deploying network reference patterns in disaggregated deployments of Azure Local (*formerly Azure Stack HCI*).

A deployment consists of single-node or multiple node systems (up to 64 machines per system) that connect to one or multiple Top of Rack (TOR) switches. Those environments have the following characteristics:

- At least four network adapter ports, where two ports are dedicated for the management and compute intent, and two more ports are used for the cluster networks. In disaggregated deployments, the cluster networks use standalone ports without a Network ATC intent and are automatically configured on behalf of the user during the Azure Local deployment for disaggregated architectures.

- Two additional network ports can be used for an additional compute intent to carry over the in guest backup traffic if the deployment requires to backup application data inside the virtual machines over the network.

- In a disaggregated SAN Fiber Channel configuration, storage traffic runs entirely on the FC fabric, separate from the Ethernet network.

:::image type="content" source="media/plan-deployment/disaggregated-rack-layout-overview.svg" alt-text="Screenshot shows Azure Local disaggregated rack layout with 64 nodes across four racks" lightbox="media/plan-deployment/disaggregated-rack-layout-overview.svg":::

## Firewall requirements

Azure Local requires periodic connectivity to Azure. If your organization's outbound firewall is restricted, you would need to include firewall requirements for outbound endpoints and internal rules and ports. There are required and recommended endpoints for the Azure Local core components, which include system creation, registration and billing, Microsoft Update, and cloud witness.

See the [firewall requirements](/azure-stack/hci/concepts/firewall-requirements?tabs=allow-table) for a complete list of endpoints. Make sure to include these required URLS in your allowed list. Proper network ports need to be opened between all machines both within a site and between sites (for stretched clusters).

Azure Local connectivity validator of the [Environment Checker](https://www.powershellgallery.com/packages/AzStackHci.EnvironmentChecker/0.2.3-preview) tool, checks for the outbound connectivity requirement by default during deployment. Additionally, you can run the Environment Checker tool standalone before, during, or after deployment to evaluate the outbound connectivity of your environment.

A best practice is to have all relevant endpoints in a data file that can be accessed by the environment checker tool. The same file can also be shared with your firewall administrator to open up the necessary ports and URLs.

For more information, see [Firewall requirements](/azure-stack/hci/concepts/firewall-requirements?tabs=allow-table).

## Next steps

- [Choose a disaggregated network pattern ](choose-network-pattern-disaggregated.md) to review.
