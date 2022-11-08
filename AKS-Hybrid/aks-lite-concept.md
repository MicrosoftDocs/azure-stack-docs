---
title: AKS on Windows concepts 
description: High-level concepts about AKS on Windows 
author: rcheeran
ms.author: rcheeran
ms.topic: conceptual
ms.date: 11/07/2022
ms.custom: template-concept
---

# AKS on Windows key concepts

This article discussed some important concepts in AKS lite.

## AKS on Windows workload types

When deploying AKS-IoT nodes you should specify the `-WorkloadType` parameter. This parameter indicates the types of workloads can run on this machine, and will tell AKS-IoT to create the corresponding VM. The possible values are “Linux”, “Windows”, or “LinuxAndWindows”. In this release, "Linux" is the only supported workload type.

> [!IMPORTANT]
> Kubernetes control plane components are in Linux, so the first node you deploy must include a Linux node.

## AKS on Windows networking

There are three key networking concepts for AKS-IoT that align with those for Kubernetes generally. They are described and the chart below shows how to configure them. This guide assumes that you have control over your network and router (i.e. in a home setting). If you are in a corporate environment, we recommend you ask your network administrator for a range of free IP addresses (from the same subnet) that are reachable on the internet, then follow the same steps as below.

- **Control plane endpoint**: The Kubernetes control plane will be reachable from this IP address. You must provide a single IP that is free throughout the lifetime of the cluster for the Kubernetes control plane.
- **Service IP range**: The Service IP range is a pool of reserved IP addresses used for allocating IP addresses to the Kubernetes services (your Kubernetes services/workloads) for your applications to be reachable.
- **VM IP**: In AKS-IoT, Kubernetes nodes are deployed as specialized virtual machines, which need IP addresses. You must assign free IPs to these VMs.

![Conceptual diagram showing networking architecture.](media/aks-lite/networking-single.png)

## External and internal switches

An **external virtual switch** connects to a wired, physical network by binding to a physical network adapter. It gives virtual machines access to a physical network to communicate with devices on an external network. In addition, it allows virtual machines on the same Hyper-V server to communicate with each other.

An **internal virtual switch** connects to a network that can be used only by the virtual machines running on the host that has the virtual switch, and between the host and the virtual machines.

## Next steps

- Try out the [Quickstart](aks-lite-quickstart.md)
- [Overview](aks-lite-overview.md)
- [Uninstall AKS cluster](aks-lite-howto-uninstall.md)
