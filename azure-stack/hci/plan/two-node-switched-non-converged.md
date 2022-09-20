---
title: Azure Stack HCI two-node storage switched, non-converged deployment network reference pattern
description: Plan to deploy an Azure Stack HCI two-node storage switched, non-converged network reference pattern.
ms.topic: conceptual
author: dansisson
ms.author: v-dansisson
ms.reviewer: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 09/19/2022
---

# Review two-node storage switched, non-converged deployment network reference pattern for Azure Stack HCI

> Applies to: Azure Stack HCI, version 21H2, Azure Stack HCI, version 22H2 (preview)

In this article, you'll learn about the two-node storage switched, non-converged with two TOR switches network reference pattern that you can use to deploy your Azure Stack HCI solution. The information in this article will also help you determine if this configuration is viable for your deployment planning needs. This article is targeted towards the IT administrators who deploy and manage Azure Stack HCI in their datacenters.

For information on other network patterns, see [Azure Stack HCI network deployment patterns](choose-network-pattern.md).

## Scenarios

## Physical connectivity components

:::image type="content" source="media/two-node-switched-non-converged/physical-components-layout.png" alt-text="Diagram showing two-node switchless physical connectivity layout" lightbox="media/two-node-switched-non-converged/physical-components-layout.png":::

## Network ATC intents

:::image type="content" source="media/two-node-switched-non-converged/network-atc.png" alt-text="Diagram showing two-node switchless Network ATC intents" lightbox="media/two-node-switched-non-converged/network-atc.png":::

## Logical connectivity components

:::image type="content" source="media/two-node-switched-non-converged/logical-components-layout.png" alt-text="Diagram showing single-node switchless physical connectivity layout" lightbox="media/two-node-switched-non-converged/logical-components-layout.png":::

[!INCLUDE [includes](includes/two-node-include.md)]

## Next steps

Learn about the [two-node storage switched, fully-converged network pattern](two-node-switched-converged.md).