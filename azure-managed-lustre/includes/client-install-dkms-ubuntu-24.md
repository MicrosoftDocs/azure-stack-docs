---
author: jebearer
ms.author: jebearer
ms.service: azure-stack
ms.topic: include
ms.date: 04/23/2026
ms.reviewer:
ms.lastreviewed: 04/23/2026
---

> [!NOTE]
> 2.16 is a non-LTS release of Lustre. Community support ends soon after the 2.17 release.

```bash
sudo apt install -y amlfs-lustre-client-dkms-2.16.1-22-g584eedc
```

This metapackage installs the Lustre userspace tools (`lustre-client`) together with the DKMS module source package (`lustre-client-modules-dkms`), so they stay at matching versions.

The DKMS package automatically compiles the Lustre kernel module for your running kernel. Unlike the prebuilt kmod package, you don't need to match a specific kernel version. DKMS rebuilds the module automatically when your kernel is upgraded.

> [!NOTE]
> DKMS requires kernel headers, GCC, and Make to be installed. The package dependencies handle this requirement automatically, but the initial install takes a few minutes while the kernel module compiles.
