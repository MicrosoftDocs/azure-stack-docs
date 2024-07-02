---
title:  Migrate an existing Azure Stack HCI cluster to Network ATC
description: This article describes how to migrate an existing Azure Stack HCI cluster to Network ATC
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.reviewer: alkohli
ms.lastreviewed: 07/02/2024
ms.date: 07/02/2024
---

# Migate an existing cluster to Network ATC

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article provides information on how to migrate your existing Azure Stack HCI cluster to Network ATC to that you can take advantage of several benefits. We'll also share how to utilize this configuration across all new deployments.

## About Network ATC

Network ATC stores information in the cluster database which is then replicated to other nodes in the cluster. From the initial node, other nodes in the cluster see the change in the cluster database and create a new intent. Here, we set up the cluster to receive a new intent. Additionally, we control the rollout of the new intent by stopping or disabling the Network ATC service on nodes that have virtual machines (VM) on them.

## Before you begin

Before you begin the migration process of your existing Azure Stack HCI cluster to Network ATC, make sure:

- You're on a host without a running VM on it.
- You're on a cluster with running workloads on the node.

> [!NOTE]
> If you don't have running workloads on your nodes, just add your intent command as if this was a brand-new cluster. You don't need to continue with the next set of instructions.

## Steps to Migrate to Network ATC

### Step 1: Install Network ATC

In this step you'll install Network ATC on every node in the cluster, using the following command. No reboot is required.
