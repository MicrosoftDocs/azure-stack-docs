---
title: AKS Edge Essentials concepts 
description: High-level concepts about AKS Edge Essentials 
author: rcheeran
ms.author: rcheeran
ms.topic: conceptual
ms.date: 12/05/2022
ms.custom: template-concept
---

# AKS Edge Essentials key concepts

This article discussed some important concepts in AKS Edge Essentials.

## Virtual machine nodes

When you create an AKS Edge Essentials deployment, AKS Edge Essentials first creates a virtual machine for each of the nodes.

![Screenshot showing the the VMs in AKS Edge.](./media/aks-edge/aks-edge-vm.png)

Note the following points:

- You can only create one Linux VM on a given host machine. This Linux VM can act as both the control plane node and as a worker node based on your deployment needs.
- Running a Windows node is optional and you can create a Windows node if you need to deploy Windows containers.
- You can define the amount of CPU and memory resources that you'd like to allocate for each of the VMs. This static allocation enables you to control how resources are used and ensures that applications running on the host have the required resources.
- AKS Edge doesn't offer dynamic creation of virtual machines. If a VM goes down, you have to recreate it. That said, if you have a full deployment with multiple control plane nodes and worker nodes, if a VM goes down, Kubernetes moves workloads to an active node.

## Networking

There are three key networking concepts for AKS Edge Essentials that align with Kubernetes concepts. They're described in this article, and the table shows how to configure them. This guide assumes that you have control over your network and router (that is, in a home setting). If you are in a corporate environment, we recommend you ask your network administrator for a range of free IP addresses (from the same subnet) that 's reachable on the internet, then follow the same steps as below.

- **Control plane endpoint**: The Kubernetes control plane will be reachable from this IP address. You must provide a single IP that is free throughout the lifetime of the cluster for the Kubernetes control plane.
- **Service IP range**: The Service IP range is a pool of reserved IP addresses used for allocating IP addresses to the Kubernetes services (your Kubernetes services/workloads) for your applications to  be reachable.
- **VM IP**: In AKS Edge Essentials, Kubernetes nodes are deployed as specialized virtual machines, which need IP addresses. You must assign free IPs to these VMs.

:::image type="content" source="media/aks-edge/networking-single.png" alt-text="Conceptual diagram showing network architecture." lightbox="media/aks-edge/networking-single.png":::

## Network switches in single machine clusters and full-deployments

A full deployment that is scalable across different machines uses an **external virtual switch**. An external virtual switch connects to a wired, physical network by binding to a physical network adapter. It gives virtual machines access to a physical network to communicate with devices on an external network. In addition, it allows virtual machines on the same Hyper-V server to communicate with each other.

A single machine deployment uses an **internal virtual switch**. An internal virtual switch connects to a network that can be used only by the virtual machines running on the host that has the virtual switch, and between the host and the virtual machines.

## Node types

When deploying AKS Edge Essentials nodes, you should specify the `-NodeType` parameter. This parameter indicates the types of workloads can run on this machine, and will tell AKS Edge Essentials to create the corresponding VM. The possible values are "Linux", "Windows", or "LinuxAndWindows".

> [!IMPORTANT]
> Kubernetes control plane components are in Linux, so the first node you deploy must include a Linux node.

## Next steps

- [Overview](aks-edge-overview.md)
- [Uninstall AKS cluster](aks-edge-howto-uninstall.md)
