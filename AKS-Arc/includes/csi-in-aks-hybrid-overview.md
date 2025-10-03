---
author: sethmanheim
ms.author: sethm
ms.service: azure-kubernetes-service-hybrid
ms.topic: include
ms.date: 07/03/2025
ms.reviewer: abha
ms.lastreviewed: 10/18/2022

# Overview of CSI file and driver functionality in AKS enabled by Azure Arc

---

The Container Storage Interface (CSI) is a standard for exposing arbitrary block and file storage systems to containerized workloads on Kubernetes. By using CSI, AKS enabled by Arc can write, deploy, and iterate plug-ins to expose new storage systems. CSI can also improve existing ones in Kubernetes without having to touch the core Kubernetes code and then wait for its release cycles.

The disk and file CSI drivers used by AKS Arc are [CSI specification](https://github.com/container-storage-interface/spec/blob/master/spec.md)-compliant drivers.

The CSI storage driver support on AKS Arc allows you to use:

- AKS Arc disks that you can use to create a Kubernetes *DataDisk* resource. These are mounted as *ReadWriteOnce*, so they're only available to a single pod at a time. For storage volumes that can be accessed by multiple pods simultaneously, use [AKS Arc files](../container-storage-interface-files.md).

- AKS Arc files that you can use to mount an SMB or NFS share to pods. These are mounted as *ReadWriteMany*, so you can share data across multiple nodes and pods. They can also be mounted as *ReadWriteOnce* based on the PVC (persistent volume claim) specification.
