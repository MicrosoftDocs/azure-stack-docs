---
title: Azure Local disaggregated deployment network reference patterns
description: Select a network reference pattern for disaggregated Azure Local deployments.
ms.topic: overview
author: alkohli
ms.author: cedward
ms.service: azure-local
ms.date: 04/13/2026
ms.subservice: hyperconverged
---

# Azure Local disaggregated deployment network reference patterns

[!INCLUDE [includes](../includes/hci-applies-to-23h2-22h2.md)]

This article describes a set of Azure Local disaggregated deployments network reference patterns to architect, deploy, and configure Azure Local when the storage is provided by an external SAN (storage area network). Depending on your needs or scenarios, you can go directly to your pattern of interest. Each pattern is described as a standalone entity and includes all the network components for specific scenarios.

## Choose a network reference pattern

Use the following table to directly go to a pattern and its content.

### Disaggregated with FC SAN without in guest backup network

**Go to [Disaggregated with FC SAN without in guest backup network](single-server-deployment.md)**

:::image type="content" source="./media/plan-deployment/disaggregated-fiber-channel-san-no-backup-host-networking.svg" alt-text="Diagram showing disaggregated FC SAN deployment without guest backup host networking pattern." lightbox="./media/plan-deployment/disaggregated-fiber-channel-san-no-backup-host-networking.svg":::

### Disaggregated with FC SAN with in guest backup network

**Go to [Disaggregated with FC SAN with in guest backup network](three-node-switchless-two-switches-single-link.md)**

:::image type="content" source="./media/plan-deployment/disaggregated-fiber-channel-san-with-backup-host-networking.svg" alt-text="Diagram showing disaggregated FC SAN deployment with guest backup host networking pattern." lightbox="./media/plan-deployment/disaggregated-fiber-channel-san-with-backup-host-networking.svg":::

## Next steps

- [Download Azure Local](../deploy/download-software.md).
