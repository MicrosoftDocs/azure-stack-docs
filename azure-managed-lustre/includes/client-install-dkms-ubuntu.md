---
author: jebearer
ms.author: jebearer
ms.service: azure-stack
ms.topic: include
ms.date: 04/23/2026
ms.reviewer:
ms.lastreviewed: 04/23/2026
---

```bash
sudo apt install -y amlfs-lustre-client-dkms-2.15.8-35-gdf4872c
```

This metapackage installs the Lustre userspace tools (`lustre-client`) together with the DKMS module source package (`lustre-client-modules-dkms`), keeping them at matching versions.

The DKMS package automatically compiles the Lustre kernel module for your running kernel. Unlike the prebuilt kmod package, you don't need to match a specific kernel version — DKMS rebuilds the module automatically when your kernel is upgraded.

> [!NOTE]
> DKMS requires kernel headers, GCC, and Make to be installed. The package dependencies handle this automatically, but the initial install takes a few minutes while the kernel module compiles.
