---
author: jebearer
ms.author: jebearer
ms.service: azure-stack
ms.topic: include
ms.date: 10/20/2026
ms.reviewer:
ms.lastreviewed: 09/11/2026
---

```bash
sudo dnf install amlfs-lustre-client-2.17.0_28_gc7c975e-$(uname -r | sed -e "s/\.$(uname -p)$//" | sed -re 's/[-_]/\./g')-1
```

> [!NOTE]
> Running `dnf search amlfs-lustre-client` doesn't show all available packages for your distribution. To see all available `amlfs-lustre-client` packages, run `dnf list --showduplicates "amlfs-lustre-client*"`.

If you want to upgrade *only* the kernel and not all packages, you must (at minimum) also upgrade the `amlfs-lustre-client` metapackage so that the Lustre client can continue to work after the restart. The command should look similar to the following example:

```bash
export NEWKERNELVERSION=6.12.0-211.66.1.el10_2
sudo dnf upgrade kernel-$NEWKERNELVERSION amlfs-lustre-client-2.17.0_28_gc7c975e-$(echo $NEWKERNELVERSION | sed -e "s/\.$(uname -p)$//" | sed -re 's/[-_]/\./g')-1
```
