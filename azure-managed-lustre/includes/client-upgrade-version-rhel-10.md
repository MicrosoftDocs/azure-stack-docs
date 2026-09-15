---
author: jebearer
ms.author: jebearer
ms.service: azure-stack
ms.topic: include
ms.date: 09/11/2026
ms.reviewer:
ms.lastreviewed: 09/11/2026
---

```bash
sudo dnf install amlfs-lustre-client-2.17.0_25_g48fb0ca-$(uname -r | sed -e "s/\.$(uname -p)$//" | sed -re 's/[-_]/\./g')-1
```
