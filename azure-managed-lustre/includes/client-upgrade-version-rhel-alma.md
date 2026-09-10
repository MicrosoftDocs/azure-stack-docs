---
author: pauljewellmsft
ms.author: pauljewell
ms.service: azure-stack
ms.topic: include
ms.date: 10/24/2024
ms.reviewer:
ms.lastreviewed:
---

```bash
sudo dnf install amlfs-lustre-client-2.15.8_39_g2d32b59-$(uname -r | sed -e "s/\.$(uname -p)$//" | sed -re 's/[-_]/\./g')-1
```
