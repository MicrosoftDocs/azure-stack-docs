---
title: Server requirements for Azure Stack HCI
description: How to choose servers for Azure Stack HCI.
author: khdownie
ms.author: v-kedow
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 10/15/2020
---

# Server requirements for Azure Stack HCI

> Applies to: Azure Stack HCI, version 20H2

A standard Azure Stack HCI cluster requires a minimum of two servers and a maximum of 16 servers; however, clusters can be combined using cluster sets to create an HCI platform of hundreds of nodes.

## Considerations and recommendations

Keep the following in mind for various types of Azure Stack HCI deployments.

- Stretched clusters require servers to be deployed at two separate sites. The sites can be in different countries, different cities, different floors, or different rooms. A stretched cluster requires a minimum of 4 servers (2 per site) and a maximum of 16 servers (8 per site).

- It's recommended that all servers be the same manufacturer and model, using 64-bit Intel Nehalem grade, AMD EPYC grade, or later compatible processors with second-level address translation (SLAT). A second-generation Intel Xeon Scalable processor is required to support Intel Optane DC persistent memory. Processors must be at least 1.4 GHz and compatible with the x64 instruction set.

- Make sure that the servers are equipped with at least 32 GB of RAM per node to accommodate the server operating system, VMs, and other apps or workloads. In addition, allow 4 GB of RAM per terabyte (TB) of cache drive capacity on each server for Storage Spaces Direct metadata.

- Verify that virtualization support is turned on in the BIOS or UEFI:
    - Hardware-assisted virtualization. This is available in processors that include a virtualization option, specifically processors with Intel Virtualization Technology (Intel VT) or AMD Virtualization (AMD-V) technology.
    - Hardware-enforced Data Execution Prevention (DEP) must be available and enabled. For Intel systems, this is the XD bit (execute disable bit). For AMD systems, this is the NX bit (no execute bit).

- You can use any boot device supported by Windows Server, which [now includes SATADOM](https://cloudblogs.microsoft.com/windowsserver/2017/08/30/announcing-support-for-satadom-boot-drives-in-windows-server-2016/). RAID 1 mirror is **not** required, but is supported for boot. A 200 GB minimum size is recommended.

- For additional feature-specific requirements for Hyper-V, see [System requirements for Hyper-V on Windows Server](/windows-server/virtualization/hyper-v/system-requirements-for-hyper-v-on-windows).

- ## Next steps

For related information, see also:

- [Networking requirements for Azure Stack HCI](networking-requirements.md)
- [Storage requirements for Azure Stack HCI](storage-requirements.md)
