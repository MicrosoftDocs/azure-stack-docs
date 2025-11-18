---
title: Troubleshoot a Kubernetes Cluster node in Ready, Scheduling Disabled after Runtime Upgrade
description: Learn what to do when your Kubernetes Cluster node is in the Ready, Scheduling Disabled state after a runtime upgrade.
ms.service: azure-operator-nexus
ms.custom: troubleshooting
ms.topic: troubleshooting
ms.date: 11/18/2025
ms.author: ekarandjeff
author: eak13
---
# Troubleshoot a Kubernetes Cluster node in Ready, Scheduling Disabled state

The purpose of this guide is to troubleshoot a Kubernetes Cluster when 1 or more of its nodes fail to uncordon after a runtime upgrade. This guide is only applicable if that node remains in the state `Ready,SchedulingDisabled`.

## Prerequisites

- Ability to run kubectl commands against the Kubernetes Cluster
- Familiarity with the capabilities referenced in this article by reviewing [how to connect to Kubernetes Clusters](howto-kubernetes-cluster-connect.md)

## Typical Cause

During a Nexus Cluster runtime upgrade on a bare metal machine hosting Tenant workloads, the system cordons and drains the virtual machine resources scheduled to that bare metal machine. It then shuts down the bare metal machine to complete the reimaging process. Once the bare metal machine completes the runtime upgrade and reboots, the expectation is that the system reschedules virtual machines to that bare metal machine. It then uncordons the virtual machine, with the Kubernetes Cluster node that virtual machine supports reflecting the appropriate state `Ready`.

However, a race condition might occur wherein the system fails to find virtual machines that should be scheduled to that bare metal machine. Each virtual machine is deployed using a virt-launcher pod. This race condition happens when the virt-launcher pod's image pull job isn't yet complete. Pod scheduling to a bare metal machine occurs only when the image pull job is complete. When the system examines these virt-launcher pods during the uncordon action execution, it can't find which bare metal machine the pod. Therefore the system skips uncordoning that virtual machine that that pod represents.

## Procedure

After Kubernetes Cluster Nodes are discovered in the `Ready,SchedulingDisabled` state, use the following remediation actions.

1. List the nodes using `kubectl get` command with the `-o wide` flag. Observe the node in **Ready,SchedulingDisabled** status.

    ~~~bash
    $ kubectl get nodes -o wide
    NAME                                          STATUS                      ROLES           AGE    VERSION    INTERNAL-IP   EXTERNAL-IP   OS-IMAGE                    KERNEL-VERSION    CONTAINER-RUNTIME
    example-naks-control-plane-tgmw8              Ready,SchedulingDisabled    control-plane   2d6h   v1.30.12   10.4.32.10    <none>        Microsoft Azure Linux 3.0   6.6.85.1-2.azl3   containerd://2.0.0
    example-naks-agentpool1-md-s8vp4-xp98x        Ready,SchedulingDisabled    <none>          2d6h   v1.30.12   10.4.32.11    <none>        Microsoft Azure Linux 3.0   6.6.85.1-2.azl3   containerd://2.0.0
    ~~~

1. Uncordon the node in the undesired state by issuing `kubectl uncordon`.

    ~~~bash
    $ kubectl uncordon example-naks-agentpool1-md-s8vp4-xp98x
    node/example-naks-agentpool1-md-s8vp4-xp98x uncordoned
    ~~~

    Alternatively, the uncordon action can be performed in bulk. The bulk execution option is useful for large scale deployments where the issue occurs more frequently. Find and uncordon all affected Nodes using `kubectl uncordon` as part of a scripted loop.

    ~~~bash
    cordoned_nodes=$(kubectl get nodes -o wide --no-headers | awk '/SchedulingDisabled/ {print $1}')
    for node in $cordoned_nodes; do
        kubectl uncordon $node
    done
    ~~~


1. Use kubectl to list the nodes using the wide flag. Observe the node in **Ready** status.
    ~~~bash
    $ kubectl get nodes -o wide
    NAME                                          STATUS  ROLES           AGE    VERSION    INTERNAL-IP   EXTERNAL-IP   OS-IMAGE                    KERNEL-VERSION    CONTAINER-RUNTIME
    example-naks-control-plane-tgmw8              Ready   control-plane   2d6h   v1.30.12   10.4.32.10    <none>        Microsoft Azure Linux 3.0   6.6.85.1-2.azl3   containerd://2.0.0
    example-naks-agentpool1-md-s8vp4-xp98x        Ready   <none>          2d6h   v1.30.12   10.4.32.11    <none>        Microsoft Azure Linux 3.0   6.6.85.1-2.azl3   containerd://2.0.0
    ~~~

If you still have questions, [contact support](https://portal.azure.com/?#blade/Microsoft_Azure_Support/HelpAndSupportBlade).
For more information about Support plans, see [Azure Support plans](https://azure.microsoft.com/support/plans/response/).