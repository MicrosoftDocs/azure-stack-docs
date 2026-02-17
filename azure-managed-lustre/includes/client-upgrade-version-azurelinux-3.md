---
author: csmuell
ms.author: chmuell
ms.service: azure-stack
ms.topic: include
ms.date: 01/30/2026
ms.reviewer:
ms.lastreviewed:
---

```bash
sudo tdnf install -y amlfs-lustre-client-2.16.1_21_g153e389-$(uname -r | sed -e "s/\.$(uname -p)$//" | sed -re 's/[-_]/\./g')-1
```
