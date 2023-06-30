---
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.topic: include
ms.date: 06/30/2023
---

**Save logs locally**

For troubleshooting purposes, you can save logs to a local SMB share when your Azure Stack HCI cluster isn't deployed yet or when it is already deployed but disconnected from Azure. For example, post-deployment, if you're normally connected but are experiencing connectivity issues, you can save logs locally to help with troubleshooting.

Follow these steps to collect logs and save them locally:

1. Run the following command on each node of the cluster to collect logs and save them locally:

   ```powershell
   Send-DiagnosticData –ToSMBShare -BypassObsAgent –SharePath C:\CILogCollection\Node1 -ShareCredential <cred>  
   ```

1. After all log collections on all nodes finish, run the following command:

   ```powershell
   Send-DiagnosticData –FromSMBShare –BypassObsAgent  –SharePath C:\CILogCollection\Node1 -ShareCredential <cred>
   ```

**Send logs to Microsoft manually**

To manually send diagnostic logs to Microsoft, use the `Send-AzStackHciDiagnosticData` cmdlet from any Azure Stack HCI cluster node. Microsoft retains this diagnostic data for up to 29 days and handles it as per the [standard privacy practices](https://privacy.microsoft.com/).

The input parameters used to send logs are the same that are required as a part of deployment, you may use any of the credentials

1. Run the following command to 

   ```powershell
   Send-AzStackHciDiagnosticData -ResourceGroupName <Resource-Group-Name> -SubscriptionId <Subscription-ID> -TenantId <Tenant-ID> -RegistrationCredential $c -DiagnosticLogPath C:\CILogCollection  
   ```

Examples:

- **Using Registration credentials (Azure credentials used for authentication to register ArcAgent)**

   ```powershell
   $secpwd = ConvertTo-SecureString -String "p a s s w o r d" -AsPlainText -Force 
   $c = New-Object System.Management.Automation.PSCredential("aszregistration@microsoft.com", $secpwd) 
 
   Send-AzStackHciDiagnosticData -ResourceGroupName strdrg -SubscriptionId 4bed37fd-19a1-4d31-8b44-40267555bec5 -TenantId 72f988bf-86f1-41af-91ab-2d7cd011db47 -RegistrationCredential $c -DiagnosticLogPath C:\MasLogs
   ```

- **Using Interactive (Option to use device and authenticate from)**

   ```powershell
   Send-AzStackHciDiagnosticData -ResourceGroupName strdrg -SubscriptionId 4bed37fd-19a1-4d31-8b44-40267555bec5 -TenantId 72f988bf-86f1-41af-91ab-2d7cd011db47 -RegistrationWithDeviceCode -DiagnosticLogPath C:\MasLogs
   ```
 
- **Using SPN Credential (This is SPN crednetials used for authentication to register ArcAgent. Needed only for ServicePrincipal set )**

   ```powershell
   $appsec = "3SW8Q~x1t8i_hg4mfEQG01UNqUeyDZkezAbpFaAP" 
   $appid = "b0734a1c-db05-4b84-b494-a6904b235a80" 
   $ss = ConvertTo-SecureString -String $appsec -AsPlainText -Force 
   $sp = New-Object System.Management.Automation.PSCredential($appid, $ss) 
 
 
   Send-AzStackHciDiagnosticData -ResourceGroupName strdrg -SubscriptionId 4bed37fd-19a1-4d31-8b44-40267555bec5 -TenantId 72f988bf-86f1-41af-91ab-2d7cd011db47 -RegistrationSPCredential $sp -DiagnosticLogPath C:\MasLogs 
   ```

- **Using Passsthrough (Using the existing context on the PowerShell window)**

   ```powershell
   Send-AzStackHciDiagnosticData -ResourceGroupName strdrg -SubscriptionId 4bed37fd-19a1-4d31-8b44-40267555bec5 -TenantId 72f988bf-86f1-41af-91ab-2d7cd011db47 -RegistrationWithExistingContext -DiagnosticLogPath C:\MasLogs 
   ```