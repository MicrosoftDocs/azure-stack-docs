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
sudo tdnf install -y amlfs-lustre-client-2.17.0_19_gbb5310f-$(uname -r | sed -e "s/\.$(uname -p)$//" | sed -re 's/[-_]/\./g')-1
```
