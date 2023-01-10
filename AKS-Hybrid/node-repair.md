---
title: Node auto-repair in AKS hybrid
description: Learn about automatic node repair of Windows and Linux nodes in AKS hybrid.
author: sethmanheim
ms.topic: how-to
ms.date: 01/10/2023
ms.author: sethm 
ms.lastreviewed: 01/10/2023
ms.reviewer: oadeniji
# Intent: As an IT Pro, I need to learn how to automatically repair unhealthy nodes in order to avoid service disruptions.
# Keyword: unhealthy nodes service disruptions node repair auto-repair

---

# Node auto-repair in AKS hybrid

[!INCLUDE [applies-to-azure stack-hci-and-windows-server-skus](includes/aks-hci-applies-to-skus/aks-hybrid-applies-to-azure-stack-hci-windows-server-sku.md)]

To help minimize service disruptions for clusters, AKS hybrid continuously monitors the health state of worker nodes, and performs automatic node repair if issues arise or if they become unhealthy. In this article, you'll learn how AKS hybrid checks for unhealthy nodes and automatically repairs both Windows and Linux nodes. You'll also learn how to manually check node health.

## How AKS checks for unhealthy nodes

AKS hybrid uses the following rules to determine if a node is unhealthy and needs repair:

- The node reports a **NotReady** status on consecutive checks.
- The node doesn't report any status within 20-30 minutes.

You can manually check the health state of your nodes with `kubectl`, as shown below:

```powershell
kubectl get nodes
```

The status of the nodes should look similar to the following output.

```Output
NAME              STATUS   ROLES    AGE   VERSION
moc-l2tlqojhk2d   Ready    master   46h   v1.19.7
moc-l8h8i6lxk1h   Ready    <none>   46h   v1.19.7
moc-lqnjufwo2cy   Ready    master   46h   v1.19.7
moc-ltyl8mqy47z   Ready    <none>   47h   v1.19.7
moc-lwn5xnrapnj   Ready    master   47h   v1.19.7
moc-wvt025q406z   Ready    <none>   47h   v1.19.7
```

## How automatic repair works

If AKS hybrid identifies an unhealthy node that remains unhealthy for more than a couple of minutes, AKS hybrid takes the following actions:

1. Reboot the node.
2. If the reboot is unsuccessful, reimage the node.
3. If the reimage is unsuccessful, create and reimage a new node.

If AKS hybrid finds multiple unhealthy nodes during a health check, each node is repaired individually before another repair begins.

## Next steps

- [Application availability](./app-availability.md)
