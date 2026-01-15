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
sudo yum install amlfs-lustre-client-2.15.4_42_gd6d405d-$(uname -r | sed -e "s/\.$(uname -p)$//" | sed -re 's/[-_]/\./g')-1
```

> [!NOTE]
> Running `dnf search amlfs-lustre-client` doesn't show all available packages for your distribution. To see all available `amlfs-lustre-client` packages, run `dnf list --showduplicates "amlfs-lustre-client*"`.

If you want to upgrade *only* the kernel and not all packages, you must (at minimum) also upgrade the `amlfs-lustre-client` metapackage so that the Lustre client can continue to work after the restart. The command should look similar to the following example:

```bash
export NEWKERNELVERSION=6.7.8
sudo yum upgrade kernel-$NEWKERNELVERSION amlfs-lustre-client-2.15.4_42_gd6d405d-$(echo $NEWKERNELVERSION | sed -e "s/\.$(uname -p)$//" | sed -re 's/[-_]/\./g')-1
```
