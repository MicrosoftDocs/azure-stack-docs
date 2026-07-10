---
author: jebearer
ms.author: jebearer
ms.service: azure-stack
ms.topic: include
ms.date: 06/19/2026
ms.reviewer:
ms.lastreviewed:
---

```bash
sudo tdnf install -y amlfs-lustre-client-2.17.0_24_gf517bc4-$(uname -r | sed -e "s/\.$(uname -p)$//" | sed -re 's/[-_]/\./g')-1
```
