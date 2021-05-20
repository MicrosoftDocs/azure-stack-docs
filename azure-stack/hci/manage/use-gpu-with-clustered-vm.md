---
title: Use GPUs with clustered VMs
description: This topic provides guidance on how to use GPUs with clustered virtual machines (VMs) running the Azure Stack HCI operating system to provide GPU acceleration to workloads running in the clustered VMs.
author: rick-man
ms.author: rickman
ms.topic: how-to
ms.date: 05/25/2021
---

# Use GPUs with clustered VMs

>Applies to: Azure Stack HCI, version 21H2 Public Preview

This topic provides guidance on how to use graphics processing units (GPUs) with clustered virtual machines (VMs) running the Azure Stack HCI operating system to provide GPU acceleration to workloads running in the clustered VMs.

Starting in Azure Stack HCI, version 21H2, you can include GPUs in your Azure Stack HCI cluster to provide GPU acceleration to workloads running in clustered VMs. This topic covers the basic prerequisites of this capability and how to deploy it.

GPU acceleration is provided via Discrete Device Assignment (DDA), also known as GPU pass-through, which allows you to dedicate one or more physical GPUs to a VM. Clustered VMs can take advantage of GPU acceleration, as well as clustering capabilities such as high availability via failover. Live migration is not currently supported, but VMs can be automatically restarted and placed where GPU resources are available in the event of a failure.

## Prerequisites
TBD





## Usage instructions
TBD





### Prepare the cluster
TBD




### Assign a VM to a GPU resource pool
TBD




<!---Example note format.--->
   >[!NOTE]
   > TBD.




## Next steps
For more information, see also:
- [Manage VMs with Windows Admin Center](vm.md)
- [Plan for deploying devices using Discrete Device Assignment](/windows-server/virtualization/hyper-v/plan/plan-for-deploying-devices-using-discrete-device-assignment)
