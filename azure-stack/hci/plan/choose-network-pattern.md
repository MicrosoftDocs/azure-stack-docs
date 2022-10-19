---
title: Azure Stack HCI deployment patterns
description: Azure Stack HCI deployment patterns for single node and two node clusters
ms.topic: overview
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 10/19/2022
---

# Azure Stack HCI network deployment patterns

> > Applies to: Azure Stack HCI, version 21H2; Azure Stack HCI, version 22H2 (preview)

This article describes a set of network patterns references to architect, deploy, and configure Azure Stack HCI with either one or two physical hosts (nodes).

The article includes five different deployment patterns. Depending on your needs or scenarios, you can go directly to your pattern of interest. Each pattern is described as a standalone entity and includes all the network components for specific scenarios.

## Choose a network reference pattern

Use the following table to directly go to a pattern and its content.

### Single-server deployment pattern

**Go to [single server deployment](single-server-switchless.md)**

![Diagram showing single-server deployment pattern](media/plan-deployment/single-server-switchless.png)

### Two-node deployment patterns

|Go to [storage switchless, single TOR switch](two-node-switchless-single-switch.md) |Go to [storage switchless, two TOR switches](two-node-switchless-two-switches.md)|
|---------|---------|
|![Diagram showing two-node storage switchless with single TOR switch](media/plan-deployment/two-node-switchless-single-switch.png) | ![Diagram showing two-node storage switchless with two TOR switches](media/plan-deployment/two-node-switchless-two-switches.png)|

|Go to [storage switched, non-converged, two TOR switches](two-node-switched-non-converged.md)    |Go to [storage switched, fully-converged, two TOR switches](two-node-switched-converged.md)       |
|---------|---------|
|![Diagram showing two-node storage switched, non-converged, two TOR switches ](media/plan-deployment/two-node-switched-non-converged.png)| ![Diagram showing two-node storage switched, fully converged, two TOR switches ](media/plan-deployment/two-node-switched-converged.png)|

## Next steps

- [Download Azure Stack HCI](https://azure.microsoft.com/products/azure-stack/hci/hci-download/)