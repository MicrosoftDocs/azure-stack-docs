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

This article helps you choose a network reference pattern for disaggregated Azure Local deployments where storage is provided by an external Storage Area Network (SAN). Each pattern is described as a standalone article and includes all the network components for that specific scenario.

For an overview of the leaf-spine fabric architecture, traffic flow, and key concepts, see [Network reference patterns overview for disaggregated deployments](network-patterns-overview-disaggregated.md).

## Choose a network reference pattern

Use the following sections to go directly to your pattern of interest.

### Disaggregated with Fiber Channel (FC) SAN without backup network

**Go to [Fiber Channel disaggregated pattern without backup network](fiber-channel-no-backup-disaggregated-pattern.md)**

:::image type="content" source="./media/plan-deployment/disaggregated-fiber-channel-san-no-backup-host-networking.svg" alt-text="Diagram showing disaggregated Fiber Channel SAN deployment without backup host networking pattern." lightbox="./media/plan-deployment/disaggregated-fiber-channel-san-no-backup-host-networking.svg":::

### Disaggregated with Fiber Channel (FC) SAN with backup network

**Go to [Fiber Channel disaggregated pattern with backup network](fiber-channel-with-backup-disaggregated-pattern.md)**

:::image type="content" source="./media/plan-deployment/disaggregated-fiber-channel-san-with-backup-host-networking.svg" alt-text="Diagram showing disaggregated Fiber Channel SAN deployment with backup host networking pattern." lightbox="./media/plan-deployment/disaggregated-fiber-channel-san-with-backup-host-networking.svg":::

## Next steps

- Learn about the [leaf-spine fabric architecture](network-patterns-overview-disaggregated.md) before choosing a pattern.
