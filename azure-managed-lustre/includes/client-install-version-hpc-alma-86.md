---
author: pauljewellmsft
ms.author: pauljewell
ms.service: azure-stack
ms.topic: include
ms.date: 10/18/2024
ms.reviewer: dsundarraj
ms.lastreviewed: 10/18/2024
---

```bash
sudo dnf install --disableexcludes=main --refresh amlfs-lustre-client-2.15.7_33_g79ddf99-$(uname -r | sed -e "s/\.$(uname -p)$//" | sed -re 's/[-_]/\./g')-1
```

> [!NOTE]
> The metapackage version doesn't always align with the kernel version. Use the preceding command to install the proper metapackage.

If you want to upgrade *only* the kernel and not all packages, you must (at minimum) also upgrade the `amlfs-lustre-client` metapackage so that the Lustre client can continue to work after the restart. The command should look similar to the following example:

```bash
export NEWKERNELVERSION=6.7.8
sudo dnf upgrade kernel-$NEWKERNELVERSION amlfs-lustre-client-2.15.7_33_g79ddf99-$(echo $NEWKERNELVERSION | sed -e "s/\.$(uname -p)$//" | sed -re 's/[-_]/\./g')-1
```
