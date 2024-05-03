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
sudo apt install amlfs-lustre-client-2.15.4-42-gd6d405d=$(uname -r)
```

> [!NOTE]
> This command installs a metapackage that will keep the version of Lustre aligned with the installed kernel. In order for this to work, you must use `apt full-upgrade` instead of simply `apt upgrade` when updating your system.

Optionally, if you want to upgrade *only* the kernel (and not all packages), you must, at minimum, also upgrade the **amlfs-lustre-client** metapackage in order for the Lustre client to continue to work after the reboot. The command should look similar to the following example:

```bash
apt upgrade linux-image-[new kernel version] amlfs-lustre-client-2.15.4-42-gd6d405d
```
