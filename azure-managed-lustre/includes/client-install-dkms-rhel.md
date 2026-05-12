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
sudo dnf install -y lustre-client-dkms-2.15.8_35_gdf4872c
```

This DKMS package automatically pulls in the matching Lustre userspace tools package (`lustre-client`) as a dependency, so a single `dnf install` command gives you both the module source and the userspace tools.

The DKMS package automatically compiles the Lustre kernel module for your running kernel. Unlike the prebuilt kmod package, you don't need to match a specific kernel version or use `sed` to transform the kernel version string — DKMS rebuilds the module automatically when your kernel is upgraded.

> [!NOTE]
> DKMS requires kernel headers (`kernel-devel`), GCC, and Make to be installed. The package dependencies handle this automatically, but the initial install takes a few minutes while the kernel module compiles.
