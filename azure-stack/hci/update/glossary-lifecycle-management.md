---
title:  Glossary for Lifecycle Management.
description: This article describes the glossary of terms and progress actions for the Lifecycle Manager.
author: ronmiab
ms.author: robess
ms.topic: reference
ms.reviewer: aaronfa
ms.lastreviewed: 04/05/2023
ms.date: 04/05/2023
---

# Glossary for Lifecycle Management

> Applies to: Azure Stack HCI, Supplemental Package

This article describes the glossary terms and progress actions associated with the Lifecycle Manager.

## Glossary

| Term                                   | Definition  | Notes     |
|----------------------------------------|-------------|-----------|
| Azure Arc                              |             |           |
| Azure Kubernetes Service (AKS)         |             |           |
| Bundle                                 |             |           |
| Hotfixes                               |             |           |
| Hotpatches                             |             |           |
| Latest Cumulative Update               |             |           |
| Lifecycle Manager                      |             |           |
| Original Equipment Manufacturer (OEM)  |             |           |
| Package                                |             |           |
| Platform                               |             |           |
| Solution Builder Extension (SBE)       |             |           |
| Software-defined Networking (SDN)      |             |           |
| Solution                               |             |           |
| Windows Admin Center                   |             |           |

## Progress actions

The Lifecycle Manager updates its own agents to ensure it has the recent fixes corresponding to the update. Here are the steps taken by the Lifecycle Manager to achieve a successful update of its agents:

1. First, steps referred to as the "servicing stack" are performed.

    - Prepare the servicing stack.
    - Update the servicing stack.
    - Copy the servicing stack agents.
    - Use the latest servicing stack agents.

2. After the servicing stack is updated, the Lifecycle Manager will install new agents and services.

3. Once the new agents and services have been installed, the host OS is updated.

   > [!NOTE]
   > For step #3, updating the host OS uses Cluster-Aware Updating to orchestrate reboots.

4. If the update includes Solution Extension content from the Solution Builder, it's installed last with the use of Cluster-Aware Updating.
