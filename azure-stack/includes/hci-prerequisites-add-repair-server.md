---
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.topic: include
ms.date: 12/13/2023
---


- `AzureStackLCMUser` is active in Active Directory. For more information, see [Prepare the Active Directory](../hci/deploy/deployment-tool-active-directory.md#active-directory-preparation-module).
- Signed in as `AzureStackLCMUser` or another user with equivalent permissions.
- Credentials for the `AzureStackLCMUser` haven't changed.
- Create a copy of the required PowerShell modules on the new node. Connect to a node on your Azure Stack HCI system and run the following PowerShell cmdlet:
    ```powershell
    Copy-Item "C:\Program Files\WindowsPowerShell\Modules\CloudCommon" "\\newserver\c$\\Program Files\WindowsPowerShell\Modules\CloudCommon" -recursive
    ```