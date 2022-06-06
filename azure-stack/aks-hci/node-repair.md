---
title: Node auto-repair on Azure Kubernetes Service on Azure Stack HCI and Windows Server
description: Learn about automatic node repair on AKS on Azure Stack HCI and Windows Server Windows and Linux nodes.
author: sethmanheim
ms.topic: how-to
ms.date: 04/27/2022
ms.author: sethm 
ms.lastreviewed: 1/14/2022
ms.reviewer: oadeniji
# Intent: As an IT Pro, I need to learn how to automatically repair unhealthy nodes in order to avoid service disruptions.
# Keyword: unhealthy nodes service disruptions node repair auto-repair

---

# Node auto-repair on Azure Kubernetes Service on Azure Stack HCI and Windows Server

Azure Kubernetes Service (AKS) on Azure Stack HCI and Windows Server continuously monitors the health state of worker nodes and performs automatic node repair if issues arise or if they become unhealthy. AKS on Azure Stack HCI and Windows Server works to minimize service disruptions for clusters.

In this topic, you will learn how to automatically repair nodes for both Windows and Linux nodes.

## How AKS checks for unhealthy nodes

AKS on Azure Stack HCI and Windows Server uses the following rules to determine if a node is unhealthy and needs repair:

- The node reports a **NotReady** status on consecutive checks. 
- The node does not report any status within a couple of minutes.

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

If AKS on Azure Stack HCI and Windows Server identifies an unhealthy node that remains unhealthy for more than a couple of minutes, AKS on Azure Stack HCI and Windows Server takes the following actions:

1. Reboot the node.
2. If the reboot is unsuccessful, reimage the node.
3. If the reimage is unsuccessful, create and reimage a new node.

If AKS on Azure Stack HCI and Windows Server finds multiple unhealthy nodes during a health check, each node is repaired individually before another repair begins.

## Next steps

- [Application availability](./app-availability.md)
