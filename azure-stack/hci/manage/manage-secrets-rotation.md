---
title: Change deployment user password on Azure Stack HCI, version 23H2
description: This article describes how to manage internal secret rotation on Azure Stack HCI, version 23H2.
author:  alkohli
ms.author:  alkohli
ms.topic: how-to
ms.date: 03/11/2024
ms.service: azure-stack
ms.subservice: azure-stack-hci
---

# Change deployment user password on Azure Stack HCI, version 23H2

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article describes how you can change the password associated with the deployment user on Azure Stack HCI.

## Change password

Use the PowerShell cmdlet `Set-AzureStackLCMUserPassword` to rotate the`AzureStackLCMUserCredential` domain administrator credential secrets. This cmdlet changes the password of the user that connects to the server hosts.

> [!NOTE]
> When running `Set-AzureStackLCMUserPassword`, it only updates what was previously changed in Active Directory.


## PowerShell cmdlet and properties

The `Set-AzureStackLCMUserPassword` cmdlet has the following parameters:

- `Identity`: Username of the user whose password you want to change.

- `OldPassword`: The current password of the user.

- `NewPassword`: The new password for the user.

There is also an optional parameter `UpdateAD`, which when used will set a new password in Active Directory. A confirmation is requested afterwards.
Once the password is changed, the session ends. You then need to sign in with the updated password.

Here is a sample output when using `Set-AzureStackLCMUserPassword`:

```output
PS C:\Users\MGMT> .
PS C:\Users\MGMT> $old pass = convertto-securestring "Passwordl23!" -asplaintext -force 
PS C:\Users\MGMT> $new_pass = convertto-securestring "Passwordl23!1" -asplaintext -force
PS C:\Users\MGMT> Set-AzureStackLCMUserPassword -Identity mgmt -OldPassword $old_pass -NewPassword $new_pass -UpdateAD Verbose -Confirm:$false
VERBOSE: Loading module from path 'C:\Program
Files\WindowsPowerShell\Modules\Microsoft.AS.Infra.Security.SecretRotation\Microsoft.AS.Infra.Security.ActionPlanExecut ion.psml'.
VERBOSE: Importing function 'Get-LatestActionPlanlnstance'.
VERBOSE: Importing function 'PrintStatus'.
VERBOSE: Importing function *Start-ActionPlan'.
VERBOSE: Creating AzsSecurity log folder: D:\CloudContent\MASLogs\AzsSecurityGeneralLogging
VERBOSE: Log file path: D:\CloudContent\MASLogs\AzsSecurityGeneralLogging\AzsSecurity_AzsSecurity_20240305-080850.log WARNING: !WARNING!
The current session will be unresponsive once this command completes. You will have to login again with updated credentials. Do you want to continue?
VERBOSE: Creating AzsSecurity log folder: D:\CloudContent\MASLogs\DomainCredentialRotation VERBOSE: Log file path:
D:\CloudContent\MASLogs\DomainCredentialRotation\AzsSecurity_Set-AzureStackLCMUserPassword_20240305-080850.log VERBOSE: Performing the operation "Set-AzureStackLCMUserPassword” on target "mgmt".
VERBOSE: Updating credentials for user mgmt.
VERBOSE: Loading module from path 'C:\Program
Files\WindowsPowerShell\Modules\Microsoft.AS.Infra.Security.SecretRotation\PasswordUtilities.psml1.
VERBOSE: Importing function 'GetSecurePassword'.
VERBOSE: Importing function 'Test-PasswordComplexity'.
VERBOSE: Importing function 'Test-PasswordLength'.
VERBOSE: Importing function 'Validateldentity'.
VERBOSE: Importing function 'GetSecurePassword'.
VERBOSE: Importing function 'Test-PasswordComplexity'.
VERBOSE: Importing function 'Test-PasswordLength'.
VERBOSE: Importing function 'Validateldentity*.
Updating password in AD. Are you sure you want to perform this action? [Y/N]: Y 
VERBOSE: mgmt user credentials have been successfully updated.
WARNING: Please close this session and log in again.
PS C:\Users\MGMT> _
```

## Next steps

- [Complete the prerequisites and checklist and install Azure Stack HCI, version 23H2](../deploy/deployment-prerequisites.md).
