---
title: Change deployment user password on Azure Local, version 23H2
description: This article describes how to manage internal secret rotation on Azure Local, version 23H2.
author:  alkohli
ms.author:  alkohli
ms.topic: how-to
ms.date: 06/16/2025
ms.service: azure-local
---

# Rotate secrets on Azure Local

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how you can change the password associated with the deployment user on Azure Local.

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

## Change cluster witness storage account key

This section describes how you can change the storage account key for the cluster witness storage account.

1. Sign in to one of the Azure Local nodes using deployment user credentials.

1. Configure the witness quorum using the secondary storage account key:

    ```powershell
    Set-ClusterQuorum -CloudWitness -AccountName <storage account name> -AccessKey <storage account secondary key>
    ```

1. Rotate the storage account primary key.

1. Configure the witness quorum using the rotated storage account key:

    ```powershell
    Set-ClusterQuorum -CloudWitness -AccountName <storage account name> -AccessKey <storage account primary key>
    ```

1. Rotate the storage account secondary key.

1. Update the storage account primary key in the ECE store:

    ```powershell
    $SecureSecretText = ConvertTo-SecureString -String "<Replace Storage account key>" -AsPlainText -Force
    $WitnessCred = New-Object -Type PSCredential -ArgumentList "WitnessCredential,$SecureSecretText"
    Set-ECEServiceSecret -ContainerName WitnessCredential -Credential $WitnessCred
    ```

## Revoke SAS token for storage account used for Azure Local VM images

This section describes how you can revoke the Shared Access Signature (SAS) token for the storage account used for images used by Azure Local VMs enabled by Arc.

| SAS policy   | SAS expired?    | Steps to revoke   |
|---------|---------|---------|
| Any SAS     | Yes      | No action is required as the SAS is no longer valid.        |
| Ad hoc SAS signed with an account key      | No      | [Manually rotate or regenerate Storage account key](/azure/storage/common/storage-account-keys-manage?tabs=azure-portal#manually-rotate-access-keys) used to create SAS.         |
| Ad hoc SAS signed with a user delegation key      | No       | To revoke user delegation key or change role assignments, see [Revoke a user delegation SAS](/rest/api/storageservices/create-user-delegation-sas#revoke-a-user-delegation-sas).         |
| SAS with stored access policy      | No       | To update the expiration time to a past date or time, or delete the stored access policy, see [Modify or revoke a stored access policy](/rest/api/storageservices/define-stored-access-policy#modify-or-revoke-a-stored-access-policy).           |

For more information, see [Revoke a SAS](/rest/api/storageservices/create-service-sas#revoke-a-sas).

## Change deployment service principal

This section describes how you can change the service principal used for deployment. 

> [!NOTE]
> This scenario applies only when you upgraded Azure Local 2306 software to Azure Local, version 23H2.

Follow these steps in to change the deployment service principal:

1. Sign on to your Microsoft Entra ID.
1. Locate the service principal that you used when deploying the Azure Local instance. Create a new client secret for the service principal.
1. Make a note of the `appID` for the existing service principal and the new `<client secret>`.
1. Sign on to one of your Azure Local machines using the deployment user credentials.
1. Sign in to Azure. Run the following PowerShell command:

    ```powershell
    Connect-AzAccount
    ```

1. Set the subscription context. Run the following PowerShell command:

    ```powershell
    Set-AzContext -Subscription <Subscription ID>
    ```

1. Update the service principal name. Run the following PowerShell commands:

    ```powershell
    cd "C:\Program Files\WindowsPowerShell\Modules\Microsoft.AS.ArcIntegration"
    Import-Module Microsoft.AS.ArcIntegration.psm1 -Force
    $secretText=ConvertTo-SecureString -String <client secret> -AsPlainText -Force
    Update-ServicePrincipalName -AppId <appID> -SecureSecretText $secretText
    ```

## Change ARB service principal secret

This section describes how you can change the service principal used for Azure resource bridge that you created during deployment.

To change the deployment service principal, follow these steps:

1. Sign in to your Microsoft Entra ID.
1. Locate the service principal for Azure resource bridge. The name of the service principal has the format **ClusternameXX.arb**.
1. Create a new client secret for the service principal.
1. Make a note of the `appID` for the existing service principal and the new `<client secret>`.
1. Sign in to one of your Azure Local machines using the deployment user credentials.
1. Run the following PowerShell command:

   ```powershell
   $SubscriptionId= "<Subscription ID>" 
   $TenantId= "<Tenant ID>"
   $AppId = "<Application ID>" 
   $secretText= "<Client secret>" 
   $NewPassword = ConvertTo-SecureString -String $secretText -AsPlainText -Force 
   Set-AzureStackRPSpCredential -SubscriptionID $SubscriptionId -TenantID $TenantId -AppId $AppId -NewPassword $NewPassword 
   ```

## Rotate internal secrets

This section describes how you can rotate internal secrets. Internal secrets include certificates, passwords, secure strings, and keys used by the Azure Local infrastructure. Internal secret rotation is only required if you suspect one has been compromised, or you've received an expiration alert.

The exact steps for secret rotation are different depending on the software version your Azure Local instance is running.

### Azure Local instance running 2411.2 and later

1. Sign in to one of the Azure Local nodes using deployment user credentials.
1. Start secret rotation. Run the following PowerShell command:

    ```PowerShell
    Start-SecretRotation
    ```

### Azure Local instance running 2411.1 to 2411.0

1. Sign in to one of the Azure Local nodes using deployment user credentials.
1. Update the CA Certificate password in ECE store. Run the following PowerShell command:

    ```PowerShell
    $SecureSecretText = ConvertTo-SecureString -String "<Replace with a strong password>" -AsPlainText -Force
    $CACertCred = New-Object -Type PSCredential -ArgumentList "CACertUser,$SecureSecretText"
    Set-ECEServiceSecret -ContainerName CACertificateCred -Credential $CACertCred
    ```

1. Start secret rotation. Run the following PowerShell command:

    ```PowerShell
    Start-SecretRotation
    ```

### Azure Local instance running 2408.2 or earlier

1. Sign in to one of the Azure Local nodes using deployment user credentials.
1. Update the CA Certificate password in ECE store. Run the following PowerShell command:

    ```PowerShell
    $SecureSecretText = ConvertTo-SecureString -String "<Replace with a strong password>" -AsPlainText -Force
    $CACertCred = New-Object -Type PSCredential -ArgumentList (CACertificateCred),$SecureSecretText
    Set-ECEServiceSecret -ContainerName CACertificateCred -Credential $CACertCred
    ```

1. Delete FCA cert from all the cluster nodes and restart FCA service. Run the following command on each node of your Azure Local instance:

    ```PowerShell
    $cert = Get-ChildItem -Recurse cert:\LocalMachine\My | Where-Object { $_.Subject -like "CN=FileCopyAgentKeyIdentifier*" } 
    $cert | Remove-Item 
    restart-service "AzureStack File Copy Agent*"
    ```

1. Start secret rotation. Run the following PowerShell command:

    ```PowerShell
    Start-SecretRotation
    ```


## Next steps

[Complete the prerequisites and checklist and install Azure Local](../deploy/deployment-prerequisites.md).
