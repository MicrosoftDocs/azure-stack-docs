---
author: mabrigg
ms.author: mattbriggs
ms.service: azure-stack
ms.topic: include
ms.date: 06/03/2020
ms.reviewer: kivenkat
ms.lastreviewed: 06/03/2020
---

## Delete a VM with dependencies using the portal

In the case where you cannot delete the resource group, either the dependencies are not in the same resource group, or there are other resources, follow the steps below:

1. Open the Azure Stack user portal.
2. Select **Virtual machines**. Find your virtual machine, and then select your machine to open the Virtual machine blade.
3. Make a note of the resource group that contains the VM and VM dependencies.
4. Select **Networking** and make note of the networking interface.
5. Select **Disks** and make note of the OS disk and data disks.
6. Return to the **Virtual machine** blade, and select **Delete**.
7. Select **Resource groups** and then select the resource group.
8. Delete the dependencies by manually selecting them and then select delete.
    1. Type `Yes`.
    2. Wait for the resource to be completely deleted.
    3. You can delete the next dependency.