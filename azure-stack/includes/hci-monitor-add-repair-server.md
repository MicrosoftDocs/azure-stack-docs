---
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.topic: include
ms.date: 11/13/2023
---

1. Run the following cmdlet and provide the operation ID from the previous step.

    ```powershell
    $ID = "<Operation ID>" 
    Start-MonitoringActionplanInstanceToComplete -actionPlanInstanceID $ID 
    ```

1. After the operation is complete, the background storage rebalancing job will continue to run. Wait for the storage rebalance job to complete. To verify the progress of this storage rebalancing job, use the following cmdlet:

    ```powershell
    Get-VirtualDisk|Get-StorageJob
    ```

    If the storage rebalance job is complete, the cmdlet won't return an output.
