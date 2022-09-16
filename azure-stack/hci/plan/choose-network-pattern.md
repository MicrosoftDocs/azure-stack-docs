---
title: Azure Stack HCI deployment patterns
description: Azure Stack HCI deployment patterns for single node and two node clusters
ms.topic: overview
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 09/16/2022
---

# Azure Stack HCI network deployment patterns

> > Applies to: Azure Stack HCI, version 22H2 (preview)

This article describes a set of network patterns references to architect, deploy, and configure Azure Stack HCI, version 22H2 with either one or two physical hosts.

The article includes six different deployment patterns. Depending on your needs or scenarios, you can go directly to your pattern of interest. Each pattern is described as a standalone entity and includes all the network components for specific scenarios.

## Choose a network reference pattern

Use the following table to directly go to a pattern and its content.

### Single-node deployment patterns

|Storage switchless |Storage switched|
|---------|---------|
|![Storage switchless - need to replace](media/plan-deployment/storage-switchless-one-tor-switch.png)<br>[Go to this pattern](single-node-switchless.md)     | ![Storage switched - need to replace](media/plan-deployment/storage-switchless-two-tor-switch.png)<br>[Go to this pattern](single-node-switched.md)         |

### Two-node deployment patterns

|Storage switchless, single TOR switch |Storage switched, two TOR switches  |
|---------|---------|
|![Storage switchless with single TOR switch](media/plan-deployment/storage-switched-non-converged-two-tor-switch.png)<br>[Go to this pattern](two-node-switchless-single-switch.md)      | ![Storage switchless with two TOR switches](media/plan-deployment/storage-switched-fully-converged-two-tor-switch.png)<br>[Go to this pattern](two-node-switchless-two-switches.md)        |

|Storage switched, non-converged, two TOR switches    | Storage switched, fully-converged, two TOR switches        |
|---------|---------|
|![Storage switched, non converged, two TOR switches ](media/plan-deployment/storage-switchless-one-tor-switch.png)<br>[Go to this pattern](two-node-switched-non-converged.md)        | ![Storage switched, fully converged, two TOR switches ](media/plan-deployment/storage-switchless-two-tor-switch.png)<br>[Go to this pattern](two-node-switched-converged.md)         |

## Next steps

- [Download Azure Stack HCI](https://azure.microsoft.com/products/azure-stack/hci/hci-download/)