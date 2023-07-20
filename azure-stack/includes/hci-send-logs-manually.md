---
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.topic: include
ms.date: 07/13/2023
---

**Save logs locally**

You can save diagnostic logs to a local Server Message Block (SMB) share, typically in the following scenarios:

- **Pre-deployment or pre-registration.** To troubleshoot any validation issues that may arise during the pre-deployment or pre-registration of the cluster.
- **Post-deployment.** If you're normally connected but experiencing connectivity issues, you can save logs locally to help with troubleshooting.

Run the following command on each node of the cluster to collect logs and save them locally:

```powershell
Send-DiagnosticData –ToSMBShare -BypassObsAgent –SharePath <Path to the SMB share> -ShareCredential <Crendentials to connect to the SharePath>  
```

**Send logs manually**

To manually send diagnostic logs to Microsoft, use the `Send-AzStackHciDiagnosticData` cmdlet from any Azure Stack HCI cluster node. Microsoft retains this diagnostic data for up to 29 days and handles it as per the [standard privacy practices](https://privacy.microsoft.com/).

The input parameters used to send logs are the same that are required as part of deployment. For description about the input parameters, see [Deploy Azure Stack HCI using PowerShell (preview)](../hci/deploy/deployment-tool-powershell.md).

You can use any of the following credentials to send the logs:

- **Send logs using registration credentials**

   ```powershell
   Send-AzStackHciDiagnosticData -ResourceGroupName <ResourceGroupName> -SubscriptionId <SubscriptionId> -TenantId <TenantId> -RegistrationCredential < RegistrationCredential>
   ```

   You can use the following cmdlets to get registration credentials:

   ```powershell
   $secpwd = ConvertTo-SecureString -String <password> -AsPlainText -Force  
   $c = New-Object System.Management.Automation.PSCredential("aszregistration@microsoft.com", $secpwd)
   ```

- **Send logs using device code credentials**

   ```powershell
   Send-AzStackHciDiagnosticData -ResourceGroupName <ResourceGroupName> -SubscriptionId <SubscriptionId> -TenantId <TenantId> - RegistrationWithDeviceCode <RegistrationWithDeviceCode>  
   ```

- **Send logs using service principal name (SPN) credentials**

   ```powershell
   Send-AzStackHciDiagnosticData -ResourceGroupName <ResourceGroupName> -SubscriptionId <SubscriptionId> -TenantId <TenantId> - RegistrationSPCredential <RegistrationSPCredential>
   ```

   You can use the following cmdlets to get SPN credentials:


   ```powershell
   $SPNAppID = "<Your App ID>"  
   $SPNSecret= "<Your SPN Secret>"  
   $SPNsecStringPassword = ConvertTo-SecureString  
   $SPNSecret -AsPlainText -Force  
   $SPNCred = New-Object System.Management.Automation.PSCredential ($SPNAppID, $SPNsecStringPassword)
   ```

- **Send logs using registration with existing context credentials**

   ```powershell
   Send-AzStackHciDiagnosticData -ResourceGroupName <ResourceGroupName> -SubscriptionId <SubscriptionId> -TenantId <TenantId> - RegistrationWithExistingContext <RegistrationWithExistingContext>    
   ```

If you have outbound connectivity from the SMB share where you saved the logs, you can run the following command to send the logs to Microsoft:

```powershell
Send-DiagnosticData –FromSMBShare –BypassObsAgent –SharePath <Path to the SMB share> -ShareCredential <Crendentials to connect to the SharePath>
```