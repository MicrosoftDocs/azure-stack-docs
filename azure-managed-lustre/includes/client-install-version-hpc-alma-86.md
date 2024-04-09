---
author: pauljewellmsft
ms.author: pauljewell
ms.service: azure-stack
ms.topic: include
ms.date: 02/15/2024
ms.reviewer: dsundarraj
ms.lastreviewed: 02/15/2024
---

```bash
sudo dnf install --disableexcludes=main --refresh amlfs-lustre-client-2.15.4_42_gd6d405d-$(uname -r | sed -e "s/\.$(uname -p)$//" | sed -re 's/[-_]/\./g')-1
```

> [!NOTE]
> The metapackage version does not always align with the kernel version. Use the install command above to install the proper metapackage.

If you want to upgrade *only* the kernel and not all packages, you must, at minimum, also upgrade the **amlfs-lustre-client** metapackage in order for the Lustre client to continue to work after the reboot. The command should look similar to the following example:

```bash
export NEWKERNELVERSION=6.7.8
sudo dnf upgrade kernel-$NEWKERNELVERSION amlfs-lustre-client-2.15.4_42_gd6d405d-$(echo $NEWKERNELVERSION | sed -e "s/\.$(uname -p)$//" | sed -re 's/[-_]/\./g')-1
```
