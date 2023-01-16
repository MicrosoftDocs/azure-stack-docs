---
author: sethmanheim
ms.author: sethm
ms.service: azure-stack
ms.topic: include
ms.date: 10/18/2022
ms.reviewer: abha
ms.lastreviewed: 10/18/2022

# Overview of CSI file and driver functionality in AKS hybrid

---

The Container Storage Interface (CSI) is a standard for exposing arbitrary block and file storage systems to containerized workloads on Kubernetes. By using CSI, AKS hybrid can write, deploy, and iterate plug-ins to expose new storage systems. Using CSI can also improve existing ones<!--"ones" = plug-ins?--> in Kubernetes without having to touch the core Kubernetes code and then wait for its release cycles.

The disk and file CSI drivers used by AKS hybrid are [CSI specification](https://github.com/container-storage-interface/spec/blob/master/spec.md)-compliant drivers.

The CSI storage driver support on AKS hybrid allows you to use:

- AKS hybrid disks that you can use to create a Kubernetes *DataDisk* resource. These are mounted as *ReadWriteOnce*, so they're only available to a single pod at a time. For storage volumes that can be accessed by multiple pods simultaneously, use [AKS hybrid files](../container-storage-interface-files.md).<!--Can we make these assumptions, and simplify these bullets to "Files that..." and "Disks that...": 1) There is no such thing as an "AKS hybrid disk" or "AKS hybrid file." 2) The intro to the bullets sets the context as AKS hybrid.-->

- AKS hybrid files that you can use to mount an SMB or NFS share to pods. These are mounted as *ReadWriteMany*, so you can share data across multiple nodes and pods. They can also be mounted as *ReadWriteOnce* based on the PVC (persistent volume claim) specification.
