---
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.topic: include
ms.date: 07/13/2023
---

### Save logs on a local file share

You can save diagnostic logs to a local share, typically in the following scenarios:

- **Pre-deployment or pre-registration.** To troubleshoot any validation issues that may arise during the pre-deployment or pre-registration of the cluster.
- **Post-deployment.** If you're normally connected but experiencing connectivity issues, you can save logs locally to help with troubleshooting.

Run the following command on each node of the cluster to collect logs and save them locally:

```powershell
Send-DiagnosticData –ToSMBShare -BypassObsAgent –SharePath <Path to the SMB share> -ShareCredential <Crendentials to connect to the SharePath>  
```

### Send logs to Microsoft

Microsoft retains the diagnostic data that you send for up to 29 days and handles it as per the [standard privacy practices](https://privacy.microsoft.com/).

You can send logs to Microsoft using `Send-DiagnosticData` and `Send-AzStackHciDiagnosticData` cmdlets, as described in the following sections.

#### Send logs using `Send-DiagnosticData`

If the SMB share where you saved the logs has outbound connectivity, you can run the following command to send logs after log collection on all the nodes finishes:

```powershell
Send-DiagnosticData –FromSMBShare –BypassObsAgent –SharePath <Path to the SMB share> -ShareCredential <Crendentials to connect to the SharePath>
```

#### Send logs using `Send-AzStackHciDiagnosticData`

Use the `Send-AzStackHciDiagnosticData` cmdlet to send logs from any machine with outbound connectivity, outside of the Azure Stack HCI stamp.

The input parameters used to send logs using `Send-AzStackHciDiagnosticData` are the same that are required as part of the deployment process. For description about the input parameters, see [Deploy Azure Stack HCI using PowerShell (preview)](../hci/deploy/deployment-tool-powershell.md).

You can use any of the following credentials to send logs:

- $RegistrationCredential
- $RegistrationWithDeviceCode
- $RegistrationSPCredential
- $RegistrationWithExistingContext

You can find the parameter values in `C:\Deployment`. Run the following command to see the output:

```powershell
$deployArgs = Import-Clixml -Path C:\Deployment\DeployArguments.xml
```

#### Get information for the required parameters

The following parameters are required to use the `Send-AzStackHciDiagnosticData` cmdlet. Consult your network administrator as needed for this information.

- `ResourceGroupName`: Name of the Azure resource group that is used during the deployment process. Use the following command to get the resource group name:

   ```powershell
   Import-Module C:\CloudDeployment\ECEngine\EnterpriseCloudEngine.psd1 -ErrorAction SilentlyContinue
   $eceConfig = Get-EceConfiguration -ErrorAction SilentlyContinue
   if ($eceConfig.Xml -match "<RegistrationResourceGroupName>(.*)</RegistrationResourceGroupName>")
   {
   $resourcegroupname =  $matches[1].Trim()
   }
   ```

- `SubscriptionId`: Name of the Azure subscription ID that is used as part of the deployment process. Use the following command to get the subscription ID:

   ```powershell
   $subscriptionId = $deployArgs.RegistrationSubscriptionId
   ```

- `TenantId`: Azure tenant ID that is used as part of the deployment process. Use the following command to get the tenant ID:

   ```powershell
   $cloudName = $deployargs.RegistrationCloudName
   Import-Module "$env:SystemDrive\CloudDeployment\Setup\Common\RegistrationHelpers.psm1"
   $RegistrationTenantId = Get-TenantId -AzureEnvironment $CloudName -SubscriptionId $subscriptionid
   ```

- `RegistrationRegion`: Regstration region that is used as part of the deployment process.

- `Cloud`: Azure cloud name that is used as part of the deployment process.

- `CacheFlushWaitTimeInSec`: Optional wait time in seconds to flush the cache folder. The default value is 600.

- `RegistrationCredential`: Azure credentials to authenticate with Azure. This is mandatory in `DefaultSet` parameter set.

- `DiagnosticLogPath`: Diagnostics log path where logs are stored.

- `RegistrationWithDeviceCode`: The switch that allows Azure authentication with the device code.

- `RegistrationWithExistingContext`: Use this switch if current Powershell window already had `Connect-AzAccount` executed and use the existing context for Azure authentication.

- `RegistrationSPCredential`: Part of the `ServicePrincipal` parameter set. Use this to send `SErvicePrincipal` credential.

#### Send logs using different credentials

Based on the type of credentials you have, use one of the following commands to send logs:

- **Send logs using registration credentials**

   ```powershell
   Send-AzStackHciDiagnosticData -ResourceGroupName <ResourceGroupName> -SubscriptionId <SubscriptionId> -TenantId <TenantId> -RegistrationCredential <RegistrationCredential> -DiagnosticLogPath <LogPath> -RegistrationRegion <RegionName> -Cloud <AzureCloud>
   ```

   Use the following command to set up the registration credentials:

   ```powershell
   $registrationaccountusername = $deployArgs.RegistrationAccountUserName
   $regPassword = $deployArgs.RegistrationAccountPassword
   $registrationCredential = New-Object System.Management.Automation.PSCredential -ArgumentList $registrationaccountusername, (ConvertTo-SecureString -AsPlainText $regPassword -Force) $registrationCredential
   ```

- **Send logs using device code credentials**

   When you run the following command, you'll be prompted to open a web browser and enter the provided code to proceed with the authentication process.

   ```powershell
   Send-AzStackHciDiagnosticData -ResourceGroupName <ResourceGroupName> -SubscriptionId <SubscriptionId> -TenantId <TenantId> - RegistrationWithDeviceCode -DiagnosticLogPath <LogPath> -RegistrationRegion <RegionName> -Cloud <AzureCloud>    
   ```

- **Send logs using service principal name (SPN) credentials**

   ```powershell
   Send-AzStackHciDiagnosticData -ResourceGroupName <ResourceGroupName> -SubscriptionId <SubscriptionId> -TenantId <TenantId> - RegistrationSPCredential <RegistrationSPCredential> -DiagnosticLogPath <LogPath> -RegistrationRegion <RegionName> -Cloud <AzureCloud>
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
   Send-AzStackHciDiagnosticData -ResourceGroupName <ResourceGroupName> -SubscriptionId <SubscriptionId> -TenantId <TenantId> - RegistrationWithExistingContext -DiagnosticLogPath <LogPath> - RegistrationRegion <RegionName> -Cloud <AzureCloud>        
   ```