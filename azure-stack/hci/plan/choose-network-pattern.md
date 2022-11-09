---
title: Azure Stack HCI deployment network reference patterns
description: Select a network reference pattern for single-server and two-node Azure Stack HCI deployments.
ms.topic: overview
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 11/10/2022
---

# Azure Stack HCI network deployment patterns

[!INCLUDE [includes](../../includes/hci-applies-to-22h2-21h2.md)]

This article describes a set of network patterns references to architect, deploy, and configure Azure Stack HCI using either one or two physical hosts. Depending on your needs or scenarios, you can go directly to your pattern of interest. Each pattern is described as a standalone entity and includes all the network components for specific scenarios.

## Choose a network reference pattern

Use the following table to directly go to a pattern and its content.

### Single-server deployment pattern

**Go to [single server deployment](single-server-deployment.md)**

![Diagram showing single-server deployment pattern](media/plan-deployment/single-server-deployment.png)

### Two-node deployment patterns

|Go to [storage switchless, single TOR switch](two-node-switchless-single-switch.md) |Go to [storage switchless, two TOR switches](two-node-switchless-two-switches.md)|
|---------|---------|
|![Diagram showing two-node storage switchless with single TOR switch](media/plan-deployment/two-node-switchless-single-switch.png) | ![Diagram showing two-node storage switchless with two TOR switches](media/plan-deployment/two-node-switchless-two-switches.png)|

|Go to [storage switched, non-converged, two TOR switches](two-node-switched-non-converged.md)    |Go to [storage switched, fully-converged, two TOR switches](two-node-switched-converged.md)       |
|---------|---------|
|![Diagram showing two-node storage switched, non-converged, two TOR switches ](media/plan-deployment/two-node-switched-non-converged.png)| ![Diagram showing two-node storage switched, fully converged, two TOR switches ](media/plan-deployment/two-node-switched-converged.png)|

## Next steps

- [Download Azure Stack HCI](https://azure.microsoft.com/products/azure-stack/hci/hci-download/)