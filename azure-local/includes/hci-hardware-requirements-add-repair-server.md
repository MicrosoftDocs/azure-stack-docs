---
author: alkohli
ms.author: alkohli
ms.service: azure-local
ms.topic: include
ms.date: 10/30/2024
---

| **Component** | **Compliance check**               |
|---------------|------------------------------------|
| CPU           | Validate the new node has the same number of or more CPU cores. If the CPU cores on the incoming node don't meet this requirement, a warning is presented. The operation is however allowed.                             |
| Memory        | Validate the new node has the same amount of or more memory installed. If the memory on the incoming node doesn't meet this requirement, a warning is presented. The operation is however allowed.                         |
| Drives        | Validate that the new node has the same number of data drives available for Storage Spaces Direct. If the number of drives on the incoming node doesn't meet this requirement, an error is reported and the operation is blocked. |
