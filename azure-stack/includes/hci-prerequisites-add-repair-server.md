---
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.topic: include
ms.date: 11/30/2023
---


- `AzureStackLCMUser` is active in Active Directory. For more information, see [Prepare the Active Directory](../hci/deploy/deployment-tool-active-directory.md#active-directory-preparation-module).
- Signed in as `AzureStackLCMUser` or another user with equivalent permissions.
- Credentials for the `AzureStackLCMUser` haven't changed.
- You have enabled **file and printer sharing** by opening the requisite firewall ports. To create the corresponding firewall rule, run the following PowerShell cmdlet on the servers.

    ```powershell
    Enable-NetFirewallRule -DisplayName 'File and Printer Sharing (SMB-In)' -Verbose
    ```