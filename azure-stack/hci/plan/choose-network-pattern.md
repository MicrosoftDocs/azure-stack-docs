---
title: Azure Stack HCI deployment network reference patterns
description: Select a network reference pattern for single-server and two-node Azure Stack HCI deployments.
ms.topic: overview
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 07/20/2023
---

# Azure Stack HCI network deployment patterns

[!INCLUDE [includes](../../includes/hci-applies-to-22h2-21h2.md)]

This article describes a set of network patterns references to architect, deploy, and configure Azure Stack HCI using either one or two physical hosts. Depending on your needs or scenarios, you can go directly to your pattern of interest. Each pattern is described as a standalone entity and includes all the network components for specific scenarios.

## Choose a network reference pattern

Use the following table to directly go to a pattern and its content.

### Single-server deployment pattern

**Go to [single server deployment](single-server-deployment.md)**

:::image type="content" source="media/plan-deployment/single-server-deployment.png" alt-text="Diagram showing single-server deployment pattern." lightbox="media/plan-deployment/single-server-deployment.png":::

### Two-node deployment patterns

|Go to [storage switchless, single TOR switch](two-node-switchless-single-switch.md) |Go to [storage switchless, two TOR switches](two-node-switchless-two-switches.md)|
|---------|---------|
|:::image type="content" source="media/plan-deployment/two-node-switchless-single-switch.png" alt-text="Diagram showing two-node storage switchless with single TOR switch." lightbox="media/plan-deployment/two-node-switchless-single-switch.png":::|:::image type="content" source="media/plan-deployment/two-node-switchless-two-switches.png" alt-text="Diagram showing two-node storage switchless with two TOR switches." lightbox="media/plan-deployment/two-node-switchless-two-switches.png":::|

|Go to [storage switched, non-converged, two TOR switches](two-node-switched-non-converged.md)    |Go to [storage switched, fully converged, two TOR switches.](two-node-switched-converged.md)       |
|---------|---------|
|:::image type="content" source="media/plan-deployment/two-node-switched-non-converged.png" alt-text="Diagram showing two-node storage switched, non-converged, two TOR switches" lightbox="media/plan-deployment/two-node-switched-non-converged.png":::|:::image type="content" source="media/plan-deployment/two-node-switched-converged.png" alt-text="Diagram showing two-node storage switched, fully converged, two TOR switches." lightbox="media/plan-deployment/two-node-switched-converged.png":::|

## Next steps

- [Download Azure Stack HCI](../deploy/download-azure-stack-hci-software.md)