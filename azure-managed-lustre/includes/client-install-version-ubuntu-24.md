---
author: jebearer
ms.author: jebearer
ms.service: azure-stack
ms.topic: include
ms.date: 06/19/2026
ms.reviewer: wdesalvador
---

> [!NOTE]
> Version 2.17 is a non-LTS release of Lustre and the community support ends soon after the release of version 2.18. For more information about the 2.18 release, check back later.

```bash
sudo apt install amlfs-lustre-client-2.17.0-24-gf517bc4=$(uname -r)
```

> [!NOTE]
> Running `apt search amlfs-lustre-client` doesn't show all available packages for your distribution. To see all available `amlfs-lustre-client` packages, run `apt list -a "amlfs-lustre-client*"`.

Optionally, if you want to upgrade *only* the kernel and not all packages, you must (at minimum) also upgrade the `amlfs-lustre-client` metapackage so that the Lustre client can continue to work after the restart. The command should look similar to the following example:

```bash
apt upgrade linux-image-[new kernel version] amlfs-lustre-client-2.17.0-24-gf517bc4
```
