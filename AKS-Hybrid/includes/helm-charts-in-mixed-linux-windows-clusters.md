---
author: sethmanheim
ms.author: sethm
ms.service: azure-stack
ms.topic: include
ms.date: 10/25/2022
ms.reviewer: abha
ms.lastreviewed: 10/24/2022

# Guidance to ensure Helm charts install on Linux nodes in a cluster with a mix of Linux and Windows nodes

---

Helm is intended to run on Linux nodes. If your cluster has Windows Server nodes, you must ensure that Helm pods are scheduled to run only on Linux nodes. You also need to ensure that any Helm charts you install are scheduled to run on the correct nodes. The commands in this article use [node-selectors](../adapt-apps-mixed-os-clusters.md#node-selector) to make sure pods are scheduled to the correct nodes, but not all Helm charts will expose a node selector. You can also use other options, such as [taints](../adapt-apps-mixed-os-clusters.md#taints-and-tolerations), on your cluster.