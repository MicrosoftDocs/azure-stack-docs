---
author: ManikaDhiman
ms.author: v-mandhiman
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.topic: include
ms.date: 02/01/2023
ms.reviewer: alkohli
---

1. Run PowerShell as administrator.

1. Run the following command to install the deployment tool:

   ```PowerShell
    .\BootstrapCloudDeploymentTool.ps1 
    ```

    This step takes several minutes to complete.

    > [!NOTE]
    > If you manually extracted deployment content from the ZIP file previously, you must run `BootstrapCloudDeployment-Internal.ps1` instead.
