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
sudo apt install amlfs-lustre-client-2.15.7-33-g79ddf99=$(uname -r)
```

> [!NOTE]
> Running `apt search amlfs-lustre-client` doesn't show all available packages for your distribution. To see all available `amlfs-lustre-client` packages, run `apt list -a "amlfs-lustre-client*"`.

Optionally, if you want to upgrade *only* the kernel and not all packages, you must (at minimum) also upgrade the `amlfs-lustre-client` metapackage so that the Lustre client can continue to work after the restart. The command should look similar to the following example:

```bash
apt upgrade linux-image-[new kernel version] amlfs-lustre-client-2.15.7-33-g79ddf99
```
