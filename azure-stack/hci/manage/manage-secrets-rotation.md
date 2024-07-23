---
title: Change deployment user password on Azure Stack HCI, version 23H2
description: This article describes how to manage internal secret rotation on Azure Stack HCI, version 23H2.
author:  alkohli
ms.author:  alkohli
ms.topic: how-to
ms.date: 04/22/2024
ms.service: azure-stack
ms.subservice: azure-stack-hci
---

# Rotate secrets on Azure Stack HCI, version 23H2

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article describes how you can change the password associated with the deployment user on Azure Stack HCI.

## Change deployment user password

Use the PowerShell cmdlet `Set-AzureStackLCMUserPassword` to rotate the`AzureStackLCMUserCredential` domain administrator credential secrets. This cmdlet changes the password of the user that connects to the server hosts.

> [!NOTE]
> When you run `Set-AzureStackLCMUserPassword`, the cmdlet only updates what was previously changed in Active Directory.


### PowerShell cmdlet and properties

The `Set-AzureStackLCMUserPassword` cmdlet takes the following parameters:


|Parameter|Description  |
|---------|---------|
|`Identity`    | Username of the user whose password you want to change.         |
|`OldPassword` | The current password of the user.        |
|`NewPassword` | The new password for the user.        |
|`UpdateAD`    | Optional parameter used to set a new password in Active Directory.        |


### Run Set-AzureStackLCMUserPassword cmdlet

Set the parameters and then run the `Set-AzureStackLCMUserPassword` cmdlet to change the password:

```azurepowershell
$old_pass = convertto-securestring "<Old password>" -asplaintext -force
$new_pass = convertto-securestring "<New password>" -asplaintext -force

Set-AzureStackLCMUserPassword -Identity mgmt -OldPassword $old_pass -NewPassword $new_pass -UpdateAD 
```

Once the password is changed, the session ends. You then need to sign in with the updated password.

Here's a sample output when using `Set-AzureStackLCMUserPassword`:

```output
PS C:\Users\MGMT> $old_pass = convertto-securestring "Passwordl23!" -asplaintext -force 
PS C:\Users\MGMT> $new_pass = convertto-securestring "Passwordl23!1" -asplaintext -force
PS C:\Users\MGMT> Set-AzureStackLCMUserPassword -Identity mgmt -OldPassword $old_pass -NewPassword $new_pass -UpdateAD 
WARNING: !WARNING!
The current session will be unresponsive once this command completes. You will have to login again with updated credentials. Do you want to continue?
Updating password in AD.
WARNING: Please close this session and log in again.
PS C:\Users\MGMT> 
```

## Change deployment service principal

This section describes how you can change the service principal used for deployment. 

> [!NOTE]
> This scenario applies only when you upgraded Azure Stack HCI 2306 software to Azure Stack HCI, version 23H2.

Follow these steps in to change the deployment service principal:

1. Sign on to your Microsoft Entra ID.
1. Locate the service principal that you used when deploying the Azure Stack HCI cluster. Create a new client secret for the service principal.
1. Make a note of the `appID` for the existing service principal and the new `<client secret>`.
1. Sign on to one of your Azure Stack HCI server nodes using the deployment user credentials.
1. Login to Azure by running Connect-AzAccount. Please ensure you've selected the correct subscription with Set-AzContext -Subscription <subscription id>.  
1. Run the following PowerShell commands:

    ```powershell
    cd "C:\Program Files\WindowsPowerShell\Modules\Microsoft.AS.ArcIntegration"
    Import-Module Microsoft.AS.ArcIntegration.psm1 -Force
    $secretText=ConvertTo-SecureString -String <client secret> -AsPlainText -Force
    Update-ServicePrincipalName -AppId <appID> -SecureSecretText $secretText
    ```

## Next steps

- [Complete the prerequisites and checklist and install Azure Stack HCI, version 23H2](../deploy/deployment-prerequisites.md).
