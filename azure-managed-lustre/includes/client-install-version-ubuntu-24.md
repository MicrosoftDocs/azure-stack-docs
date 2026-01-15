---
author: t-mialve
ms.author: normesta
ms.service: azure-stack
ms.topic: include
ms.date: 04/29/2025
ms.reviewer: rohogue
---

> [!NOTE]
> 2.16 is a non-LTS release of Lustre and will stop receiving support from the community soon after the release of 2.17. Please check back in late 2025/early 2026 for more information about the 2.17 release.

```bash
sudo apt install amlfs-lustre-client-2.16.1-14-gbc76088=$(uname -r)
```

> [!NOTE]
> Running `apt search amlfs-lustre-client` doesn't show all available packages for your distribution. To see all available `amlfs-lustre-client` packages, run `apt list -a "amlfs-lustre-client*"`.

Optionally, if you want to upgrade *only* the kernel and not all packages, you must (at minimum) also upgrade the `amlfs-lustre-client` metapackage so that the Lustre client can continue to work after the restart. The command should look similar to the following example:

```bash
apt upgrade linux-image-[new kernel version] amlfs-lustre-client-2.16.1-14-gbc76088
```
