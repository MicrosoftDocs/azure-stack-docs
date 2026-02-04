---
title: Optimize Azure Managed Lustre performance
description: Learn how to optimize Azure Managed Lustre (AMLFS) performance with recommended network configuration, including accelerated networking, availability zone placement, and routing.
ms.date: 02/04/2026
ms.topic: reference
author: wolfgang-desalvador
ms.author: wolfgang-desalvador
ms.service: azure-managed-lustre
---

# Optimize Azure Managed Lustre performance

This reference describes how network configuration for your client virtual machines (VMs) and file system affects Azure Managed Lustre (AMLFS) performance.

Network throughput and latency between AMLFS and your clients directly affects job completion times. To get predictable, high performance, use the following design principles:

- Client VMs use accelerated networking.
- AMLFS and client VMs are placed in the same availability zone in region supporting Availability Zones.
- Network routing between clients and AMLFS is as direct as possible, with minimal or no extra hops in the data path.

## Environment assumptions

These recommendations assume the following environment:

- An Azure Managed Lustre file system deployed in a virtual network (VNet).
- One or more Linux client VMs that meet the [AMLFS prerequisites](amlfs-prerequisites.md).
- The Lustre client installed and mounted, as described in [Install Lustre client](client-install.md) and [Connect client to the file system](connect-clients.md).

## Accelerated networking requirements

Accelerated networking uses single root I/O virtualization (SR-IOV) to deliver higher throughput, lower latency, and reduced jitter compared to basic network adapters. For I/O intensive AMLFS workloads, Microsoft strongly recommends enabling accelerated networking on all client VMs. For more background, see [Azure Accelerated Networking overview](/azure/virtual-network/accelerated-networking-overview).

Plan client VMs for AMLFS as follows:

- Priotize VM sizes that support accelerated networking. This is the case for all the HPC/AI VM sizes on Azure.
- Enable accelerated networking when you create the network interface, or update the interface with accelerated networking enabled if the VM size supports it. For step-by-step options in the portal, Azure CLI, and PowerShell, see [Manage accelerated networking for Azure Virtual Machines](/azure/virtual-network/manage-accelerated-networking).
- When you deploy client VMs by using Azure CLI, Bicep, Terraform, or ARM templates, configure the network interfaces so that accelerated networking is enabled by default.
- When you provision client pools through orchestrators such as [Azure CycleCloud](/azure/cyclecloud/overview), [Azure Batch](/azure/batch/batch-technical-overview), or [Azure Kubernetes Service (AKS)](/azure/aks/intro-kubernetes), ensure that node pool or VM definitions specify VM sizes and NIC settings that support and enable accelerated networking.

You can validate that accelerated networking is enabled on a client VM by:

- In the Azure portal, open the network interface resource and confirm that **Accelerated networking** is set to **Enabled**.
- On the VM, verify that the network interface is using the accelerated network driver according to your distribution documentation.

For more options to confirm the setting from scripts or command-line tools, see [Confirm that Accelerated Networking is enabled](/azure/virtual-network/create-vm-accelerated-networking-cli?tabs=windows#confirm-that-accelerated-networking-is-enabled).

Enabling accelerated networking on all AMLFS clients helps maximize per-node throughput and reduces CPU overhead for network processing, which is important for highly parallel Lustre workloads.

## Availability zone considerations

In regions that support availability zones, AMLFS is always deployed into a specific availability zone. Align client VM placement with the AMLFS zone to minimize latency and avoid cross-zone traffic. For an overview of availability zones in Azure, see [Availability zones overview](/azure/reliability/availability-zones-overview).

Follow these guidelines:

- When you deploy client VMs, place them in the same availability zone as the AMLFS file system.
- Avoid designs where clients in one zone primarily access AMLFS in another zone, because cross-zone traffic can add latency.
- For large clusters, group clients by workload or job type and keep each group in the same zone as the AMLFS instance they use.

If you must span multiple zones for resiliency or operational reasons and the cross-zone latency is degrading performance, consider:

- Keeping latency-sensitive or bandwidth-intensive jobs in the same zone as AMLFS.
- Using additional AMLFS instances in other zones to localize data access for separate workloads.

To check which VM sizes are available in each availability zone for a given region, use the Azure CLI or PowerShell guidance in [Check VM SKU availability](/azure/virtual-machines/linux/create-cli-availability-zone#check-vm-sku-availability).

## Network topology considerations

Every extra network hop between your client VMs and AMLFS can add latency, reduce throughput, and introduce jitter. For best performance, deploy AMLFS and client VMs in the same virtual network and use direct routing between subnets, without additional network virtual appliances or intermediate hops on the data path. If you use user-defined routes (UDRs) in the VNet, make sure they don't override the system routes between client subnets and the AMLFS subnet so that Lustre traffic stays on the direct path.

## Next steps

In this article, you learned how to optimize AMLFS performance by optimizing network configuration, availability zone placement, and routing.

To further optimize your deployment, see:

- [Optimize file and directory layouts](optimize-file-layouts.md)
- [Monitor a file system](monitor-file-system.md)
