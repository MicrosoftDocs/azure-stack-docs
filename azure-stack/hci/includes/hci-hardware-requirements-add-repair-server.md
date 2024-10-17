---
author: alkohli
ms.author: alkohli
ms.service: azure-stack-hci
ms.topic: include
ms.date: 10/17/2024
---

| **Component** | **Compliance check**               |
|---------------|------------------------------------|
| CPU           | Validate the new machine has the same number of or more CPU cores. If the CPU cores on the incoming machine don't meet this requirement, a warning is presented. The operation is however allowed.                             |
| Memory        | Validate the new machine has the same amount of or more memory installed. If the memory on the incoming machine doesn't meet this requirement, a warning is presented. The operation is however allowed.                         |
| Drives        | Validate the new machine has the same number of data drives available for Storage Spaces Direct. If the number of drives on the incoming machine don't meet this requirement, an error is reported and the operation is blocked. |
